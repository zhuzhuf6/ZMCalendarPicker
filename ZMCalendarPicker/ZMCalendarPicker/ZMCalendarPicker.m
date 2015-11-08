//
//  ZMCalendarPicker.m
//  ZMCalendarPicker
//
//  Created by 朱敏 on 15/11/9.
//  Copyright © 2015年 Arron Zhu. All rights reserved.
//

#import "ZMCalendarPicker.h"
#import "UIColor+HEXString.h"
#import "NSDateComponents+DealDate.h"
#import "UIView+FRAME.h"
#import "ZMCalendarCell.h"

#define kTwentyYear 60 * 60 * 24 * 365 * 20
#define kWeeklyDays 7
#define kSpace      10
#define kHeight     16
#define kScreen     [UIScreen mainScreen].bounds

@interface ZMCalendarPicker ()
/**
 *  日历九宫格
 */
@property (nonatomic, weak) UICollectionView *collectionView;
/**
 *  选中模式下数据字典
 */
@property (nonatomic, strong) NSMutableDictionary *chooseDateDict;
/**********************************  toolView  **********************************/

/**
 *  toolView
 */
@property (nonatomic, weak) UIView *toolView;
/**
 *  左侧按钮
 */
@property (nonatomic, weak) UIButton *leftButton;
/**
 *  右侧按钮
 */
@property (nonatomic, weak) UIButton *rightButton;
/**
 *  中间的时间显示按钮
 */
@property (nonatomic, weak) UIButton *dateButton;

/**********************************  end  **********************************/

/**
 *  周一到周日视图
 */
@property (nonatomic, weak) UIView *weeklyView;
/**
 *  蒙版
 */
@property (nonatomic, strong) UIView *mask;

@end

@implementation ZMCalendarPicker
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 数据初始化
        self.targetDate = [NSDate date];
        self.startDate = [NSDate dateWithTimeIntervalSinceNow:-kTwentyYear];
        self.startDate = [NSDate dateWithTimeIntervalSinceNow:kTwentyYear];
        
        self.backgroundColor = [UIColor colorWithWhite:0.985 alpha:1];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.mask) [self addTapWithMask];
    [self addSwipeWithSelf];
}

#pragma mark - custon method
- (void)addTapWithMask {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.mask addGestureRecognizer:tap];
}

- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
        self.mask.alpha = 0;
    } completion:^(BOOL isFinished) {
        [self.mask removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)addSwipeWithSelf
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextShow)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseShow)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)chooseDateDict {
    if (!_chooseDateDict) {
        _chooseDateDict = [NSMutableDictionary dictionary];
    }
    return _chooseDateDict;
}

- (UIView *)weeklyView {
    if (!_weeklyView) {
        UIView *view = [[UIView alloc] init];
        NSArray *array = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        _weeklyView = view;
        for (int i = 0; i < kWeeklyDays; i++) {
            UILabel *label = [[UILabel alloc] init];
            [label setText:array[i]];
            label.font = [UIFont systemFontOfSize:15];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            [_weeklyView addSubview:label];
        }
        [self addSubview:_weeklyView];
    }
    return _weeklyView;
}
@end
