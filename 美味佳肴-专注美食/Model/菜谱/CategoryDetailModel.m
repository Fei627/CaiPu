//
//  CategoryDetailModel.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "CategoryDetailModel.h"

@implementation CategoryDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.ID = value;
    }
}


@end
