//
//  QuestionSquareViewController.h
//  MHProject
//
//  Created by 张好志 on 15/7/3.
//  Copyright (c) 2015年 Andy. All rights reserved.
//问题广场

#import "BaseViewController.h"

@interface QuestionSquareViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    
}
//
@property(strong,nonatomic)PullingRefreshTableView *tableView;
@property (nonatomic,assign)long                    pageNumber;
@property(strong,nonatomic)NSMutableArray          *questionListArray;



@property(nonatomic,strong)NSString *categoryID;
@property(nonatomic,strong)NSString *categoryName;



@end
