//
//  XDSFileManager.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/7.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "XDSFileManager.h"
@implementation XDSFileManager

+ (FileInfoModel *)getFileInfoWithFilePath:(NSString *)path{
    
    FileInfoModel * fileInfo = [[FileInfoModel alloc] initWithFilePath:path];
    return fileInfo;
}


//文件所在的文件夹路径
+ (NSString *)documentPath{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if (![documentPath hasSuffix:@"/"]) {
        documentPath = [documentPath stringByAppendingString:@"/"];
    }
    return documentPath;
}

//TODO:获取文件夹下的所有文件
//获取当前目录下的所有文件
+ (NSArray *)getAllFilesInDirectory:(NSString *)directoryPath{
    NSError * error = nil;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error || directoryContents.count <= 0) {
        return nil;
    }
    

    return directoryContents;
}

+ (NSArray<FileInfoModel *> *)getAllFrameworkInDocument{
    NSString * documentPath = [self documentPath];
    NSError * error = nil;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:&error];
    if (error || directoryContents.count <= 0) {
        return nil;
    }
    
    NSMutableArray * files = [NSMutableArray arrayWithCapacity:0];
    [directoryContents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * fileName = obj;
        if ([fileName hasSuffix:@"framework"]) {
            NSString * frameworkPath = [documentPath stringByAppendingString:fileName];
            FileInfoModel * fileModel = [[FileInfoModel alloc] initWithFilePath:frameworkPath];
            [files addObject:fileModel];
        }
    }];
    return files;
}
@end
