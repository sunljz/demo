//
//  BarrageAnimation.h
//  BarrageDemo
//
//  Created by 李剑钊 on 15/7/2.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BarrageProtocol.h"
@class UIView;

typedef NS_ENUM(NSUInteger, BarrageAnimationState) {
    BarrageAnimationState_stop,
    BarrageAnimationState_playing,
    BarrageAnimationState_pause,
};

@class BarrageView;

@protocol BarrageViewDataSource <NSObject>
@required
/// 提供弹幕视图源
- (UIView<BarrageItemProtocol> *)itemForBarrage:(BarrageView *)barrage;

@optional
/// 弹幕即将显示 row:行号
- (void)itemWillShow:(UIView<BarrageItemProtocol> *)item atRow:(NSUInteger)row;

@end

@interface BarrageView : UIView

/// 弹幕的行数，默认为1，开始以后，数量可以增加，但不能减少
@property (nonatomic, assign) NSUInteger playSubQueueMaxCount;

/// 弹幕的距离 default=16
@property (nonatomic, assign) NSUInteger barrageDistance;

/// 弹幕的平均速度，当旋转屏幕时，所有的正在播放的弹幕会设置成这个速度，避免出现重叠
@property (nonatomic, assign) CGFloat barrageAverageSpeed;

@property (nonatomic, weak) NSObject<BarrageViewDataSource> *dataSource;

#pragma mark play control

/// 弹幕播放状态
@property (nonatomic, readonly) BarrageAnimationState state;

- (BOOL)startBarrage;

- (BOOL)pauseBarrage;

- (BOOL)resumeBarrage;

- (BOOL)stopBarrage;

#pragma mark - item control

/// 获取可重用的弹幕
- (UIView<BarrageItemProtocol> *)dequeueReusableItem;

@end
