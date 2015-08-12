//
//  DetailModel.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/25.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "DetailModel.h"
#import <sqlite3.h>

@implementation DetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

/**
 *  数据库 （收藏类）
 */

@implementation DataBaseManager

// 单例
+ (DataBaseManager *)shareDataBaseManager
{
    static DataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataBaseManager alloc] init];
    });
    return manager;
}

/**
 *   获取Documents路径
 */
- (NSString *)documentsPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return array.firstObject;
}


#pragma mark ********* 操作数据库 **********

// 声明一个数据库对象
static sqlite3 *db = nil;

// 打开数据库
- (void)openDB
{
    if (db != nil) {
        //NSLog(@"数据库已经打开");
        return;
    }
    
    NSString *dbPath = [[self documentsPath] stringByAppendingPathComponent:@"Manager.sqlite"];
    //NSLog(@"%@",dbPath);
    
    // 打开数据库
    int result = sqlite3_open(dbPath.UTF8String, &db);
    
    if (result == SQLITE_OK) {
        //NSLog(@"打开成功");
    }
    
    else {
        //NSLog(@"打开失败");
    }
}

// 建表
- (void)createTable
{
    // 准备SQL语句
    NSString *sqlStr = @"CREATE TABLE detailModel(vegetable_id TEXT PRIMARY KEY,name TEXT NOT NULL,fittingRestriction TEXT NOT NULL,method TEXT NOT NULL,imagePathLandscape TEXT NOT NULL,materialVideoPath TEXT NOT NULL,productionProcessPath TEXT NOT NULL,imagePathThumbnails TEXT NOT NULL)";
    
    // 执行语句
    int result = sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        //NSLog(@"建表成功");
    }
    
    else {
        //NSLog(@"建表失败");
    }
}

// 插入数据
- (void)insertDetailModel:(DetailModel *)model
{
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO detailModel(vegetable_id,name,fittingRestriction,method,imagePathLandscape,materialVideoPath,productionProcessPath,imagePathThumbnails) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",model.vegetable_id,model.name,model.fittingRestriction,model.method,model.imagePathLandscape,model.materialVideoPath,model.productionProcessPath,model.imagePathThumbnails];
    
    int result = sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        //NSLog(@"添加成功");
    }

    else {
        //NSLog(@"添加失败");
    }
}

// 查询数据
- (NSArray *)selectAll
{
    NSMutableArray *mutableArray = nil;
    
    NSString *sqlStr = @"SELECT * FROM detailModel";
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, sqlStr.UTF8String, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        
        // 存储查询出的数据
        mutableArray = [[NSMutableArray alloc] init];
        
        //判断是否还有数据
        //使用while循环来判断每行的数据。while适用于不知道循环次数的时候使用
        //通过伴随指针来查询
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSString *vegetable_id = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
            NSString *name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *fittingRestriction = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            NSString *method = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            NSString *imagePathLandscape = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
            NSString *materialVideoPath = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            NSString *productionProcessPath = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
            NSString *imagePathThumbnails = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
            
            // 创建数据模型
            DetailModel *model = [[DetailModel alloc] init];
            
            model.vegetable_id = vegetable_id;
            model.name = name;
            model.fittingRestriction = fittingRestriction;
            model.method = method;
            model.imagePathLandscape = imagePathLandscape;
            model.materialVideoPath = materialVideoPath;
            model.productionProcessPath = productionProcessPath;
            model.imagePathThumbnails = imagePathThumbnails;
            
            [mutableArray addObject:model];
        }
        
        sqlite3_finalize(stmt);
    }
    
    // 找到数组 可以返回
    return mutableArray;
}

/**
 @property (nonatomic, copy) NSString *vegetable_id;// 1761
 @property (nonatomic, copy) NSString *name;// 辣拌土豆丝
 @property (nonatomic, copy) NSString *fittingRestriction;// 土豆200克，青椒20克，红椒
 @property (nonatomic, copy) NSString *method;// 盐2克，味精、辣椒油、芝麻油、食用油各适量
 @property (nonatomic, copy) NSString *imagePathLandscape;// 图片URL
 @property (nonatomic, copy) NSString *materialVideoPath;// 第一个视频URL
 @property (nonatomic, copy) NSString *productionProcessPath;// 第二个视频URL
 @property (nonatomic, copy) NSString *imagePathThumbnails; // 新鲜事-详情-头部图片URL
 */

// 删除数据
- (void)deleteWithVegetableId:(NSString *)vegetableId
{
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM detailModel WHERE vegetable_id = '%@'",vegetableId];
    
    int result = sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, NULL);
    
    if (result == SQLITE_OK) {
        //NSLog(@"删除成功");
    }
    
    else {
        //NSLog(@"删除失败");
    }
}

// 关闭数据库
- (void)closeDB
{
    int result = sqlite3_close(db);
    if (result == SQLITE_OK) {
        //NSLog(@"关闭成功");
    }
    
    else {
        //NSLog(@"关闭失败");
    }
}




@end