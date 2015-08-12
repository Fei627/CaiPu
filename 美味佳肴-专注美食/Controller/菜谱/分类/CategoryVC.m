//
//  CategoryVC.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/5.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "CategoryVC.h"
#import "JPCollectCell.h"
#import "CategoryDetailVC.h"
#import "DuiZhengVC.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "CategoryModel.h"
#import "JPModel.h"


@interface CategoryVC () <UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, copy) NSString *nameString;

@end

@implementation CategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectArray = [[NSMutableArray alloc] init]; // 开辟空间
    self.tableArray = [[NSMutableArray alloc] init];
    
    [self loadMainView]; // 加载主视图
    [self requestNetworkData]; // 分类集合视图的数据源
    
}

#pragma mark *************** 数据请求 ***************
- (void)requestNetworkData // 分类集合视图的数据源
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/home/tblAssort!getFirstgrade.do"];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak CategoryVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *dataArray = dict[@"data"];
        for (NSDictionary *dictionary in dataArray) {
            
            CategoryModel *model = [[CategoryModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.collectArray addObject:model];
            
        }
        [aSelf.collectArray removeLastObject];
        [aSelf.collectArray removeLastObject];
        [aSelf.collectArray removeLastObject];
        [aSelf.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark **************** 布局视图 ****************
- (void)loadMainView // 加载主视图
{
    // 在导航栏左侧添加 返回 按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // 集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 5, 20);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[JPCollectCell class] forCellWithReuseIdentifier:@"collect"];

    // 表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(- kViewWidth / 3, 0, kViewWidth / 3, kViewHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
}
#pragma mark ***************** 集合视图的配置 ******************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *model = self.collectArray[indexPath.row];
    
    JPCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collect" forIndexPath:indexPath];
    
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    cell.titleLable.text = model.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *model = self.collectArray[indexPath.row];

    self.tableArray = model.secondgradeArray;

    self.nameString = model.name;
    
    [self.tableView reloadData];

    [UIView animateWithDuration:0.3f animations:^{
        
        if (self.collectionView.frame.origin.x > 10) {

            self.collectionView.frame = CGRectMake(0, 0, kViewWidth, kViewHeight - 64);
            self.tableView.frame = CGRectMake(- kViewWidth / 3, 0, kViewWidth / 3, kViewHeight - 64);
        }
        
        else {
            
            self.collectionView.frame = CGRectMake(kViewWidth / 3, 0, kViewWidth , kViewHeight - 64);
            
            self.tableView.frame = CGRectMake(0, 0, kViewWidth / 3, kViewHeight - 64);
        }

    }];

}
#pragma mark ****************** 表视图的配置 ******************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondgradeModel *model = self.tableArray[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondgradeModel *model = self.tableArray[indexPath.row];
    
    //NSLog(@"model.id ====== %@",model.nameID);
    
    if ([self.nameString isEqualToString:@"对症食疗"]) {
        
        DuiZhengVC *duizhengVC = [[DuiZhengVC alloc] init];
        
        duizhengVC.model = model;
        
        [self.navigationController pushViewController:duizhengVC animated:YES];
        
    } else {
        
        CategoryDetailVC *categoryDetailVC = [[CategoryDetailVC alloc] init];
        
        categoryDetailVC.model = model;
        
        [self.navigationController pushViewController:categoryDetailVC animated:YES];
    }
    
}
#pragma mark ****************** 返回按钮的点击 ********************
- (void)backButtonClick // 模态返回
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
