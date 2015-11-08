//
//  ZMCalendarPicker.h
//  ZMCalendarPicker
//
//  Created by 朱敏 on 15/11/9.
//  Copyright © 2015年 Arron Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMCalendarPicker;

typedef void(^chooseDateBlock)(NSDate *chooseDate, NSInteger status);

@protocol ZMCalendarPickerDelegate <NSObject>
@optional
- (void)calendarPicker:(ZMCalendarPicker *)calendarPicker DidChooseDate:(NSDate *)chooseDate withStatus:(NSInteger)status;

@end

@interface ZMCalendarPicker : UIView
/**********************************  ZMCalendarPicker属性设置  **********************************/

/**
 *  当前日期(默认为今天)
 */
@property (nonatomic, strong) NSDate *targetDate;
/**
 *  开始日期(默认为今天 - 20年)
 */
@property (nonatomic, strong) NSDate *startDate;
/**
 *  结束日期(默认为今天 + 20年)
 */
@property (nonatomic, strong) NSDate *endDate;
/**
 *  开始日期至结束日期范围内的字体颜色
 */
@property (nonatomic, strong) UIColor *inDateColor;
/**
 *  开始日期至结束日期范围之外的字体颜色
 */
@property (nonatomic, strong) UIColor *outDateColor;
/**
 *  选择模式！！！
 *  数组chooseDateArray包存储着数组B, B数组中存储着一组需要设置相同底色的NSDate
 *  chooseDateArray数量必须与chooseDateColorArray数量相同
 *  数据模式设置错误无效！！！
 */
@property (nonatomic, strong) NSArray *chooseDateArray;
/**
 *  选择模式！！！
 *  数组chooseDateColorArray包存UIColor, 用于存储对应chooseDateArray中的底色
 *  chooseDateArray数量必须与chooseDateColorArray数量相同
 *  数据模式设置错误无效！！！
 */
@property (nonatomic, strong) NSArray *chooseDateColorArray;
/**
 *  流水布局
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/**********************************  end  **********************************/

/**
 *  代理
 */
@property (nonatomic, weak) id delegate;
/**
 *  block
 */
@property (nonatomic, copy) chooseDateBlock chooseDateBlock;

@end
