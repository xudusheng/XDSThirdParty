//
//  XDSRectangle.m
//  XDSThirdParty
//
//  Created by dusheng.xu on 15/09/2017.
//  Copyright © 2017 Hmily. All rights reserved.
//

#import "XDSRectangle.h"

@implementation XDSRectangle


- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat y = self.superview.frame.size.height - self.frame.size.height;
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
    CGFloat weight = self.frame.size.height / self.superview.frame.size.height;
    UIColor *color = [UIColor colorWithHue:weight saturation:1 brightness:1 alpha:1];
    self.backgroundColor = color;
}


- (void)updateHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.origin.y = self.superview.frame.size.height - height;
    frame.size.height = height;
    self.frame = frame;
}
@end
