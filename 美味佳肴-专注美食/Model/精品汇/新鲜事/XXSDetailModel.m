//
//  XXSDetailModel.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/29.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "XXSDetailModel.h"
#import "DetailModel.h"

@implementation XXSDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"vegetable"]) {
        
        self.vegetableArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in value) {
            
            DetailModel *model = [[DetailModel alloc] init];
            
            [model setValuesForKeysWithDictionary:dict];
            
            [self.vegetableArray addObject:model];
        }
    }
}


@end


//@implementation VegetableModel
//
////- (void)setValue:(id)value forUndefinedKey:(NSString *)key
////{
////    
////}
//
//@end
