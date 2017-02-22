//
//  XDSThirdPartyTests.m
//  XDSThirdPartyTests
//
//  Created by Hmily on 2017/2/22.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XDSThirdPartyTests : XCTestCase

@end

@implementation XDSThirdPartyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"%s", __func__);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    NSLog(@"%s", __func__);

}

- (void)testFunction{
    NSLog(@"%s", __func__);
    [UIView animateWithDuration:2 animations:^{
        NSLog(@"dong something");
    }];

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    NSLog(@"%s", __func__);

    [self measureBlock:^{
        [self testFunction];
    }];
}

@end
