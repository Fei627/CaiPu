//
//  DetailCollectCell.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/25.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "DetailCollectCell.h"

@implementation DetailCollectCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.pictureView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.pictureView];
        self.pictureView.image = [UIImage imageNamed:@"2"];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:self.titleLable];
        self.titleLable.text = @"醋溜土豆丝";
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pictureView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - 20);
    self.titleLable.frame = CGRectMake(0, self.contentView.frame.size.height - 20, self.contentView.frame.size.width, 20);
    
}





@end
