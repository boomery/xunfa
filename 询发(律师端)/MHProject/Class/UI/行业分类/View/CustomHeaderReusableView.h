//
//  CustomHeaderReusableView.h
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
typedef void(^GetBannerSuccessBlock)(NSMutableArray *array);


#import <UIKit/UIKit.h>
#import "PageView.h"
@interface CustomHeaderReusableView : UICollectionReusableView

@property (nonatomic, copy) GetBannerSuccessBlock bannerBlock;
@property (nonatomic, strong) PageView *pageView;


@end
