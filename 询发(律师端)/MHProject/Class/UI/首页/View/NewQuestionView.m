//
//  NewQuestionView.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "NewQuestionView.h"
#import "HZUtil.h"
#import "UIImageView+WebCache.h"
#import "HZShowImageView.h"
@implementation NewQuestionView
- (id)initWithFrame:(CGRect)frame with:(id)data
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        创建视图并赋值
        [self CreatViewWith:frame with:data];
    }
    
    return self;
    
    
}
-(void)CreatViewWith:(CGRect)frame with:(id)data
{
    _data = data;
    self.backgroundColor = [UIColor whiteColor];
    //名字
    UILabel *questionNameLable = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 200, 15)];
    questionNameLable.font = DEF_Font(13.5);
    questionNameLable.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1];
    questionNameLable.text = data[@"name"];
    [self addSubview:questionNameLable];
    
    //时间
    UILabel *timeLable = [[UILabel alloc]initForAutoLayout];
    [self addSubview:timeLable];
    [timeLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
    [timeLable autoSetDimension:ALDimensionHeight toSize:20];
    [timeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:questionNameLable];
    [timeLable autoSetDimension:ALDimensionWidth toSize:10 relation:NSLayoutRelationGreaterThanOrEqual];
    timeLable.text = data[@"created_at"];
    timeLable.textAlignment = 2;
    timeLable.textColor = DEF_RGB_COLOR(142, 142, 147);
    timeLable.font = [UIFont systemFontOfSize:13.5];
    
    //内容和图片
    CGFloat contentHeight = [HZUtil getHeightWithString:data[@"content"] fontSize:16 width:DEF_SCREEN_WIDTH-24];
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, DEF_BOTTOM(questionNameLable)+8, DEF_SCREEN_WIDTH-24, contentHeight+5)];
    [self addSubview:_questionLabel];
    _questionLabel.font = [UIFont systemFontOfSize:16];
    _questionLabel.text = data[@"content"];
    _questionLabel.numberOfLines = 0;
    NSArray *imageArr = data[@"image"];
    if ([imageArr count] > 0)
    {
        UIScrollView *scrollView = [[UIScrollView alloc]initForAutoLayout];
        [self addSubview:scrollView];
        [scrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_questionLabel withOffset:8];
        [scrollView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0];
        [scrollView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
        [scrollView autoSetDimension:ALDimensionHeight toSize:width(100.0)];
        [scrollView autoSetDimension:ALDimensionWidth toSize:DEF_SCREEN_WIDTH];
        scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i < [imageArr count]; i ++)
        {
            float hSpace = width(5.0);
            float width = width(100.0);
            float heigth = width(100.0);
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(hSpace + i*(width + hSpace), 0, width, heigth)];
            imageView.tag = i;
            imageView.backgroundColor = [UIColor lightGrayColor];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleToFill;

            imageView.userInteractionEnabled = YES;
            [scrollView addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[i]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                if (image)
                {
//                    NSLog(@"");
                }
            }];
            scrollView.contentSize = CGSizeMake((width + hSpace)* [imageArr count], 0);
            
            //为imageView添加点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            tap.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:tap];
        }
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-LINE_HEIGHT, self.width, LINE_HEIGHT)];
    lineView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [self addSubview:lineView];

}
- (void)tap:(UITapGestureRecognizer *)recognizer
{
    NSInteger index = recognizer.view.tag;
    HZShowImageView *showImageView = [[HZShowImageView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT) withImageArray:self.data[@"image"] clickIndex:index];
    [showImageView show];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

