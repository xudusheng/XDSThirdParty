//
//  XDSSortClass.h
//  XDSThirdParty
//
//  Created by dusheng.xu on 15/09/2017.
//  Copyright © 2017 Hmily. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SortResultBlock)(NSNumber*, NSNumber*);
typedef void (^SortSuccessBlock)(NSArray<NSNumber*> *);
@protocol SortTypeObjectDelegate <NSObject>
@optional
- (NSArray<NSNumber*> *)sort:(NSArray<NSNumber*>*)items;
- (void)setEveryStepSortCallBack:(SortResultBlock)sortResultBlock sortSuccessBlock:(SortSuccessBlock)sortSuccessBlock;
@end

typedef enum : NSInteger {
    SortTypeBubble = 0,     //冒泡排序
    SortTypeSelect,         //选择排序
    SortTypeInsert,         //插入排序
    SortTypeShell,          //希尔排序
    SortTypeHeap,           //堆排序
    SortTypeMerge,          //归并排序
    SortTypeQuick,          //快速排序
    SortTypeRadix,          //基数排序
}SortType;

@interface SortFactory : NSObject
+ (id<SortTypeObjectDelegate>)create:(SortType)type;
@end

@interface SoreBaseClass : NSObject
@property (copy, nonatomic) SortResultBlock everyStepBlock;
@property (copy, nonatomic) SortSuccessBlock sortSuccessBlock;
- (void)displayResult:(NSNumber *)index value:(NSNumber *)value;
- (void)successSort:(NSArray<NSNumber *> *)sortList;
@end

//MARK: 冒泡排序：时间复杂度----O(n^2)
@interface BubbleSort : SoreBaseClass<SortTypeObjectDelegate>
@end

//MARK: 简单选择排序－O(n^2)
@interface SimpleSelectionSort : SoreBaseClass<SortTypeObjectDelegate>
@end

//MARK: 插入排序-O(n^2)
@interface InsertSort : SoreBaseClass<SortTypeObjectDelegate>
@end

//MARK: 希尔排序：时间复杂度----O(n^(3/2))
@interface ShellSort : SoreBaseClass<SortTypeObjectDelegate>
@end

//MARK: 堆排序 (O(nlogn))
@interface HeapSort : SoreBaseClass<SortTypeObjectDelegate>
@end

//MARK: 归并排序O(nlogn)
@interface MergingSort : SoreBaseClass<SortTypeObjectDelegate>
@end

//MARK: 快速排序O(nlogn)
@interface QuickSort : SoreBaseClass<SortTypeObjectDelegate>
@end

//MARK: 基数排序
@interface RadixSort : SoreBaseClass<SortTypeObjectDelegate>
@end
