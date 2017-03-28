//
//  CityModel.h
//  MHProject
//
//  Created by 杜宾 on 15/7/2.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property(copy,nonatomic)NSString * district_id;   //区域id

@property(copy,nonatomic)NSString * district_name;  //区域名字


@property(nonatomic,strong)NSMutableArray *townMutableArray;
-(id)initWithDict:(NSDictionary *)dictionary;

@end
