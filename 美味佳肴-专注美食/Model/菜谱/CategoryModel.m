//
//  CategoryModel.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/8.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.categoryID = value;
        
    }
    
    else if ([key isEqualToString:@"secondgrade"]) {
        
        self.secondgradeArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in value) {
            
            SecondgradeModel *model = [[SecondgradeModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.secondgradeArray addObject:model];
        }
    }
}

@end


@implementation SecondgradeModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.nameID = value;
    }
}


@end

