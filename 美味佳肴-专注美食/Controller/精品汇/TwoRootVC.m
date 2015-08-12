//
//  TwoRootVC.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "TwoRootVC.h"
// view
#import "JPCollectCell.h"
#import "XXTableCell.h"
// 第三方
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
// 数据模型
#import "JPModel.h"
#import "XXModel.h"
// viewController
#import "JPCollectVC.h"
#import "XXSRootVC.h"

@interface TwoRootVC () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;

@property (nonatomic, strong) NSMutableArray *collectArray; // 精品汇数据源
@property (nonatomic, strong) NSMutableArray *tableArray; // 新鲜事的数据源数组

@property (nonatomic, strong) UIAlertView *alertView;

@end

static NSInteger number = 1;

@implementation TwoRootVC

- (UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无连接" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    }
    return _alertView;
}

-(NSMutableArray *)collectArray
{
    if (!_collectArray) {
        _collectArray = [[NSMutableArray alloc] init];
    }
    return _collectArray;
}

-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc] init];
    }
    return _tableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNavigationBarView];//加载导航栏上的按钮
    [self loadMainView];//加载主视图 “精品汇” “新鲜事”
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            
            //NSLog(@"未知网络");
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
            
            //******* 精品汇 数据源*******
            [self.collectArray removeAllObjects];
            [self CollectViewrequestData];//数据请求
            
            //*******新鲜事 数据源********
            [self tableViewRequestData];
            [self upDateTableView];//刷新数据
            
            return;
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            //NSLog(@"3G网络");
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
            
            //******* 精品汇 数据源*******
            [self.collectArray removeAllObjects];
            [self CollectViewrequestData];//数据请求
            
            //*******新鲜事 数据源********
            [self tableViewRequestData];
            [self upDateTableView];//刷新数据
            
            return;
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            //NSLog(@"WiFi网络");
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
            
            //******* 精品汇 数据源*******
            [self.collectArray removeAllObjects];
            [self CollectViewrequestData];//数据请求
            
            //*******新鲜事 数据源********
            [self tableViewRequestData];
            [self upDateTableView];//刷新数据
            
            return;
        }
        else {
            //NSLog(@"网络无连接");
            [self.alertView show];
            return;
        }
    }];
}

#pragma mark *********刷新数据**********
-(void)upDateTableView
{
    [self.tableView addHeaderWithTarget:self action:@selector(stepHeader)];
    [self.tableView addFooterWithTarget:self action:@selector(stepFooter)];
}
-(void)stepHeader//刷新最新
{
    number = 1;
    [self tableViewRequestData];
}
-(void)stepFooter//加载更多
{
    number += 1;
    if (number == 7) {
        self.tableView.footerPullToRefreshText = @"已经是最后一条了亲····";
        self.tableView.footerRefreshingText = @"已经是最后一条了亲····";
        self.tableView.footerReleaseToRefreshText = @"已经是最后一条了亲····";
    }
    [self tableViewRequestData];
    
}
#pragma mark *********数据请求***********
-(void)CollectViewrequestData//精品汇的数据源
{
//    if (self.collectArray.count != 0) {
//        
//        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
//        return;
//    }
    
    NSString *urlPath = @"http://121.41.88.179:80/HandheldKitchen/api/found/tblBoutique!getTblBoutiqueTypeList.do?is_traditional=0&phonetype=2&page=1&pageRecord=100";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //1.2告诉manager只下载原始数据, 不要解析数据(一定要写)

    //     AFN即可以下载网络数据, 又可以解析json数据,如果不写下面的  自动就解析json
    //     由于做服务器的人返回json数据往往不规范, 凡是AFN又检查很严格,导致json解析往往失败
    //     下面这句话的意思是 告诉AFN千万别解析, 只需要给我裸数据就可以
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak TwoRootVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = operation.responseData;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            
            JPModel *model = [[JPModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.collectArray addObject:model];
        }
                
        [aSelf.collectView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)tableViewRequestData//新鲜事的数据源
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.84.91:80/HandheldKitchen/api/found/tblFresh!getTblFreshList.do?is_traditional=0&page=%ld&pageRecord=10&phonetype=1",number];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak TwoRootVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (number == 1) {
            [aSelf.tableArray removeAllObjects];
        }
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            XXModel *model = [[XXModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.tableArray addObject:model];
        }
        
        [aSelf.tableView reloadData];
        [aSelf.tableView headerEndRefreshing];
        [aSelf.tableView footerEndRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark ********导航栏视图***********
-(void)loadNavigationBarView
{
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    self.barView.backgroundColor = [UIColor grayColor];
    self.barView.layer.cornerRadius = 15;
    
    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.firstButton.frame = CGRectMake(10, 0, 80, 30);
    [self.firstButton setTitle:@"精品汇" forState:UIControlStateNormal];
    [self.firstButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.firstButton.selected = YES;
    [self.firstButton addTarget:self action:@selector(firstButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.secondButton.frame = CGRectMake(90, 0, 80, 30);
    [self.secondButton setTitle:@"新鲜事" forState:UIControlStateNormal];
    [self.secondButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.secondButton addTarget:self action:@selector(secondButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.barView addSubview:self.firstButton];
    [self.barView addSubview:self.secondButton];
    self.navigationItem.titleView = self.barView;
}
#pragma mark *******导航栏按钮的点击 响应事件*********
// 精品汇
-(void)firstButtonClickAction:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        self.secondButton.selected = NO;
     } else {
        sender.selected = YES;
        self.secondButton.selected = NO;
    }
    self.collectView.frame = CGRectMake(0, 0, kViewWidth, kViewHeight - 113);
    self.tableView.frame = CGRectMake(kViewWidth, 0, kViewWidth, kViewHeight - 113);
    
}
// 新鲜事
-(void)secondButtonClickAction:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        self.firstButton.selected = NO;
    } else {
        sender.selected = YES;
        self.firstButton.selected = NO;
    }
    self.tableView.frame = CGRectMake(0, 0, kViewWidth, kViewHeight - 113);
    self.collectView.frame = CGRectMake(kViewWidth, 0, kViewWidth, kViewHeight - 113);
    
}
#pragma mark **********精品汇 新鲜事 主视图****************
-(void)loadMainView
{
    // 精品汇
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 5, 20);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 113) collectionViewLayout:flowLayout];
    self.collectView.backgroundColor = [UIColor whiteColor];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    
    //新鲜事
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kViewWidth, 0, kViewWidth, kViewHeight - 113) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //***************************************************
    
    [self.view addSubview:self.collectView];
    [self.view addSubview:self.tableView];
    // 注册单元格
    [self.collectView registerClass:[JPCollectCell class] forCellWithReuseIdentifier:@"collect"];
    [self.tableView registerClass:[XXTableCell class] forCellReuseIdentifier:@"tableView"];
    
}
#pragma mark ************精品汇 集合视图 代理方法**************
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPModel *model = self.collectArray[indexPath.row];
    JPCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collect" forIndexPath:indexPath];
    cell.titleLable.text = model.name;
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.imageFilename] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JPModel *model = self.collectArray[indexPath.row];
    
    JPCollectVC *collect = [[JPCollectVC alloc] init];
    
    collect.model = model;
    
    [collect setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:collect animated:YES];
    
}
#pragma mark ************新鲜事 表视图 代理方法***************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXModel *model = self.tableArray[indexPath.row];
    XXTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView" forIndexPath:indexPath];
    
    cell.titleLable.text = model.name;
    cell.digestLable.text = model.content;
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.titleImageFile] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXModel *model = self.tableArray[indexPath.row];
    
    XXSRootVC *rootVC = [[XXSRootVC alloc] init];
    
    rootVC.model = model;
    
    [rootVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:rootVC animated:YES];
    
    
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
