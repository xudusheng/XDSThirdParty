//
//  UIColor+XDSAddition.h
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XDSAddition)

/**
 *  将hex色值转换成UIColor
 *
 *  @param stringToConvert hex色值，如#ff00ee, 0Xffffff, bbccff
 *
 *  @return UIColor类型的颜色
 */
+ (UIColor *)colorWithHexString: (NSString *)stringToConvert;//hex色值


@end
