//
//  DynamicLoadViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/7.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "DynamicLoadViewController.h"
#import "ZipArchive.h"
#import "CheckVersionAlertView.h"
#import "XDSFileManager.h"

@interface DynamicLoadViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * modulsArray;

@end

@implementation DynamicLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ({
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 70, 44);
        button.center = self.view.center;
        [button setTitle:@"检查模块更新" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(checkModuleVersion:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = button;
    });
    
    self.tableView = ({
        UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                               style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 55;
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self showAllFrameworkFile];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modulsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    FileInfoModel * fileModel = _modulsArray[indexPath.row];
    cell.textLabel.text = fileModel.fileName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"更新时间：%@", fileModel.modifyDate];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FileInfoModel * fileModel = _modulsArray[indexPath.row];
    [self loadFrameworkWithFileModel:fileModel];
}

//TODO:检查模块是否有版本更新
- (void)checkModuleVersion:(UIButton *)button{
    NSString * documentPath = [XDSFileManager documentPath];
    [XDSFileManager getAllFilesInDirectory:documentPath];

    ({
        CheckVersionAlertView * checkAV = [[NSBundle mainBundle]
                                           loadNibNamed:@"CheckVersionAlertView"
                                           owner:nil
                                           options:nil].lastObject;
        checkAV.frame = self.navigationController.view.bounds;
        [self.navigationController.view addSubview:checkAV];
        __weak typeof(self)weakSelf = self;
        [checkAV startDownloadByFrameworkName:@"IFramework" complete:^(NSError *error) {
            if (error) {
                NSLog(@"error = %@", error.localizedDescription);
            }else{
                [weakSelf showAllFrameworkFile];
            }
        }];
    });
}


#pragma mark - 加载动态库
- (void)loadFrameworkWithFileModel:(FileInfoModel *)fileModel{
    NSParameterAssert(fileModel);

    NSDictionary * fileAndClass = @{
                                    @"IFramework":@"iFrameworkViewController",
                                    
                                    };
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileModel.filePath]) {
        NSBundle *bundle = [NSBundle bundleWithPath:fileModel.filePath];
        NSError * error = nil;
        if (!bundle || ![bundle loadAndReturnError:&error]) {
            NSLog(@"bundle load error");
            if (error) {
                NSLog(@"error = %@", error);
            }
        }else{
            NSString * className = fileAndClass[fileModel.fileName];
            if (!className) {
                return;
            }
            Class loadClass = [bundle classNamed:className];
            if (loadClass != Nil) {
                UIViewController * iFrameworkViewController = [[loadClass alloc] init];
                [self presentViewController:iFrameworkViewController animated:YES completion:nil];
            }else{
                NSLog(@"class not exist");
            }
        }
        
    }
}
- (void)showAllFrameworkFile{
    if (!_modulsArray) {
        self.modulsArray = [NSMutableArray arrayWithCapacity:0];
    }
    NSArray * array = [XDSFileManager getAllFrameworkInDocument];
    if (array.count) {
        [_modulsArray removeAllObjects];
        [_modulsArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
}




@end
