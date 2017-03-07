//
//  CheckVersionAlertView.h
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/7.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDSFileManager.h"

typedef void(^downloadComplete)(NSError * error);
@interface CheckVersionAlertView : UIView

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

- (void)startDownloadByFrameworkName:(NSString *)frameworkName complete:(downloadComplete)complete;

@end
