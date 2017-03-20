//
//  NSString+XDSAddition.h
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XDSAddition)

//清空字符串中的空白字符
- (NSString *)trimString;

//md5加密(全大写)
- (NSString *)md5String;

//base64加密
- (NSData *)base64StringData;
+ (NSString *)base64StringFromData:(NSData *)data;

//将一个数字字符串保留指定的位数,digit为保留的位数
- (NSString *)decimalString:(NSInteger)digit
                              decimalStyle:(BOOL)flag;
//四舍五入方法
+ (NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV;
//将一个数字字符串转换为百分号显示,保留2位
- (NSString *)percentageString;
//得到两位随机数
+ (NSString *)twoCharRandom;



typedef NS_ENUM(NSInteger, CalculateType){
    CalculateTypeAdding = 0,//加
    CalculateTypeSubtracting,//减
    CalculateTypeMultiplying,//乘
    CalculateTypeDividing,//除
};
//高精度的加减乘除
+ (NSString *)calculateWithFirstValue:(NSString *)firstValue
                          secondValue:(NSString *)secondValue
                                 type:(CalculateType)type;

//校验身份证
- (BOOL)validateIDCardNumber;

//判断是否为整形
- (BOOL)isPureInt;
//判断是否为浮点形
- (BOOL)isPureFloat;
//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo;
- (BOOL)isEmail;
- (BOOL)isGK;

@end
