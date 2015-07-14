//
//  BarrageItemView.m
//  BarrageDemo
//
//  Created by 李剑钊 on 15/7/2.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "BarrageItemView.h"
#import "UIColor+Addition.h"

@interface BarrageItemView () {
    CGFloat mySpeed;
    CGFloat myCurDistance;
}

@property (nonatomic, strong) UILabel *detailLabel;

@end


@implementation BarrageItemView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maxWidth = 360;
        [self addSubview:self.detailLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _detailLabel.frame = self.bounds;
}

- (void)dealloc {
	
}

#pragma mark - setter and getter

- (void)setDetail:(NSString *)detail {
    if ([_detail isEqualToString:detail] == NO) {
        _detail = detail;
        _detailLabel.text = detail;
        CGSize size = [_detailLabel sizeThatFits:CGSizeMake(_maxWidth, 20)];
        self.bounds = CGRectMake(0, 0, size.width, size.height);
    }
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithHexString:@"ffffff"];
        label.font = [UIFont systemFontOfSize:15];
        _detailLabel = label;
    }
    return _detailLabel;
}

- (void)setDetailColor:(UIColor *)detailColor {
    _detailColor = detailColor;
    _detailLabel.textColor = detailColor;
}

- (void)setSpeed:(CGFloat)speed {
    mySpeed = speed;
}

- (CGFloat)speed {
    return mySpeed;
}

- (void)setCurDistance:(CGFloat)curDistance {
    myCurDistance = curDistance;
}

- (CGFloat)curDistance {
    return myCurDistance;
}

@end
