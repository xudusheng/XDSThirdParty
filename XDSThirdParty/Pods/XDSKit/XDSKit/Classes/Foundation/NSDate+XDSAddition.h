//
//  NSDate+XDSAddition.h
//  XDSKit
//
//  Created by Hmily on 2017/3/18.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XDSAddition)

//NSString转化为NSDate （format可定义为一个枚举）
+ (NSDate*)convertDateFromString:(NSString*)uiDate
                          format:(NSString *)format;

//根据年月日时分秒获取NSDate (zone可定义为一个枚举)
+ (NSDate *)dateFromYear:(NSUInteger)year
                   month:(NSUInteger)month
                     day:(NSUInteger)day
                    hour:(NSUInteger)hour
                  minute:(NSUInteger)minute
                  second:(NSUInteger)second
                    zone:(NSString *)zone;

//日期转换
+ (NSString *)timeStringForTime:(NSUInteger)time;//整形时间转化为00:00字符串

//比较2个日期大小
- (NSComparisonResult)compareDay:(NSDate *)anotherDay;

//转换为特定格式的字符串，format为@“HH:mm”返回时分 （format可定义为一个枚举）
- (NSString *)stringWithFormat:(NSString *)format;



//计算时间 例如：刚刚、几秒钟前、几分钟前
- (NSInteger)secondsAgo;
- (NSInteger)minutesAgo;
- (NSInteger)hoursAgo;
- (NSInteger)monthsAgo;
- (NSInteger)yearsAgo;
- (NSString *)stringTimesAgo;//代码更新时间

@end
