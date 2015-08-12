//
//  ThreeRootVC.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "ThreeRootVC.h"
#import "TangCollectCell.h"
#import "TangDetailVC.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

#import "TangListModel.h"
#import "TangCollectModel.h"


@interface ThreeRootVC () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) NSMutableArray *sectionArr; // 记录各分区对应的行数的数组
@property (nonatomic, strong) NSMutableArray *openSectionArr; // 记录分区点击状态数组

@property (nonatomic, strong) UICollectionView *collecttionView;
@property (nonatomic, strong) NSMutableArray *collectArray;
@property (nonatomic, assign) NSInteger page; // 用来刷新的参数

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger index; // 用来记录当前点击的分区

@property (nonatomic, assign) NSInteger senderTag;

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation ThreeRootVC

// 重写属性的getter方法
- (BOOL)isSelect
{
    // 这个方法返回的是当前被点击的单元格所在的分区和行数
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (indexPath.row == 0) {
        
        self.index = indexPath.section;
        return YES;
    } else {
        return NO;
    }
}

- (UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无连接" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    }
    return _alertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群汤荟萃";
    self.page = 1;

    [self creatDataArray]; // 为数据源数组开辟空间
    [self layoutMainViews]; // 加载主视图
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            
            //NSLog(@"未知网络");
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
            [self.tableArray removeAllObjects];
            [self.collectArray removeAllObjects];
            [self tableViewRequestData]; // 左边表视图的数据源
            [self collectionViewRequestDataBaseID:@"43"]; // 右边集合视图
            [self updateNetworkData]; // 刷新数据
            
            return;
            
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            //NSLog(@"3G网络");
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
            [self.tableArray removeAllObjects];
            [self.collectArray removeAllObjects];
            [self tableViewRequestData]; // 左边表视图的数据源
            [self collectionViewRequestDataBaseID:@"43"]; // 右边集合视图
            [self updateNetworkData]; // 刷新数据
            
            return;
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];

            [self.tableArray removeAllObjects];
            [self.collectArray removeAllObjects];
            
            [self tableViewRequestData]; // 左边表视图的数据源
            [self collectionViewRequestDataBaseID:@"43"]; // 右边集合视图
            [self updateNetworkData]; // 刷新数据
            
            return;
        }
        else {
            [self.alertView show];
            return;
        }
    }];
}

#pragma mark *************** 接收传出来的数据源数组 ******************
- (void)reciveDataArray:(NSMutableArray *)array
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        TangListModel *model = array[i];
        NSString *str = [NSString stringWithFormat:@"%ld",model.hotwaterArray.count];
        [arr addObject:str];
    }
    
    // 这两个数组是为了存储 每个分区 对应的单元格数量，下边点击区头按钮时，展开收起单元格操作要用到这两个数组
    self.sectionArr = [NSMutableArray arrayWithArray:arr];
    self.openSectionArr = [NSMutableArray arrayWithArray:arr];
}

#pragma mark ***************** 给数据源数组开辟空间 *******************
- (void)creatDataArray // 为数据源数组开辟空间
{
    self.senderTag = 100; // 给它一个初始值 用来作为判断依据
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableArray = [[NSMutableArray alloc] init]; // 开辟空间
    self.collectArray = [[NSMutableArray alloc] init];
}
#pragma mark **************** 刷新数据 *********************
- (void)updateNetworkData
{
    [self.collecttionView addFooterWithTarget:self action:@selector(stepFooter)];
}
- (void)stepFooter
{
    if (self.isSelect) {
        //NSLog(@" index ============ %ld",self.index);
        if (self.senderTag != 100) {
            
            TangListModel *model = self.tableArray[self.senderTag];
            self.page += 1;
            [self collectionViewRequestDataBaseID:model.listID];
        }
        else {
            
            TangListModel *model = self.tableArray[self.index];
            self.page += 1;
            [self collectionViewRequestDataBaseID:model.listID];
        }
        
    } else {
        
        [self.collecttionView footerEndRefreshing];
        return;
    }
}
#pragma mark **************** 请求数据 *********************
- (void)tableViewRequestData // 左边表视图的数据源
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/more/hotwater!getHotwaterClass.do?is_traditional=0"];
    
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak ThreeRootVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            TangListModel *model = [[TangListModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.tableArray addObject:model];
            
        }
        
        [aSelf reciveDataArray:aSelf.tableArray]; // 把数据源数组传出去
        [aSelf.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)collectionViewRequestDataBaseID:(NSString *)listID // 右边集合视图的数据源 (显示全部)
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/more/hotwater!getHotwaterList.do?id=%@&page=%ld&pageRecord=8&is_traditional=0",listID,self.page];
    
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak ThreeRootVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            TangCollectModel *model = [[TangCollectModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.collectArray addObject:model];
        }
        
        [aSelf.collecttionView reloadData];
        [aSelf.collecttionView footerEndRefreshing];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)requestPartDataBaseDetailID:(NSString *)detailID // 请求分类单独的数据
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/more/hotwater!getHotwaterClassList.do?id=%@&is_traditional=0&page=1&pageRecord=10",detailID];

    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak ThreeRootVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            TangCollectModel *model = [[TangCollectModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.collectArray addObject:model];
        }
        
        [aSelf.collecttionView reloadData];
        [aSelf.collecttionView footerEndRefreshing];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark ***************** 布局主视图 ********************
- (void)layoutMainViews // 加载主视图
{
    // 左边的tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth / 3, kViewHeight - 113) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    // 右边的集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(((kViewWidth - (kViewWidth / 3)) - 30) / 2, ((kViewWidth - (kViewWidth / 3)) - 30) / 2 + 30);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collecttionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kViewWidth / 3, 0, kViewWidth - (kViewWidth / 3), kViewHeight - 113) collectionViewLayout:flowLayout];
    self.collecttionView.backgroundColor = [UIColor grayColor];
    self.collecttionView.delegate = self;
    self.collecttionView.dataSource = self;
    self.collecttionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collecttionView];
    [self.collecttionView registerClass:[TangCollectCell class] forCellWithReuseIdentifier:@"collect"];
    
}
#pragma mark ****************** 表视图的配置 *********************
// 自定义分区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.tag = 200 + section;
    aButton.backgroundColor = [UIColor colorWithRed:226.0 / 255.0 green:215.0 / 255.0 blue:196.0 / 255.0 alpha:1.0];
    [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aButton setTitle:[self.tableArray[section] name] forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    aButton.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
    [aButton addTarget:self action:@selector(aButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return aButton;
}
// 区头按钮的点击
- (void)aButtonClickAction:(UIButton *)sender
{
#warning 第一个分区要特殊处理 因为第一次进入界面 它是展开着的 所以打开方法跟关闭方法相反
    if (sender.tag == 200) {
        
        // 打开
        if ([[self.sectionArr objectAtIndex:sender.tag - 200] integerValue] == 1) {
            
            [self.sectionArr replaceObjectAtIndex:sender.tag - 200 withObject:@"0"];
            self.senderTag = sender.tag - 200;
            self.page = 1;
            [self.collectArray removeAllObjects];
            TangListModel *model = self.tableArray[sender.tag - 200];
            [self collectionViewRequestDataBaseID:model.listID];

            //NSLog(@"%ld打开",sender.tag);
        }
        
        // 关闭
        else {
            
            [self.sectionArr replaceObjectAtIndex:sender.tag - 200 withObject:@"1"];
            
            //NSLog(@"%ld关闭",sender.tag);
        }

    }
#warning 剩下的分区正常处理
    else {
        
        // 关闭
        if ([[self.sectionArr objectAtIndex:sender.tag - 200] integerValue] == 1) {
            
            [self.sectionArr replaceObjectAtIndex:sender.tag - 200 withObject:@"0"];
            //NSLog(@"%ld关闭",sender.tag);
        }
        
        // 打开
        else {
            
            [self.sectionArr replaceObjectAtIndex:sender.tag - 200 withObject:@"1"];
            
            self.senderTag = sender.tag - 200;
            self.page = 1;
            [self.collectArray removeAllObjects];
            TangListModel *model = self.tableArray[sender.tag - 200];
            [self collectionViewRequestDataBaseID:model.listID];
            //NSLog(@"%ld打开",sender.tag);
        }
    }
    
    [self.tableView reloadData];
}
// 自定义区尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *aLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0.1)];
    aLable.backgroundColor = [UIColor whiteColor];
    return aLable;
}
// 设置区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
// 设置区尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
// 分区的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableArray.count;
}
// 分区对应的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if ([[self.sectionArr objectAtIndex:section] integerValue] == 1) {
            return 0;
        }
        
        return [self.openSectionArr[section] integerValue];
    }
    
    else {
        
        if ([[self.sectionArr objectAtIndex:section] integerValue] == 1) {
            
            return [self.openSectionArr[section] integerValue];
        }
        
        return 0;
    }
}
// 重用机制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TangListModel *model = self.tableArray[indexPath.section];
    TangListDetailModel *detailModel = model.hotwaterArray[indexPath.row];
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    cell.textLabel.text = detailModel.name;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}
// 点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"section = %ld ------- row = %ld",indexPath.section,indexPath.row);
    
    [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];

    TangListModel *model = self.tableArray[indexPath.section];
    
    TangListDetailModel *detailModel = model.hotwaterArray[indexPath.row];
    
    if (indexPath.row == 0) {
        
        self.page = 1;
        [self collectionViewRequestDataBaseID:model.listID]; // 显示全部
        
    } else {
        
        [self requestPartDataBaseDetailID:detailModel.detailID];
    }
    
    [self.collectArray removeAllObjects];
}
#pragma mark ************** 集合视图的配置 **********************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TangCollectModel *model = self.collectArray[indexPath.row];
    
    TangCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collect" forIndexPath:indexPath];
    
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.imageFilename] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    cell.nameLable.text = model.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%ld",indexPath.row);
    TangCollectModel *model = self.collectArray[indexPath.row];
    
    TangDetailVC *detailVC = [[TangDetailVC alloc] init];
    
    [detailVC setHidesBottomBarWhenPushed:YES];
    
    detailVC.model = model;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
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
