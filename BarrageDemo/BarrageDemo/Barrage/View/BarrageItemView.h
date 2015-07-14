//
//  BarrageItemView.h
//  BarrageDemo
//
//  Created by 李剑钊 on 15/7/2.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarrageProtocol.h"
#import "UIView+Metrics.h"

@interface BarrageItemView : UIView<BarrageItemProtocol>

/// default = 360
@property (nonatomic, assign) NSInteger maxWidth;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) UIColor *detailColor;

@end
