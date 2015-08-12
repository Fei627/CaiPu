//
//  DuiZhengCell.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "DuiZhengCell.h"

@implementation DuiZhengCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.pictureView = [[UIImageView alloc] init];
        self.pictureView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.pictureView];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.numberOfLines = 0;
        [self.contentView addSubview:self.titleLable];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pictureView.frame = CGRectMake(0, 0, self.contentView.frame.size.height, self.contentView.frame.size.height);
    self.titleLable.frame = CGRectMake(self.contentView.frame.size.height, 0, self.contentView.frame.size.width - self.contentView.frame.size.height, self.contentView.frame.size.height);
    
}



@end
