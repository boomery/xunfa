//
//  MyCollectionLawyerNewCell.m
//  MHProject
//
//  Created by 杜宾 on 15/7/28.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyCollectionLawyerNewCell.h"

@implementation MyCollectionLawyerNewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //  底部的背景视图
        UIView *bgView = [[UIView alloc]initForAutoLayout];
        [self addSubview:bgView];
        [bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
        [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
        [bgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:0];
        bgView.layer.borderWidth = LINE_HEIGHT;
        bgView.layer.borderColor = DEF_RGB_COLOR(214, 214, 217).CGColor;
        bgView.backgroundColor = [UIColor whiteColor];
        _bgView = bgView;
        
        
        //律师头像
        self.lawerHeadImageBtn = [[UIButton alloc]initForAutoLayout];
        [bgView addSubview:self.lawerHeadImageBtn];
        [self.lawerHeadImageBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:10 ];
        [self.lawerHeadImageBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView withOffset:10];
        [self.lawerHeadImageBtn autoSetDimensionsToSize:CGSizeMake(34, 34)];
        self.lawerHeadImageBtn.layer.masksToBounds = YES;
        self.lawerHeadImageBtn.layer.cornerRadius = 17;
        self.lawerHeadImageBtn.clipsToBounds = YES;
        
        
        
        
        //名字
        self.lawerNameLB = [[UILabel alloc] initForAutoLayout];
        [bgView addSubview:self.lawerNameLB];
        self.lawerNameLB.textColor = DEF_RGB_COLOR(111, 111, 111);
        self.lawerNameLB.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.5];
        [self.lawerNameLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lawerHeadImageBtn withOffset:13];
        [self.lawerNameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lawerHeadImageBtn withOffset:0];
        [self.lawerNameLB autoSetDimensionsToSize:CGSizeMake(100, 13)];
        
        UILabel *lawyerAddress = [[UILabel alloc]initForAutoLayout];
        [bgView addSubview:lawyerAddress];
        [lawyerAddress autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lawerNameLB withOffset:8];
        [lawyerAddress autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.lawerHeadImageBtn withOffset:0];
        [lawyerAddress autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.lawerNameLB withOffset:0];
        [lawyerAddress autoSetDimension:ALDimensionWidth toSize:DEF_SCREEN_WIDTH/2];
        lawyerAddress.text = @"上海江三角律师事务所";
        lawyerAddress.font = DEF_Font(13.5);
        lawyerAddress.textColor = DEF_RGB_COLOR(111, 111, 111);
        _lvSuoLab = lawyerAddress;

     
        UILabel *lawyerCity = [[UILabel alloc]initForAutoLayout];
        [bgView addSubview:lawyerCity];
        [lawyerCity autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lawerNameLB withOffset:0];
        [lawyerCity autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-10];
        [lawyerCity autoSetDimensionsToSize:CGSizeMake(100, 13)];
        lawyerCity.text = @"上海";
        lawyerCity.font = DEF_Font(13.5);
        lawyerCity.textColor = DEF_RGB_COLOR(159, 159, 159);
        lawyerCity.textAlignment = 2;
        _cityLan = lawyerCity;

        
        UILabel *hehuoLable = [[UILabel alloc]initForAutoLayout];
        [bgView addSubview:hehuoLable];
        [hehuoLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:lawyerAddress withOffset:0];
        [hehuoLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-10];
        [hehuoLable autoSetDimensionsToSize:CGSizeMake(100, 13)];
        hehuoLable.text = @"高级合伙人";
        hehuoLable.font = DEF_Font(13.5);
        hehuoLable.textColor = DEF_RGB_COLOR(159, 159, 159);
        hehuoLable.textAlignment = 2;
        _heHuoLab = hehuoLable;
        
        //线
        UIImageView *lineImage = [[UIImageView alloc]initForAutoLayout];
        [bgView addSubview:lineImage];
        lineImage.backgroundColor = DEF_RGB_COLOR(242,241,244);
        [lineImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:10];
        [lineImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-10];
        [lineImage autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lawerHeadImageBtn withOffset:8];
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            [lineImage autoSetDimension:ALDimensionHeight toSize:1];
        }
        else{
            [lineImage autoSetDimension:ALDimensionHeight toSize:LINE_HEIGHT];
        }
        
        
        
        //
        self.lawershanchangSortLB = [[UILabel alloc] initForAutoLayout];
        [bgView addSubview:self.lawershanchangSortLB];
        
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            self.lawershanchangSortLB.font = [UIFont systemFontOfSize:11];

        }
        else{
            self.lawershanchangSortLB.font = [UIFont systemFontOfSize:13.5];        }
        self.lawershanchangSortLB.textColor = DEF_RGB_COLOR(142, 142, 147);
        [self.lawershanchangSortLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:10 ];
        [self.lawershanchangSortLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineImage withOffset:10];
        [self.lawershanchangSortLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-10];
        self.lawershanchangSortLB.textAlignment = 1;
        
        
        float width;
        if (DEF_SCREEN_WIDTH == 320.0)
        {
             width = 46;

        }
        else{
             width = 56;

        }
        
        _shanLabOne = [[UILabel alloc]initForAutoLayout];
        [bgView addSubview:_shanLabOne];
        [_shanLabOne autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lawershanchangSortLB withOffset:0];
        [_shanLabOne autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lawershanchangSortLB withOffset:0];
        [_shanLabOne autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.lawershanchangSortLB withOffset:0];
        [_shanLabOne autoSetDimension:ALDimensionWidth toSize:width];
         _shanLabOne.textColor = DEF_RGB_COLOR(61, 61, 71);
        if (DEF_SCREEN_WIDTH == 320.0)
        {
           _shanLabOne.font = DEF_Font(10);
        }
        else{
            _shanLabOne.font = DEF_Font(12);

        }
         _shanLabOne.backgroundColor = DEF_RGB_COLOR(242, 241, 244);
         _shanLabOne.textAlignment = 1;
         _shanLabOne.layer.masksToBounds = YES;
         _shanLabOne.layer.cornerRadius = 3;


        
        
        _shanLabTwo = [[UILabel alloc]initForAutoLayout];
        [bgView addSubview:_shanLabTwo];
        [_shanLabTwo autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lawershanchangSortLB withOffset:width+8];
        [_shanLabTwo autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lawershanchangSortLB withOffset:0];
        [_shanLabTwo autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.lawershanchangSortLB withOffset:0];
        [_shanLabTwo autoSetDimension:ALDimensionWidth toSize:width];
        _shanLabTwo.textColor = DEF_RGB_COLOR(61, 61, 71);
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            _shanLabTwo.font = DEF_Font(10);
        }
        else{
            _shanLabTwo.font = DEF_Font(12);
            
        }

        _shanLabTwo.backgroundColor = DEF_RGB_COLOR(242, 241, 244);
        _shanLabTwo.textAlignment = 1;
        _shanLabTwo.layer.masksToBounds = YES;
        _shanLabTwo.layer.cornerRadius = 3;

        
        
        _shanLabThree = [[UILabel alloc]initForAutoLayout];
        [bgView addSubview:_shanLabThree];
        [_shanLabThree autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lawershanchangSortLB withOffset:width+8+width+8];
        [_shanLabThree autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lawershanchangSortLB withOffset:0];
        [_shanLabThree autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.lawershanchangSortLB withOffset:0];
        [_shanLabThree autoSetDimension:ALDimensionWidth toSize:width];
        _shanLabThree.textColor = DEF_RGB_COLOR(61, 61, 71);
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            _shanLabThree.font = DEF_Font(10);
        }
        else{
            _shanLabThree.font = DEF_Font(12);
            
        }

        _shanLabThree.backgroundColor = DEF_RGB_COLOR(242, 241, 244);
        _shanLabThree.textAlignment = 1;
        _shanLabThree.layer.masksToBounds = YES;
        _shanLabThree.layer.cornerRadius = 3;

        
        
       self.laweryearLB = [[UILabel alloc]initForAutoLayout];
       [bgView addSubview:self.laweryearLB];
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            self.laweryearLB.font = [UIFont systemFontOfSize:10];
        }
        else{
            self.laweryearLB.font = [UIFont systemFontOfSize:12];
        }
       self.laweryearLB.textColor = DEF_RGB_COLOR(60, 153, 230);
        self.laweryearLB.backgroundColor = [UIColor whiteColor];
        self.laweryearLB.layer.borderWidth = LINE_HEIGHT;
        self.laweryearLB.layer.borderColor = DEF_RGB_COLOR(228, 228, 228).CGColor;
        self.laweryearLB.textAlignment = 1;
        self.laweryearLB.layer.masksToBounds = YES;
        self.laweryearLB.layer.cornerRadius = 3;
       [self.laweryearLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:lineImage withOffset:0];
       [self.laweryearLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lawershanchangSortLB withOffset:0];
        [self.laweryearLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.lawershanchangSortLB withOffset:0];
       [self.laweryearLB autoSetDimensionsToSize:CGSizeMake(32, 20)];




        
        
        ////    律师等级
        self.lawergradeLB = [[UILabel alloc]initForAutoLayout];
        [bgView addSubview:self.lawergradeLB];
        if (DEF_SCREEN_WIDTH == 320.0)
        {
            self.lawergradeLB.font = [UIFont systemFontOfSize:10];
        }
        else{
            self.lawergradeLB.font = [UIFont systemFontOfSize:12];
        }
        self.lawergradeLB.textColor = DEF_RGB_COLOR(60, 153, 230);
        self.lawergradeLB.backgroundColor = [UIColor whiteColor];
        self.lawergradeLB.layer.borderWidth = LINE_HEIGHT;
        self.lawergradeLB.layer.borderColor = DEF_RGB_COLOR(228, 228, 228).CGColor;
        self.lawergradeLB.textAlignment = 1;
        self.lawergradeLB.layer.masksToBounds = YES;
        self.lawergradeLB.layer.cornerRadius = 3;
        [self.lawergradeLB autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.laweryearLB withOffset:-8];
        [self.lawergradeLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.lawershanchangSortLB withOffset:0];
        [self.lawergradeLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.lawershanchangSortLB withOffset:0];
        [self.lawergradeLB autoSetDimensionsToSize:CGSizeMake(36, 20)];
        
//
//        ///    律师年限
        
        
//        //问题
//        self.lawerIntroductionLB = [[UILabel alloc] initForAutoLayout];
//        [bgView addSubview:self.lawerIntroductionLB];
//        self.lawerIntroductionLB.textColor = DEF_RGB_COLOR(61, 61, 71);
//        self.lawerIntroductionLB.font = DEF_Font(16);
//        self.lawerIntroductionLB.numberOfLines = 0;
//        [self.lawerIntroductionLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:10];
//        [self.lawerIntroductionLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView withOffset:-10];
//        [self.lawerIntroductionLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lawerHeadImageBtn withOffset:9];
//        [self.lawerIntroductionLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView withOffset:-47];
    
    }
    return self;
}
-(void)loadCellWithDict:(NSMutableDictionary *)dict
{
    
    
    [self.lawerHeadImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dict[@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"admin"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            DEF_DEBUG(@"有图片");
        }
    }];
    self.lawerNameLB.text = dict[@"name"];
    self.lawergradeLB.text = [NSString stringWithFormat:@"LV%@",dict[@"lv"]];
    self.laweryearLB.text = [NSString stringWithFormat:@"%@年",dict[@"year"]];
    
//    self.lawerIntroductionLB.text = dict[@"introduce"];
    
//    _lvSuoLab.text = dict[@""]
    
    self.lawershanchangSortLB.text = @"擅长分类：";
    NSArray *adeptArr = dict[@"category_name"];
     _shanArray = [[NSMutableArray alloc]init];
    if (adeptArr.count == 0)
    {
        _shanLabOne.hidden = YES;
        _shanLabTwo.hidden = YES;
        _shanLabThree.hidden = YES;
        return;
    }
    for (int i = 0; i< adeptArr.count; i++)
    {
        NSDictionary *dict = adeptArr[i];
        NSArray *nameArray = [dict allValues];
        NSString *nameStr = nameArray[0];
        [_shanArray addObject:nameStr];
    }
    if (_shanArray.count == 1)
    {
        _shanLabOne.text = _shanArray[0];
        _shanLabTwo.hidden = YES;
        _shanLabThree.hidden = YES;
    }
    if (_shanArray.count == 2)
    {
        _shanLabOne.text = _shanArray[0];
        _shanLabTwo.text = _shanArray[1];
        _shanLabThree.hidden = YES;
    }
    if (_shanArray.count == 3)
    {
        _shanLabOne.text = _shanArray[0];
        _shanLabTwo.text = _shanArray[1];
        _shanLabThree.text = _shanArray[2];
    }
    
    
    //@"上海江三角律师事务所";

    _lvSuoLab.text = [NSString stringWithFormat:@"%@",dict[@"lawyer_company"]];
    _cityLan.text = dict[@"city"];
    _heHuoLab.text = dict[@"work_title"];
}
+(float)heightForCellWithDict:(NSDictionary *)dict
{
    //主意：上方头像45 下方擅长分类30
    
    NSString *detailStr = dict[@"introduce"];
    //     NSString *detailStr = [NSString stringWithFormat:@"%@思考出门了可是每次看没人来看vknvjrmlkcslkmcmvsrklmvskldmvrmcslmdlkcm啥都没出两块是男人女少女",dict[@"introduce"]];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(DEF_SCREEN_WIDTH-20, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    float height =ziTiSize.height+10+10+10+34+47;
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
