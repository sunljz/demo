//
//  ViewController.m
//  BarrageDemo
//
//  Created by 李剑钊 on 15/7/2.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "ViewController.h"
#import "BarrageView.h"
#import "UIView+Metrics.h"
#import "BarrageItemView.h"

@interface ViewController ()<BarrageViewDataSource>

@property (nonatomic, strong) BarrageView *barrageView;
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic, strong) NSMutableArray *messagePool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.messagePool = [NSMutableArray array];
	
    _parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 150)];
    [self.view insertSubview:_parentView atIndex:0];
    
    BarrageView *barrage = [[BarrageView alloc] initWithFrame:_parentView.bounds];
    barrage.dataSource = self;
    barrage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    barrage.playSubQueueMaxCount = 3;
    barrage.backgroundColor = [UIColor blackColor];
    barrage.barrageAverageSpeed = 80;
    [_parentView addSubview:barrage];
    _barrageView = barrage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    static NSInteger type = 0;
    for (NSInteger i = 0; i < 50; i ++) {
        NSString *title = nil;
        if (type == 0) {
            type = 1;
            title = @"1shihiaognaihoi";
        } else if (type == 1) {
            type = 2;
            title = @"HenHenH";
        } else if (type == 2) {
            type = 3;
            title = @"_@#!+-";
        } else if (type == 3) {
            type = 4;
            title = @"嘻嘻呵呵哈哈嘎嘎";
        } else {
            type = 0;
            title = @"10759651235215662164322346321523512";
        }
		
        [_messagePool addObject:title];
    }
}

- (IBAction)sendBtnTouch:(id)sender {
    [_messagePool addObject:@"我的消息"];
}

- (IBAction)buttonTouched:(id)sender {
    static BOOL rotate = NO;
    [UIView animateWithDuration:0.2 animations:^{
        if (rotate == NO) {
            rotate = YES;
            _parentView.size = CGSizeMake(self.view.height, 100);
            _parentView.center = CGPointMake(self.view.width/2, self.view.height/2);
            _parentView.transform = CGAffineTransformMakeRotation(M_PI/2);
        } else {
            rotate = NO;
            _parentView.transform = CGAffineTransformIdentity;
            _parentView.size = CGSizeMake(self.view.width, 150);
            _parentView.origin = CGPointMake(0, 20);
        }
    } completion:nil];
}

- (IBAction)pauseBtnTouch:(id)sender {
    [_barrageView pauseBarrage];
}
- (IBAction)resumeBtnTouch:(id)sender {
    [_barrageView resumeBarrage];
}

- (IBAction)startBtnTouch:(id)sender {
    [_barrageView startBarrage];
}

- (IBAction)stopBtnTouch:(id)sender {
    [_barrageView stopBarrage];
    [_messagePool removeAllObjects];
}

- (IBAction)removeBtnTouch:(id)sender {
    [_barrageView stopBarrage];
    _barrageView.dataSource = nil;
    [_barrageView removeFromSuperview];
    self.barrageView = nil;
    [_messagePool removeAllObjects];
}

#pragma mark - BarrageViewDataSource

- (UIView<BarrageItemProtocol> *)itemForBarrage:(BarrageView *)barrage {
    NSString *title = [_messagePool firstObject];
    if (title) {
        [_messagePool removeObjectAtIndex:0];
        
        BarrageItemView *item = (BarrageItemView *)[barrage dequeueReusableItem];
        if (!item) {
            item = [BarrageItemView new];
        }
        item.speed = 80;
        item.detail = title;
        return item;
    }
    return nil;
}

- (void)itemWillShow:(UIView<BarrageItemProtocol> *)item atRow:(NSUInteger)row {
    if (row == 2) {
        item.speed = 130;
    }
}

@end
