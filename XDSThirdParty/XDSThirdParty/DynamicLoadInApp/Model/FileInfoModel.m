//
//  FileInfoModel.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/7.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "FileInfoModel.h"
@interface FileInfoModel()

@property (copy, nonatomic) NSString * pFilePath;

@property (strong, nonatomic) NSDictionary * fileAttributes;

@end


@implementation FileInfoModel
- (instancetype)initWithFilePath:(NSString *)path{
    NSParameterAssert(path);
    if (self = [super init]) {
        self.pFilePath = path;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        self.fileAttributes = fileAttributes;
    }
    return self;
}

//文件路径
- (NSString *)filePath{
    return _pFilePath;
}

//文件名称
- (NSString *)fileName{
    if (_pFilePath.length <= 0) {
        return nil;
    }
    
    NSString * fileFullName = [_pFilePath componentsSeparatedByString:@"/"].lastObject;
    if ([fileFullName isEqualToString:@"Documents"]) {
        return nil;
    }
    
    NSArray * nameAndSubfix = [fileFullName componentsSeparatedByString:@"."];
    if (nameAndSubfix.count <= 2) {
        return nameAndSubfix.firstObject;
    }else{
        NSString * subfix = nameAndSubfix.lastObject;
        NSString * filename = [fileFullName substringToIndex:fileFullName.length-subfix.length];
        return filename;
    }
}

//文件后缀名
- (NSString *)fileSubfix{
    if (_pFilePath.length <= 0) {
        return nil;
    }
    
    NSString * fileFullName = [_pFilePath componentsSeparatedByString:@"/"].lastObject;
    if ([fileFullName isEqualToString:@"Documents"]) {
        return nil;
    }
    
    NSArray * nameAndSubfix = [fileFullName componentsSeparatedByString:@"."];
    if (nameAndSubfix.count >= 2) {
        return nameAndSubfix.lastObject;
    }else{
        return nil;
    }
}



//文件大小
- (int64_t)fileSize{
    NSNumber *fileSize = [_fileAttributes objectForKey:NSFileSize];
    if (fileSize) {
        return fileSize.unsignedLongLongValue;
    }
    return 0;
}

//文件创建日期
- (NSString *)createDate{
    NSString * creationDate = [_fileAttributes objectForKey:NSFileCreationDate];
    return creationDate;
}

//TODO:文件修改日期
- (NSDate *)modifyDate{
    NSDate * modifyDate = [_fileAttributes objectForKey:NSFileModificationDate];
    return modifyDate;
}

//TODO:判断是否是为目录
- (BOOL)isDirectory{
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:_pFilePath isDirectory:&isDir] && isDir){//目录
        return YES;
    }else{//文件
        return NO;
    }
}




@end
