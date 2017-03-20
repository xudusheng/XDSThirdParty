//
//  XDSSwizzing.h
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSSwizzing : NSObject

/**
 *  替换实例方法
 */
+ (void)swizzingInstanceMethodByClass:(Class)cls
                       originSelector:(SEL)originSelector
                     swizzingSelector:(SEL)swizzingSelector;

/**
 *  替换类方法
 */
+ (void)swizzingClassMethodByClass:(Class)cls
                    originSelector:(SEL)originSelector
                  swizzingSelector:(SEL)swizzingSelector;

@end
