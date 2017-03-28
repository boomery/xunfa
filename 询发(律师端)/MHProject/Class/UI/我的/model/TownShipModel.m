//
//  TownShipModel.m
//  MHProject
//
//  Created by 杜宾 on 15/7/2.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "TownShipModel.h"

@implementation TownShipModel
-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.township_id = dic[@"id"];
        self.townshipName = dic[@"name"];
        
    }
    return self;
}

@end
