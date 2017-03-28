//
//  QuestionDetailCell.m
//  MHProject
//
//  Created by 杜宾 on 15/6/17.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//
#import "QuestionDetailCell.h"
#import "UIButton+WebCache.h"
#import "MCFireworksButton.h"

@implementation QuestionDetailCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self CreatCustomQuestionCell];
    }
    return self;
}
// 这里这样创建，以后数据了就把model传进来在里面操作
-(void)CreatCustomQuestionCell
{
    //线
    UIImageView *topImage = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:topImage];
    topImage.backgroundColor = DEF_RGB_COLOR(228,228,228);
    [topImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [topImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
    [topImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:0];
    [topImage autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
    self.topImageLine = topImage;
    self.topImageLine.hidden = YES;
    
    //律师头像
    self.userImageBtn = [[LawerHearImageBtn alloc]initForAutoLayout];
    [self addSubview:self.userImageBtn];
    [self.userImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10];
    [self.userImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
    [self.userImageBtn autoSetDimensionsToSize:CGSizeMake(34, 34)];
    self.userImageBtn.layer.masksToBounds = YES;
    self.userImageBtn.layer.cornerRadius = 17;
    self.userImageBtn.clipsToBounds = YES;
    
    //名字
    self.name = [[UILabel alloc] initForAutoLayout];
    [self addSubview:self.name];
    self.name.textColor = DEF_RGB_COLOR(111, 111, 111);
    self.name.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.5];
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userImageBtn withOffset:13];
    [self.name autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.userImageBtn withOffset:0];
    [self.name autoSetDimension:ALDimensionHeight toSize:34];
    [self.name autoSetDimension:ALDimensionWidth toSize:TRANSFORM_WIDTH(106/3*2) relation:NSLayoutRelationGreaterThanOrEqual];
//    self.name.backgroundColor = [UIColor orangeColor];
    
    ////    律师等级
    self.gradeLab = [[UILabel alloc]initForAutoLayout];
    [self addSubview:self.gradeLab];
    self.gradeLab.font = [UIFont systemFontOfSize:12];
    self.gradeLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    [self.gradeLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.name withOffset:0 ];
    [self.gradeLab autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.name withOffset:7];
    [self.gradeLab autoSetDimensionsToSize:CGSizeMake(TRANSFORM_WIDTH(82/3*2), 20)];
    self.gradeLab.textAlignment = 1;
//    self.gradeLab.backgroundColor = [UIColor redColor];
    
    ///    律师年限
    self.yearLab = [[UILabel alloc]initForAutoLayout];
    [self addSubview:self.yearLab];
    self.yearLab.font = [UIFont systemFontOfSize:12];
    self.yearLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    [self.yearLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.gradeLab withOffset:0];
    [self.yearLab autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.gradeLab withOffset:0];
    [self.yearLab autoSetDimensionsToSize:CGSizeMake(TRANSFORM_WIDTH(42/3*2), 20)];
    self.yearLab
    .textAlignment = 1;

    
    //律师地点
    self.addressLab = [[UILabel alloc]initForAutoLayout];
    [self addSubview:self.addressLab];
    self.addressLab.font = [UIFont systemFontOfSize:12];
    self.addressLab.textColor = DEF_RGB_COLOR(111, 111, 111);
    self.addressLab.textAlignment = NSTextAlignmentCenter;
    [self.addressLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.yearLab withOffset:10];
    [self.addressLab autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.gradeLab withOffset:0];
    [self.addressLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.gradeLab withOffset:0];
    [self.addressLab autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
//    self.addressLab.backgroundColor = [UIColor redColor];
    
    //问题
    self.questionLable = [[UILabel alloc] initForAutoLayout];
    [self addSubview:self.questionLable];
    self.questionLable.textColor = DEF_RGB_COLOR(61, 61, 71);
    self.questionLable.font = DEF_Font(16);
    self.questionLable.numberOfLines = 0;
    [self.questionLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10];
    [self.questionLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
    [self.questionLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userImageBtn withOffset:9];
    [self.questionLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-47];
    
    //线
    UIImageView *lineImage = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:lineImage];
    lineImage.backgroundColor = DEF_RGB_COLOR(242,241,244);
    [lineImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10];
    [lineImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
    [lineImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.questionLable withOffset:10];
    [lineImage autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
    
    //    采纳回复
    self.adoptImagePic = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:self.adoptImagePic];
    self.adoptImagePic.contentMode = UIViewContentModeScaleAspectFit;
    [self.adoptImagePic autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:20];
    [self.adoptImagePic autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-23];
    [self.adoptImagePic autoSetDimensionsToSize:CGSizeMake(60, 60)];
    
    
    //点赞的按钮
    _praiseBtn= [[MCFireworksButton alloc]initForAutoLayout];
    [self addSubview:_praiseBtn];
    [_praiseBtn setImage:[UIImage imageNamed:@"ic_laud"] forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage imageNamed:@"ic_laud_o"] forState:UIControlStateSelected];
    _praiseBtn.selected = NO;
    self.praiseBtn.particleImage = [UIImage imageNamed:@"Sparkle"];
    self.praiseBtn.particleScale = 0.05;
    self.praiseBtn.particleScaleRange = 0.02;
    _praiseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.praiseBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.questionLable withOffset:0];
    [self.praiseBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:0];
    [self.praiseBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
    [self.praiseBtn autoSetDimension:ALDimensionWidth toSize:30];
    
    //点赞的数量
    _praiseCount = [[UILabel alloc]initForAutoLayout];
    _praiseCount.textColor = DEF_RGB_COLOR(159, 159, 159);
    _praiseCount.text = @"2";
    self.praiseCount.font = [UIFont fontWithName:@"Helvetica" size:13.5];
    [self addSubview:_praiseCount];
    [self.praiseCount autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.praiseBtn withOffset:0];
    [self.praiseCount autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.praiseBtn withOffset:0];
    [self.praiseCount autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.praiseBtn withOffset:0];
    [self.praiseCount autoSetDimension:ALDimensionWidth toSize:25];
    
    //时间
    self.timeLable = [[UILabel alloc]initForAutoLayout];
    [self addSubview:self.timeLable];
    self.timeLable.font = [UIFont systemFontOfSize:12];
    self.timeLable.textColor = DEF_RGB_COLOR(142, 142, 147);
    self.timeLable.textAlignment = 2;
    [self.timeLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
    [self.timeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.praiseCount withOffset:0];
    [self.timeLable autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.praiseBtn withOffset:0];
    [self.timeLable autoSetDimension:ALDimensionWidth toSize:100];
    
    //下方短线
    UIImageView *bottomlineImage = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:bottomlineImage];
    bottomlineImage.backgroundColor = DEF_RGB_COLOR(214, 214, 217);
    [bottomlineImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10];
    [bottomlineImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
    [bottomlineImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:LINE_HEIGHT];
    [bottomlineImage autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
    self.bottomShortLineImage = bottomlineImage;

    //线
    _cellLastLine = [[UIImageView alloc]initForAutoLayout];
    [self addSubview:_cellLastLine];
    _cellLastLine.backgroundColor = DEF_RGB_COLOR(228, 228, 228);
    [_cellLastLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
    [_cellLastLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-0];
    [_cellLastLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:LINE_HEIGHT];
    [_cellLastLine autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];

}
-(void)loadCellWithDict:(NSDictionary *)diction WithHeadName:(NSString *)headName
{
    
    self.addressLab.text = diction[@"city"];
    //用户头像
    [self.userImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:diction[@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"admin"]];
    self.praiseBtn.enabled = YES;
    
    //用户名字 判断是不是用户自己评论的 如果是自己评论的不能给自己点赞
    NSString *userType = diction[@"user_type"];
    //只用户的评论
    if ([userType isEqualToString:@"1"])
    {
        NSString *loginUid = @"";
        NSString *commentUid = @"l";
        if ([loginUid isEqualToString:commentUid])
        {
            self.praiseBtn.enabled = NO;
        }
    }
    
    //显示出提问者
    if ([diction[@"name"] isEqualToString:headName])
    {
        self.name.text = [NSString stringWithFormat:@"%@(提问者)",headName];
    }
    else
    {
        self.name.text = diction[@"name"];
    }
    
    self.questionLable.text = [NSString stringWithFormat:@"%@",diction[@"content"]];
    
    //点赞的数量
    self.praiseCount.text = diction[@"like_num"];
    
    //该用户是否已经点赞的界面处理，点过赞显示红色，没有点赞显示灰色
    NSString *is_like = diction[@"is_like"];
    if ([is_like isEqualToString:@"0"]) {
        _praiseBtn.selected = NO;
        self.praiseCount.textColor = DEF_RGB_COLOR(142, 142, 147);
    }else if ([is_like isEqualToString:@"1"]){
        _praiseBtn.selected = YES;
        self.praiseCount.textColor = DEF_RGB_COLOR(255, 85, 47);
    }
    
    // 时间
    self.timeLable.text = diction[@"created_at"];
    NSString *selected_state = diction[@"selected_state"];
    
    //如果存在则是律师回复的，不然则是用户评论的
    if (selected_state)
    {
        self.gradeLab.hidden = NO;
        self.yearLab.hidden = NO;
        self.adoptImagePic.hidden = NO;
        self.addressLab.hidden = NO;
        self.gradeLab.text = [NSString stringWithFormat:@"%@ %@",@"LV",diction[@"lv"]];
        self.yearLab.text = [NSString stringWithFormat:@"%@"@"年",diction[@"year"]];
        if (![NSString isBlankString:diction[@"city"]])
        {
            self.addressLab.text = diction[@"city"];
        }
        if ([selected_state isEqualToString:@"1"])
        {
            //是1 用户采纳
            self.adoptImagePic.image = [UIImage imageNamed:@"caina"];
        }
        else if ([selected_state isEqualToString:@"2"])
        {
            //是2 平台采纳
            self.adoptImagePic.image = [UIImage imageNamed:@"tuijian"];
        }
        else if ([selected_state isEqualToString:@"0"])
        {
            self.adoptImagePic.image = nil;
        }
    }
    else
    {
        self.gradeLab.hidden = YES;
        self.yearLab.hidden = YES;
        self.adoptImagePic.hidden = YES;
        self.addressLab.hidden = YES;
    }
}
+ (float)heightForCellWithDict:(NSDictionary *)diction;
{
    //主意 下方擅长分类30
    NSString *detailStr = diction[@"content"];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-20, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    float height = ziTiSize.height+10+10+34+47;
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
