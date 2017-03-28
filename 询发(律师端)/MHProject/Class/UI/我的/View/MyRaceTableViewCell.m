//
//  MyIdeaTableViewCell.m
//  MHProject
//
//  Created by 张好志 on 15/6/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyRaceTableViewCell.h"

@implementation MyRaceTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initForAutoLayout];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
        [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
        [bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
        
        UIView *topLineView = [[UIView alloc] initForAutoLayout];
        topLineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.86 alpha:1];
        [bgView addSubview:topLineView];
        [topLineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView];
        [topLineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView];
        [topLineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView];
        [topLineView autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
        
        UIView *bottomLineView = [[UIView alloc] initForAutoLayout];
        bottomLineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.86 alpha:1];
        [bgView addSubview:bottomLineView];
        [bottomLineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView];
        [bottomLineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView];
        [bottomLineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView];
        [bottomLineView autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
        //
        self.myIdeaToPersonLB = [[UILabel alloc] initForAutoLayout];
        [bgView addSubview:self.myIdeaToPersonLB];
        self.myIdeaToPersonLB.text = @"给**用户出的主意：";
        self.myIdeaToPersonLB.font = [UIFont systemFontOfSize:13.5];
        self.myIdeaToPersonLB.textColor = DEF_RGB_COLOR(111, 111, 111);
        [self.myIdeaToPersonLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15];
        [self.myIdeaToPersonLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView withOffset:10];
        [self.myIdeaToPersonLB autoSetDimensionsToSize:CGSizeMake(200, 20)];
        
        //
        self.myIdeaTimeLB = [[UILabel alloc] initForAutoLayout];
        [bgView addSubview:self.myIdeaTimeLB];
        self.myIdeaTimeLB.text = @"06-01 14:30";
        self.myIdeaTimeLB.textAlignment = NSTextAlignmentRight;
        self.myIdeaTimeLB.font = [UIFont systemFontOfSize:12];
        self.myIdeaTimeLB.textColor = DEF_RGB_COLOR(159, 159, 159);
        [self.myIdeaTimeLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.myIdeaToPersonLB withOffset:10];
        [self.myIdeaTimeLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.myIdeaToPersonLB withOffset:0];
        [self.myIdeaTimeLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15];
        [self.myIdeaTimeLB autoSetDimensionsToSize:CGSizeMake(100, 20)];
        
        //
        self.myIdeaLB = [[UILabel alloc] initForAutoLayout];
        [bgView addSubview:self.myIdeaLB];
        self.myIdeaLB.text = @"5年";
        self.myIdeaLB.font = [UIFont systemFontOfSize:16];
        self.myIdeaLB.textColor = DEF_RGB_COLOR(51, 51, 51);
        self.myIdeaLB.numberOfLines = 0;
        [self.myIdeaLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15];
        [self.myIdeaLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15];
        [self.myIdeaLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.myIdeaToPersonLB withOffset:12];
        [self.myIdeaLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-56];

        UIView *lineView = [[UIView alloc] initForAutoLayout];
        lineView.backgroundColor = DEF_RGB_COLOR(244, 244, 244);
        [self addSubview:lineView];
        [lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15];
        [lineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0 ];
        [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.myIdeaLB withOffset:12];
        [lineView autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
        //
        self.questionLB = [[UILabel alloc]initForAutoLayout];
        [bgView addSubview:self.questionLB];
        [self.questionLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:15];
        [self.questionLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-15 ];
        [self.questionLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-12];
        [self.questionLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView withOffset:12];
        self.questionLB.layer.cornerRadius = 2;
        self.questionLB.clipsToBounds = YES;
        self.questionLB.textColor = DEF_RGB_COLOR(60, 153, 230);
        self.questionLB.textAlignment = NSTextAlignmentLeft;
        self.questionLB.font = [UIFont systemFontOfSize:13.5];

        
        //
//        self.questionBtn = [[UIButton alloc]initForAutoLayout];
//        [bgView addSubview:self.questionBtn];
//        [self.questionBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10 ];
//        [self.questionBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10 ];
//        [self.questionBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-10];
//        [self.questionBtn autoSetDimensionsToSize:CGSizeMake(DEF_SCREEN_WIDTH-20, 30)];
//        self.questionBtn.layer.cornerRadius = 2;
//        self.questionBtn.clipsToBounds = YES;
//        self.questionBtn.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//我的抢答
-(void)loadCellWithRaceQuestionDict:(NSDictionary *)dict
{
    self.myIdeaToPersonLB.text =[NSString stringWithFormat:@"给%@用户的回复：",dict[@"name"]];
    self.myIdeaTimeLB.text = dict[@"created_at"];
    NSString *ping_content = dict[@"ping_content"];
    NSString *answer_content = dict[@"answer_content"];
    NSString *contentString = ping_content? ping_content : answer_content;
    self.myIdeaLB.text = contentString;
    self.questionLB.text = [NSString stringWithFormat:@" 问题：%@",dict[@"content"]];
}

+(float)heightForCellWithRaceQuestionDict:(NSDictionary *)dict
{
    //主意：上方头像40 下方擅长分类40
    float fontsize = 16;
    NSString *ping_content = dict[@"ping_content"];
    NSString *answer_content = dict[@"answer_content"];
    NSString *contentString = ping_content? ping_content : answer_content;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]};
    CGSize ziTiSize = [contentString boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-30, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    float height =ziTiSize.height+108;
    return height;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
