//
//  AndroidFragementViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/14.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "AndroidFragementViewController.h"

#import <Masonry/Masonry.h>
#import <iCarousel/iCarousel.h>
#import "iCarouselTableView.h"

@interface AndroidFragementViewController () <iCarouselDelegate, iCarouselDataSource>

@property (strong, nonatomic) iCarousel *carousel;
@property (strong, nonatomic) UISegmentedControl * segmentControl;

@end

@implementation AndroidFragementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _segmentControl = ({
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"first", @"second", @"third"]];
        segmentControl.frame = CGRectMake(0, 0, 150, 35);
        segmentControl.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segmentControl;
        [segmentControl addTarget:self action:@selector(segmentControlSelected:) forControlEvents:UIControlEventValueChanged];
        segmentControl;
    });
    
    _carousel = ({
        iCarousel *icarousel = [[iCarousel alloc] init];
        icarousel.dataSource = self;
        icarousel.delegate = self;
        icarousel.decelerationRate = 1.0;
        icarousel.scrollSpeed = 1.0;
        icarousel.type = iCarouselTypeLinear;
        icarousel.pagingEnabled = YES;
        icarousel.clipsToBounds = YES;
        icarousel.bounceDistance = 0.2;
        icarousel.bounces = NO;
        [self.view addSubview:icarousel];
        [icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        icarousel;
    });
    
    
}

- (void)segmentControlSelected:(UISegmentedControl *)segmentControl{
    [_carousel scrollToItemAtIndex:segmentControl.selectedSegmentIndex animated:YES];
}

#pragma mark - iCarouselDelegate, iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _segmentControl.numberOfSegments;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    iCarouselTableView * tableView = (iCarouselTableView * )view;
    if (!tableView) {
        tableView = [[iCarouselTableView alloc] initWithFrame:_carousel.bounds];
    }
    
    return tableView;
}



- (void)carouselDidEndDecelerating:(iCarousel *)carousel{
    _segmentControl.selectedSegmentIndex = carousel.currentItemIndex;
}

@end
