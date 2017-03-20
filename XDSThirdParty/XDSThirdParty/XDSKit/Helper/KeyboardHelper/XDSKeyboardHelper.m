//
//  XDSKeyboardHelper.m
//  Laomoney
//
//  Created by zhengda on 16/7/8.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "XDSKeyboardHelper.h"
@interface XDSKeyboardHelper()
@property (strong, nonatomic)UIView * toMovedView;
@end
@implementation XDSKeyboardHelper

static XDSKeyboardHelper * _instance = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance;
}
+ (instancetype) allocWithZone:(struct _NSZone *)zone{
    return [self shareInstance] ;
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [XDSKeyboardHelper shareInstance] ;
}



+ (void)addKeyboardObserverWithToMovedView:(UIView * _Nonnull)toMovedView{
    if (!toMovedView && ![toMovedView isKindOfClass:[UIView class]]) {
        return;
    }
    XDSKeyboardHelper * helper = [XDSKeyboardHelper shareInstance];
    [helper addKeyboardObserverWithToMovedView:toMovedView];
}
- (void)addKeyboardObserverWithToMovedView:(UIView *)toMovedView{
    [self removeKeyboardObserver];
    self.toMovedView = toMovedView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


+ (void)removeKeyboardObserver{
    XDSKeyboardHelper * helper = [XDSKeyboardHelper shareInstance];
    [helper removeKeyboardObserver];
}

- (void)removeKeyboardObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];//移除监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];//移除监听
    _toMovedView = nil;
}

#pragma mark--监听键盘
- (void)dealKeyboardShow:(NSNotification *)notification{
    [self resetViewFrame:notification isKeyboardShow:YES];
}
- (void)dealKeyboardHide:(NSNotification *)notification{
    [self resetViewFrame:notification isKeyboardShow:NO];
}
-(void)resetViewFrame:(NSNotification *)notification isKeyboardShow:(BOOL)isKeyboardShow{
    UIView * backImageView = _toMovedView;
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [backImageView.superview convertRect:keyboardBounds toView:nil];
    CGRect frame = backImageView.frame;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat passwordViewHeight = CGRectGetHeight(frame);
    BOOL needToMove = !(screenHeight/2 > (passwordViewHeight/2 + keyboardBounds.size.height));
    
    if (!needToMove) {
        return;
    }
    
    if (isKeyboardShow) {
        frame.origin.y = screenHeight - keyboardBounds.size.height - passwordViewHeight;
    }else{
        frame.origin.y = screenHeight/2 - frame.size.height/2;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    backImageView.frame = frame;
    [UIView commitAnimations];
}

@end
