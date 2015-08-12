//
//  TangCollectCell.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/31.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "TangCollectCell.h"

@implementation TangCollectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleImageView = [[UIImageView alloc] init];
        self.titleImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.titleImageView];
        
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.textAlignment = NSTextAlignmentCenter;
        self.nameLable.numberOfLines = 0;
        self.nameLable.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.nameLable];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - 30);
    self.nameLable.frame = CGRectMake(0, self.contentView.frame.size.height - 30, self.contentView.frame.size.width, 30);
}




@end
