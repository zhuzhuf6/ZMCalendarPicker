//
//  ViewController.m
//  ZMCalendarPicker
//
//  Created by 朱敏 on 15/11/9.
//  Copyright © 2015年 Arron Zhu. All rights reserved.
//

#import "ViewController.h"
#import "ZMCalendarPicker.h"
#import "UIColor+HEXString.h"
#import "UIView+FRAME.h"

#define kScreen     [UIScreen mainScreen].bounds
#define kOneYear  60 * 60 * 24 * 365
#define kOneMonth 60 * 60 * 24 * 30
#define kOneDay   60 * 60 * 24

@interface ViewController () <ZMCalendarPickerDelegate>
/**
 *  normalPickView
 */
@property (nonatomic, weak) ZMCalendarPicker *normalPick;
/**
 *  StatusPickView
 */
@property (nonatomic, weak) ZMCalendarPicker *stautsPick;
@end

@implementation ViewController
/**
 *  没有蒙版效果的普通日历
 */
- (IBAction)calendarWithOutMask:(id)sender {
    if (self.normalPick.x < 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.stautsPick.x = kScreen.size.width;
            self.normalPick.x = 0;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.normalPick.x = -kScreen.size.width;
        }];
    }
}
/**
 *  带有蒙版效果的弹出式日历
 */
- (IBAction)calendarWithMask:(id)sender {
    ZMCalendarPicker *picker = [[ZMCalendarPicker alloc] init];
    picker.frame = CGRectMake(0, 150, kScreen.size.width, 300);
    picker.targetDate = [NSDate date];
    picker.startDate = [NSDate dateWithTimeInterval:-kOneMonth * 2 sinceDate:picker.targetDate];
    picker.endDate = [NSDate dateWithTimeInterval:kOneMonth * 2 sinceDate:picker.targetDate];
    // 设置选择模式数据！！！
    NSMutableArray *statusArray1 = [NSMutableArray array];
    NSMutableArray *statusArray2 = [NSMutableArray array];
    NSMutableArray *statusArray3 = [NSMutableArray array];
    for (int i = 0; i < 30; i++) {
        NSDate *date = [NSDate dateWithTimeInterval:kOneDay * i sinceDate:[NSDate date]];
        if (i % 3 == 0) [statusArray1 addObject:date];
        if (i % 3 == 1) [statusArray2 addObject:date];
        if (i % 3 == 2) [statusArray3 addObject:date];
    }
    NSArray *dateArray = [NSArray arrayWithObjects:statusArray1, statusArray2, statusArray3, nil];
    NSArray *colorArray = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"#2F99FF"], [UIColor colorWithHexString:@"#EDCF18"], [UIColor colorWithHexString:@"#D4484E"], nil];
    
    picker.chooseDateArray = dateArray;
    picker.chooseDateColorArray = colorArray;
    
    // 带有蒙版效果的弹出式日历,必须通过此方法创建
    [picker showInView:nil andResult:^(NSDate *chooseDate, NSInteger status) {
        NSLog(@"%@-%ld", chooseDate, status);
    }];
}
/**
 *  没有蒙版效果的多状态日历
 */
- (IBAction)calendarWithVarietyStatus:(id)sender {
    
    if (self.stautsPick.x > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.normalPick.x = -kScreen.size.width;
            self.stautsPick.x = 0;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.stautsPick.x = kScreen.size.width;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"ZMCalendarPicker";
    
    self.normalPick.frame = CGRectMake(-kScreen.size.width, 210, kScreen.size.width, 300);
    self.stautsPick.frame = CGRectMake(kScreen.size.width, 210, kScreen.size.width, 300);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn addTarget:self action:@selector(openUrl) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 15.0f;
    btn.clipsToBounds = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)openUrl {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/zhuzhuf6"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZMCalendarPickerDelegate
- (void)calendarPicker:(ZMCalendarPicker *)calendarPicker DidChooseDate:(NSDate *)chooseDate withStatus:(NSInteger)status {
    NSLog(@"%@-%ld", chooseDate, status);
}

#pragma mark - 懒加载
- (ZMCalendarPicker *)normalPick {
    if (!_normalPick) {
        ZMCalendarPicker *picker = [[ZMCalendarPicker alloc] init];
        picker.targetDate = [NSDate dateWithTimeIntervalSinceNow:-kOneYear];
        picker.startDate = [NSDate dateWithTimeInterval:- kOneYear - kOneMonth * 3 sinceDate:picker.targetDate];
        picker.endDate = [NSDate dateWithTimeInterval:kOneDay sinceDate:picker.targetDate];
        picker.delegate = self;
        [self.view addSubview:picker];
        _normalPick = picker;
    }
    return _normalPick;
}

- (ZMCalendarPicker *)stautsPick {
    if (!_stautsPick) {
        ZMCalendarPicker *picker = [[ZMCalendarPicker alloc] init];
        picker.targetDate = [NSDate date];
        picker.startDate = [NSDate dateWithTimeInterval:-kOneMonth * 3 sinceDate:picker.targetDate];
        picker.endDate = [NSDate dateWithTimeInterval:kOneMonth * 3 sinceDate:picker.targetDate];
        [self.view addSubview:picker];
        // 设置选择模式数据！！！
        NSMutableArray *statusArray1 = [NSMutableArray array];
        NSMutableArray *statusArray2 = [NSMutableArray array];
        NSMutableArray *statusArray3 = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            NSDate *date = [NSDate dateWithTimeInterval:kOneDay * i sinceDate:[NSDate date]];
            if (i % 3 == 0) [statusArray1 addObject:date];
            if (i % 3 == 1) [statusArray2 addObject:date];
            if (i % 3 == 2) [statusArray3 addObject:date];
        }
        NSArray *dateArray = [NSArray arrayWithObjects:statusArray1, statusArray2, statusArray3, nil];
        NSArray *colorArray = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"#2F99FF"], [UIColor colorWithHexString:@"#EDCF18"], [UIColor colorWithHexString:@"#D4484E"], nil];
        
        picker.chooseDateArray = dateArray;
        picker.chooseDateColorArray = colorArray;
        // end
        picker.delegate = self;
        _stautsPick = picker;
    }
    return _stautsPick;
}

@end
