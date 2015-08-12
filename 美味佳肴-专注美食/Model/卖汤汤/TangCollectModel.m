//
//  TangCollectModel.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "TangCollectModel.h"

@implementation TangCollectModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.detailID = value;
    }
}



@end

