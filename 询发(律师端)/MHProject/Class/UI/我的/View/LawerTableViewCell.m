//
//  LawerTableViewCell.m
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "LawerTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation LawerTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        float fontSize;
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            fontSize = 14.0;
        }
        else
        {
            fontSize = 16.0;
        }
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = DEF_RGB_COLOR(205, 204, 208).CGColor;
        
        //律师头像
        self.lawerHeadImageBtn = [[UIButton alloc]initForAutoLayout];
        [self addSubview:self.lawerHeadImageBtn];
        [self.lawerHeadImageBtn autoSetDimensionsToSize:CGSizeMake(width(35.0), width(35.0))];
        [self.lawerHeadImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10 ];
        [self.lawerHeadImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10 ];
        self.lawerHeadImageBtn.layer.cornerRadius = width(17.5);
        self.lawerHeadImageBtn.clipsToBounds = YES;
        [self.lawerHeadImageBtn setBackgroundImage:[UIImage imageNamed:@"boss"] forState:UIControlStateNormal];
        
        //律师名字
        self.lawerNameLB = [[UILabel alloc] initForAutoLayout];
        [self addSubview:self.lawerNameLB];
        //        self.lawerNameLB.text = @"褚振亚律师";
        self.lawerNameLB.font = [UIFont systemFontOfSize:fontSize];
        self.lawerNameLB.textColor = DEF_RGB_COLOR(142, 147, 147);
        [self.lawerNameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lawerHeadImageBtn withOffset:10 ];
        [self.lawerNameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [self.lawerNameLB autoSetDimensionsToSize:CGSizeMake(100, height(30.0))];
        
        
        // 年限
        self.laweryearLB = [[UILabel alloc] initForAutoLayout];
        [self addSubview:self.laweryearLB];
        self.laweryearLB.font = [UIFont systemFontOfSize:fontSize];
        self.laweryearLB.textColor = DEF_RGB_COLOR(142, 147, 147);
        [self.laweryearLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [self.laweryearLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
        [self.laweryearLB autoSetDimensionsToSize:CGSizeMake(width(30.0), height(30.0))];
        
        
        // 等级
        self.lawergradeLB = [[UILabel alloc] initForAutoLayout];
        [self addSubview:self.lawergradeLB];
        self.lawergradeLB.textAlignment = 1;
        self.lawergradeLB.font = [UIFont systemFontOfSize:fontSize];
        self.lawergradeLB.textColor = DEF_RGB_COLOR(142, 147, 147);
        [self.lawergradeLB autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.laweryearLB withOffset:-10 ];
        [self.lawergradeLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lawerNameLB withOffset:0];
        [self.lawergradeLB autoSetDimensionsToSize:CGSizeMake(width(30.0), height(30.0))];
        
        
        // 问题
        self.lawerIntroductionLB = [[UILabel alloc] initForAutoLayout];
        [self addSubview:self.lawerIntroductionLB];
        self.lawerIntroductionLB.text = @"5年";
        self.lawerIntroductionLB.font = [UIFont systemFontOfSize:fontSize];
        self.lawerIntroductionLB.textColor = DEF_RGB_COLOR(100, 99, 105);
        self.lawerIntroductionLB.numberOfLines = 0;
        [self.lawerIntroductionLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10 ];
        [self.lawerIntroductionLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10 ];
        [self.lawerIntroductionLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lawerHeadImageBtn withOffset:5];
        [self.lawerIntroductionLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-height(25.0)];
        
        
        //擅长分类
        self.lawershanchangSortLB = [[UILabel alloc] initForAutoLayout];
        [self addSubview:self.lawershanchangSortLB];
        //        self.lawershanchangSortLB.text = @"擅长分类：经济纠纷";
        self.lawershanchangSortLB.font = [UIFont systemFontOfSize:fontSize];
        self.lawershanchangSortLB.textColor = DEF_RGB_COLOR(142, 142, 147);
        [self.lawershanchangSortLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10 ];
        [self.lawershanchangSortLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lawerIntroductionLB withOffset:0];
        [self.lawershanchangSortLB autoSetDimensionsToSize:CGSizeMake(width(70.0), height(20.0))];
        self.lawershanchangSortLB.textAlignment = 1;
        
        UILabel *lab = [[UILabel alloc] initForAutoLayout];
        [self addSubview:lab];
        lab.font = [UIFont systemFontOfSize:fontSize];
        lab.textColor = DEF_RGB_COLOR(142, 142, 147);
        [lab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lawershanchangSortLB withOffset:0];
        [lab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lawerIntroductionLB withOffset:0];
        [lab autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.lawerIntroductionLB withOffset:0];
        [lab autoSetDimension:ALDimensionHeight toSize:height(20.0)];
        self.areaLabel = lab;
    }
    return self;
}
-(void)loadCellWithDict:(NSMutableDictionary *)dict
{
    float fontSize;
    if (DEF_SCREEN_WIDTH == 320.0)
    {
        fontSize = 14.0;
    }
    else
    {
        fontSize = 16.0;
    }
    
    [self.lawerHeadImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"admin"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            DEF_DEBUG(@"有图片");
        }
    }];
    self.lawerNameLB.text = dict[@"name"];
    self.lawergradeLB.text = [NSString stringWithFormat:@"LV%@",dict[@"lv"]];
    self.laweryearLB.text = [NSString stringWithFormat:@"%@年",dict[@"year"]];
    
    self.lawerIntroductionLB.text = dict[@"introduce"];
    
    self.lawershanchangSortLB.text = @"擅长分类：";
    NSArray *tagArr = dict[@"category_name"];
    
    //
    NSMutableString *shanchangStr = [[NSMutableString alloc]init];
    for (int i=0; i<tagArr.count; i++)
    {
        NSDictionary *dict = tagArr[i];
        NSArray *nameArray = [dict allValues];
        NSString *nameStr = nameArray[0];
        
        if (i!=0) {
            nameStr = [NSString stringWithFormat:@",%@",nameStr];
        }
        [shanchangStr appendString:nameStr];
    }
    
  
    self.areaLabel.text =shanchangStr;
    
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    //主意：上方头像45 下方擅长分类30
    
    float fontSize;
    if (DEF_SCREEN_WIDTH == 320.0)
    {
        fontSize = 14.0;
    }
    else
    {
        fontSize = 16.0;
    }
    NSString *detailStr = dict[@"introduce"];
    //     NSString *detailStr = [NSString stringWithFormat:@"%@思考出门了可是每次看没人来看vknvjrmlkcslkmcmvsrklmvskldmvrmcslmdlkcm啥都没出两块是男人女少女",dict[@"introduce"]];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-20, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    float height =ziTiSize.height+width(35.0)+15+height(30.0);
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
//        //lawerPhoneBtn;       //打电话按
//        self.lawerPhoneBtn = [[UIButton alloc]initForAutoLayout];
//        [bgView addSubview:self.lawerPhoneBtn];
//        [self.lawerPhoneBtn autoSetDimensionsToSize:CGSizeMake(width(40.0), width(40.0))];
//        [self.lawerPhoneBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10 ];
//        [self.lawerPhoneBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lawerHeadImageBtn withOffset:0];
//        self.lawerPhoneBtn.layer.cornerRadius = width(20.0);
//        self.lawerPhoneBtn.clipsToBounds = YES;
//        [self.lawerPhoneBtn setBackgroundImage:[UIImage imageNamed:@"phone-gray"] forState:UIControlStateNormal];
//        [self.lawerPhoneBtn setBackgroundImage:[UIImage imageNamed:@"phone-green"] forState:UIControlStateSelected];
//        self.lawerPhoneBtn.selected = NO;


//              //
//        self.bottomLineLB = [[UILabel alloc] initForAutoLayout];
//        [self addSubview:self.bottomLineLB];
//        [self.bottomLineLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:6 ];
//        [self.bottomLineLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-6 ];
//        [self.bottomLineLB autoSetDimensionsToSize:CGSizeMake(selfCellWidth-12, 1)];
//        [self.bottomLineLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-0.5];
//        self.bottomLineLB.backgroundColor = DEF_RGB_COLOR(214, 214, 217);
