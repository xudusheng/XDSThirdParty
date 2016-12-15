//
//  UIView+Common.h
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/15.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseBlankPageView.h"

@interface UIView (Common)

#pragma mark BlankPageView
@property (strong, nonatomic) EaseBlankPageView *blankPageView;

- (void)configBlankPage:(EaseBlankPageType)blankPageType
                hasData:(BOOL)hasData
               hasError:(BOOL)hasError
      reloadButtonBlock:(void (^)(id))reloadButtonBlock
       clickButtonBlock:(void (^)(EaseBlankPageType))clickButtonBlock;

- (void)configBlankPage:(EaseBlankPageType)blankPageType
                hasData:(BOOL)hasData
               hasError:(BOOL)hasError
                offsetY:(CGFloat)offsetY
      reloadButtonBlock:(void (^)(id))reloadButtonBlock
       clickButtonBlock:(void (^)(EaseBlankPageType))clickButtonBlock;
@end
