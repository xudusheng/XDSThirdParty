//
//  CheckVersionAlertView.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/7.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "CheckVersionAlertView.h"
#import "ZipArchive.h"

@interface CheckVersionAlertView()<NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (copy, nonatomic) downloadComplete completeBlock;
@property (copy, nonatomic) NSString * frameworkName;
@property (copy, nonatomic) NSString * frameworkPath;
@property (copy, nonatomic) NSString * zipPath;


@end

@implementation CheckVersionAlertView


- (void)startDownloadByFrameworkName:(NSString *)frameworkName
                            complete:(downloadComplete)complete{
    self.frameworkName = frameworkName;
    NSString * documentPath = [XDSFileManager documentPath];
    
    NSString * frameworkPath = [NSString stringWithFormat:@"%@%@.framework", documentPath, frameworkName];
    NSString * zipPath = [NSString stringWithFormat:@"%@%@.zip", documentPath, frameworkName];
    self.frameworkPath = frameworkPath;
    self.zipPath = zipPath;
    
    NSString * downloadUrl = @"http://omf8zzesn.bkt.clouddn.com/framework/";
    downloadUrl = [NSString stringWithFormat:@"%@%@.zip", downloadUrl, frameworkName];
    
    self.completeBlock = complete;
    
    //开始下载文件
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                           delegate:self
                                                      delegateQueue:[[NSOperationQueue alloc] init]];
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:downloadUrl]];
    [downloadTask resume];
}

#pragma mark -
// 每次写入调用(会调用多次)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // 可在这里通过已写入的长度和总长度算出下载进度
    CGFloat progress = 1.0000 * totalBytesWritten / totalBytesExpectedToWrite;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _progress.progress = progress;
        _progressLabel.text = [NSString stringWithFormat:@"已下载：%.2f%%", progress*100];
    }];

    NSLog(@"%f",progress);
}

// 下载完成调用
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    // location还是一个临时路径,需要自己挪到需要的路径(caches下面)
    [[NSFileManager defaultManager] moveItemAtURL:location
                                            toURL:[NSURL fileURLWithPath:_zipPath]
                                            error:nil];
}

// 任务完成调用
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    [self unZipFileWithError:error];

}


#pragma mark --zip文件解压
-(void)unZipFileWithError:(NSError *)error{
    if (!error) {
        ZipArchive *zipAr = [[ZipArchive alloc] init];
        if (!error && [zipAr UnzipOpenFile: _zipPath]) {
            NSString * documentPath = [XDSFileManager documentPath];

            BOOL ret = [zipAr UnzipFileTo:documentPath overWrite:YES];
            if (NO == ret){
                NSLog(@"解压失败");
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"unzip failed"                                                                      forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:NSCocoaErrorDomain
                                            code:0
                                        userInfo:userInfo];
            }else{
                NSFileManager * fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:_zipPath error:nil];//解压完成以后，删除zip包
            }
            [zipAr UnzipCloseFile];
        }
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _finishButton.enabled = YES;
        
        if (error) {
            self.progressLabel.text = error.localizedDescription;
        }
        if (_completeBlock) {
            _completeBlock(error);
        }
    }];
    
}

- (IBAction)finishButtonClick:(id)sender {
    [self removeFromSuperview];
}

@end
