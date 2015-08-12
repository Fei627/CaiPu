//
//  PackageView.h
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/27.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  封装 精品汇-100道 “相宜相克”板块
 */
@interface PackageView : UIView

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *rightLable;


@end


/**
 *  
 */
@interface XiangYiView : UIView

@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *centerLable;
@property (nonatomic, strong) UIImageView *rightImageView;

@end


