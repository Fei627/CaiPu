//
//  CaiLiaoModel.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/25.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "CaiLiaoModel.h"

@implementation CaiLiaoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"TblSeasoning"]) {
        
        self.imageArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in value) {
            
            CaiLiao_Model *model = [[CaiLiao_Model alloc] init];
            
            [model setValuesForKeysWithDictionary:dict];
            
            [self.imageArray addObject:model];
        }
    }
}

@end


@implementation CaiLiao_Model

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end