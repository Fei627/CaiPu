//
//  PackageView.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/27.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "PackageView.h"

@implementation PackageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.leftImageView = [[UIImageView alloc] init];
        [self addSubview:self.leftImageView];
        
        self.leftLable = [[UILabel alloc] init];
        self.leftLable.adjustsFontSizeToFitWidth = YES;
        self.leftLable.numberOfLines = 0;
        self.leftLable.textAlignment = NSTextAlignmentCenter;
        self.leftLable.font = [UIFont boldSystemFontOfSize:17];
        self.leftLable.textColor = [UIColor colorWithRed:192/256.0 green:180/256.0 blue:96/256.0 alpha:1.0];
        self.leftLable.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.leftLable];
        
        self.rightLable = [[UILabel alloc] init];
        self.rightLable.font = [UIFont boldSystemFontOfSize:14];
        self.rightLable.numberOfLines = 0;
        self.rightLable.textAlignment = NSTextAlignmentCenter;
        self.rightLable.backgroundColor = [UIColor colorWithRed:192/256.0 green:180/256.0 blue:96/256.0 alpha:0.7];
        [self addSubview:self.rightLable];
    }
    return self;
}

-(void)layoutSubviews
{
    self.leftImageView.frame = CGRectMake(0, 0, 60, self.frame.size.height);
    self.leftLable.frame = CGRectMake(60, 0, 80, self.frame.size.height);
    self.rightLable.frame = CGRectMake(140, 0, self.frame.size.width - 140, self.frame.size.height);
}

@end

#pragma mark *****************************************************

@implementation XiangYiView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.leftLable = [[UILabel alloc] init];
        self.leftLable.textColor = [UIColor whiteColor];
        self.leftLable.backgroundColor = [UIColor colorWithRed:60/256.0 green:71/256.0 blue:33/256.0 alpha:1.0];
        self.leftLable.font = [UIFont boldSystemFontOfSize:20];
        self.leftLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.leftLable];
        
        self.centerLable = [[UILabel alloc] init];
        self.centerLable.textColor = [UIColor colorWithRed:13/256.0 green:61/256.0 blue:23/256.0 alpha:1.0];
        self.centerLable.font = [UIFont boldSystemFontOfSize:15];
        self.centerLable.textAlignment = NSTextAlignmentCenter;
        self.centerLable.backgroundColor = [UIColor colorWithRed:192/256.0 green:180/256.0 blue:96/256.0 alpha:0.7];
        [self addSubview:self.centerLable];
        
        self.rightImageView = [[UIImageView alloc] init];
        [self addSubview:self.rightImageView];
        
    }
    return self;
}

-(void)layoutSubviews
{
    self.leftLable.frame = CGRectMake(0, 0, 60, 30);
    self.centerLable.frame = CGRectMake(60, 0, self.frame.size.width - 110, 30);
    self.rightImageView.frame = CGRectMake(self.frame.size.width - 50, 0, 50, 30);
}



@end












