//
//  XDSGlobalConst.h
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/16.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#ifndef XDSGlobalConst_h
#define XDSGlobalConst_h


#define IOS6 ([[UIDevice currentDevice] systemVersion].floatValue>=6.0f)
#define IOS7 ([[UIDevice currentDevice] systemVersion].floatValue>=7.0f)
#define IOS8 ([[UIDevice currentDevice] systemVersion].floatValue>=8.0f)
#define DEVICE_APP_BUNDLE_IDENTIFIER              [[NSBundle mainBundle]bundleIdentifier]//本应用的bundle identifier

#define DEVICE_SCREEN_WIDTH               [UIScreen mainScreen].bounds.size.width
#define DEVICE_SCREEN_HEIGHT              [UIScreen mainScreen].bounds.size.height
#define DEVICE_SCREEN_BOUNDS               [UIScreen mainScreen].bounds


#endif /* XDSGlobalConst_h */
