//
//  TangListModel.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/1.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "TangListModel.h"

@implementation TangListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
     
        self.listID = value;
        
    } else if ([key isEqualToString:@"hotwater"]) {
        
        self.hotwaterArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in value) {

            TangListDetailModel *model = [[TangListDetailModel alloc] init];

            [model setValuesForKeysWithDictionary:dict];
            
            [self.hotwaterArray addObject:model];
        }
    }
}


@end


@implementation TangListDetailModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {

        self.detailID = value;
        
    }
}


@end


