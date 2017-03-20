//
//  UIView+XDSAddition.m
//  FrameWorks
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "UIView+XDSAddition.h"

@implementation UIView (XDSAddition)

#pragma mark - frame

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setLeft:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setTop:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect rect = self.frame;
    rect.origin.y = bottom - self.frame.size.height;
    self.frame = rect;
}

- (CGFloat)bottom {
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setRight:(CGFloat)right {
    CGRect rect = self.frame;
    rect.origin.x = right - self.frame.size.width;
    self.frame = rect;
}

- (CGFloat)right {
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGPoint)origin {
    return self.frame.origin;
}

#pragma mark - position

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

#pragma mark - subviews

- (void)xds_removeAllSubviews {
    NSArray *subviews = self.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
}


#pragma mark - parentViewController
- (UIViewController *)xds_parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]]) {
        responder = [responder nextResponder];
    }
    return (UIViewController *)responder;
}

@end
