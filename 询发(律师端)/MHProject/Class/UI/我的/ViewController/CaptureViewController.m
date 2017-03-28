//
//  CaptureViewController.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/17.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "CaptureViewController.h"

@implementation CaptureViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加导航栏和完成按钮
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 64)];
    [self.view addSubview:naviBar];
    
    UINavigationItem *naviItem = [[UINavigationItem alloc] initWithTitle:@"图片裁剪"];
    [naviBar pushNavigationItem:naviItem animated:YES];
    self.view.backgroundColor = [UIColor blackColor];
    
    //保存按钮
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    naviItem.rightBarButtonItem = doneItem;
    
    //取消
    UIBarButtonItem *cacelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    naviItem.leftBarButtonItem = cacelItem;
    
    //image为上一个界面传过来的图片资源
    AGSimpleImageEditorView *editorView = [[AGSimpleImageEditorView alloc] initWithImage:self.image];
    editorView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_WIDTH);
    editorView.backgroundColor = [UIColor clearColor];
    editorView.center = self.view.center;
    
    //外边框的宽度及颜色
    editorView.borderWidth = 1.f;
    editorView.borderColor = [UIColor blackColor];
    
    //截取框的宽度及颜色
    editorView.ratioViewBorderWidth = 1.f;
    editorView.ratioViewBorderColor = [UIColor orangeColor];
    
    //截取比例，我这里按正方形1:1截取（可以写成 3./2. 16./9. 4./3.）
    editorView.ratio = 640/390.0;
    
    [self.view addSubview:editorView];
    self.editorView = editorView;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(DoneEditForImage:)])
    {
        [self.delegate DoneEditForImage:self.editorView.output];
    }
}
@end
