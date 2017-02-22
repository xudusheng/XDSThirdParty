//
//  XDSEaseDefine.h
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/16.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#ifndef XDSEaseDefine_h
#define XDSEaseDefine_h


#ifdef DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

/**
 *  单例宏
 \ 代表下一行也属于宏
 ## 是分隔符
 */

#define SYNTHESIZE_SINGLETON_FOR_CLASS(__class_name__) \
static __class_name__ *_instance; \
\
+ (__class_name__ *)shared##__class_name__ \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}


//简易提示框
#define kTipAlert(_S_, ...)   [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]





#endif /* XDSEaseDefine_h */
