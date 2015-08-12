//
//  TangDetailModel.h
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/4.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TangDetailModel : NSObject

@property (nonatomic, copy) NSString *productId; // 483
@property (nonatomic, copy) NSString *name; //小米白扁豆七谷养生粥
@property (nonatomic, copy) NSString *hotwaterVideo; // 视频URL
@property (nonatomic, copy) NSString *imageFilename; // 视频占位图

// 材料准备
@property (nonatomic, copy) NSString *materialPrepare; // 原料
@property (nonatomic, copy) NSString *materialImage; // 原料图片
@property (nonatomic, copy) NSString *flavor; // 调料用量（盐2克）
@property (nonatomic, strong) NSMutableArray *TblSeasoningArray; // 调料数组

// 制作指导
@property (nonatomic, strong) NSMutableArray *TblProcessArray; //存放制作步骤的数组
@property (nonatomic, copy) NSString *cookPrompt; // 温馨提升内容


// 科学食用
@property (nonatomic, copy) NSString *nousImage; // 顶部图片
@property (nonatomic, copy) NSString *scienceNous; // 科学食用说明
@property (nonatomic, copy) NSString *meekPrompt; // 温馨提示内容

// 在线购买
@property (nonatomic, copy) NSString *purchaseImage; // 大长图


@end



@interface TangZhiDaoModel : NSObject

// 材料准备数组里的属性
@property (nonatomic, copy) NSString *name; // 材料名（盐）
@property (nonatomic, copy) NSString *imagePath; // 图片（URL）

// 制作指导数组里的属性
@property (nonatomic, copy) NSString *orderid; // 01
@property (nonatomic, copy) NSString *describe; // 将材料洗净后浸泡2小时
@property (nonatomic, copy) NSString *imageProcess; // 图片URL

@end





