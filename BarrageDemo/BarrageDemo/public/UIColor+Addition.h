//
//  UIColor+Addition.h
//  QiaoQiaoMovie
//
//  Created by zelong zou on 13-3-17.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import <UIKit/UIKit.h>


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface UIColor (Addition)
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert alpha:(float) alpha;
//颜色转字符串
- (NSString *) changeUIColorToRGB;
@end
