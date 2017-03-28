//
//  CityModel.m
//  MHProject
//
//  Created by 杜宾 on 15/7/2.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "CityModel.h"
#import "TownShipModel.h"

@implementation CityModel
-(id)initWithDict:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.townMutableArray = [[NSMutableArray alloc]init];
        self.district_name=dictionary[@"name"];
        self.district_id=dictionary[@"id"];
        NSMutableArray *array = dictionary[@"data"];
        
        for (NSDictionary *dict in array)
        {
            TownShipModel *town = [[TownShipModel alloc]initWithDictionary:dict];
            
            [self.townMutableArray addObject:town];
        }
        
    }
    
    
    return self;
    
    
}

@end
