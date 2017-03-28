//
//  SearchQuestionCell.m
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "SearchQuestionCell.h"
#import "HomeStagCustomView.h"
#import "HZUtil.h"

@implementation SearchQuestionCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self creatSearchCell];
    }
    
    return self;
    
}

-(void)creatSearchCell
{
    //
    
    //  底部的背景视图
    UIView *bgView = [[UIView alloc]initForAutoLayout];
    [self addSubview:bgView];
    [bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:8];
    [bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
    [bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    bgView.layer.borderWidth = LINE_HEIGHT;
    bgView.layer.borderColor = DEF_RGB_COLOR(202, 202, 202).CGColor;
    bgView.backgroundColor = [UIColor whiteColor];
   
    
    //    问题
    self.questionLable = [[UILabel alloc] initForAutoLayout];
    [bgView addSubview:self.questionLable];
    self.questionLable.font = DEF_Font(16);
    self.questionLable.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.questionLable.numberOfLines = 4;
    [self.questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:12];
    [self.questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-12];
    [self.questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView withOffset:12];
    [self.questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-40];
    
    
    //线
    UIImageView *lineImage = [[UIImageView alloc]initForAutoLayout];
    [bgView addSubview:lineImage];
    lineImage.backgroundColor = DEF_RGB_COLOR(244,244,244);
    [lineImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12];
    [lineImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
    [lineImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:12];
    [lineImage autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
    
    //左边的标签
    _left = [[HomeStagCustomView alloc]initForAutoLayout];
    [bgView addSubview:_left];
    [_left.stagLable autoPinEdge:ALEdgeLeft  toEdge:ALEdgeLeft ofView:_left withOffset:20];
    _left.stagLable.textAlignment = NSTextAlignmentLeft;
    [_left autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:6];
    [_left autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-6];
    _left.stagImagePic.image = [UIImage imageNamed:@"ic_list_tag"];
    if (DEF_SCREEN_WIDTH==320) {
        [_left autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lineImage withOffset:-8];
    }else{
        [_left autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lineImage withOffset:-5];
    }
    [_left autoSetDimension:ALDimensionWidth toSize:75];
    _left.stagLable.textColor = DEF_RGB_COLOR(111, 111, 111);
    _left.stagLable.font = DEF_Font(13.5);
    
    
    
    //    日期
    self.dateLable = [[UILabel alloc]initForAutoLayout];
    [bgView addSubview:self.dateLable];
    self.dateLable.font = [UIFont systemFontOfSize:13.5];
    self.dateLable.textColor = DEF_RGB_COLOR(159, 159, 159);
    //    self.dateLable.text = @"03-03 18:00";
    self.dateLable.textAlignment = 2;
    //    右边
    [self.dateLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-12];
    //    上
    [self.dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:6];
    [self.dateLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-6];
    [self.dateLable autoSetDimension:ALDimensionWidth toSize:100];
    
    //左边的标签
    _right = [[HomeStagCustomView alloc]initForAutoLayout];
    [bgView addSubview:_right];
    [_right.stagLable autoPinEdge:ALEdgeRight  toEdge:ALEdgeLeft ofView:self.dateLable withOffset:0];
    _right.stagLable.textAlignment = NSTextAlignmentLeft;
    [_right autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:6];
    [_right autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-6];
    _right.stagImagePic.image = [UIImage imageNamed:@"ic_idea"];
    if (DEF_SCREEN_WIDTH==320) {
        [_right autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lineImage withOffset:-8];
    }else{
        [_right autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lineImage withOffset:-5];
    }
    [_right autoSetDimension:ALDimensionWidth toSize:75];
    _right.stagLable.textColor = DEF_RGB_COLOR(60, 153, 230);
    _right.stagLable.font = DEF_Font(13.5);


}
-(void)loadCellWithDict:(NSDictionary *)dict
{
    self.questionLable.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
    _left.stagLable.text = dict[@"category_name"];
    self.dateLable.text = dict[@"created_at"];
    _right.stagLable.text = [NSString stringWithFormat:@"%@个主意",dict[@"ping_num"]];
    [_right.stagLable sizeToFit];
    
    
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    NSString *detailStr = dict[@"content"];
    float contentHeight =  [HZUtil getHeightWithString:detailStr fontSize:16 width:DEF_SCREEN_WIDTH-24];
    if (contentHeight > 76)
    {
        contentHeight = 76;
    }
    float height = contentHeight +8+12+40+5;
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
