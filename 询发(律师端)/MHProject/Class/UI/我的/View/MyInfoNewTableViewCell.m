//
//  MyInfoNewTableViewCell.m
//  MHProject
//
//  Created by 张好志 on 15/8/3.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#import "MyInfoNewTableViewCell.h"

@implementation MyInfoNewTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //线
        UIImageView *topImage = [[UIImageView alloc]initForAutoLayout];
        [self.contentView addSubview:topImage];
        topImage.backgroundColor = DEF_RGB_COLOR(202,202,202);
        [topImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
        [topImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
        [topImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0];
        [topImage autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
        self.topLine = topImage;
        
        //
        self.lawyerTipLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.lawyerTipLB];
        self.lawyerTipLB.textColor = [UIColor blackColor];
        self.lawyerTipLB.font = [UIFont systemFontOfSize:16];
        [self.lawyerTipLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [self.lawyerTipLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12];
        [self.lawyerTipLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.lawyerTipLB autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH-24, 20)];
        
        //
        self.enterImageView = [[UIImageView alloc]initForAutoLayout];
        [self addSubview:self.enterImageView];
        self.enterImageView.image = [UIImage imageNamed:@"ic_news_read_arrow"];
        self.enterImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.enterImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [self.enterImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.enterImageView autoSetDimensionsToSize:CGSizeMake(24, 20)];
        
        //
        self.timeLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.timeLB];
        self.timeLB.textColor = [UIColor blackColor];
        self.timeLB.font = [UIFont systemFontOfSize:12];
        [self.timeLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lawyerTipLB withOffset:1];
        [self.timeLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12];
        [self.timeLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.timeLB autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH-24, 20)];

        //
        self.questionLB = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.questionLB];
        self.questionLB.textColor = DEF_RGB_COLOR(111, 111, 111);
        self.questionLB.font = [UIFont systemFontOfSize:12];
        [self.questionLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timeLB withOffset:1];
        [self.questionLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12];
        [self.questionLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.questionLB autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH-24, 20)];
        //
//        //线
        self.bottomLine = [[UIImageView alloc]initForAutoLayout];
        [self.contentView addSubview:self.bottomLine];
        self.bottomLine.backgroundColor = DEF_RGB_COLOR(202,202,202);
        [self.bottomLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
        [self.bottomLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-0];
        [self.bottomLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:LINE_HEIGHT];
        [self.bottomLine autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
    }
    return self;
}
//
-(void)loadCellWithDict:(NSDictionary *)dict
{
    /*
     content = "\U5df2\U6709\U4e00\U4e2a\U65b0\U95ee\U9898\Uff0c\U8bf7\U6ce8\U610f\U62a2\U7b54";
     "created_at" = "08-03 11:05";
     id = 486;
     "is_read" = 0;
     "lawyer_id" = 0;
     qid = 462;
     */
    self.lawyerTipLB.text = dict[@"content"];
    self.timeLB.text = dict[@"created_at"];
    NSString *pointColorStr = dict[@"is_read"];
    //为0 是未读消息  否则是已读消息
    if ([pointColorStr isEqualToString:@"0"])
    {
        self.lawyerTipLB.textColor = [UIColor blackColor];
        self.timeLB.textColor = [UIColor blackColor];
        self.questionLB.textColor = DEF_RGB_COLOR(111, 111, 111);
        self.enterImageView.image = [UIImage imageNamed:@"ic_news_read_arrow"];
    }
    else
    {
        self.lawyerTipLB.textColor = DEF_RGB_COLOR(202, 202, 202);
        self.timeLB.textColor = DEF_RGB_COLOR(202, 202, 202);
        self.questionLB.textColor = DEF_RGB_COLOR(202, 202, 202);
        self.enterImageView.image = [UIImage imageNamed:@"ic_news_arrow"];
    }
    self.questionLB.text = dict[@"question_content"];
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    return 80;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
