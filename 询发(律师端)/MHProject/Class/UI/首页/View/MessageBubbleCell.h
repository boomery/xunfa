//
//  MessageBubbleCell.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/7.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageBubbleCell : UITableViewCell

@property (nonatomic, strong) UIButton *headImageButton;
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)refreshCellWithDictionary:(NSDictionary *)dictionary;
+ (CGFloat)heightForCellWithDictionary:(NSDictionary *)dictionary;


@end
