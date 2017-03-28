//
//  QuestionListCell.m
//  MHProject
//
//  Created by 张好志 on 15/7/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "QuestionListCell.h"
#import "HZUtil.h"
@implementation QuestionListCell
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
    self.name.textColor = DEF_RGB_COLOR(111, 111, 111);
    self.name.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.5];
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:13];
    [self.name autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageBtn withOffset:0];
    [self.name autoSetDimension:ALDimensionHeight toSize:34];
    
    //时间
    self.dateLable = [[UILabel alloc]initForAutoLayout];
    [bgView addSubview:self.dateLable];
    self.dateLable.font = [UIFont systemFontOfSize:13.5];
    self.dateLable.textColor = DEF_RGB_COLOR(159, 159, 159);
    self.dateLable.textAlignment = 2;
    [self.dateLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-12];
    [self.dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageBtn withOffset:7];
    [self.dateLable autoSetDimension:ALDimensionHeight toSize:20];
    [self.dateLable autoSetDimension:ALDimensionWidth toSize:100 relation:NSLayoutRelationLessThanOrEqual];
    
    [self.name autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.dateLable withOffset:-12];
    
    //问题
    self.questionLable = [[UILabel alloc] initForAutoLayout];
    [bgView addSubview:self.questionLable];
    self.questionLable.textColor = DEF_RGB_COLOR(52, 52, 52);
    self.questionLable.font = DEF_Font(16);
    self.questionLable.numberOfLines = 4;
    [self.questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:12];
    [self.questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
    [self.questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageBtn withOffset:9];
    [self.questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-49];
    
    //线
    UIImageView *lineImage = [[UIImageView alloc]initForAutoLayout];
    [bgView addSubview:lineImage];
    lineImage.backgroundColor = DEF_RGB_COLOR(244,244,244);
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
    _rigth.stagLable.textColor = DEF_RGB_COLOR(60, 153, 230);
    _rigth.stagLable.font = DEF_Font(13.5);
    
    //采纳回复
    self.adopt = [[UILabel alloc]initForAutoLayout];
    [bgView addSubview:self.adopt];
    [self.adopt autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_rigth];
    [self.adopt autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_rigth];
    [self.adopt autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_rigth];
    [self.adopt autoSetDimension:ALDimensionWidth toSize:60];
    self.adopt.textColor = DEF_RGB_COLOR(255, 84, 46);
    self.adopt.font = DEF_Font(13.5);
    
    //图片
    self.adoptImagePic = [[UIImageView alloc]initForAutoLayout];
    [bgView addSubview:self.adoptImagePic];
    [self.adoptImagePic autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_adopt];
    [self.adoptImagePic autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_rigth];
    [self.adoptImagePic autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_rigth];
    [self.adoptImagePic autoSetDimension:ALDimensionWidth toSize:16];
    self.adoptImagePic.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)loadCellWithDict:(NSDictionary *)dict
{
    //头像
    [self.userImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"admin"]];
    //名字
    self.name.text = [NSString stringWithFormat:@"%@问：",dict[@"name"]];
    //时间
    self.dateLable.text = dict[@"created_at"];
    //问题
    self.questionLable.text = [NSString stringWithFormat:@"%@",dict[@"content"]];

    //左下角的stag
    _left.stagLable.text = dict[@"category_name"];
    _left.stagImagePic.image = [UIImage imageNamed:@"ic_list_tag"];

    //右下角的idear
    _rigth.stagImagePic.image = [UIImage imageNamed:@"ic_idea"];
    _rigth.stagLable.text = [NSString stringWithFormat:@"%@个主意",dict[@"ping_num"]];
    [_rigth.stagLable sizeToFit];
    
    //
    self.adopt.hidden = NO;
    self.adoptImagePic.hidden = NO;
    if ([dict[@"selected_state"] isEqualToString:@"1"])//已采纳
    {
        self.adopt.text = @"已采纳";
        self.adoptImagePic.image = [UIImage imageNamed:@"ic_list_report"];
    }
    else if([dict[@"selected_state"] isEqualToString:@"2"])
    {
        self.adopt.text = @"已推荐";
        self.adoptImagePic.image = [UIImage imageNamed:@"ic_list_report"];
    }
    else
    {
        self.adopt.hidden = YES;
        self.adoptImagePic.hidden = YES;
    }
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







//-(void)initCell
//{
//    //    底部的背景图
//    self.bgView = [[UIView alloc]initForAutoLayout];
//    [self addSubview:self.bgView];
//    self.bgView.backgroundColor = [UIColor whiteColor];
//    [self.bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
//    [self.bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
//    [self.bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
//    [self.bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
//    
//    //律师头像
//    self.userImageBtn = [[UIButton alloc]initForAutoLayout];
//    [self.bgView addSubview:self.userImageBtn];
//    [self.userImageBtn autoSetDimensionsToSize:CGSizeMake(width(26.0), width(26.0))];
//    [self.userImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10 ];
//    [self.userImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bgView withOffset:10 ];
//    self.userImageBtn.layer.cornerRadius = width(13.0);
//    self.userImageBtn.clipsToBounds = YES;
//    
//    //提问者
//    self.name = [[UILabel alloc] initForAutoLayout];
//    [self.bgView addSubview:self.name];
//    self.name.text = @"山子问:";
//    self.name.font = [UIFont systemFontOfSize:17];
//    self.name.textColor = DEF_RGB_COLOR(142, 147, 147);
//    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:10 ];
//    [self.name autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bgView withOffset:13];
//    [self.name autoSetDimensionsToSize:CGSizeMake(width(200.0), height(20.0))];
//    
//    //    日期
//    self.dateLable = [[UILabel alloc]initForAutoLayout];
//    [self.bgView addSubview:self.dateLable];
//    self.dateLable.font = [UIFont systemFontOfSize:13];
//    self.dateLable.textColor = DEF_RGB_COLOR(111, 111, 111);
//    //    self.dateLable.text = @"03-03 18:00";
//    self.dateLable.textAlignment = 2;
//    [self.dateLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.bgView withOffset:-10];
//    [self.dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.bgView withOffset:13];
//    [self.dateLable autoSetDimensionsToSize:CGSizeMake(width(80.0), height(20.0))];
//    
//    //问题
//    self.questionLable = [[UILabel alloc] initForAutoLayout];
//    [self addSubview:self.questionLable];
//    self.questionLable.textColor = DEF_RGB_COLOR(100, 99, 105);
//    self.questionLable.numberOfLines = 4;
//    self.questionLable.font = [UIFont systemFontOfSize:16];
//    [self.questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userImageBtn withOffset:0];
//    [self.questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.bgView withOffset:-10];
//    [self.questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageBtn withOffset:5];
//    [self.questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgView withOffset:-40];
////    self.questionLable.backgroundColor = [UIColor redColor];
//    
//    //
//    UIImageView *tagImagePic = [[UIImageView alloc]initForAutoLayout];
//    [self.bgView addSubview:tagImagePic];
//    tagImagePic.image = [UIImage imageNamed:@"s-tag"];
//    tagImagePic.contentMode = UIViewContentModeScaleAspectFit;
//    [tagImagePic autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.userImageBtn withOffset:0];
//    [tagImagePic autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset: 10];
//    [tagImagePic autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgView withOffset:- 12];
//    [tagImagePic autoSetDimension:ALDimensionWidth toSize:width(14.0)];
//    
//    //
//    self.leftBottomLable = [[UILabel alloc]initForAutoLayout];
//    [self.bgView addSubview:self.leftBottomLable];
//    _leftBottomLable.font = [UIFont systemFontOfSize:13];
//    _leftBottomLable.textColor = DEF_RGB_COLOR(0, 160, 233);
//    _leftBottomLable.text = @"经济纠纷";
//    [self.leftBottomLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tagImagePic withOffset:0];
//    [self.leftBottomLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:5];
//    [self.leftBottomLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.bgView withOffset:-10];
//    [self.leftBottomLable autoSetDimension:ALDimensionWidth toSize:width(60.0)];
////    self.leftBottomLable.backgroundColor = [UIColor redColor];
//    
//    //
//    self.rightBottomLable = [[UILabel alloc]initForAutoLayout];
//    [self.bgView addSubview:self.rightBottomLable];
//    self.rightBottomLable.font = [UIFont systemFontOfSize:13];
//    _rightBottomLable.textColor = DEF_RGB_COLOR(178, 196, 205);
//    self.rightBottomLable.textAlignment = 1;
//    [self.rightBottomLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
//    [self.rightBottomLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
//    [self.rightBottomLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
//    [self.rightBottomLable autoSetDimension:ALDimensionWidth toSize:width(200.0) relation:NSLayoutRelationLessThanOrEqual];
//    
//    //
//    UIImageView *sIdeaImagePic = [[UIImageView alloc]initForAutoLayout];
//    [self.bgView addSubview:sIdeaImagePic];
//    sIdeaImagePic.image = [UIImage imageNamed:@"s-idea"];
//    sIdeaImagePic.contentMode = UIViewContentModeScaleAspectFit;
//    [sIdeaImagePic autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightBottomLable withOffset:0];
//    [sIdeaImagePic autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:12];
//    [sIdeaImagePic autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-12];
//    [sIdeaImagePic autoSetDimension:ALDimensionWidth toSize:width(15.0)];
//    
//}
//-(void)loadCellWithDict:(NSDictionary *)dict
//{
//    
//    self.questionLable.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
//    self.leftBottomLable.text = dict[@"category_name"];
//    self.rightBottomLable.text = [NSString stringWithFormat:@"%@%@",dict[@"ping_num"],@"个主意"];
//    self.dateLable.text = dict[@"created_at"];
//    self.name.text = [NSString stringWithFormat:@"%@问：",dict[@"name"]];
//    [self.userImageBtn  sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"admin"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image)
//        {
//            NSLog(@"有图片");
//        }
//        else
//        {
//            NSLog(@"无图片");
//        }
//    }];
//}
//+(float)heightForCellWithDict:(NSDictionary *)dict
//{
//    NSString *detailStr = dict[@"content"];
//    float contentHeight =  [HZUtil getHeightWithString:detailStr fontSize:16 width:DEF_SCREEN_WIDTH-20];
//    if (contentHeight > 76)
//    {
//        contentHeight = 76;
//    }
//    float height = contentHeight + width(40.0)+60;
//    return height;
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
