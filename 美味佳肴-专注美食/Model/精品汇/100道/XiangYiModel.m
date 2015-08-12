//
//  XiangYiModel.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/27.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "XiangYiModel.h"

@implementation XiangYiModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"Fitting"] && value != nil) {
        
        self.FitArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in value) {

            FittingOrGram *model = [[FittingOrGram alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.FitArray addObject:model];
        }
    } else if ([key isEqualToString:@"Gram"] && value != nil) {
        
        self.GramArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in value) {
            
            FittingOrGram *model = [[FittingOrGram alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.GramArray addObject:model];
        }
    }
    
}

@end


@implementation FittingOrGram

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end






