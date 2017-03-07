//
//  XDSFileManager.h
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/7.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileInfoModel.h"

@interface XDSFileManager : NSObject

+ (NSString *)documentPath;//文件所在的文件夹路径


/**
 * 根据文件路径获取具体的文件信息
 */
+ (FileInfoModel *)getFileInfoWithFilePath:(NSString *)path;


/**
 * 获取文件夹下的所有文件
 */
+ (NSArray *)getAllFilesInDirectory:(NSString *)directoryPath;


/**
 * 获取Document文件夹下的所有framework文件
 */
+ (NSArray<FileInfoModel *> *)getAllFrameworkInDocument;

@end
