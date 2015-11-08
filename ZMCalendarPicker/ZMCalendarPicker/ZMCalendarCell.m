//
//  ZMCalendarCell.m
//  ZMCalendarPicker
//
//  Created by 朱敏 on 15/11/9.
//  Copyright © 2015年 Arron Zhu. All rights reserved.
//

#import "ZMCalendarCell.h"

@implementation ZMCalendarCell
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        UILabel *label = [[UILabel alloc] init];
        _dateLabel = label;
        _dateLabel.layer.cornerRadius = 10.0f;
        _dateLabel.clipsToBounds = YES;
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (void)layoutSubviews {
    
    CGFloat width = self.bounds.size.width;
    CGFloat heigth = self.bounds.size.height;
    _dateLabel.frame = CGRectMake(2, 2, width - 4, heigth - 4);
}
@end
