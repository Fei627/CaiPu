//
//  XXCollectCell.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/29.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "XXCollectCell.h"

@implementation XXCollectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleImageView = [[UIImageView alloc] init];
        self.titleImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.titleImageView];
        
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.textAlignment = NSTextAlignmentCenter;
        self.nameLable.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:self.nameLable];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleImageView.frame = CGRectMake(0, 0, (kViewWidth - 30) / 2, ((float)120 / (float)667) * kViewHeight);
    self.nameLable.frame = CGRectMake(0, ((float)120 / (float)667) * kViewHeight, (kViewWidth - 30) / 2, 20);
    
}


@end
