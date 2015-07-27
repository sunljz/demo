//
//  UIView+Metrics.m
//  NeeFrame
//
//  Created by 李剑钊 on 15/7/24.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

@dynamic top;
@dynamic bottom;
@dynamic left;
@dynamic right;

@dynamic width;
@dynamic height;

@dynamic size;

@dynamic x;
@dynamic y;

- (CGFloat)top
{
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
	CGRect frame = self.frame;
	frame.origin.y = top;
	self.frame = frame;
}

- (CGFloat)left
{
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
	CGRect frame = self.frame;
	frame.origin.x = left;
	self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)x
{ 
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
	CGRect frame = self.frame;
	frame.origin.x = value;
	self.frame = frame;
}

- (CGFloat)y
{
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
	CGRect frame = self.frame;
	frame.origin.y = value;
	self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
	return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

@end
