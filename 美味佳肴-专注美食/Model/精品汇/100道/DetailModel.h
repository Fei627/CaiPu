//
//  DetailModel.h
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/25.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject

@property (nonatomic, copy) NSString *vegetable_id;// 1761
@property (nonatomic, copy) NSString *name;// 辣拌土豆丝
@property (nonatomic, copy) NSString *fittingRestriction;// 土豆200克，青椒20克，红椒15克，蒜末少许
@property (nonatomic, copy) NSString *method;// 盐2克，味精、辣椒油、芝麻油、食用油各适量
@property (nonatomic, copy) NSString *imagePathLandscape;// 图片URL
@property (nonatomic, copy) NSString *materialVideoPath;// 第一个视频URL
@property (nonatomic, copy) NSString *productionProcessPath;// 第二个视频URL

@property (nonatomic, copy) NSString *imagePathThumbnails; // 新鲜事-详情-头部图片URL

@end


/**
 *  数据库 （收藏类）
 */

@interface DataBaseManager : NSObject

// 单例
+ (DataBaseManager *)shareDataBaseManager;

// 操作数据库

// 打开数据库
- (void)openDB;

// 建表
- (void)createTable;

// 插入数据
- (void)insertDetailModel:(DetailModel *)model;

// 查询数据
- (NSArray *)selectAll;

// 删除数据
- (void)deleteWithVegetableId:(NSString *)vegetableId;

// 关闭数据库
- (void)closeDB;

@end



