//
//  HomeOpenCell.m
//  MHProject
//
//  Created by 杜宾 on 15/7/3.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HomeOpenCell.h"
#import "UIButton+AFNetworking.h"
#import "HZUtil.h"
#import "HomeStagCustomView.h"
@implementation HomeOpenCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initCell];
    }
    return self;
}
-(void)initCell
{
    //  底部的背景视图
    UIView *bgView = [[UIView alloc]initForAutoLayout];
    [self addSubview:bgView];
    [bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:8];
    [bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
    [bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    bgView.layer.borderWidth = DEF_SCREEN_WIDTH==320 ? 1/2.0 :1.0/3.0;
    bgView.layer.borderColor = DEF_RGB_COLOR(228, 228, 228).CGColor;
    bgView.backgroundColor = [UIColor whiteColor];

    
    //律师头像
    self.userImageBtn = [[UIButton alloc]initForAutoLayout];
    [bgView addSubview:self.userImageBtn];
    [self.userImageBtn autoSetDimensionsToSize:CGSizeMake(34, 34)];
    [self.userImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:12];
    [self.userImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView withOffset:12];
    self.userImageBtn.layer.cornerRadius = 17;
    self.userImageBtn.clipsToBounds = YES;
    
    //提问者
    self.name = [[UILabel alloc] initForAutoLayout];
    [bgView addSubview:self.name];
    self.name.text = @"山子问:";
    self.name.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.5];
    self.name.textColor = DEF_RGB_COLOR(111, 111, 111);
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:10 ];
    [self.name autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageBtn withOffset:0];
    [self.name autoSetDimension:ALDimensionHeight toSize:34];
    
    //抢答按钮
    self.rushImageView = [[UIImageView alloc]initForAutoLayout];
    self.rushImageView.image = [UIImage imageNamed:@"ic_right_rob"];
    [bgView addSubview:self.rushImageView];
    [self.rushImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
    [self.rushImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView withOffset:16];
    [self.rushImageView autoSetDimensionsToSize:CGSizeMake(57, 24)];
    self.rushImageView.layer.cornerRadius = 5;
    self.rushImageView.clipsToBounds = YES;
    self.rushImageView.userInteractionEnabled = YES;

    [self.name autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rushImageView  withOffset:-12];
    
    //    问题
    self.questionLable = [[UILabel alloc] initForAutoLayout];
    [bgView addSubview:self.questionLable];
    self.questionLable.font = DEF_Font(16);
    self.questionLable.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.questionLable.numberOfLines = 4;
    [self.questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userImageBtn withOffset:0];
    [self.questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
    [self.questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageBtn withOffset:8];
    [self.questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-49];
    
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
    [_left autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:9];
    [_left autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-12];
    _left.stagImagePic.image = [UIImage imageNamed:@"ic_list_tag"];
    if (DEF_SCREEN_WIDTH==320) {
        [_left autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lineImage withOffset:-8];
    }else{
        [_left autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:lineImage withOffset:-5];
    }
    [_left autoSetDimension:ALDimensionWidth toSize:75];
    _left.stagLable.textColor = DEF_RGB_COLOR(159, 159, 159);
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
    [self.dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:8];
    [self.dateLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-12];
    [self.dateLable autoSetDimension:ALDimensionWidth toSize:100];
    //    下
    //    size
}
-(void)loadCellWithDict:(NSDictionary *)dict
{
    self.questionLable.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
    _left.stagLable.text = dict[@"category_name"];
    self.dateLable.text = dict[@"created_at"];
    self.name.text = [NSString stringWithFormat:@"%@问：",dict[@"name"]];
    [self.userImageBtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:dict[@"avatar"]] placeholderImage:[UIImage imageNamed:@"admin.png"]];
}

+(float)heightForCellWithDict:(NSDictionary *)dict
{
    NSString *detailStr = dict[@"content"];
    float contentHeight =  [HZUtil getHeightWithString:detailStr fontSize:16 width:DEF_SCREEN_WIDTH-20];
    if (contentHeight > 76)
    {
        contentHeight = 76;
    }
    float height = contentHeight +10+ 12+34+8+49;
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
