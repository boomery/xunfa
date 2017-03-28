//
//  QuestionCustomCell.m
//  MHProject
//
//  Created by 杜宾 on 15/6/17.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//

#import "QuestionCustomCell.h"
@implementation QuestionCustomCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self CreatCustomQuestionCell];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}
// 这里这样创建，以后数据了就把model传进来在里面操作
-(void)CreatCustomQuestionCell
{
    
    //律师头像
    self.userImageBtn = [[UIButton alloc]initForAutoLayout];
    [self addSubview:self.userImageBtn];
    [self.userImageBtn autoSetDimensionsToSize:CGSizeMake(35, 35)];
    [self.userImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10 ];
    [self.userImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10 ];
    self.userImageBtn.layer.cornerRadius = 17.5;
    self.userImageBtn.clipsToBounds = YES;
//    [self.userImageBtn setBackgroundImage:[UIImage imageNamed:@"boss"] forState:UIControlStateNormal];
    
    //
    self.name = [[UILabel alloc] initForAutoLayout];
    [self addSubview:self.name];
//    self.name.text = @"褚振亚律师";
    self.name.font = [UIFont systemFontOfSize:17];
    self.name.textColor = DEF_RGB_COLOR(142, 147, 147);
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:10 ];
    [self.name autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
    [self.name autoSetDimensionsToSize:CGSizeMake(100, 30)];
    
    self.questionLable = [[UILabel alloc] initForAutoLayout];
    [self addSubview:self.questionLable];
       self.questionLable.textColor = DEF_RGB_COLOR(100, 99, 105);
    self.questionLable.numberOfLines = 0;
    [self.questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.name withOffset:0];
    [self.questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
    [self.questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageBtn withOffset:5];
    [self.questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-30];
    
    self.dateLable = [[UILabel alloc]initForAutoLayout];
    [self addSubview:self.dateLable];
    self.dateLable.font = [UIFont systemFontOfSize:10];
    self.dateLable.textColor = DEF_RGB_COLOR(142, 142, 147);
//    self.dateLable.text = @"03-03 18:00";
    self.dateLable.textAlignment = 2;
    //    右边
    [self.dateLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.questionLable withOffset:0];
    //    上
    [self.dateLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.name withOffset:0];
    //    下
    //    size
    [self.dateLable autoSetDimensionsToSize:CGSizeMake(80, 30)];

    
    
    UIImageView *tagImagePic = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:tagImagePic];
    tagImagePic.image = [UIImage imageNamed:@"s-tag"];
    tagImagePic.contentMode = UIViewContentModeScaleAspectFit;
    //    左边
    [tagImagePic autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.name withOffset:0];
    //    上
    [tagImagePic autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset: 10];
    //    下
    [tagImagePic autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:- 10];
    //    size
    [tagImagePic autoSetDimension:ALDimensionWidth toSize:15];
    
    
    
    self.leftBottomLable = [[UILabel alloc]initForAutoLayout];
    [self addSubview:self.leftBottomLable];
    _leftBottomLable.font = [UIFont systemFontOfSize:10];
    _leftBottomLable.textColor = DEF_RGB_COLOR(0, 160, 233);
    _leftBottomLable.text = @"经济纠纷";
    //    左边
    [self.leftBottomLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:tagImagePic withOffset:0];
    //    上
    [self.leftBottomLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
    //    下
    [self.leftBottomLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
    //    size
    [self.leftBottomLable autoSetDimension:ALDimensionWidth toSize:60];
    
    
    
    self.rightBottomLable = [[UILabel alloc]initForAutoLayout];
    [self addSubview:self.rightBottomLable];
    self.rightBottomLable.font = [UIFont systemFontOfSize:10];
    _rightBottomLable.textColor = DEF_RGB_COLOR(178, 196, 205);
    self.rightBottomLable.text = @"20人出主意";
    //    右边
    [self.rightBottomLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.questionLable withOffset:0];
    //    上
    [self.rightBottomLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
    //    下
    [self.rightBottomLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
    //    size
    [self.rightBottomLable autoSetDimension:ALDimensionWidth toSize:80];
    //

    
    //
    UIImageView *sIdeaImagePic = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:sIdeaImagePic];
    sIdeaImagePic.image = [UIImage imageNamed:@"s-idea"];
    sIdeaImagePic.contentMode = UIViewContentModeScaleAspectFit;
    //    左边
    [sIdeaImagePic autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightBottomLable withOffset:0];
    //    上
    [sIdeaImagePic autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
    //    下
    [sIdeaImagePic autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
    //    size
    [sIdeaImagePic autoSetDimension:ALDimensionWidth toSize:15];
    
    
    self.adopt = [[UILabel alloc]initForAutoLayout];
    [self addSubview:self.adopt];
    self.adopt.backgroundColor = DEF_RGB_COLOR(255, 134, 0);
    self.adopt.font = DEF_Font(10);
    self.adopt.textColor = [UIColor whiteColor];
    [self.adopt autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:sIdeaImagePic withOffset:10];
    self.adopt.textAlignment = 1;
    self.adopt.layer.masksToBounds = YES;
    self.adopt.layer.cornerRadius = 2;
    //    上
    [self.adopt autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
    //    下
    [self.adopt autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
    //    size
    [self.adopt autoSetDimension:ALDimensionWidth toSize:50];
    
    
    
    
    
    UIImageView *lineImage = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:lineImage];
    lineImage.backgroundColor = DEF_RGB_COLOR(214, 214, 217);
    //    左边
    [lineImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    //    左边
    [lineImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
    //    下
    [lineImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-1];
    //    size
    [lineImage autoSetDimension:ALDimensionHeight toSize:1];
    
    
    if (DEF_SCREEN_IS_5s)
    {
        self.questionLable.font = DEF_Font(14);
        
        [self.rightBottomLable autoSetDimension:ALDimensionWidth toSize:60];
    }
    else if (DEF_SCREEN_IS_6)
    {
        self.questionLable.font = DEF_Font(16);
        self.name.font = DEF_Font(12);
        self.dateLable.font = DEF_Font(12);
        self.leftBottomLable.font = DEF_Font(12);
        [self.rightBottomLable autoSetDimension:ALDimensionWidth toSize:60];
    }
    else
    {
        self.questionLable.font = DEF_Font(18);
        self.name.font = DEF_Font(14);
        self.dateLable.font = DEF_Font(14);
        self.leftBottomLable.font = DEF_Font(14);
        self.rightBottomLable.font = DEF_Font(14);
    }
 }
-(void)loadCellWithDict:(NSDictionary *)dict
{
    self.questionLable.text = [NSString stringWithFormat:@"%@",dict[@"content"]];
    self.leftBottomLable.text = dict[@"category_name"];
    NSString *people = dict[@"ping_num"];
    NSString *str = @"人出主意";
    self.rightBottomLable.text = [NSString stringWithFormat:@"%@ %@",people,str];
    self.dateLable.text = dict[@"created_at"];
    self.name.text = dict[@"name"];
    [self.userImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"avatar"]] forState:UIControlStateNormal];
    if ([dict[@"selected_state"] isEqualToString:@"1"])
    {
        self.adopt.text = @"采纳回复";
    }
    else
    {
        self.adopt.hidden = YES;
    }
    
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    //主意 下方擅长分类30
    NSString *detailStr = dict[@"content"];
    
    if (DEF_SCREEN_IS_5s)
    {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-55, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        float height = ziTiSize.height+ 40 + 50;
        return height;
    }
    else if (DEF_SCREEN_IS_6)
    {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
        CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-20, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        float height = ziTiSize.height+ 40 + 50;
        return height;
    }
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
        CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-20, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        float height = ziTiSize.height+ 40 + 50;
        return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
