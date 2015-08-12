//
//  LIView.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/4.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "LIView.h"

@implementation LIView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleImageView = [[UIImageView alloc] init];
        [self addSubview:self.titleImageView];
        
        self.nameLable = [[UILabel alloc] init];
        self.nameLable.font = [UIFont systemFontOfSize:12];
        self.nameLable.adjustsFontSizeToFitWidth = YES;
        self.nameLable.numberOfLines = 0;
        [self addSubview:self.nameLable];
        
        self.pageLable = [[UILabel alloc] init];
        self.pageLable.font = [UIFont systemFontOfSize:12];
        self.pageLable.textAlignment = NSTextAlignmentCenter;
        self.pageLable.textColor = [UIColor purpleColor];
        self.pageLable.layer.cornerRadius = 10;
        self.pageLable.layer.masksToBounds = YES;
        self.pageLable.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.pageLable];
    }
    
    return self;
}


- (void)layoutSubviews
{
    self.titleImageView.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 40);
    self.pageLable.frame = CGRectMake(0, self.frame.size.height - 30, 20, 20);
    self.nameLable.frame = CGRectMake(20, self.frame.size.height - 35, self.frame.size.width - 25, 35);
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
