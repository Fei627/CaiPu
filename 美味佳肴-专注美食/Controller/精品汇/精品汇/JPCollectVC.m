//
//  JPCollectVC.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "JPCollectVC.h"

#import "DetailCollectCell.h"
#import "DetailVC.h"

//第三方
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

//数据模型
#import "DetailModel.h"


@interface JPCollectVC () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger number;

@end

@implementation JPCollectVC

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.model.name;
    self.number = 1;
    
    [self loadCollectionView];//加载集合视图
    [self requestData];
    [self upDate];
}

#pragma mark ***********刷新数据**************
-(void)upDate
{
    [self.collectView addFooterWithTarget:self action:@selector(stepFooter)];
}
-(void)stepFooter
{
    [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
    if (self.number == 10) {
        self.collectView.footerPullToRefreshText = @"已经是最后一条了亲····";
        self.collectView.footerRefreshingText = @"已经是最后一条了亲····";
        self.collectView.footerReleaseToRefreshText = @"已经是最后一条了亲····";
        [self.collectView footerEndRefreshing];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        return;
    }
    self.number += 1;
    [self requestData];
}
#pragma mark ***********数据请求***************
-(void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.84.91:80/HandheldKitchen/api/found/tblBoutique!getTblBoutiqueVegetableList.do?is_traditional=0&page=%ld&pageRecord=10&phonetype=0&user_id=0&typeId=%@",self.number,self.model.jpID];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak JPCollectVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            DetailModel *model = [[DetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.dataArray addObject:model];
        }
        [aSelf.collectView reloadData];
        [aSelf.collectView footerEndRefreshing];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark ***********加载集合视图***************
-(void)loadCollectionView
{
    // 替换导航栏左侧的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    // 集合视图的配置
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kViewWidth - 30) / 2, ((float)120 / (float)667) * kViewHeight);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64) collectionViewLayout:flowLayout];
    self.collectView.backgroundColor = [UIColor whiteColor];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    [self.view addSubview:self.collectView];
    
    //注册单元格
    [self.collectView registerClass:[DetailCollectCell class] forCellWithReuseIdentifier:@"CELL"];
    
}
#pragma mark ***********集合视图 代理方法*************
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel *model = self.dataArray[indexPath.row];
    
    DetailCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.imagePathLandscape] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    cell.titleLable.text = model.name;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel *model = self.dataArray[indexPath.row];
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    
    detailVC.model = model;
    
    detailVC.vegetableID = model.vegetable_id;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
