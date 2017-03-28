//
//  MycollectionQuestionCell.m
//  MHProject
//
//  Created by 杜宾 on 15/7/15.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MycollectionQuestionCell.h"
#import "UIButton+WebCache.h"
#import "HZUtil.h"
#import "HomeStagCustomView.h"

@implementation MycollectionQuestionCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self CreatCustomQuestionCell];
    }
    return self;
}
-(void)CreatCustomQuestionCell
{
    //  底部的背景视图
    UIView *bgView = [[UIView alloc]initForAutoLayout];
    [self addSubview:bgView];
    [bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:8];
    [bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
    [bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    bgView.layer.borderWidth = LINE_HEIGHT;
;
    bgView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
    bgView.backgroundColor = [UIColor whiteColor];
    
    //律师头像
    self.userImageBtn = [[UIButton alloc]initForAutoLayout];
    [bgView addSubview:self.userImageBtn];
    [self.userImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12 ];
    [self.userImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView withOffset:12 ];
    [self.userImageBtn autoSetDimensionsToSize:CGSizeMake(34, 34)];
    self.userImageBtn.layer.masksToBounds = YES;
    self.userImageBtn.layer.cornerRadius = 17;
    self.userImageBtn.clipsToBounds = YES;
    
    //名字
    self.name = [[UILabel alloc] initForAutoLayout];
    [bgView addSubview:self.name];
    self.name.textColor = NameColor;
    self.name.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.5];
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:13];
    [self.name autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageBtn withOffset:0];
    [self.name autoSetDimension:ALDimensionHeight toSize:34];
    
    //时间
    self.dateLable = [[UILabel alloc]initForAutoLayout];
    [bgView addSubview:self.dateLable];
    self.dateLable.font = [UIFont systemFontOfSize:12];
    self.dateLable.textColor = DEF_RGB_COLOR(142, 142, 147);
    self.dateLable.textAlignment = 2;
    [self.dateLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-12];
    [self.dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageBtn withOffset:7];
    [self.dateLable autoSetDimension:ALDimensionHeight toSize:20];
    [self.dateLable autoSetDimension:ALDimensionWidth toSize:100 relation:NSLayoutRelationLessThanOrEqual];
    
    [self.name autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.dateLable withOffset:-12];
    
    //问题
    self.questionLable = [[UILabel alloc] initForAutoLayout];
    [bgView addSubview:self.questionLable];
    self.questionLable.textColor = DEF_RGB_COLOR(61, 61, 71);
    self.questionLable.font = DEF_Font(16);
    self.questionLable.numberOfLines = 4;
    [self.questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:12];
    [self.questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
    [self.questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageBtn withOffset:9];
    [self.questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-49];
    
    //线
    UIImageView *lineImage = [[UIImageView alloc]initForAutoLayout];
    [bgView addSubview:lineImage];
    lineImage.backgroundColor = DEF_RGB_COLOR(242,241,244);
    [lineImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:12];
    [lineImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-12];
    [lineImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:12];
    [lineImage autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
    
    //左边的标签
    _left = [[HomeStagCustomView alloc]initForAutoLayout];
    [bgView addSubview:_left];
    [_left.stagLable autoPinEdge:ALEdgeLeft  toEdge:ALEdgeLeft ofView:_left withOffset:20];
    _left.stagLable.textAlignment = NSTextAlignmentLeft;
    [_left autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:9];
    [_left autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-12];
    if (DEF_SCREEN_WIDTH==320) {
        [_left autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lineImage withOffset:-8];
    }else{
        [_left autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lineImage withOffset:-5];
    }
    [_left autoSetDimension:ALDimensionWidth toSize:75];
    _left.stagLable.textColor = DEF_RGB_COLOR(142, 142, 147);
    _left.stagLable.font = DEF_Font(13.5);
    
    //右下角的出主意
    _rigth = [[HomeStagCustomView alloc]initForAutoLayout];
    [bgView addSubview:_rigth];
    _rigth.stagLable.textAlignment = NSTextAlignmentRight;
    [_rigth autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:9];
    [_rigth autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-12];
    [_rigth autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:lineImage withOffset:0];
    [_rigth autoSetDimension:ALDimensionWidth toSize:90];
    _rigth.stagLable.textColor = DEF_RGB_COLOR(73, 155, 227);
    _rigth.stagLable.font = DEF_Font(13.5);
    
}

-(void)loadCellWithDict:(NSDictionary *)dict
{
    //    头像
    [self.userImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"andy.jpg"]];
    //    名字
    self.name.text = [NSString stringWithFormat:@"%@问：",dict[@"name"]];
    //    时间
    self.dateLable.text = dict[@"created_at"];
    //   问题
    self.questionLable.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
    //    左下角的stag
    _left.stagLable.text = dict[@"category_name"];
    _left.stagImagePic.image = [UIImage imageNamed:@"ic_list_tag"];
    //    右下角的idear
    _rigth.stagImagePic.image = [UIImage imageNamed:@"ic_list_idea"];
    _rigth.stagLable.text = [NSString stringWithFormat:@"%@个主意",dict[@"ping_num"]];
    [_rigth.stagLable sizeToFit];
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    //主意 下方擅长分类30
    NSString *detailStr = dict[@"content"];
    float contentHeight =  [HZUtil getHeightWithString:detailStr fontSize:16 width:DEF_SCREEN_WIDTH-24];
    if (contentHeight > 80)
    {
        contentHeight = 80;
    }
    
    // 问题上方（8+12+34+9） 问题下方（12+9+16+12+1）1是线的高度
    float height = contentHeight+8+12+34+9+12+9+16+12+1;
    return height;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
