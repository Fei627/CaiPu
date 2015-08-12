//
//  CollectVC.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "CollectVC.h"
#import "DetailVC.h"

#import "DetailModel.h"
#import "CustomCell.h"

@interface CollectVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self layoutMainView];
    
    // 数据库
    [[DataBaseManager shareDataBaseManager] openDB];
    [self.dataArray setArray:[[DataBaseManager shareDataBaseManager] selectAll]];
}

#pragma mark ********** 布局视图 ***********
- (void)layoutMainView
{
    // 替换导航栏左侧的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"CELL"];
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 10)];
    aView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = aView;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    
}

#pragma mark *************** 表视图的配置 ***************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel *model = self.dataArray[indexPath.row];
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.titleLable.text = model.name;
    cell.rightImageView.image = [UIImage imageNamed:@"right"];
    
    cell.backgroundColor = [UIColor colorWithRed:192.0 / 255.0 green:180.0 / 255.0 blue:96.0 / 255.0 alpha:0.3];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    DetailModel *model = self.dataArray[indexPath.row];
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    
    detailVC.model = model;
    
    detailVC.vegetableID = model.vegetable_id;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark *********** 单元格编辑 ***********
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel *model = self.dataArray[indexPath.row];
    
    // 先删除数据库里的数据
    [[DataBaseManager shareDataBaseManager] openDB];
    [[DataBaseManager shareDataBaseManager] deleteWithVegetableId:model.vegetable_id];
    
    // 再删除数据源数组中的数据
    [self.dataArray removeObject:model];
    
    // 最后再删除单元格
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
    if (editing) {

        self.navigationItem.rightBarButtonItem.title = @"完成";
    }
    
    else {
        
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    
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
