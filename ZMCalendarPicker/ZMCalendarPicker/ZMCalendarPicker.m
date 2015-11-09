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
#define kWeeklyDays 7.0
#define kSpace      10
#define kHeight     16
#define kScreen     [UIScreen mainScreen].bounds
#define kCollectionCellCount 42
#define ZMIdentifier @"calendarCell"
#define kCellColor  @"cellColor"
#define kCellStatus  @"cellStatus"

@interface ZMCalendarPicker () <UICollectionViewDataSource, UICollectionViewDelegate>
/**
 *  日历九宫格
 */
@property (nonatomic, weak) UICollectionView *collectionView;
/**
 *  选中模式下数据字典
 */
@property (nonatomic, strong) NSMutableDictionary *chooseDateDict;
/**
 *  当前日历显示的时间
 */
@property (nonatomic, strong) NSDate *currentDate;
/**********************************  toolView  **********************************/

/**
 *  toolView
 */
@property (nonatomic, weak) UIView *toolBarView;
/**
 *  中间的时间显示按钮
 */
@property (nonatomic, weak) UIButton *dateButton;
/**
 *  左按钮
 */
@property (nonatomic, weak) UIButton *leftButton;
/**
 *  右按钮
 */
@property (nonatomic, weak) UIButton *rightButton;

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
        self.endDate = [NSDate dateWithTimeIntervalSinceNow:kTwentyYear];
        self.outDateColor = [UIColor colorWithHexString:@"#e9e9e9"];
        self.inDateColor = [UIColor blackColor];
        
        
        [self.collectionView registerClass:[ZMCalendarCell class] forCellWithReuseIdentifier:ZMIdentifier];
        self.backgroundColor = [UIColor colorWithWhite:0.985 alpha:1];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.mask) [self addTapWithMask];
    if (self.chooseDateArray) [self manageChooseDict];
    [self addSwipeWithSelf];
    [self showCollectionView];
}

#pragma mark - custon method
- (void)manageChooseDict{
    for (NSArray *array in self.chooseDateArray) {
        if (![array isKindOfClass:[NSArray class]]) {
            NSLog(@"请传入正确数据");
            return;
        } else {
            for (NSDate *date in array) {
                if (![date isKindOfClass:[NSDate class]]) {
                    NSLog(@"请传入正确数据");
                    return;
                }
            }
        }
    }
    
    for (UIColor *color in self.chooseDateColorArray) {
        if (![color isKindOfClass:[UIColor class]]) {
            NSLog(@"请传入正确数据");
            return;
        }
    }
    
    if (self.chooseDateColorArray.count != self.chooseDateArray.count) {
        NSLog(@"chooseDateColorArray.count != chooseDateArray.count");
        return;
    }
    
    for (int i = 0; i < self.chooseDateArray.count; i++) {
        NSArray *array = self.chooseDateArray[i];
        
        for (NSDate *date in array) {
            NSString *year = [NSString stringWithFormat:@"%ld", [NSDateComponents year:date]];
            NSDictionary *yearDict = self.chooseDateDict[year];
            if (!yearDict) {
                yearDict = [NSMutableDictionary dictionary];
                [self.chooseDateDict setValue:yearDict forKey:year];
            }
            
            NSString *month = [NSString stringWithFormat:@"%ld", [NSDateComponents month:date]];
            NSDictionary *monthDict = yearDict[month];
            if (!monthDict) {
                monthDict = [NSMutableDictionary dictionary];
                [yearDict setValue:monthDict forKey:month];
            }
            
            NSString *day = [NSString stringWithFormat:@"%ld", [NSDateComponents day:date]];
            NSDictionary *dayDict = monthDict[day];
            if (!dayDict) {
                dayDict = [NSMutableDictionary dictionary];
                [monthDict setValue:dayDict forKey:day];
            }
            
            [dayDict setValue:self.chooseDateColorArray[i] forKey:kCellColor];
            [dayDict setValue:[NSString stringWithFormat:@"%d", i + 10] forKey:kCellStatus];
        }
    }
    
}

- (void)judgeButtonStatus {
    // 判断是否是结束日期
    if ([NSDateComponents year:self.currentDate] == [NSDateComponents year:self.endDate] && [NSDateComponents month:self.currentDate] == [NSDateComponents month:self.endDate]) {
        self.rightButton.enabled = NO;
    } else if ([NSDateComponents year:self.currentDate] == [NSDateComponents year:self.startDate] && [NSDateComponents month:self.currentDate] == [NSDateComponents month:self.startDate]) {
        self.leftButton.enabled = NO;
    } else {
        self.leftButton.enabled = YES;
        self.rightButton.enabled = YES;
    }
}

- (void)showCollectionView {
    [self judgeButtonStatus];
    
    self.transform = CGAffineTransformTranslate(self.transform, 0, - self.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        [self customFlowLayout];
    }];
}

- (void)customFlowLayout {
    CGFloat itemWidth = (_collectionView.frame.size.width - (kWeeklyDays + 1) * kSpace) / kWeeklyDays;
    CGFloat itemHeight = (_collectionView.frame.size.height - kWeeklyDays * kSpace) / (kWeeklyDays - 1);
    
    if (!self.flowLayout) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, kSpace, 0, kSpace);
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = kSpace;
        layout.minimumInteritemSpacing = kSpace;
        self.flowLayout = layout;
    }
    [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
}

- (void)setFlowLayout:(UICollectionViewFlowLayout *)flowLayout {
    _flowLayout = flowLayout;
    [self customFlowLayout];
}

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

- (void)nextShow {
    // 判断是否是结束日期
    if ([NSDateComponents year:self.currentDate] == [NSDateComponents year:self.endDate] && [NSDateComponents month:self.currentDate] == [NSDateComponents month:self.endDate]) return;
    // 进行动画
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.currentDate = [NSDateComponents nextMonth:self.currentDate];
    } completion:nil];
}

- (void)previouseShow {
    // 判断是否是开始日期
    if ([NSDateComponents year:self.currentDate] == [NSDateComponents year:self.startDate] && [NSDateComponents month:self.currentDate] == [NSDateComponents month:self.startDate]) return;
    // 进行动画
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.currentDate = [NSDateComponents lastMonth:self.currentDate];
    } completion:nil];
}

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    
    [self judgeButtonStatus];
    
    [self.dateButton setTitle:[NSString stringWithFormat:@"%ld-%.2ld",[NSDateComponents year:self.currentDate],(long)[NSDateComponents month:self.currentDate]] forState:UIControlStateNormal];
    [_collectionView reloadData];
}

- (void)setTargetDate:(NSDate *)targetDate {
    _targetDate = targetDate;
    self.startDate = [NSDate dateWithTimeInterval:-kTwentyYear sinceDate:_targetDate];
    self.endDate = [NSDate dateWithTimeInterval:kTwentyYear sinceDate:_targetDate];
    self.currentDate = _targetDate;
}

- (void)layoutSubviews {
    self.toolBarView.frame = CGRectMake(0, 0, kScreen.size.width, kSpace + kHeight);
    
    self.weeklyView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame) + 10, kScreen.size.width, kHeight);
    
    CGFloat width = (kScreen.size.width - (kWeeklyDays + 1) * kSpace) / kWeeklyDays;
    int i = 0;
    for (UILabel *label in self.weeklyView.subviews) {
        label.frame = CGRectMake((kSpace + width) * i + kSpace, 0, width, kHeight);
        i++;
    }
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.weeklyView.frame) + 10, kScreen.size.width, self.height - CGRectGetMaxY(self.weeklyView.frame) - 10);
}

- (void)showInView:(UIView *)view andResult:(chooseDateBlock)chooseDate {
    if (!view) {
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        view = window.rootViewController.view;
    }
    
    UIView *mask = [[UIView alloc] initWithFrame:view.bounds];
    mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.mask = mask;
    [view addSubview:mask];
    [view addSubview:self];
    self.chooseDateBlock = chooseDate;
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kCollectionCellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZMCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZMIdentifier forIndexPath:indexPath];
    cell.dateLabel.backgroundColor = [UIColor clearColor];
    [cell.dateLabel setTextColor:[UIColor blackColor]];
    
    NSInteger daysInThisMonth = [NSDateComponents totaldaysInMonth:self.currentDate];
    NSInteger firstWeekday = [NSDateComponents firstWeekdayInThisMonth:self.currentDate];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    
    if (i < firstWeekday) {
        [cell.dateLabel setText:@""];
    } else if (i > firstWeekday + daysInThisMonth - 1){
        [cell.dateLabel setText:@""];
    } else {
        day = i - firstWeekday + 1;
        [cell.dateLabel setText:[NSString stringWithFormat:@"%ld",day]];

        // 优先判定是否是选择模式下
        NSString *year = [NSString stringWithFormat:@"%ld", [NSDateComponents year:self.currentDate]];
        NSString *month = [NSString stringWithFormat:@"%ld", [NSDateComponents month:self.currentDate]];
        NSDate *todayDate = [NSDateComponents dateWithSlashFromStr:[NSString stringWithFormat:@"%@-%@-%@", year, month, [NSString stringWithFormat:@"%ld", day]]];
        
        NSDictionary *dayDict = [self.chooseDateDict valueForKeyPath:[NSString stringWithFormat:@"%@.%@.%@", year, month, [NSString stringWithFormat:@"%ld", day]]];
        if (dayDict) {
            [cell.dateLabel setTextColor:[UIColor whiteColor]];
            cell.dateLabel.backgroundColor = dayDict[kCellColor];
            cell.tag = [dayDict[kCellStatus] integerValue];
        } else if ([todayDate compare:self.startDate] == NSOrderedAscending || [todayDate compare:self.endDate] == NSOrderedDescending) {
            [cell.dateLabel setTextColor:self.outDateColor];
            cell.tag = 1;
        } else {
            [cell.dateLabel setTextColor:self.inDateColor];
            cell.tag = 0;
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZMCalendarCell *cell = (ZMCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.dateLabel.text) return NO;
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __block ZMCalendarCell *cell = (ZMCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSString *day = cell.dateLabel.text;
    NSString *year = [NSString stringWithFormat:@"%ld", [NSDateComponents year:self.currentDate]];
    NSString *month = [NSString stringWithFormat:@"%ld", [NSDateComponents month:self.currentDate]];
    __block NSDate *todayDate = [NSDateComponents dateWithSlashFromStr:[NSString stringWithFormat:@"%@-%@-%@", year, month, day]];
    
    if ([self.delegate respondsToSelector:@selector(calendarPicker:DidChooseDate:withStatus:)]) {
        [self.delegate calendarPicker:self DidChooseDate:todayDate withStatus:cell.tag];
    }
    
    if (self.chooseDateBlock) self.chooseDateBlock(todayDate, cell.tag);
}

#pragma mark - 懒加载
- (NSMutableDictionary *)chooseDateDict {
    if (!_chooseDateDict) {
        _chooseDateDict = [NSMutableDictionary dictionary];
    }
    return _chooseDateDict;
}

- (UIView *)toolBarView {
    if (!_toolBarView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#45B5AF"];
        _toolBarView = view;
        [self addSubview:view];
    }
    return _toolBarView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSpace, 5, kHeight, kHeight)];
        [leftBtn addTarget:self action:@selector(previouseShow) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"bt_previous"] forState:UIControlStateNormal];
        [self.toolBarView addSubview:leftBtn];
        _leftButton = leftBtn;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen.size.width - kSpace * 2 - kHeight, 5, kHeight, kHeight)];
        [rightBtn addTarget:self action:@selector(nextShow) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"bt_next"] forState:UIControlStateNormal];
        [self.toolBarView addSubview:rightBtn];
        _rightButton = rightBtn;
    }
    return _rightButton;
}

- (UIButton *)dateButton {
    if (!_dateButton) {
        UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreen.size.width - 8 * kSpace) / 2.0, 5, 8 * kSpace, kHeight)];
        dateButton.titleLabel.font = [UIFont systemFontOfSize:16];
        dateButton.titleLabel.textColor = [UIColor whiteColor];
        dateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.toolBarView addSubview:dateButton];
        _dateButton = dateButton;
    }
    return _dateButton;
}

- (UIView *)weeklyView {
    if (!_weeklyView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
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

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreen.size.width, 300) collectionViewLayout:[[UICollectionViewLayout alloc] init]];
        view.backgroundColor = [UIColor clearColor];
        _collectionView = view;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
@end
