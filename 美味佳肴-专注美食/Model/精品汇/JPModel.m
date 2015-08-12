//
//  JPModel.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "JPModel.h"

@implementation JPModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.jpID = value;
    }
}


@end
