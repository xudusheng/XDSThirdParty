//
//  NSDate+XDSAddition.m
//  XDSKit
//
//  Created by Hmily on 2017/3/18.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "NSDate+XDSAddition.h"

//static NSString *kNSDateAdditionFormatFullDateWithTime    = @"MMM d, yyyy h:mm a";
//static NSString *kNSDateAdditionFormatFullDate            = @"MMM d, yyyy";
//static NSString *kNSDateAdditionFormatShortDateWithTime   = @"MMM d h:mm a";
//static NSString *kNSDateAdditionFormatShortDate           = @"MMM d";
//static NSString *kNSDateAdditionFormatWeekday             = @"EEEE";
//static NSString *kNSDateAdditionFormatWeekdayWithTime     = @"EEEE h:mm a";
//static NSString *kNSDateAdditionFormatTime                = @"h:mm a";
//static NSString *kNSDateAdditionFormatTimeWithPrefix      = @"'at' h:mm a";
//static NSString *kNSDateAdditionFormatSQLDate             = @"yyyy-MM-dd";
//static NSString *kNSDateAdditionFormatSQLTime             = @"HH:mm:ss";
//static NSString *kNSDateAdditionFormatSQLDateWithTime     = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDate (XDSAddition)

static NSCalendar *_calendar = nil;
static NSDateFormatter *_displayFormatter = nil;

+ (void)initializeStatics {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
#if __has_feature(objc_arc)
                _calendar = [NSCalendar currentCalendar];
#else
                _calendar = [[NSCalendar currentCalendar] retain];
#endif
            }
            if (_displayFormatter == nil) {
                _displayFormatter = [[NSDateFormatter alloc] init];
            }
        }
    });
}

+ (NSCalendar *)sharedCalendar {
    [self initializeStatics];
    return _calendar;
}

+ (NSDateFormatter *)sharedDateFormatter {
    [self initializeStatics];
    return _displayFormatter;
}


#pragma mark - 新增方法
//TODO:NSString转化为NSDate
+ (NSDate*)convertDateFromString:(NSString*)uiDate
                          format:(NSString *)format{
    NSParameterAssert(uiDate);
    NSParameterAssert(format);//如：@"yyyy-MM-dd HH:mm:ss"
    
    NSDateFormatter *formatter = [[self class] sharedDateFormatter];;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

//TODO:根据年月日时分秒获取NSDate
+ (NSDate *)dateFromYear:(NSUInteger)year
                   month:(NSUInteger)month
                     day:(NSUInteger)day
                    hour:(NSUInteger)hour
                  minute:(NSUInteger)minute
                  second:(NSUInteger)second
                    zone:(NSString *)zone{
    if (!zone || zone.length < 1) {
        zone = @"GMT";
    }
    NSDate *date = [NSDate date];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:zone];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setTimeZone:gmt];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond  fromDate:date];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    NSDate *newDate = [gregorian dateFromComponents: components];
    return newDate;
}

//TODO:整形时间转化为00:00字符串
+ (NSString *)timeStringForTime:(NSUInteger)time{
    NSString *timeString;
    
    if (time < 60) {
        if (time < 10) {
            timeString = [NSString stringWithFormat:@"00 : 0%lu", (unsigned long)time];
        } else {
            timeString = [NSString stringWithFormat:@"00 : %lu", (unsigned long)time];
        }
    } else if (time >= 60) {
        NSUInteger minute = time/60;
        NSUInteger second = time % 60;
        NSString *minuteString;
        NSString *secondString;
        if (minute < 10) {
            minuteString = [NSString stringWithFormat:@"0%lu", (unsigned long)minute];
        } else {
            minuteString = [NSString stringWithFormat:@"%lu", (unsigned long)minute];
        }
        if (second < 10) {
            secondString = [NSString stringWithFormat:@"0%lu", (unsigned long)second];
        } else {
            secondString = [NSString stringWithFormat:@"%lu", (unsigned long)second];
        }
        timeString = [NSString stringWithFormat:@"%@ : %@", minuteString, secondString];
    }
    
    return timeString;
}



//TODO:比较2个日期大小
- (NSComparisonResult)compareDay:(NSDate *)anotherDay{
    NSParameterAssert(anotherDay);
    
    NSDateFormatter *dateFormatter = [[self class] sharedDateFormatter];;
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:self];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    return result;
}

//TODO:format为@“HH:mm”返回时分
- (NSString *)stringWithFormat:(NSString *)format{
    NSParameterAssert(format);
    NSDateFormatter *dateFormatter = [[self class] sharedDateFormatter];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

//TODO：获取中文日期
+ (NSString *)getChinaDate:(NSString *)dateString
                    format:(NSString *)format{
    NSParameterAssert(dateString);
    NSParameterAssert(format);
    
    NSDateFormatter *dateformatter = [[self class] sharedDateFormatter];//定义NSDateFormatter用来显示格式
    [dateformatter setDateFormat:format];//设定格式
    
    NSCalendar *cal = [[self class] sharedCalendar];//定义一个NSCalendar对象
    
    NSDate *todate = [dateformatter dateFromString:dateString];
    
    NSDate *today = [NSDate date];//得到当前时间
    //用来得到具体的时差
    unsigned int unitFlags;
    unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | kCFCalendarUnitSecond;
    NSDateComponents *comps = [cal components:unitFlags fromDate:today toDate:todate options:0];
    
    if ([comps year]>0) {
        return [NSString stringWithFormat:@"%d年%d月%d天",(int)[comps year], (int)[comps month], (int)[comps day]];
    }else if ([comps month]>0) {
        return [NSString stringWithFormat:@"%d月%d天%d小时",(int)[comps month],(int)[comps day],(int)[comps hour]];
    }else if ([comps day]>0) {
        return [NSString stringWithFormat:@"%d天%d小时%d分",(int)[comps day],(int)[comps hour],(int)[comps minute]];
    }else if ([comps hour]>0) {
        return [NSString stringWithFormat:@"%d小时%d分",(int)[comps hour],(int)[comps minute]];
    }else if ([comps minute]>0) {
        return [NSString stringWithFormat:@"%d分钟",(int)[comps minute]];
    }else if ([comps second]>0){
        return @"1分";
    }else {
        return @"已过期";
    }
}


- (NSInteger)secondsAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitSecond)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components second];
}
- (NSInteger)minutesAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components minute];
}
- (NSInteger)hoursAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components hour];
}
- (NSInteger)monthsAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components month];
}

- (NSInteger)yearsAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components year];
}


- (NSString *)stringTimesAgo{
    if ([self compare:[NSDate date]] == NSOrderedDescending) {
        return @"刚刚";
    }
    
    NSString *text = nil;
    
    NSInteger agoCount = [self monthsAgo];
    if (agoCount > 0) {
        text = [NSString stringWithFormat:@"%ld个月前", (long)agoCount];
    }else{
        agoCount = [self daysAgoAgainstMidnight];
        if (agoCount > 0) {
            text = [NSString stringWithFormat:@"%ld天前", (long)agoCount];
        }else{
            agoCount = [self hoursAgo];
            if (agoCount > 0) {
                text = [NSString stringWithFormat:@"%ld小时前", (long)agoCount];
            }else{
                agoCount = [self minutesAgo];
                if (agoCount > 0) {
                    text = [NSString stringWithFormat:@"%ld分钟前", (long)agoCount];
                }else{
                    agoCount = [self secondsAgo];
                    if (agoCount > 15) {
                        text = [NSString stringWithFormat:@"%ld秒前", (long)agoCount];
                    }else{
                        text = @"刚刚";
                    }
                }
            }
        }
    }
    return text;
}

- (NSUInteger)daysAgoAgainstMidnight {
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [[self class] sharedDateFormatter];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}
@end
