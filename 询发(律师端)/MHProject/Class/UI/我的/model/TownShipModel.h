//
//  TownShipModel.h
//  MHProject
//
//  Created by 杜宾 on 15/7/2.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TownShipModel : NSObject

@property(nonatomic,copy)NSString *township_id;//区id
@property(nonatomic,copy)NSString  *townshipName;//区名

- (id)initWithDictionary:(NSDictionary *)dic;


@end
