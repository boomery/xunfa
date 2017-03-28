//
//  QuestionInteractionCell.m
//  MHProject
//
//  Created by 杜宾 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "QuestionInteractionCell.h"
#import "UIImageView+AFNetworking.h"

@implementation QuestionInteractionCell


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
    self.headImage = [[UIImageView alloc]init];
    [self addSubview:self.headImage];
    self.headImage.frame = CGRectMake(5, 10, 40, 40);
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 20;
    
    self.questionLab = [[UILabel alloc]init];
    [self addSubview:self.questionLab];
    
//    self.buddleImageView = [[UIImageView alloc]init];
//    [self addSubview:self.buddleImageView];
//    
    
    
}


-(void)loadCellWithDict:(NSDictionary *)dict
{
    
    
    
    
    NSString *type = dict[@"type"];

    //     type 为2是律师
    if ([type isEqualToString:@"2"])
    {
        
        [self.headImage setImageWithURL:[NSURL URLWithString:dict[@"avatar"]]];
        self.questionLab.numberOfLines=0;
        NSString * str= dict[@"content"];
        UIFont * font =[UIFont systemFontOfSize:17];
        NSDictionary * diction =[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 5000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:diction context:nil];
        CGSize size = rect.size;
        self.questionLab.text=str;
//        self.questionLab.backgroundColor = [UIColor redColor];
        self.questionLab.frame=CGRectMake(65, 10, size.width, size.height);
        
//        self.buddleImageView = [[UIImageView alloc]init];
//        UIImage * image=[[UIImage imageNamed:@"otherChat.png"]stretchableImageWithLeftCapWidth:22 topCapHeight:15];
//         self.buddleImageView.image=image;
//         self.buddleImageView.frame=CGRectMake(50, 10, size.width+30, size.height+10);
//        

    }
//    1 用户
    else if ([type isEqualToString:@"1"])
    {
        [self.headImage setImageWithURL:[NSURL URLWithString:dict[@"avatar"]]];
        self.questionLab = [[UILabel alloc]init];
        self.questionLab.numberOfLines=0;
        NSString * str= dict[@"content"];
        UIFont * font =[UIFont systemFontOfSize:17];
        NSDictionary * diction =[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 5000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:diction context:nil];
        CGSize size = rect.size;
        self.questionLab.text=str;
        self.questionLab.textColor = [UIColor redColor];
        self.questionLab.frame=CGRectMake(65, 10, size.width, size.height);
//        
//        UIImage * image=[[UIImage imageNamed:@"myChat.png"]stretchableImageWithLeftCapWidth:22 topCapHeight:15];
//         self.buddleImageView.image=image;
//         self.buddleImageView.frame=CGRectMake(50, 10, size.width+30, size.height+10);
        

    }
    
    
}

+(float)heightForCellWithDict:(NSDictionary *)dict
{
    NSString * str= dict[@"content"];
    UIFont * font =[UIFont systemFontOfSize:17];
    NSDictionary * diction =[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 5000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:diction context:nil];
    CGSize size = rect.size;
    return size.height+50;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
