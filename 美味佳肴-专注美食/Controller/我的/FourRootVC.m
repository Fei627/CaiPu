//
//  FourRootVC.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "FourRootVC.h"
#import "CustomCell.h"
#import "CollectVC.h"
#import "AboutUsVC.h"

#import "DetailModel.h"

@interface FourRootVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIAlertView *declareAlertView;

@end

@implementation FourRootVC

- (UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有收藏哦！！!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _alertView;
}

- (UIAlertView *)declareAlertView
{
    if (!_declareAlertView) {
        _declareAlertView = [[UIAlertView alloc
                              ] initWithTitle:@"声明" message:@"     本app所有内容,包括文字、图⽚、视频、软件、程序、以及版式设计等均在⺴上搜集。访问者可将本app提供的内容或服务用于个⼈人学习、研究或欣赏,以及其他非商业性或 非盈利性用途,但同时应遵守著作权法及其他相关法律的规定,不得侵犯本app及相关权利⼈人的合法权利。除此以外,将本app任何内容或服务用于其他用途时,须征得本app及相关权利人的书面许可,并支付报酬。本app内容原作者如不愿意在本app刊登内容,请及时通知本app,予以删除。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }
    return _declareAlertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameArray = @[@"收藏列表",@"关于我们",@"免责声明"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"CELL"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 0.1)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    
}

#pragma mark *********************** 表视图的配置 *************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.titleLable.text = self.nameArray[indexPath.row];
    cell.rightImageView.image = [UIImage imageNamed:@"right"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    if (indexPath.row == 0) {
        
        [[DataBaseManager shareDataBaseManager] openDB];
        
        if ([[DataBaseManager shareDataBaseManager] selectAll].count != 0) {
         
            CollectVC *collectVC = [[CollectVC alloc] init];
            
            [collectVC setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:collectVC animated:YES];
        }
        else {
            
            [self.alertView show];
        }
        
    }
    
    else if (indexPath.row == 1) {
        
        //NSLog(@"关于我们");
        AboutUsVC *usVC = [[AboutUsVC alloc] init];
        
        [usVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:usVC animated:YES];
    }
    
    else {
        
        //NSLog(@"免责声明");
        [self.declareAlertView show];
    }
    
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
