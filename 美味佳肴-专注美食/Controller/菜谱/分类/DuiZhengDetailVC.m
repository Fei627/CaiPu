//
//  DuiZhengDetailVC.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/8.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "DuiZhengDetailVC.h"
#import "DetailCollectCell.h"
#import "DetailVC.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "DuiZhengDetailModel.h"


#define kBottomWidth self.bottomView.frame.size.width
#define kBottomHeight self.bottomView.frame.size.height

#define kScrollHeight self.scrollView.frame.size.height


@interface DuiZhengDetailVC () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView; // 底视图

@property (nonatomic, strong) UIView *bottomView; // 描述症状的底视图
@property (nonatomic, strong) UILabel *describeLable;// 病症简介lable
@property (nonatomic, strong) UILabel *fitEatLable; // 饮食保健 lable
@property (nonatomic, strong) UILabel *lifeSuitLable; // 生活保健lable

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger maxPageNumber;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation DuiZhengDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.diseaseName;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    
    [self loadMainView]; // 布局视图
    [self requestData];
    [self updateData];
    
}

#pragma mark ************* 刷新数据 ***********
- (void)updateData
{
    [self.collectionView addFooterWithTarget:self action:@selector(stepFooter)];
}

- (void)stepFooter
{
    if (self.currentPage > self.maxPageNumber) {
        
        [self.collectionView footerEndRefreshing];
        return;
    }
    self.currentPage ++;
    [self requestData];
}
#pragma mark ************* 数据请求 *************
- (void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/vegetable/tbldisease!getVegetable.do?diseaseId=%@&page=%ld&pageRecord=8&phonetype=0&is_traditional=0",self.model.diseaseId,self.currentPage];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak DuiZhengDetailVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *dataArray = dict[@"data"];
        for (NSDictionary *dictionary in dataArray) {
            
            DuiZhengDetailModel *model = [[DuiZhengDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.dataArray addObject:model];
        }
        
        NSDictionary *beanDict = dict[@"bean"];
        self.maxPageNumber = [beanDict[@"maxPageNumber"] integerValue];
        
        [aSelf.collectionView reloadData];
        [self.collectionView footerEndRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (DetailModel *)detailModelRequestDataBaseVegetableId:(NSString *)ID
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/vegetable/tblvegetable!getTblVegetables.do?vegetable_id=%@&phonetype=2&user_id=&is_traditional=0",ID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    id tempObj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dict = (NSDictionary *)tempObj;
    
    NSArray *mainArray = dict[@"data"];
    NSDictionary *mainDict = mainArray.firstObject;
    
    DetailModel *model = [[DetailModel alloc] init];
    [model setValuesForKeysWithDictionary:mainDict];
    
    return model;
}
#pragma mark *************** 布局视图 ******************
- (void)loadMainView
{
    // 替换导航栏左侧的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    // 底视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(0, kViewHeight);
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    // 描述症状的底视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, kViewWidth - 10, 100)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:192.0 / 255.0 green:180.0 / 255.0 blue:96.0 / 255.0 alpha:0.3];
    [self.scrollView addSubview:self.bottomView];

    // 病症简介
    
    self.describeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kBottomWidth, 80)];
    self.describeLable.font = [UIFont systemFontOfSize:14];
    self.describeLable.numberOfLines = 0;
    self.describeLable.text = self.model.diseaseDescribe;
    [self.bottomView addSubview:self.describeLable];
    
    // 饮食保健
    
    self.fitEatLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.fitEatLable.font = [UIFont systemFontOfSize:14];
    self.fitEatLable.numberOfLines = 0;
    self.fitEatLable.text = self.model.fitEat;
    [self.bottomView addSubview:self.fitEatLable];
    
    // 生活保健
    
    self.lifeSuitLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.lifeSuitLable.font = [UIFont systemFontOfSize:14];
    self.lifeSuitLable.numberOfLines = 0;
    self.lifeSuitLable.text = self.model.lifeSuit;
    [self.bottomView addSubview:self.lifeSuitLable];
    
    self.bottomView.frame = CGRectMake(5, 0, kViewWidth - 10, 100);
    
    // “详情按钮”
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kBottomWidth - 40, kBottomHeight - 20, 40, 20);
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"详情" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [self.bottomView addSubview:button];
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kViewWidth - 30) / 2, ((float)120 / (float)667) * kViewHeight);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 110, kViewWidth, kViewHeight - 64 - 110) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.scrollView addSubview:self.collectionView];
    
    //注册单元格
    [self.collectionView registerClass:[DetailCollectCell class] forCellWithReuseIdentifier:@"CELL"];
}
#pragma mark **************** 计算字符串高度 ****************
- (CGFloat)getHeightWithstring:(NSString *)string
{
    //获取字符串显示的高度
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGRect rect=[string boundingRectWithSize:CGSizeMake(kViewWidth - 10, 100000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return rect.size.height;
}
#pragma mark ************** “详情”按钮的点击 ***************
- (void)buttonClickAction:(UIButton *)sender
{
    CGFloat height1 = [self getHeightWithstring:self.model.diseaseDescribe];
    CGFloat height2 = [self getHeightWithstring:self.model.fitEat];
    CGFloat height3 = [self getHeightWithstring:self.model.lifeSuit];

    if (sender.selected) {
        
        //NSLog(@"收起");
        [UIView animateWithDuration:0.5f animations:^{
            
            self.lifeSuitLable.frame = CGRectMake(0, 0, 0, 0);
            self.fitEatLable.frame = CGRectMake(0, 0, 0, 0);
            self.describeLable.frame = CGRectMake(0, 10, kBottomWidth, 80);
            self.bottomView.frame = CGRectMake(5, 0, kViewWidth - 10, 100);
            sender.frame = CGRectMake(kBottomWidth - 40, kBottomHeight - 20, 40, 20);
            self.collectionView.frame = CGRectMake(0, kBottomHeight + 10, kViewWidth, kViewHeight - kBottomHeight - 10 - 64);
            sender.selected = NO;

        }];
        
    } else {
        
        //NSLog(@"展开");
        [UIView animateWithDuration:0.5f animations:^{
            
            self.lifeSuitLable.frame = CGRectMake(0, height1 + height2 + 40, kBottomWidth, height3);
            self.fitEatLable.frame = CGRectMake(0, height1 + 20, kBottomWidth, height2);
            self.describeLable.frame = CGRectMake(0, 10, kBottomWidth, height1);
            self.bottomView.frame = CGRectMake(5, 0, kViewWidth - 10, height1 + height2 + height3 + 60);
            sender.frame = CGRectMake(kBottomWidth - 40, kBottomHeight - 20, 40, 20);
            self.collectionView.frame = CGRectMake(0, kBottomHeight + 10, kViewWidth, kViewHeight - kBottomHeight - 10 - 64);
            sender.selected = YES;

        }];
    }
}
#pragma mark ************** 集合视图的配置 ***************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DuiZhengDetailModel *model = self.dataArray[indexPath.row];
    
    DetailCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.imagePathLandscape] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    cell.titleLable.text = model.name;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DuiZhengDetailModel *model = self.dataArray[indexPath.row];
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    
    detailVC.vegetableID = model.vegetableId;
    
    detailVC.model = [self detailModelRequestDataBaseVegetableId:model.vegetableId];
    
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
