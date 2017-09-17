//
//  XDSSortClass.m
//  XDSThirdParty
//
//  Created by dusheng.xu on 15/09/2017.
//  Copyright © 2017 Hmily. All rights reserved.
//

#import "XDSSortClass.h"

@implementation SortFactory

//SortTypeBubble = 0,     //冒泡排序
//SortTypeSelect,         //选择排序
//SortTypeInsert,         //插入排序
//SortTypeShell,          //希尔排序
//SortTypeHeap,           //堆排序
//SortTypeMerge,          //归并排序
//SortTypeQuick,          //快速排序
//SortTypeRadix,          //基数排序
+ (id<SortTypeObjectDelegate>)create:(SortType)type {
    switch (type) {
        case SortTypeBubble:
            return [[BubbleSort alloc] init];
        case SortTypeSelect:
            return [[SimpleSelectionSort alloc] init];
        case SortTypeInsert:
            return [[InsertSort alloc] init];
        case SortTypeShell:
            return [[ShellSort alloc] init];
        case SortTypeHeap:
            return [[HeapSort alloc] init];
        case SortTypeMerge:
            return [[MergingSort alloc] init];
        case SortTypeQuick:
            return [[QuickSort alloc] init];
        case SortTypeRadix:
            return [[RadixSort alloc] init];
    }
}

@end

@implementation SoreBaseClass
- (void)displayResult:(NSNumber *)index value:(NSNumber *)value {
    if (self.everyStepBlock) {
        self.everyStepBlock(index, value);
        [NSThread sleepForTimeInterval:0.01];
    }
}

- (void)successSort:(NSArray<NSNumber *> *)sortList{
    if (self.sortSuccessBlock) {
        self.sortSuccessBlock(sortList);
    }
}
- (void)setEveryStepSortCallBack:(SortResultBlock)sortResultBlock sortSuccessBlock:(SortSuccessBlock)sortSuccessBlock {
    self.everyStepBlock = sortResultBlock;
    self.sortSuccessBlock = sortSuccessBlock;
}
@end

//MARK: 冒泡排序：时间复杂度----O(n^2)
@implementation BubbleSort
- (NSArray<NSNumber *> *)sort:(NSArray<NSNumber *> *)items {
    NSMutableArray<NSNumber *> *list = [NSMutableArray arrayWithArray:items];
    for (NSUInteger i = 0; i < list.count; i ++) {
        NSUInteger j = list.count - 1;
        while (j > i) {
            if (list[j-1] > list[j]){
                NSNumber *temp = list[j];
                list[j] = list[j-1];
                list[j-1] = temp;
                
                [self displayResult:@(j) value:list[j]];
                [self displayResult:@(j-1) value:list[j-1]];
            }
            j --;
        }
    }
    [self successSort:list];
    return list;
}
@end

//MARK: 简单选择排序－O(n^2)
@implementation SimpleSelectionSort
- (NSArray<NSNumber *> *)sort:(NSArray<NSNumber *> *)items {
    NSMutableArray<NSNumber *> *list = [NSMutableArray arrayWithArray:items];
    
    for (NSUInteger i = 0; i < list.count; i ++) {
        NSUInteger j = i + 1;
        NSNumber *minValue = list[i];
        NSUInteger minIndex = i;
        while (j < list.count) {
            if (minValue > list[j]) {
                minValue = list[j];
                minIndex = j;
            }
            
            [self displayResult:@(j) value:list[j]];

            j ++;
        }
        
        if (minIndex != i) {
            NSNumber *temp = list[i];
            list[i] = list[minIndex];
            list[minIndex] = temp;
            
            [self displayResult:@(i) value:list[i]];
            [self displayResult:@(minIndex) value:list[minIndex]];
        }
        
    }
   
    [self successSort:list];
    return list;
}
@end

//MARK: 插入排序-O(n^2)
@implementation InsertSort
- (NSArray<NSNumber *> *)sort:(NSArray<NSNumber *> *)items {
    NSMutableArray<NSNumber *> *list = [NSMutableArray arrayWithArray:items];
    
    for (NSUInteger i = 1; i < list.count; i ++) {
        NSUInteger j = i;
        while (j > 0) {
            if (list[j] < list[j-1]) {
                NSNumber *temp = list[j];
                list[j] = list[j-1];
                list[j-1] = temp;
                
                [self displayResult:@(j) value:list[j]];
                [self displayResult:@(j-1) value:list[j-1]];
                j --;
            }else{
                break;
            }
        }
    }
    
    
    [self successSort:list];
    return list;
}

@end

//MARK: 希尔排序：时间复杂度----O(n^(3/2))
@implementation ShellSort
- (NSArray<NSNumber *> *)sort:(NSArray<NSNumber *> *)items {
    NSMutableArray<NSNumber *> *list = [NSMutableArray arrayWithArray:items];
    
    NSUInteger step = list.count / 2;
    while (step > 0) {
        for (NSUInteger i = 0; i < list.count; i ++) {
            NSUInteger j = i + step;
            while (j >= step && j < list.count) {
                if (list[j] < list[j - step]) {
                    NSNumber *temp = list[j];
                    list[j] = list[j-step];
                    list[j-step] = temp;
                    
                    [self displayResult:@(j) value:list[j]];
                    [self displayResult:@(j-step) value:list[j-step]];
                    j -= step;
                }else{
                    break;
                }
            }
        }
        step = step / 2;     //缩小步长
    }
    
    [self successSort:list];
    return list;
}
@end


//MARK: 堆排序 (O(nlogn))
@implementation HeapSort
@end

//MARK: 归并排序O(nlogn)
@implementation MergingSort
@end

//MARK: 快速排序O(nlogn)
@implementation QuickSort
@end

//MARK: 基数排序
@implementation RadixSort
@end



