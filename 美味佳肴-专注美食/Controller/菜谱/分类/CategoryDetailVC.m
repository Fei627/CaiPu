//
//  CategoryDetailVC.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "CategoryDetailVC.h"
#import "DetailCollectCell.h"
#import "DetailVC.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"

#import "CategoryDetailModel.h"
//#import "DetailModel.h"

@interface CategoryDetailVC () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger maxPageNumber;
@property (nonatomic, assign) NSInteger number;

@end

@implementation CategoryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.name;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init]; // 开辟空间
    self.number = 1;
    
    [self loadMainView]; // 加载视图
    [self requestData]; // 数据请求
    [self updateNetworkData]; // 刷新数据
    
}

#pragma mark *********** 刷新数据 ***********
- (void)updateNetworkData
{
    [self.collectView addFooterWithTarget:self action:@selector(stepFooter)];
}

- (void)stepFooter
{
    if (self.number > self.maxPageNumber) {
        
        [self.collectView footerEndRefreshing];
        return;
    }
    
    self.number ++;
    [self requestData];
}
#pragma mark ************** 数据请求 ***********
- (void)requestData
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];

    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/home/tblAssort!getVegetable.do?id=%@&page=%ld&pageRecord=10&is_traditional=0&phonetype=1",self.model.nameID,self.number];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak CategoryDetailVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            
            CategoryDetailModel *model = [[CategoryDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.dataArray addObject:model];
        }
        
        NSDictionary *beanDict = dict[@"bean"];
        self.maxPageNumber = [beanDict[@"maxPageNumber"] integerValue];
        
        [aSelf.collectView reloadData];
        [aSelf.collectView footerEndRefreshing];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (DetailModel *)detailModelRequestBaseID:(NSString *)ID
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/vegetable/tblvegetable!getTblVegetables.do?vegetable_id=%@&phonetype=2&user_id=&is_traditional=0",ID];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    id tempObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *mainDict = (NSDictionary *)tempObject;
    
    NSArray *mainArray = mainDict[@"data"];
    
    NSDictionary *dict = mainArray.firstObject;

    DetailModel *model = [[DetailModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
    
}
#pragma mark ******************* 加载视图 ******************
- (void)loadMainView // 加载视图
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
#pragma mark ********************* 集合视图的配置 *********************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailModel *model = self.dataArray[indexPath.row];
    
    DetailCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    cell.titleLable.text = model.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailModel *model = self.dataArray[indexPath.row];
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    
    detailVC.vegetableID = model.ID;
    
    detailVC.model = [self detailModelRequestBaseID:model.ID];
    
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
