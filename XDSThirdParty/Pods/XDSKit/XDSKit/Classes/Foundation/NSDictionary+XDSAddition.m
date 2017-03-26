//
//  NSDictionary+XDSAddition.m
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "NSDictionary+XDSAddition.h"
#import "XDSSwizzing.h"
@implementation NSDictionary (XDSAddition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [XDSSwizzing swizzingClassMethodByClass:[self class]
                                 originSelector:@selector(dictionaryWithObject:forKey:)
                               swizzingSelector:@selector(safeDictionaryWithObject:forKey:)];
        [XDSSwizzing swizzingClassMethodByClass:[self class]
                                 originSelector:@selector(dictionaryWithObjects:forKeys:count:)
                               swizzingSelector:@selector(safeDictionaryWithObjects:forKeys:count:)];
    });
}

+ (id)safeDictionaryWithObject:(id)object forKey:(id<NSCopying>)key {
    if (!object || !key) {
        NSAssert(NO, @"attempt DictionaryWithObject:%@ forKey:%@ to dictionary:%@", object, key, self);
        return [self dictionary];
    }
    else {
        return [self safeDictionaryWithObject:object forKey:key];
    }
}

+ (instancetype)safeDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects
                                  forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys
                                    count:(NSUInteger)cnt {
    for (NSInteger i = 0; i < cnt; i++) {
        if (!objects[i] || !keys[i]) {
            return [self dictionary];
        }
    }
    return [self safeDictionaryWithObjects:objects forKeys:keys count:cnt];
}

@end






@implementation NSMutableDictionary (XDSAddition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSDictionaryM");
        [XDSSwizzing swizzingInstanceMethodByClass:cls
                                    originSelector:@selector(setObject:forKey:)
                                  swizzingSelector:@selector(safeSetObject:forKey:)];
        [XDSSwizzing swizzingInstanceMethodByClass:cls
                                    originSelector:@selector(removeObjectForKey:)
                                  swizzingSelector:@selector(safeRemoveObjectForKey:)];
    });
}

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if(!aKey){
        NSAssert(NO, @"attempt set object:%@ for WRONG subscript key:%@ to mutable dictionary:%@",
                 anObject, aKey, self);
        return;
    }
    if(!anObject){
        NSAssert(NO, @"attempt set WRONG: object %@ for subscript key:%@ to mutable dictionary:%@",
                 anObject, aKey, self);
        return;
    }
    return [self safeSetObject:anObject forKey:aKey];
}

- (void)safeRemoveObjectForKey:(id)aKey {
    if (!aKey) {
        NSAssert(NO, @"attempt safeRemoveObjectForKey:%@ to mutable dictionary:%@", aKey, self);
        return;
    }
    return[self safeRemoveObjectForKey:aKey];
}

@end
