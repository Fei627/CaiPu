//
//  JPCollectCell.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "JPCollectCell.h"

@implementation JPCollectCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.pictureView = [[UIImageView alloc] init];
        self.pictureView.image = [UIImage imageNamed:@"2"];
        [self.contentView addSubview:self.pictureView];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.font = [UIFont boldSystemFontOfSize:12];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.text = @"美容餐100道";
        [self.pictureView addSubview:self.titleLable];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pictureView.frame = CGRectMake(0, 0, 80, 80);
    self.titleLable.frame = CGRectMake(0, 60, 80, 20);
}


@end
