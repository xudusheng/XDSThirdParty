//
//  aFNetworkingViewController.h
//  XDSThirdParty
//
//  Created by Hmily on 2017/2/8.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@interface aFNetworkingViewController : UIViewController

@end

@interface aFNetworkingViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong) NSString * titleName;

@end
