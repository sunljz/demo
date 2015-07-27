//
//  UIView+Metrics.h
//  NeeFrame
//
//  Created by 李剑钊 on 15/7/24.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  方便的访问和设置View的属性
 */
@interface UIView (Layout)

@property (assign, nonatomic) CGFloat	top;
@property (assign, nonatomic) CGFloat	bottom;
@property (assign, nonatomic) CGFloat	left;
@property (assign, nonatomic) CGFloat	right;

@property (assign, nonatomic) CGFloat	x;
@property (assign, nonatomic) CGFloat	y;
@property (assign, nonatomic) CGPoint	origin;

@property (assign, nonatomic) CGFloat	centerX;
@property (assign, nonatomic) CGFloat	centerY;

@property (assign, nonatomic) CGFloat	width;
@property (assign, nonatomic) CGFloat	height;
@property (assign, nonatomic) CGSize	size;


@end
