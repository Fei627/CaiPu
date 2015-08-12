//
//  TableCell.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/25.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bottomPicView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom"]];
        [self.contentView addSubview:self.bottomPicView];
        
        self.pictureView = [[UIImageView alloc] init];
        self.pictureView.image = [UIImage imageNamed:@"2"];
        [self.bottomPicView addSubview:self.pictureView];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.textAlignment = NSTextAlignmentCenter;
        self.titleLable.font = [UIFont boldSystemFontOfSize:12];
        [self.bottomPicView addSubview:self.titleLable];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bottomPicView.frame = CGRectMake(0, 5, self.contentView.frame.size.width, self.contentView.frame.size.height - 10);
    self.pictureView.frame = CGRectMake(50, 5, self.bottomPicView.frame.size.width - 100, self.contentView.frame.size.height - 10 - 30);
    self.titleLable.frame = CGRectMake(50, self.contentView.frame.size.height - 10 - 30 + 5, self.pictureView.frame.size.width, 20);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
