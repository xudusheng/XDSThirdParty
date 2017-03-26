//
//  NSArray+XDSAddition.m
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "NSArray+XDSAddition.h"
#import "XDSSwizzing.h"
@implementation NSArray (XDSAddition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayClass = NSClassFromString(@"__NSArrayI");
        [XDSSwizzing swizzingInstanceMethodByClass:arrayClass
                                    originSelector:@selector(objectAtIndex:)
                                  swizzingSelector:@selector(safeObjectAtIndex:)];
        [XDSSwizzing swizzingInstanceMethodByClass:arrayClass
                                    originSelector:@selector(subarrayWithRange:)
                                  swizzingSelector:@selector(safeSubarrayWithRange:)];
        
        Class emptyArrayClass = NSClassFromString(@"__NSArray0");
        if (emptyArrayClass) {
            [XDSSwizzing swizzingInstanceMethodByClass:emptyArrayClass
                                        originSelector:@selector(objectAtIndex:)
                                      swizzingSelector:@selector(emptySafeObjectAtIndex:)];
        }
    });
}
- (id)safeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSAssert(NO, @"index %ld >= array count %ld", (long)index, (long)self.count);
        return nil;
    }
    return [self safeObjectAtIndex:index];
}

- (id)emptySafeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSAssert(NO, @"index %ld >= array count %ld", (long)index, (long)self.count);
        return nil;
    }
    return [self emptySafeObjectAtIndex:index];
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.count) {
        //超过了边界,就获取从loction开始所有的item
        NSAssert(NO, @"attempt get subarray with Range: location:%ld, length:%ld to array:%@",
                  range.location, range.length, self);
        if ((location + length) > self.count) {
            length = (self.count - location);
            return [self safeSubarrayWithRange:NSMakeRange(location, length)];
        }
        return nil;
    }
    else {
        return [self safeSubarrayWithRange:range];
    }
}


@end






@implementation NSMutableArray (XDSAddition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSArrayM");
        [XDSSwizzing swizzingInstanceMethodByClass:cls
                                    originSelector:@selector(addObject:)
                                  swizzingSelector:@selector(safeAddObject:)];
        [XDSSwizzing swizzingInstanceMethodByClass:cls
                                    originSelector:@selector(replaceObjectAtIndex:withObject:)
                                  swizzingSelector:@selector(safeReplaceObjectAtIndex:withObject:)];
        [XDSSwizzing swizzingInstanceMethodByClass:cls
                                    originSelector:@selector(removeObjectAtIndex:)
                                  swizzingSelector:@selector(safeRemoveObjectAtIndex:)];
        [XDSSwizzing swizzingInstanceMethodByClass:cls
                                    originSelector:@selector(insertObject:atIndex:)
                                  swizzingSelector:@selector(safeInsertObject:atIndex:)];
        [XDSSwizzing swizzingInstanceMethodByClass:cls
                                    originSelector:@selector(removeObjectsInRange:)
                                  swizzingSelector:@selector(safeRemoveObjectsInRange:)];
    });
}

- (void)safeAddObject:(id)object {
    if (object == nil) {
        NSAssert(NO, @"attempt add object:%@ to mutable array:%@", object, self);
        return;
    }
    return [self safeAddObject:object];
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (anObject == nil || index >= self.count) {
        NSAssert(NO, @"attempt replaceObjectAtIndex:%ld withObject:%@ to mutable array %@",
                 (long)index, anObject, self);
        return;
    }
    return [self safeReplaceObjectAtIndex:index withObject:anObject];
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
    if (index >= self.count || (long)index < 0) {
        NSAssert(NO, @"attempt removeObjectAtIndex:%ld to mutable array %@", (long)index, self);
        return;
    }
    return [self safeRemoveObjectAtIndex:index];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index {
    if (index > self.count || (long)index < 0) {
        NSAssert(NO, @"attempt set object:%@ at WRONG subscript index:%li to mutable array:%@",
                 object, (long)index, self);
        return;
    }
    if(!object || [object isKindOfClass:[NSNull class]]) {
        NSAssert(NO, @"attempt set WRONG object:%@ at subscript index:%li to mutable array:%@",
                 object, (long)index, self);
        return;
    }
    if(index == self.count) {
        //add
        [self safeAddObject:object];
    }
    else {
        //replace
        [self safeReplaceObjectAtIndex:index withObject:object];
    }
}

- (void)safeInsertObject:(id)object atIndex:(NSUInteger)index {
    if (!object || index > self.count) {
        NSAssert(NO, @"attempt insert object:%@ atIndex:%ld to mutable array:%@",
                 object, (unsigned long)index, self);
        return;
    }else {
        [self safeInsertObject:object atIndex:index];
    }
}

- (void)safeRemoveObjectsInRange:(NSRange)range {
    NSUInteger location = range.location;
    NSUInteger length = range.length;
    if (location + length > self.count) {
        NSAssert(NO, @"attempt RemoveObjectsInRange: range.location:%ld range.length:%ld to mutable array:%@",
                 (unsigned long)range.location, (unsigned long)range.length, self);
        return;
    }
    else {
        [self safeRemoveObjectsInRange:range];
    }
}

@end
