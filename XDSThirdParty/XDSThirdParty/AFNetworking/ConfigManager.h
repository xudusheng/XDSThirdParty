//
//  ConfigManager.h
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/19.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ConfigManager : NSObject

@property (strong, nonatomic) UIColor * color;
@property (strong, readonly, nonatomic) NSString * name;
+ (instancetype)manager;
@end
