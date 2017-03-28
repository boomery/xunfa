//
//  HomeViewController.h
//  BMProject
//
//  Created by 杜宾 on 15/4/19.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "BaseViewController.h"
@class QuestionCustomCell;
@interface HomeViewController : BaseViewController 

@property(strong,nonatomic)PullingRefreshTableView *homeCloseTableView;

//接收从抢答回复界面传递过来的抢答成功的字段
@property(strong,nonatomic)NSString *showRaceSuccessTipStr;

@end
