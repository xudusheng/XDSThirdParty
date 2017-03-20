//
//  UIViewController+XDSAddition.h
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XDSAddition)

/**
 *  是否隐藏UINavigationBar,与原生的hidesBottomBarWhenPushed属性类型
 */
@property (assign, nonatomic)BOOL hidesTopBarWhenPushed;


/**
 *  获取当前可见ViewController
 *
 *  NS_EXTENSION_UNAVAILABLE_IOS
 *  标记iOS插件不能使用这些API,后面有一个参数，可以作为提示，用什么API替换
 */

+ (UIViewController *)xds_visiableViewController NS_EXTENSION_UNAVAILABLE_IOS("iOS插件不能使用这些API，请参考实现方法重新定义API");

@end
