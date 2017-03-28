//
//  HZShowImageView.m
//  MHProject
//
//  Created by 张好志 on 15/7/4.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HZShowImageView.h"
#import "ProgressImageView.h"
#import "UIImageView+WebCache.h"
@interface HZShowImageView () <UIScrollViewDelegate>
{
    NSInteger _selectedIndex;
}
@end

@implementation HZShowImageView
- (void)dealloc
{
    
}
- (id)initWithFrame:(CGRect)frame withImageArray:(NSMutableArray *)array clickIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageArray = array;
        _selectedIndex = index;
        UIView *bgBlackView = [[UIView alloc]initWithFrame:frame];
        bgBlackView.backgroundColor = [UIColor blackColor];
        [self addSubview:bgBlackView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
        [bgBlackView addGestureRecognizer:singleTap];
        
        self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, DEF_SCREEN_WIDTH + 10, DEF_SCREEN_HEIGHT-80)];
        self.bgScrollView.pagingEnabled = YES;
        self.bgScrollView.backgroundColor = [UIColor clearColor];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        self.bgScrollView.showsHorizontalScrollIndicator = NO;
        self.bgScrollView.delegate = self;
        [self addSubview:self.bgScrollView];
        self.bgScrollView.contentSize = CGSizeMake((DEF_SCREEN_WIDTH+10)*array.count, DEF_SCREEN_WIDTH-80);
        self.bgScrollView.contentOffset = CGPointMake((DEF_SCREEN_WIDTH+10)*index, 0);
        
        //显示第几张
        UILabel *pageLabel = [[UILabel alloc] initForAutoLayout];
        [self addSubview:pageLabel];
        pageLabel.textColor = [UIColor whiteColor];
        [pageLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self];
        [pageLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset: -height(30.0)];
        [pageLabel autoSetDimension:ALDimensionHeight toSize:20.0];
        self.pageLabel = pageLabel;
        
        //根据传进来的url设置图片
        if (array.count > 0)
        {
            [self setPageLabelText:[NSString stringWithFormat:@"%ld/%ld",index+1,array.count]];
            for (int i=0; i<array.count; i++)
            {
                float width = DEF_SCREEN_WIDTH;
                float heig = DEF_SCREEN_HEIGHT-80;
                
                ProgressImageView *imagePic = [[ProgressImageView alloc]initWithFrame:CGRectMake(i*(width+10), 0, width, heig)];
                imagePic.tag = 1000 + i;
                //                imagePic.backgroundColor = [UIColor grayColor];
                [self.bgScrollView addSubview:imagePic];
                __weak ProgressImageView *weakImagePic = imagePic;
                id  object;
                object = array[i];
                if ([object isKindOfClass:[UIImage class]])
                {
                    imagePic.imageView.image = object;
                    imagePic.progress = 1;
                }
                else{
                    [imagePic.imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            weakImagePic.progress = floorf(receivedSize)/floorf(expectedSize);
                        });
                        DEF_DEBUG(@"%ld_____%ld",(long)receivedSize,(long)expectedSize);
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        weakImagePic.progress = 1;
                    }];
                }
                               //添加手势
                imagePic.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
                singleTap.numberOfTapsRequired = 1;
                [imagePic addGestureRecognizer:singleTap];
                
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapImage:)];
                doubleTap.numberOfTapsRequired = 2;
                [imagePic addGestureRecognizer:doubleTap];
                
                [singleTap requireGestureRecognizerToFail:doubleTap];
                
                // 内容模式
                imagePic.clipsToBounds = YES;
                imagePic.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
    }
    return self;
}

//
-(void)hidden
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//
-(void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        [[AppDelegate appDelegate].window addSubview:self];
    }];
}

- (void)tapSelf:(UITapGestureRecognizer *)tap
{
    [self hidden];
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    [self hidden];
}
- (void)doubleTapImage:(UITapGestureRecognizer *)tap
{
    ProgressImageView *imagePic = (ProgressImageView *)tap.view;
    if (imagePic.scrollView.zoomScale ==1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            imagePic.scrollView.zoomScale = 1.5;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            imagePic.scrollView.zoomScale = 1;
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.width + 1;
    
    if (_selectedIndex != index-1)
    {
        ProgressImageView *imagePic = (ProgressImageView *)[scrollView viewWithTag:1000+_selectedIndex];
        imagePic.scrollView.zoomScale = 1;
    }
    
    _selectedIndex = index-1;
    [self setPageLabelText:[NSString stringWithFormat:@"%ld/%ld",index,self.imageArray.count]];
}
- (void)setPageLabelText:(NSString *)text
{
    _pageLabel.text = text;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
