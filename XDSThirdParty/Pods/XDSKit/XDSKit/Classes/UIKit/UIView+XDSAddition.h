//
//  UIView+XDSAddition.h
//  FrameWorks
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XDSAddition)

#pragma mark - setFrame
/**
 *  设置 view 的frame
 */
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

#pragma mark - setPosition
/**
 *  设置 view 的position
 */
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

#pragma mark - subviews
/**
 *  移除 view 上所有的子view
 */
- (void)xds_removeAllSubviews;


#pragma mark - parentViewController
/**
 *  返回 view 所在的 ViewController；
 */
- (UIViewController *)xds_parentViewController;

@end
