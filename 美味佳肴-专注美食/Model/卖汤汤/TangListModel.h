//
//  TangListModel.h
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/1.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TangListModel : NSObject

@property (nonatomic, copy) NSString *listID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *hotwaterArray;

@end



@interface TangListDetailModel : NSObject

@property (nonatomic, copy) NSString *detailID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isGift;

@end