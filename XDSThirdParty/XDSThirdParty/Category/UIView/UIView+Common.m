//
//  UIView+Common.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/15.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>

@implementation UIView (Common)


#pragma mark BlankPageView
static char BlankPageViewKey;
- (void)setBlankPageView:(EaseBlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(EaseBlankPageType)blankPageType
                hasData:(BOOL)hasData
               hasError:(BOOL)hasError
      reloadButtonBlock:(void (^)(id))reloadButtonBlock
       clickButtonBlock:(void (^)(EaseBlankPageType))clickButtonBlock{
    
    [self configBlankPage:blankPageType
                  hasData:hasData
                 hasError:hasError
                  offsetY:0
        reloadButtonBlock:reloadButtonBlock
         clickButtonBlock:clickButtonBlock];
}

- (void)configBlankPage:(EaseBlankPageType)blankPageType
                hasData:(BOOL)hasData
               hasError:(BOOL)hasError
                offsetY:(CGFloat)offsetY
      reloadButtonBlock:(void (^)(id))reloadButtonBlock
       clickButtonBlock:(void (^)(EaseBlankPageType))clickButtonBlock{
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    }else{
        if (!self.blankPageView) {
            self.blankPageView = [[EaseBlankPageView alloc] initWithFrame:self.bounds];
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer insertSubview:self.blankPageView atIndex:0];
        [self.blankPageView configWithType:blankPageType
                                   hasData:hasData
                                  hasError:hasError
                                   offsetY:offsetY
                         reloadButtonBlock:reloadButtonBlock
                          clickButtonBlock:clickButtonBlock];
    }
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}
@end
