//
//  XDSThirdPartyUITests.m
//  XDSThirdPartyUITests
//
//  Created by Hmily on 2017/2/22.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <XCTest/XCTest.h>



@interface XDSThirdPartyUITests : XCTestCase

@end

@implementation XDSThirdPartyUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];

}

- (void)tearDown {
    [super tearDown];
}



- (void)testThirdPartyUI{
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"AFNetworking(Web Request)"] tap];
    [app.navigationBars[@"aFNetworkingView"].buttons[@"\u7b2c\u4e09\u65b9\u5e93"] tap];
    
    XCUIElement *table = [app.tables containingType:XCUIElementTypeCell identifier:@"1"].element;
    [table tap];
    [table swipeDown];
    [tablesQuery.cells[@"2"] tap];
    [tablesQuery.staticTexts[@"Android Fragement"] tap];
    
    XCUIElement *androidfragementviewNavigationBar = app.navigationBars[@"AndroidFragementView"];
    [androidfragementviewNavigationBar.buttons[@"third"] tap];
    
    XCUIElement *element = [[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"AndroidFragementView"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [element swipeRight];
    [element swipeRight];
    [element swipeRight];
    [element swipeLeft];
    [element swipeLeft];
    [[[[androidfragementviewNavigationBar childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    [tablesQuery.staticTexts[@"\u4effiOS\u591a\u4efb\u52a1\u7ba1\u7406\u5668"] tap];
    
    XCUIElement *element2 = [[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"MultiTaskManagerView"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [element2 tap];
    [element2 tap];
    [element2 tap];
    [element2 swipeLeft];
    [element2 tap];
    [element2 tap];
    [element2 tap];
    [[[[app.navigationBars[@"MultiTaskManagerView"] childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    [app.navigationBars[@"iCarouselView"].buttons[@"\u7b2c\u4e09\u65b9\u5e93"] tap];
    
    [tablesQuery.staticTexts[@"MJPhotoBrowser(PhotoBrowser)"] tap];
    [app.navigationBars[@"MJPhotoBrowserView"].buttons[@"\u7b2c\u4e09\u65b9\u5e93"] tap];
    [tablesQuery.cells[@"JazzHands(\u4ea4\u4e92\u52a8\u753b), MJPhotoBrowserListView"] tap];
    [app.alerts[@"\u63d0\u793a"].buttons[@"\u77e5\u9053\u4e86"] tap];

    
}


@end
