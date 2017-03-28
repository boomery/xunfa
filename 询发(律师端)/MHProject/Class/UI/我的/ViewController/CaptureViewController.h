//
//  CaptureViewController.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/17.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "BaseViewController.h"
#import "AGSimpleImageEditorView.h"
@interface CaptureViewController : BaseViewController
{
    UIImage *image;
}

@property (nonatomic, strong) AGSimpleImageEditorView *editorView;

@property (nonatomic, strong) UIImage *image;

@property (assign, nonatomic) id delegate;

@end

@protocol CaptureViewControllerDelegate <NSObject>

- (void)DoneEditForImage:(UIImage *)image;

@end