//
//  ZMCalendarPicker.h
//  ZMCalendarPicker
//
//  Created by 朱敏 on 15/11/9.
//  Copyright © 2015年 Arron Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMCalendarPicker;

/**
 *  block返回结果
 *
 *  @param chooseDate 选择的日期
 *  @param status     返回选择日期的状态， 在开始日期-结束日期之间 == 0，  在开始日期-结束日期之外 == 1
 *                    其他值：如果成功开启选择模式，chooseDateArray 的返回的值为 数组index + 10;
 *                    chooseDateArray中第一组数组返回为10，第二组为11，依次+1
 */
typedef void(^chooseDateBlock)(NSDate *chooseDate, NSInteger status);

@protocol ZMCalendarPickerDelegate <NSObject>
@optional
/**
 *  代理返还结果
 *
 *  @param calendarPicker 日历
 *  @param chooseDate     选择的日期
 *  @param status         返回选择日期的状态， 在开始日期-结束日期之间 == 0，  在开始日期-结束日期之外 == 1
 *                        其他值：如果成功开启选择模式，chooseDateArray 的返回的值为 数组index + 10;
 *                        chooseDateArray中第一组数组返回为10，第二组为11，依次+1
 */
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


- (void)showInView:(UIView *)view andResult:(chooseDateBlock)chooseDate;
@end
