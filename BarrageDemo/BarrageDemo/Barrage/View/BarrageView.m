//
//  BarrageAnimation.m
//  BarrageDemo
//
//  Created by 李剑钊 on 15/7/2.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "BarrageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Metrics.h"

static NSUInteger defaultPlaySubQueueMaxCount = 3;

@interface BarrageView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UIView<BarrageItemProtocol> *nextItem;

/// 弹幕的播放队列，二级对象为NSArray，表示一条弹道的弹幕，三级对象为弹幕视图
@property (nonatomic, strong) NSMutableArray *playQueue;

/// 弹幕重用池
@property (nonatomic, strong) NSMutableSet *reusePool;

@end

@implementation BarrageView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _playSubQueueMaxCount = defaultPlaySubQueueMaxCount;
        _barrageDistance = 16;
        _state = BarrageAnimationState_stop;
        self.reusePool = [NSMutableSet set];
        
        self.playQueue = [NSMutableArray array];
        for (NSInteger i = 0; i < _playSubQueueMaxCount; i ++) {
            [_playQueue addObject:[NSArray array]];
        }
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - public
#pragma mark playe control

- (BOOL)startBarrage {
    if (_state == BarrageAnimationState_stop) {
        _state = BarrageAnimationState_playing;
        [self displayLink];
        return YES;
    }
    return NO;
}

- (BOOL)pauseBarrage {
    if (_state == BarrageAnimationState_playing) {
        _state = BarrageAnimationState_pause;
        [self destoryDisplayLink];
        return YES;
    }
    return NO;
}

- (BOOL)resumeBarrage {
    if (_state == BarrageAnimationState_pause) {
        _state = BarrageAnimationState_playing;
        [self displayLink];
        return YES;
    }
    return NO;
}

- (BOOL)stopBarrage {
    if (_state == BarrageAnimationState_pause || _state == BarrageAnimationState_playing) {
        _state = BarrageAnimationState_stop;
        [self destoryDisplayLink];
        [self.reusePool removeAllObjects];
        self.nextItem = nil;
        
        for (NSUInteger i = 0; i < _playQueue.count; i ++) {
            NSArray *subQueue = _playQueue[i];
            for (NSInteger j = 0; j < subQueue.count; j ++) {
                UIView<BarrageItemProtocol> *item = subQueue[j];
                [item removeFromSuperview];
            }
            [_playQueue replaceObjectAtIndex:i withObject:@[]];
        }
        
        return YES;
    }
    return NO;
}

#pragma mark  item control

- (UIView<BarrageItemProtocol> *)dequeueReusableItem {
    UIView<BarrageItemProtocol> *item = [_reusePool anyObject];
    if (item) {
        [_reusePool removeObject:item];
    }
    return item;
}

#pragma mark - event

- (void)update:(CADisplayLink *)link {
    CFTimeInterval interval = link.duration;
    [self updateQueueAmination:interval];
    
    UIView<BarrageItemProtocol> *item = _nextItem;
    if (!item) {
        if ([_dataSource respondsToSelector:@selector(itemForBarrage:)]) {
            self.nextItem = [_dataSource itemForBarrage:self];
            item = _nextItem;
        }
    }
    
    if (item) {
        // 有待播放的弹幕
        if ([self addItemToPlayQueue:item]) {
            self.nextItem = nil;
        }
    }
    
    [self removeFinishedPlayingItem];
}

- (void)itemFinishPlay:(UIView<BarrageItemProtocol> *)item {
    [item removeFromSuperview];
    [_reusePool addObject:item];
}

/// 更新队列中弹幕的动画
- (void)updateQueueAmination:(CFTimeInterval)interval {
    for (NSUInteger i = 0; i < _playQueue.count; i ++) {
        NSArray *subQueue = _playQueue[i];
        
        for (NSUInteger j = 0; j < subQueue.count; j ++) {
            UIView<BarrageItemProtocol> *item = subQueue[j];
            item.curDistance = item.curDistance + (item.speed * interval);
            CGFloat x = [self barrageBeginX] - item.curDistance;
            NSInteger ix = x;
            NSInteger rightNumber = x*10 - ix*10;
            if (rightNumber > 5) {
                ix ++;
            }
            item.x = ix;
            item.centerY = [self getCenterYBySubQueueIndex:i];
        }
        
    }
}

#pragma mark - algorithm

/// 添加弹幕到播放队列,自动判断这时候能否播放新弹幕，如果能则添加成功，返回YES
- (BOOL)addItemToPlayQueue:(UIView<BarrageItemProtocol> *)item {
    BOOL hadAdded = NO;
    if (!item) {
        return hadAdded;
    }
    [self initItem:item];
    
    for (NSUInteger i = 0; i < _playQueue.count; i ++) {
        NSArray *subQueue = _playQueue[i];
        UIView<BarrageItemProtocol> *curItem = [subQueue lastObject];
        
        if (curItem && curItem.left - self.width > -0.00001) {
            // 还没开始播放
            continue;
        }
        
        if ([_dataSource respondsToSelector:@selector(itemWillShow:atRow:)]) {
            [_dataSource itemWillShow:item atRow:i];
        }
        
        NSTimeInterval newItemInterval = [self itemFinishedPlayingTime:item appendDistance:-item.width - _barrageDistance];
        NSTimeInterval curItemInterval = [self itemFinishedPlayingTime:curItem appendDistance:0];
        if (curItem && curItemInterval > newItemInterval) {
            /// 当前弹幕的速度过慢，会被新的弹幕追上
            continue;
        }
        
        if (curItem && self.width - (curItem.right+_barrageDistance) < 0.000001) {
            /// 两个弹幕的距离太短
            continue;
        }
        
        NSMutableArray *newSubQueue = [subQueue mutableCopy];
        [newSubQueue addObject:item];
        [_playQueue replaceObjectAtIndex:i withObject:newSubQueue];
        [self configItem:item inSubQueueIndex:i];
        
        hadAdded = YES;
        break;
    }
    
    return hadAdded;
}

/// 弹幕播放完毕还需要多少时间
- (NSTimeInterval)itemFinishedPlayingTime:(UIView<BarrageItemProtocol> *)item appendDistance:(NSInteger)append {
    if (!item) {
        return 0;
    }
    if (item.right < 0) {
        return 0;
    }
    if (fabs(item.speed) < 0.0000001) {
        /// 没有设置item的速度
        return CGFLOAT_MAX;
    }
    
    NSInteger distance = item.right - 0;
    distance += append;
    NSTimeInterval interval = distance/item.speed;
    return interval;
}

/// 移除播放完成的弹幕
- (void)removeFinishedPlayingItem {
    for (NSUInteger i = 0; i < _playQueue.count; i ++) {
        NSArray *subQueue = _playQueue[i];
        NSMutableArray *newSubQueue = [NSMutableArray array];
        
        for (NSUInteger j = 0; j < subQueue.count; j ++) {
            UIView<BarrageItemProtocol> *item = subQueue[j];
            if (item.right - 0 < 0.000001) {
                // 播放完成
                [self itemFinishPlay:item];
            } else {
                [newSubQueue addObject:item];
            }
        }
        
        [_playQueue replaceObjectAtIndex:i withObject:newSubQueue];
    }
}

#pragma mark - config

- (void)destoryDisplayLink {
    [_displayLink invalidate];
    self.displayLink = nil;
}

/// 初始化弹幕的配置
- (void)initItem:(UIView<BarrageItemProtocol> *)item {
    item.left = [self barrageBeginX];
    item.y = 0;
    item.curDistance = 0;
}

- (void)configItem:(UIView<BarrageItemProtocol> *)item inSubQueueIndex:(NSUInteger)index {
    item.centerY = [self getCenterYBySubQueueIndex:index];
    item.left = [self barrageBeginX];
    [self addSubview:item];
}

- (NSInteger)barrageBeginX {
    return self.width;
}

- (NSInteger)getCenterYBySubQueueIndex:(NSUInteger)index {
    NSInteger rowHeight = self.height / _playSubQueueMaxCount;
    NSInteger centerY = (index+0.5) * rowHeight;
    return centerY;
}

- (void)updateQueueItemWhenSizeChange {
    if (_barrageAverageSpeed < 0.00001) {
        /// 没有设置速度
        return;
    }
    
    for (NSUInteger i = 0; i < _playQueue.count; i ++) {
        NSArray *subQueue = _playQueue[i];
        
        for (NSUInteger j = 0; j < subQueue.count; j ++) {
            UIView<BarrageItemProtocol> *item = subQueue[j];
            item.speed = _barrageAverageSpeed;
        }
    }
}

#pragma mark - setter and getter

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        _displayLink = link;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (void)setPlaySubQueueMaxCount:(NSUInteger)playSubQueueMaxCount {
    if (_playSubQueueMaxCount != playSubQueueMaxCount) {
        _playSubQueueMaxCount = playSubQueueMaxCount;
        
        if (playSubQueueMaxCount > _playQueue.count) {
            NSInteger count = playSubQueueMaxCount - _playQueue.count;
            for (NSInteger i = 0; i < count; i ++) {
                [_playQueue addObject:[NSArray array]];
            }
        }
        /// 暂时不处理数量变少的情况
    }
}

- (void)setFrame:(CGRect)frame {
    if (CGSizeEqualToSize(self.size, frame.size) == NO) {
        [super setFrame:frame];
        [self updateQueueItemWhenSizeChange];
    } else {
        [super setFrame:frame];
    }
}

@end
