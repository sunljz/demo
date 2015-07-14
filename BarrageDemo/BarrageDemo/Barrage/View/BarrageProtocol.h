//
//  BarrageProtocol.h
//  BarrageDemo
//
//  Created by 李剑钊 on 15/7/2.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#ifndef BarrageDemo_BarrageProtocol_h
#define BarrageDemo_BarrageProtocol_h

#import <CoreGraphics/CoreGraphics.h>

@protocol BarrageItemProtocol <NSObject>

/// 速度 point per second
@property (nonatomic, readwrite) CGFloat speed;

/// 当前路程，即弹幕跑了多长
@property (nonatomic, assign) CGFloat curDistance;

@end

#endif
