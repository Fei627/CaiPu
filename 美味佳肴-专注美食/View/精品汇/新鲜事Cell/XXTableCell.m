//
//  XXTableCell.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "XXTableCell.h"

@implementation XXTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bottomView = [[UIImageView alloc] init];
        self.bottomView.backgroundColor = [UIColor colorWithRed:58.0/256.0 green:58.0/256.0 blue:58.0/256.0 alpha:0.3];
        [self.contentView addSubview:self.bottomView];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.font = [UIFont boldSystemFontOfSize:15];
        [self.bottomView addSubview:self.titleLable];
        
        self.digestLable = [[UILabel alloc] init];
        self.digestLable.font = [UIFont systemFontOfSize:13];
        self.digestLable.textColor = [UIColor grayColor];
        self.digestLable.numberOfLines = 0;
        [self.bottomView addSubview:self.digestLable];
        
        self.pictureView = [[UIImageView alloc] init];
        [self.bottomView addSubview:self.pictureView];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bottomView.frame = CGRectMake(0, 5, self.contentView.frame.size.width, self.contentView.frame.size.height - 10);
    self.titleLable.frame = CGRectMake(10, 20, ((float)200 / (float)375)  * kViewWidth, 30);
    self.digestLable.frame = CGRectMake(10, 50, ((float)200 / (float)375) * kViewWidth, 40);
    self.pictureView.frame = CGRectMake(((float)200 / (float)375) * kViewWidth + 30, 10, ((float)140 / (float)375) * kViewWidth - 5, 90);
    
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
