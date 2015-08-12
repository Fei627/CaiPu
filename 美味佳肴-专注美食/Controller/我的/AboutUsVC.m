//
//  AboutUsVC.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/10.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@property (nonatomic, strong) UIImageView *titleImageView; // 图标
@property (nonatomic, strong) UILabel *versionLable; // 版本号

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *introduceLable; // APP介绍
@property (nonatomic, strong) UILabel *contactLable; // 意见反馈

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 替换导航栏左侧的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 图标
    self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kViewWidth - 80) / 2, 50, 80, 80)];
    self.titleImageView.image = [UIImage imageNamed:@"us"];
    self.titleImageView.layer.cornerRadius = 10;
    self.titleImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.titleImageView];
    
    // 版本号
    self.versionLable = [[UILabel alloc] initWithFrame:CGRectMake((kViewWidth - 80) / 2 - 40, 135, 160, 20)];
    self.versionLable.text = @"美味私厨";
    self.versionLable.font = [UIFont boldSystemFontOfSize:18];
    self.versionLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.versionLable];
    
    // 底视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 175, kViewWidth, kViewHeight - 175)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:192.0 / 255.0 green:180.0 / 255.0 blue:96.0 / 255.0 alpha:0.3];
    [self.view addSubview:self.bottomView];
    
    // 介绍
    self.introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kViewWidth - 40, 100)];
    self.introduceLable.numberOfLines = 0;
    self.introduceLable.textColor = [UIColor blackColor];
    self.introduceLable.font = [UIFont systemFontOfSize:15];
    self.introduceLable.text = @"      美味私厨是一款集 家常菜的做法步骤、制作材料、相关常识、相宜相克以及视频教程为一体的美食软件，本软件为您呈现了上万道精品美食的制作方法，让您尽享美食的诱惑！！！";
    [self.bottomView addSubview:self.introduceLable];
    //self.introduceLable.backgroundColor = [UIColor orangeColor];
    
    // 意见反馈
    UILabel *aLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, kViewWidth - 40, 20)];
    aLable.text = @"联系我们：";
    aLable.font = [UIFont systemFontOfSize:15];
    [self.bottomView addSubview:aLable];
    
    self.contactLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, kViewWidth - 40, 50)];
    self.contactLable.numberOfLines = 0;
    self.contactLable.font = [UIFont systemFontOfSize:15];
    self.contactLable.text = @"E-MAIL：gaojianlongbj@foxmail.com";
    [self.bottomView addSubview:self.contactLable];
    
}

#pragma mark ***************** 导航栏按钮的点击 *********************
- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
