//
//  ProgressImageView.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/20.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "ProgressImageView.h"
@interface ProgressImageView ()
{
    UIImageView *_imageView;
}
@end

@implementation ProgressImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        SDPieProgressView *pie = [[SDPieProgressView alloc] initWithFrame:CGRectMake((self.width - 100)/2.0, (self.height - 100)/2.0, 100, 100)];
        [self addSubview:pie];
        _pie = pie;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        //设置最大伸缩比例
        scrollView.maximumZoomScale = 2.0;
        //设置最小伸缩比例
        scrollView.minimumZoomScale= 1;
        
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        imageView.backgroundColor = [UIColor redColor];
        [scrollView addSubview:imageView];
        _imageView = imageView;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.pie.progress = progress;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //    CGSize size = scrollView.contentSize;
    //    size.height = 0;
    //    scrollView.contentSize = size;
}
@end
