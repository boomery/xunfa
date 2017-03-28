//
//  CustomHeaderReusableView.m
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "CustomHeaderReusableView.h"
@implementation CustomHeaderReusableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.pageView = [[PageView alloc] initPageViewFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 400/3.0)];
        _pageView.duration    = 2.0;
        _pageView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_pageView];

        [MHAsiNetworkAPI getBannerBySuccessBlock:^(id returnData)
         {
             DEF_DEBUG(@"广告轮播图接口返回的数据：%@",returnData);
             NSMutableArray *headImageArray = returnData[@"data"];
             
             NSMutableArray *arr = [[NSMutableArray alloc]init];
             for (NSDictionary *dict in headImageArray)
             {
                 [arr addObject:dict[@"image"]];
             }
             _pageView.isWebImage = YES;
             _pageView.imageArray = arr;
             self.bannerBlock(headImageArray);
             
         } failureBlock:^(NSError *error) {
             
         } showHUD:NO];
    }
    
    return self;
}




//
//NSMutableArray *headImageArray = [[NSMutableArray alloc]initWithObjects:@"ad",@"ad_2",@"ad",@"ad_2" ,nil];
//
//NSMutableArray *viewsArray  = [[NSMutableArray alloc] init];
//if (headImageArray.count !=0)
//{
//    for (NSInteger i = 0; i < headImageArray.count; i++)
//    {
//        UIImageView *imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, autoScrollView.frame.size.width, autoScrollView.frame.size.height)];
//        imageView.backgroundColor = [UIColor orangeColor];
//        imageView.image = [UIImage imageNamed:headImageArray[i]];
//        [viewsArray addObject:imageView];
//        
//        
//        
//    }
//    if (viewsArray.count >= 2 )
//    {
//        // 开启自定义scrollview的自动滚动
//        [autoScrollView shouldAutoShow:YES];
//    }
//    else
//    {
//        // 开启自定义scrollview的自动滚动
//        [autoScrollView shouldAutoShow:NO];
//    }
//    
//    [autoScrollView setViewsArray:viewsArray];
//}


@end
