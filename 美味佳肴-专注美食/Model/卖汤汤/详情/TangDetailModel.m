//
//  TangDetailModel.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/4.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "TangDetailModel.h"

@implementation TangDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"TblProcess"]) {
        
        self.TblProcessArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in value) {
            
            TangZhiDaoModel *model = [[TangZhiDaoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.TblProcessArray addObject:model];
        }
    }
    
    else if ([key isEqualToString:@"TblSeasoning"]) {
        
        self.TblSeasoningArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in value) {
            
            TangZhiDaoModel *model = [[TangZhiDaoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.TblSeasoningArray addObject:model];
        }
    }
    
}



@end


@implementation TangZhiDaoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end


