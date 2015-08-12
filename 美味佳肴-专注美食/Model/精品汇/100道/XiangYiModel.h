//
//  XiangYiModel.h
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiangYiModel : NSObject

@property (nonatomic ,copy) NSString *materialName; // 相宜的对象 名字
@property (nonatomic ,copy) NSString *imageName; // 图片URL
@property (nonatomic ,strong) NSMutableArray *FitArray; // 相宜 数组
@property (nonatomic ,strong) NSMutableArray *GramArray; // 相克 数组

@end


@interface FittingOrGram : NSObject

@property (nonatomic, copy) NSString *materialName; // 相宜/克 的对象名字
@property (nonatomic, copy) NSString *contentDescription; // 会出现的症状
@property (nonatomic, copy) NSString *imageName; // 图片URL

@end