//
//  NSString+XDSAddition.m
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "NSString+XDSAddition.h"
#import "XDSSwizzing.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#include <stdint.h>
#include <stdio.h>

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};


@implementation NSString (XDSAddition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [XDSSwizzing swizzingClassMethodByClass:[self class]
                                 originSelector:@selector(stringWithString:)
                               swizzingSelector:@selector(safeStringWithString:)];
        
        [XDSSwizzing swizzingInstanceMethodByClass:[self class]
                                    originSelector:@selector(stringByAppendingString:)
                                  swizzingSelector:@selector(safeStringByAppendingString:)];
        [XDSSwizzing swizzingInstanceMethodByClass:[self class]
                                    originSelector:@selector(rangeOfString:)
                                  swizzingSelector:@selector(safeRangeOfString:)];
        [XDSSwizzing swizzingInstanceMethodByClass:[self class]
                                    originSelector:@selector(rangeOfString:options:)
                                  swizzingSelector:@selector(safeRangeOfString:options:)];
        [XDSSwizzing swizzingInstanceMethodByClass:[self class]
                                    originSelector:@selector(substringFromIndex:)
                                  swizzingSelector:@selector(safeSubstringFromIndex:)];
        [XDSSwizzing swizzingInstanceMethodByClass:[self class]
                                    originSelector:@selector(substringToIndex:)
                                  swizzingSelector:@selector(safeSubstringToIndex:)];
    });
}

- (NSString *)safeStringByAppendingString:(NSString *)aString {
    if (!aString || ![aString isKindOfClass:[NSString class]]){
        NSAssert(NO, @"attempt appending string:%@ to string:%@", aString, self);
        return [self safeStringByAppendingString:@""];
        
    } else {
        return [self safeStringByAppendingString:aString];
        
    }
}

+ (id)safeStringWithString:(NSString *)string {
    if (!string || ![string isKindOfClass:[NSString class]]){
        NSAssert(NO, @"attempt StringWithString:%@", string);
        return [self safeStringWithString:@""];
        
    } else {
        return [self safeStringWithString:string];
        
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString {
    if (!aString || ![aString isKindOfClass:[NSString class]]){
        NSAssert(NO, @"attempt safeRangeOfString:%@", aString);
        return NSMakeRange(NSNotFound, 0);
        
    } else {
        return [self safeRangeOfString:aString];
        
    }
}

- (NSRange)safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask {
    if (!aString || ![aString isKindOfClass:[NSString class]]){
        NSAssert(NO, @"attempt safeRangeOfString:%@ options", aString);
        return NSMakeRange(NSNotFound, 0);
    } else {
        return [self safeRangeOfString:aString options:mask];
    }
}

- (NSString *)safeSubstringFromIndex:(NSUInteger)from {
    if (from > self.length) {
        NSAssert(NO, @"attempt substringFromIndex:%ld from string:%@",(unsigned long)from, self);
        return nil;
    } else {
        return [self safeSubstringFromIndex:from];
    }
}

- (NSString *)safeSubstringToIndex:(NSUInteger)to {
    if (to > self.length) {
        NSAssert(NO, @"attempt substringToIndex:%ld from string:%@",(unsigned long)to, self);
        return nil;
    } else {
        return [self safeSubstringToIndex:to];
    }
}

#pragma mark 清空字符串中的空白字符
- (NSString *)trimString{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)md5String{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    NSString *output = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    return output.uppercaseString;
}


+ (NSString *)twoCharRandom{
    int retVal = arc4random() % 100;
    if (retVal < 10) {
        return [NSString stringWithFormat:@"0%d", retVal];
    }
    return [NSString stringWithFormat:@"%d", retVal];
}



- (NSString *)percentageString{
    NSString * string = self;
    if (!string.length) return @"";
    
    float a = [string floatValue];
    float b = a * 100;
    NSString * bstring = [NSString stringWithFormat:@"%f",b];
    NSArray *arr = [bstring componentsSeparatedByString:@"."];
    NSString *beforeString = arr[0];
    NSString *afterString = [arr[1] substringToIndex:2];
    return [NSString stringWithFormat:@"%@.%@%%",beforeString,afterString];
}

- (NSString *)decimalString:(NSInteger)digit
               decimalStyle:(BOOL)flag{
    NSString * string = self;
    if (!string.length) return @"";
    if (flag) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        string = [formatter stringFromNumber:[NSNumber numberWithDouble:string.doubleValue]];
    }
    
    NSArray *arr = [string componentsSeparatedByString:@"."];
    if (arr.count == 1) {
        if (!digit) return string;
        
        string = [string stringByAppendingString:@"."];
        for (int i = 0; i < digit; i ++) {
            string = [string stringByAppendingString:@"0"];
        }
        return string;
    } else {
        NSString *beforeString = arr[0];
        NSString *afterString = arr[1];
        
        if (digit == 0) {
            return [string componentsSeparatedByString:@"."][0];
        } else if (afterString.length >= digit) {
            return [NSString stringWithFormat:@"%@.%@",beforeString,[afterString substringToIndex:digit]];
        } else {
            NSUInteger c = digit - afterString.length;
            for (int k = 0; k < c; k ++) {
                string = [string stringByAppendingString:@"0"];
            }
            return string;
        }
    }
}

//格式话小数 四舍五入类型
+(NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}


//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//高精度的加减乘除
+ (NSString *)calculateWithFirstValue:(NSString *)firstValue secondValue:(NSString *)secondValue type:(CalculateType)type{
    NSDecimalNumber *firstNumber = [NSDecimalNumber decimalNumberWithString:firstValue.length?firstValue:@"0"];
    NSDecimalNumber *secondNumber = [NSDecimalNumber decimalNumberWithString:secondValue.length?secondValue:@"0"];
    NSDecimalNumber *sumNumber = [NSDecimalNumber zero];
    SEL selector;
    switch (type) {
        case CalculateTypeAdding:
            selector = @selector(decimalNumberByAdding:);
            break;
        case CalculateTypeSubtracting:
            selector = @selector(decimalNumberBySubtracting:);
            break;
        case CalculateTypeMultiplying:
            selector = @selector(decimalNumberByMultiplyingBy:);
            break;
        case CalculateTypeDividing:
            selector = @selector(decimalNumberByDividingBy:);
            break;
    }
    @try {
        IMP imp = [firstNumber methodForSelector:selector];
        NSDecimalNumber * (*func)(id, SEL, id) = (void *)imp;
        sumNumber = func(firstNumber, selector, secondNumber);
    } @catch (NSException *exception) {//NSDecimalNumberDivideByZeroException
        NSLog(@"calculateWithFirstValue: secondValue: type:方法捕获到异常 = %@", exception.name);
    }
    return sumNumber.stringValue;
}

//校验身份证
- (BOOL)validateIDCardNumber{
    NSString * value = self;
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}



//手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    NSScanner* scan = [NSScanner scannerWithString:mobileNum];
    int val;
    BOOL isPureInt = [scan scanInt:&val] && [scan isAtEnd];
    if (!isPureInt) {
        return NO;
    }
    if (mobileNum.length!= 11) {
        return NO;
    }
    if (![mobileNum hasPrefix:@"1"]) {
        return NO;
    }
    return YES;
}

#pragma mark - base64解密
#define xx 65
static unsigned char base64DecodeLookup[256] =
{
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx,
    xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx,
    xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
};

#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4
void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength)
{
    if (length == -1)
    {
        length = strlen(inputBuffer);
    }
    
    size_t outputBufferSize =
    ((length+BASE64_UNIT_SIZE-1) / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE;
    unsigned char *outputBuffer = (unsigned char *)malloc(outputBufferSize);
    
    size_t i = 0;
    size_t j = 0;
    while (i < length)
    {
        unsigned char accumulated[BASE64_UNIT_SIZE];
        size_t accumulateIndex = 0;
        while (i < length)
        {
            unsigned char decode = base64DecodeLookup[inputBuffer[i++]];
            if (decode != xx)
            {
                accumulated[accumulateIndex] = decode;
                accumulateIndex++;
                
                if (accumulateIndex == BASE64_UNIT_SIZE)
                {
                    break;
                }
            }
        }
        
        if(accumulateIndex >= 2)
            outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);
        if(accumulateIndex >= 3)
            outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);
        if(accumulateIndex >= 4)
            outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
        j += accumulateIndex - 1;
    }
    
    if (outputLength)
    {
        *outputLength = j;
    }
    return outputBuffer;
}



+ (NSString *)base64StringFromData:(NSData *)data
{
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    int length = (int)[data length];
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}


- (NSData *)base64StringData{
    NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding];
    size_t outputLength;
    void *outputBuffer = NewBase64Decode([data bytes], [data length], &outputLength);
    NSData *result = [NSData dataWithBytes:outputBuffer length:outputLength];
    free(outputBuffer);
    return result;
}


//判断是否为整形
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否是手机号码或者邮箱
- (BOOL)isPhoneNo{
    //    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSString *phoneRegex = @"[0-9]{1,15}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
- (BOOL)isEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
- (BOOL)isGK{
    NSString *gkRegex = @"[A-Z0-9a-z-_]{3,32}";
    NSPredicate *gkTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", gkRegex];
    return [gkTest evaluateWithObject:self];
}
@end
