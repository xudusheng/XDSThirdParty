//
//  XDSSwizzing.m
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "XDSSwizzing.h"
#import <objc/runtime.h>

@implementation XDSSwizzing

+ (void)swizzingInstanceMethodByClass:(Class)cls
                       originSelector:(SEL)originSelector
                     swizzingSelector:(SEL)swizzingSelector {
    NSParameterAssert(cls);
    NSParameterAssert(originSelector);
    NSParameterAssert(swizzingSelector);
    
    Method originalMethod = class_getInstanceMethod(cls, originSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzingSelector);
    
    if (originalMethod && swizzledMethod) {
        BOOL didAddMethod =
        class_addMethod(cls,
                        originSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(cls,
                                swizzingSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

+ (void)swizzingClassMethodByClass:(Class)cls
                    originSelector:(SEL)originSelector
                  swizzingSelector:(SEL)swizzingSelector {
    NSParameterAssert(cls);
    NSParameterAssert(originSelector);
    NSParameterAssert(swizzingSelector);
    
    Method originalMethod = class_getClassMethod(cls, originSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzingSelector);
    
    cls = object_getClass((id)cls);
    
    if (originalMethod && swizzledMethod) {
        BOOL didAddMethod =
        class_addMethod(cls,
                        originSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(cls,
                                swizzingSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

@end
