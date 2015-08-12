//
//  CategoryModel.h
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/8.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSMutableArray *secondgradeArray;

@end



@interface SecondgradeModel : NSObject

@property (nonatomic, copy) NSString *nameID;
@property (nonatomic, copy) NSString *name;

@end