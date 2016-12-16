//
//  EaseMarkdownTextView.m
//  Coding_iOS
//
//  Created by Ease on 15/2/9.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import "EaseMarkdownTextView.h"
#import "RFKeyboardToolbar.h"
#import "RFToolbarButton.h"
#import <RegexKitLite-NoWarning/RegexKitLite.h>

////at某人
//#import "UsersViewController.h"
//#import "ProjectMemberListViewController.h"
//#import "Users.h"
//#import "Login.h"
//#import "Helper.h"
//
////photo
//#import "Coding_FileManager.h"
//#import "Coding_NetAPIManager.h"
//#import <MBProgressHUD/MBProgressHUD.h>

@interface EaseMarkdownTextView () <UIActionSheetDelegate>
//@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSString *uploadingPhotoName;
@end


@implementation EaseMarkdownTextView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.inputAccessoryView = [RFKeyboardToolbar toolbarWithButtons:[self buttons]];
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    NSString *actionName = NSStringFromSelector(action);
    if ([actionName isEqualToString:@"_addShortcut:"]) {
        return NO;
    }else{
        return [super canPerformAction:action withSender:sender];
    }
}

- (NSArray *)buttons {
    return @[
             
             [self createButtonWithTitle:@"@" andEventHandler:^{ [self doAT]; }],
             
             [self createButtonWithTitle:@"#" andEventHandler:^{ [self insertText:@"#"]; }],
             [self createButtonWithTitle:@"*" andEventHandler:^{ [self insertText:@"*"]; }],
             [self createButtonWithTitle:@"`" andEventHandler:^{ [self insertText:@"`"]; }],
             [self createButtonWithTitle:@"-" andEventHandler:^{ [self insertText:@"-"]; }],
             
             [self createButtonWithTitle:@"照片" andEventHandler:^{ [self doPhoto]; }],
             
             [self createButtonWithTitle:@"标题" andEventHandler:^{ [self doTitle]; }],
             [self createButtonWithTitle:@"粗体" andEventHandler:^{ [self doBold]; }],
             [self createButtonWithTitle:@"斜体" andEventHandler:^{ [self doItalic]; }],
             [self createButtonWithTitle:@"代码" andEventHandler:^{ [self doCode]; }],
             [self createButtonWithTitle:@"引用" andEventHandler:^{ [self doQuote]; }],
             [self createButtonWithTitle:@"列表" andEventHandler:^{ [self doList]; }],
             
             [self createButtonWithTitle:@"链接" andEventHandler:^{
                 NSString *tipStr = @"在此输入链接地址";
                 NSRange selectionRange = self.selectedRange;
                 selectionRange.location += 5;
                 selectionRange.length = tipStr.length;

                 [self insertText:[NSString stringWithFormat:@"[链接](%@)", tipStr]];
                 [self setSelectionRange:selectionRange];
             }],
             
             [self createButtonWithTitle:@"图片链接" andEventHandler:^{
                 NSString *tipStr = @"在此输入图片地址";
                 NSRange selectionRange = self.selectedRange;
                 selectionRange.location += 6;
                 selectionRange.length = tipStr.length;

                 [self insertText:[NSString stringWithFormat:@"![图片](%@)", tipStr]];
                 [self setSelectionRange:selectionRange];
             }],
             
             [self createButtonWithTitle:@"分割线" andEventHandler:^{
                 NSRange selectionRange = self.selectedRange;
                 NSString *insertStr = [self needPreNewLine]? @"\n\n------\n": @"\n------\n";
                 
                 selectionRange.location += insertStr.length;
                 selectionRange.length = 0;
                 
                 [self insertText:insertStr];
                 [self setSelectionRange:selectionRange];
             }],
             
             [self createButtonWithTitle:@"_" andEventHandler:^{ [self insertText:@"_"]; }],
             [self createButtonWithTitle:@"+" andEventHandler:^{ [self insertText:@"+"]; }],
             [self createButtonWithTitle:@"~" andEventHandler:^{ [self insertText:@"~"]; }],
             [self createButtonWithTitle:@"=" andEventHandler:^{ [self insertText:@"="]; }],
             [self createButtonWithTitle:@"[" andEventHandler:^{ [self insertText:@"["]; }],
             [self createButtonWithTitle:@"]" andEventHandler:^{ [self insertText:@"]"]; }],
             [self createButtonWithTitle:@"<" andEventHandler:^{ [self insertText:@"<"]; }],
             [self createButtonWithTitle:@">" andEventHandler:^{ [self insertText:@">"]; }]
             ];
}

- (BOOL)needPreNewLine{
    NSString *preStr = [self.text substringToIndex:self.selectedRange.location];
    return !(preStr.length == 0
            || [preStr isMatchedByRegex:@"[\\n\\r]+[\\t\\f]*$"]);
}

- (RFToolbarButton *)createButtonWithTitle:(NSString*)title andEventHandler:(void(^)())handler {
    return [RFToolbarButton buttonWithTitle:title andEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelectionRange:(NSRange)range {
    UIColor *previousTint = self.tintColor;
    
    self.tintColor = UIColor.clearColor;
    self.selectedRange = range;
    self.tintColor = previousTint;
}

#pragma mark md_Method
- (void)doTitle{
    [self doMDWithLeftStr:@"## " rightStr:@" ##" tipStr:@"在此输入标题" doNeedPreNewLine:YES];
}

- (void)doBold{
    [self doMDWithLeftStr:@"**" rightStr:@"**" tipStr:@"在此输入粗体文字" doNeedPreNewLine:NO];
}

- (void)doItalic{
    [self doMDWithLeftStr:@"*" rightStr:@"*" tipStr:@"在此输入斜体文字" doNeedPreNewLine:NO];
}

- (void)doCode{
    [self doMDWithLeftStr:@"```\n" rightStr:@"\n```" tipStr:@"在此输入代码片段" doNeedPreNewLine:YES];
}

- (void)doQuote{
    [self doMDWithLeftStr:@"> " rightStr:@"" tipStr:@"在此输入引用文字" doNeedPreNewLine:YES];
}

- (void)doList{
    [self doMDWithLeftStr:@"- " rightStr:@"" tipStr:@"在此输入列表项" doNeedPreNewLine:YES];
}

- (void)doMDWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr tipStr:(NSString *)tipStr doNeedPreNewLine:(BOOL)doNeedPreNewLine{
    
    BOOL needPreNewLine = doNeedPreNewLine? [self needPreNewLine]: NO;
    
    
    if (!leftStr || !rightStr || !tipStr) {
        return;
    }
    NSRange selectionRange = self.selectedRange;
    NSString *insertStr = [self.text substringWithRange:selectionRange];
    
    if (selectionRange.length > 0) {//已有选中文字
        //撤销
        if (selectionRange.location >= leftStr.length && selectionRange.location + selectionRange.length + rightStr.length <= self.text.length) {
            NSRange expandRange = NSMakeRange(selectionRange.location- leftStr.length, selectionRange.length +leftStr.length +rightStr.length);
            expandRange = [self.text rangeOfString:[NSString stringWithFormat:@"%@%@%@", leftStr, insertStr, rightStr] options:NSLiteralSearch range:expandRange];
            if (expandRange.location != NSNotFound) {
                selectionRange.location -= leftStr.length;
                selectionRange.length = insertStr.length;
                [self setSelectionRange:expandRange];
                [self insertText:insertStr];
                [self setSelectionRange:selectionRange];
                return;
            }
        }
        //添加
        selectionRange.location += needPreNewLine? leftStr.length +1: leftStr.length;
        insertStr = [NSString stringWithFormat:needPreNewLine? @"\n%@%@%@": @"%@%@%@", leftStr, insertStr, rightStr];
    }else{//未选中任何文字
        //添加
        selectionRange.location += needPreNewLine? leftStr.length +1: leftStr.length;
        selectionRange.length = tipStr.length;
        insertStr = [NSString stringWithFormat:needPreNewLine? @"\n%@%@%@": @"%@%@%@", leftStr, tipStr, rightStr];
    }
    [self insertText:insertStr];
    [self setSelectionRange:selectionRange];
}

#pragma mark AT
- (void)doAT{
    //跳转到选择人员的页面
    NSLog(@"点击了@，请跳转到到选择人员的页面");

}


#pragma mark Photo
- (void)doPhoto{
    //
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self];
    
}

- (void)presentPhotoVCWithIndex:(NSInteger)index{
    if (index == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if (index == 0) {
        //拍照
        if (NO) {//相机不可用
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (index == 1){
        //相册
        if (NO) {//相册访问受限
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:picker animated:YES completion:nil];//进入照相界面
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self presentPhotoVCWithIndex:buttonIndex];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    // 保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && originalImage) {
        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
    }

    //上传照片
    [picker dismissViewControllerAnimated:YES completion:^{
        if (originalImage) {
            [self doUploadPhoto:originalImage];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)doUploadPhoto:(UIImage *)image{
    //处理照片
    //上传或者保存等
}

- (void)completionUploadWithResult:(id)responseObject error:(NSError *)error{
    //文件上传成功以后插入文字
    NSString *photoLinkStr = [self needPreNewLine]? @"\n![图片](https://www.baidu.com/)\n": @"![图片](https://www.baidu.com/)\n";
    [self insertText:photoLinkStr];
    [self becomeFirstResponder];
}



@end
