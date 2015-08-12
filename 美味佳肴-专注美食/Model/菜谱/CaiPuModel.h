//
//  CaiPuModel.h
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/5.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaiPuModel : NSObject

@property (nonatomic, copy) NSString *vegetable_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *englishName;
@property (nonatomic, copy) NSString *imagePathLandscape; // 长图
@property (nonatomic, copy) NSString *imagePathPortrait; // 中图
@property (nonatomic, copy) NSString *imagePathThumbnails; // 小图


@end
