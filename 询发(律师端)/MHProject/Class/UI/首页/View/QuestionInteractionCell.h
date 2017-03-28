//
//  QuestionInteractionCell.h
//  MHProject
//
//  Created by 杜宾 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionInteractionCell : UITableViewCell
@property(nonatomic,strong)UILabel *questionLab;  // 问题

@property(nonatomic,strong)UIImageView *headImage;

@property(nonatomic,strong)UIImageView * buddleImageView;

//-(void)setQuestionText:(NSString *)text;
-(void)loadCellWithDict:(NSDictionary *)dict;

+(float)heightForCellWithDict:(NSDictionary *)dict;
@end
