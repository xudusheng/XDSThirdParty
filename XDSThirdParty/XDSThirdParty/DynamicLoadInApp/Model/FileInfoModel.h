//
//  FileInfoModel.h
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/7.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfoModel : NSObject

- (instancetype)initWithFilePath:(NSString *)path;

@property (copy, readonly, nonatomic) NSString * fileName;//文件名称
@property (copy, readonly, nonatomic) NSString * fileSubfix;//文件后缀名

@property (copy, nonatomic) NSString * downloadUrl;//文件下载地址

@property (copy, readonly, nonatomic) NSString * filePath;//文件路径

@property (assign, readonly, nonatomic) int64_t fileSize;//文件大小
@property (copy, readonly, nonatomic) NSString * createDate;//文件创建日期
@property (strong, readonly, nonatomic) NSDate * modifyDate;//文件修改日期

@property (assign, readonly ,nonatomic) BOOL isDirectory;//是否文件夹

@end
