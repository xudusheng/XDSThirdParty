//
//  XDSVisualSortViewController.m
//  XDSThirdParty
//
//  Created by dusheng.xu on 15/09/2017.
//  Copyright © 2017 Hmily. All rights reserved.
//


//来源：https://github.com/lizelu/DataStruct-Swift

#import "XDSVisualSortViewController.h"
#import "XDSRectangle.h"
#import "XDSSortClass.h"
@interface XDSVisualSortViewController ()

@property (weak, nonatomic) IBOutlet UIView *displayView;
@property (weak, nonatomic) IBOutlet UITextField *numberCountTextField;
@property (weak, nonatomic) IBOutlet UIView *modeMaskView;


@property (nonatomic, strong) NSArray<XDSRectangle *> *rectangles;
@property (nonatomic, strong) NSArray<NSNumber*> *rectangleHeights;
@property (nonatomic, strong) id<SortTypeObjectDelegate> sortObject;

@property (assign, nonatomic) NSInteger numberCount;
@property (assign, nonatomic, readonly) CGFloat displayViewHeight;
@property (assign, nonatomic, readonly) CGFloat displayViewWidth;
@property (assign, nonatomic, readonly) CGFloat rectangleWidth;

@property (assign, nonatomic, readonly) CGFloat rectangleGap;


@end

@implementation XDSVisualSortViewController

- (instancetype)init {
    self = [[XDSVisualSortViewController alloc] initWithNibName:@"XDSVisualSortViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可视化排序算法";
    self.rectangles = [NSMutableArray arrayWithCapacity:0];
    self.rectangleHeights = [NSMutableArray arrayWithCapacity:0];

    self.numberCount = 50;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self resetSortObject:SortTypeBubble];
    [self resetSubViews];
}


- (void)resetSortObject:(SortType)type {
    self.sortObject = [SortFactory create:type];
    
    __weak typeof(self)weakSelf = self;
    
    [self.sortObject setEveryStepSortCallBack:^(NSNumber *index, NSNumber *value) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateRectangleHeight:index.integerValue value:value.floatValue];
        });
    } sortSuccessBlock:^(NSArray<NSNumber *> *list) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.modeMaskView.hidden = YES;
        });
    }];
    
}
- (void)resetSubViews {
    for (UIView *subView in self.rectangles) {
        [subView removeFromSuperview];
    }
    
    self.rectangles = nil;
    self.rectangleHeights = nil;
    [self configRectangleHeights];
    [self addRectangles];
}

- (void)updateRectangleHeight:(NSInteger)index value:(CGFloat)value{
    [self.rectangles[index] updateHeight:value];
}
//MARK: 随机生成Rectangle的高度
- (void)configRectangleHeights {
    if (self.rectangleHeights.count) {
        self.rectangleHeights = nil;
    }
    NSMutableArray *multArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.numberCount; i ++) {
        [multArr addObject:@(arc4random()%((NSInteger)self.displayViewHeight))];
    }
    self.rectangleHeights = multArr;
}
- (void)addRectangles {
    NSMutableArray *multArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0 ; i < self.numberCount; i ++) {
        CGSize size = CGSizeMake(self.rectangleWidth, [self.rectangleHeights[i] floatValue]);
        CGPoint origin = CGPointMake((self.rectangleWidth + self.rectangleGap) * i, 0);
        CGRect frame = CGRectZero;
        frame.origin = origin;
        frame.size = size;
        XDSRectangle *rectangle = [[XDSRectangle alloc] initWithFrame:frame];
        [self.displayView addSubview:rectangle];
        [multArr addObject:rectangle];
    }
    self.rectangles = multArr;
}

//MARK:点击事件
- (IBAction)tapSortButton:(UIButton *)sender {
    self.modeMaskView.hidden = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.rectangleHeights = [self.sortObject sort:self.rectangleHeights];
    });
}
- (IBAction)tapSegmentContol:(UISegmentedControl *)sender {
    [self configRectangleHeights];
    for (int i = 0; i < self.numberCount; i ++) {
        [self updateRectangleHeight:i value:[self.rectangleHeights[i] floatValue]];
    }
    
    [self resetSortObject:sender.selectedSegmentIndex];
}


//MARK:尺寸相关
- (CGFloat)displayViewWidth {
    return CGRectGetWidth(self.displayView.frame);
}

- (CGFloat)displayViewHeight {
    return CGRectGetHeight(self.displayView.frame);
}

- (CGFloat)rectangleWidth {
    return (self.displayViewWidth - (self.rectangleGap * (self.numberCount - 1)))/self.numberCount;
}

- (CGFloat)rectangleGap {
    return self.displayViewWidth/self.numberCount/10;
}
@end
