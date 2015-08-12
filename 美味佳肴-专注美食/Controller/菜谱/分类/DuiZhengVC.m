//
//  DuiZhengVC.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/8.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "DuiZhengVC.h"
#import "DuiZhengCell.h"
#import "DuiZhengDetailVC.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#import "DuiZhengModel.h"

@interface DuiZhengVC () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DuiZhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self loadMianView]; // 加载视图
    [self requestData]; // 数据请求
    
    
}

#pragma mark ************* 数据请求 *************
- (void)requestData // 数据请求
{
    [SVProgressHUD showWithStatus:@"正在加载中" maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/vegetable/tbldisease!getDisease.do?officeId=%@&is_traditional=0",self.model.nameID];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak DuiZhengVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *dataArray = dict[@"data"];
        for (NSDictionary *dictionary in dataArray) {
            
            DuiZhengModel *model = [[DuiZhengModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.dataArray addObject:model];
        }
        [aSelf.collectionView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark ****************** 布局视图 ********************
- (void)loadMianView // 加载视图
{
    // 替换导航栏左侧的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    // 集合视图的配置
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kViewWidth - 40)/ 2, ((float)50 / (float)667) * kViewHeight);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:192.0 / 255.0 green:180.0 / 255.0 blue:96.0 / 255.0 alpha:0.3];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[DuiZhengCell class] forCellWithReuseIdentifier:@"CELL"];
    
}
#pragma mark ****************** 集合视图的配置 *********************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DuiZhengModel *model = self.dataArray[indexPath.row];
    
    DuiZhengCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.imageName]];
    cell.titleLable.text = model.diseaseName;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DuiZhengModel *model = self.dataArray[indexPath.row];
    
    DuiZhengDetailVC *detailVC = [[DuiZhengDetailVC alloc] init];
    
    detailVC.model = model;
    
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
