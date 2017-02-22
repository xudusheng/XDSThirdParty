//
//  aFNetworkingViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/2/8.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "aFNetworkingViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MainTableViewController.h"

@implementation aFNetworkingViewController


NSString * const requestURL = @"http://v.juhe.cn/toutiao/index?type=top&key=f2b9c5a8243bc824253119ba09f7759a";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"request begin");
    
    aFNetworkingViewController * controller = [[aFNetworkingViewController alloc] init];
    controller.titleName = @"nihao";
    
    NSLog(@"title = %@", controller.titleName);
    
    

    NSArray * arr = @[@"1", @"2", @"3", @"5", @"4", @"1", @"3", @"8"];
    
    NSLog(@"array = %@", arr);

    NSSet * set = [NSSet setWithArray:arr];
    NSLog(@"set = %@", set.allObjects);
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self payThroughApplePay];
}


//Apple Pay

- (void)payThroughApplePay{
    
    NSArray * supportedNetworks = @[PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay];
    BOOL canMakePayments = [PKPaymentAuthorizationController canMakePayments];
    
    //如果 canMakePayments 返回 NO，那么说明该设备不支持Apple Pay。
    //如果 canMakePayments 返回 YES，但 canMakePaymentsUsingNetworks：返回 NO，设备支持苹果支付，但用户未添加任何所要求的银行卡。
    if (canMakePayments) {
        canMakePayments = [PKPaymentAuthorizationController canMakePaymentsUsingNetworks:supportedNetworks];
        if (!canMakePayments) {
            NSLog(@"用户未添加任何所要求的银行卡");
            return;
        }
    }else{
        NSLog(@"该设备不支持 Apple Pay 功能！");
        return;
    }
    
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    //2.1)创建相关商品信息
    PKPaymentSummaryItem *good1 = [PKPaymentSummaryItem summaryItemWithLabel:@"HHKB professional 2" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
    PKPaymentSummaryItem *good2 = [PKPaymentSummaryItem summaryItemWithLabel:@"营养快线" amount:[NSDecimalNumber decimalNumberWithString:@"0.02"]];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"德玛西亚" amount:[NSDecimalNumber decimalNumberWithString:@"0.03"]];
    request.paymentSummaryItems = @[ good1, good2, total];
    
    //2.2)货币单位
    request.currencyCode = @"CNY";//(人民币)
    request.countryCode = @"CN";
    
    //2.3)Wallet所绑定的卡的类型
    request.supportedNetworks = supportedNetworks;
    
    //2.4)merchant ID
    request.merchantIdentifier = @"merchant.com.youmi.applepay";
    
    //2.5)支付处理标准
    //通过指定merchantCapabilities属性来指定你支持的支付处理标准，3DS支付方式是必须支持的，EMV方式是可选的。
    request.merchantCapabilities = PKMerchantCapabilityEMV;
    
    //2.6)配送信息
    //设置后，如果用户之前没有填写过，那么会要求用户必须填写才能够使用Apple Pay。
    request.requiredShippingAddressFields = PKAddressFieldPostalAddress | PKAddressFieldPhone | PKAddressFieldName;
        
        
    PKPaymentAuthorizationViewController * applePayController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    applePayController.delegate = self;
    [self presentViewController:applePayController animated:YES completion:nil];
    
}


#pragma mark - PKPaymentAuthorizationViewControllerDelegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion{
    NSLog(@"payment = %@", payment);
    id paymentData = [NSJSONSerialization JSONObjectWithData:payment.token.paymentData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"paymentData = %@", paymentData);
    completion(PKPaymentAuthorizationStatusSuccess);
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
//    OSMemoryNotificationLevelAny
}



@end
