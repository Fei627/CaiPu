//
//  CaiLiaoModel.h
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/25.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaiLiaoModel : NSObject

@property (nonatomic, copy) NSString *vegetable_id;
@property (nonatomic, copy) NSString *imagePath;// 第一张图片的URL
@property (nonatomic, strong) NSMutableArray *imageArray; //图片数组

@end


@interface CaiLiao_Model : NSObject

@property (nonatomic, copy) NSString *orderId;// 图片页数
@property (nonatomic, copy) NSString *name;// 图片名字
@property (nonatomic, copy) NSString *imagePath;// 图片URL

@end