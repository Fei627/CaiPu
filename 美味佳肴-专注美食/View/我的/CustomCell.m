//
//  CustomCell.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLable];
        
        self.rightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rightImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews]; // 不要忘记写了
    self.titleLable.frame = CGRectMake(15, 0, 200, self.contentView.frame.size.height);
    self.rightImageView.frame = CGRectMake(self.contentView.frame.size.width - 35, 12, 20, 20);
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
