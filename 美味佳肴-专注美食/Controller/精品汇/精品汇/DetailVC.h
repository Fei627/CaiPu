//
//  DetailVC.h
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/25.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"

@interface DetailVC : UIViewController

@property (nonatomic, strong) DetailModel *model;

@property (nonatomic, copy) NSString *vegetableID;

@end
