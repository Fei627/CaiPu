//
//  XXSDetailModel.h
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/29.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXSDetailModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageFilename;
@property (nonatomic, strong) NSMutableArray *vegetableArray;

@end


//@interface VegetableModel : DetailModel
//
////@property (nonatomic, copy) NSString *vegetable_id;
////@property (nonatomic, copy) NSString *name; // 菜名
////@property (nonatomic, copy) NSString *imagePathThumbnails; // 菜的图片URL
//
//@end

