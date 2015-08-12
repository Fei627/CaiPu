//
//  OneRootVC.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/24.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "OneRootVC.h"
#import "CategoryVC.h"
#import "DetailVC.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

#import "CaiPuModel.h"


#define kScrollWidth self.scrollView.frame.size.width
#define kScrollHeight self.scrollView.frame.size.height

@interface OneRootVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView; // 轮播图的底视图

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
// 图片名字
@property (nonatomic, copy) NSString *leftName;
@property (nonatomic, copy) NSString *centerName;
@property (nonatomic, copy) NSString *rightName;
@property (nonatomic, strong) NSMutableArray *imageArray; // 存放图片URL的数组

@property (nonatomic, strong) UILabel *nameLable; // 中文名字
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) UILabel *englishLable; // 英文名字
@property (nonatomic, strong) NSMutableArray *englishArray;

@property (nonatomic, strong) NSMutableArray *dataArray; // 数据源数组

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIAlertView *alertView; // 无网络状态的提示框

@end

@implementation OneRootVC

- (UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络无连接" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    }
    return _alertView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}
- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
- (UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
    }
    return _centerImageView;
}
- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}
- (UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
    }
    return _nameLable;
}
- (UILabel *)englishLable
{
    if (!_englishLable) {
        _englishLable = [[UILabel alloc] init];
    }
    return _englishLable;
}

- (void)creatDataArray // 数组开辟空间
{
    self.dataArray = [[NSMutableArray alloc] init];
    self.imageArray = [[NSMutableArray alloc] init];
    self.nameArray = [[NSMutableArray alloc] init];
    self.englishArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菜谱";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatDataArray]; // 数组开辟空间
    [self layoutViews]; // 布局视图
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(beginLunBo) userInfo:nil repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            
            //NSLog(@"未知网络");
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
            [self requestNetWorkData];
            //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(doFinished) userInfo:nil repeats:YES];
            return;
            
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            //NSLog(@"3G网络");
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
            [self requestNetWorkData];
            //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(doFinished) userInfo:nil repeats:YES];
            return;
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            //NSLog(@"WiFi网络");
            [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
            [self requestNetWorkData];
            return;
        }
        else {
            //NSLog(@"网络无连接");
            [self.alertView show];
            return;
        }
    }];

}

#pragma mark ************* 计时器会触发的方法 ***************
- (void)beginLunBo
{
    if (self.imageArray.count == 0) {
        return;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.scrollView.contentOffset = CGPointMake(kViewWidth * 2, 0);
        
        if (self.pageControl.currentPage >= 9) {
            
            self.pageControl.currentPage = 0;
        }
        
        else {
            
            self.pageControl.currentPage ++;
        }
    }];
    
    if (self.scrollView.contentOffset.x == kViewWidth * 2) {
        self.leftName = self.centerName;
        self.centerName = self.rightName;
        
        if ([self getImageName:self.rightName] == self.imageArray.count - 1) {
            
            self.rightName = self.imageArray[0];
            
        } else {
            
            self.rightName = self.imageArray[[self getImageName:self.rightName] + 1];
        }
    }
    
    if (self.scrollView.contentOffset.x == 0) {
        self.rightName = self.centerName;
        self.centerName = self.leftName;
        
        if ([self getImageName:self.leftName] == 0) {
            
            self.leftName = self.imageArray[self.imageArray.count - 1];
            
        } else {
            
            self.leftName = self.imageArray[[self getImageName:self.leftName] - 1];
        }
    }
    
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.centerName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    self.scrollView.contentOffset = CGPointMake(kViewWidth, 0);
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.leftName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.rightName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    self.nameLable.text = self.nameArray[[self getImageName:self.centerName]];
    self.englishLable.text = self.englishArray[[self getImageName:self.centerName]];
}
#pragma mark **************** 数据请求 ******************
- (void)requestNetWorkData // 首页轮播图数据源
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/more/tblcalendaralertinfo!homePageInfo.do?phonetype=2&page=1&pageRecord=10&is_traditional=0"];
    
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak OneRootVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            CaiPuModel *model = [[CaiPuModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.dataArray addObject:model];
        }
        
        [aSelf reciveDataArray:aSelf.dataArray]; // 把数据源数组传出去
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (DetailModel *)detailModelRequsetWithID:(NSString *)idStr
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/vegetable/tblvegetable!getTblVegetables.do?vegetable_id=%@&phonetype=2&user_id=&is_traditional=0",idStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    id tempObj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    NSDictionary *mainDict = (NSDictionary *)tempObj;
    NSArray *mainArray = mainDict[@"data"];
    NSDictionary *dict = mainArray.firstObject;
    DetailModel *model = [[DetailModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
#pragma mark ***************** 布局视图 ******************
- (void)layoutViews
{
#pragma mark ------------ 在导航栏上边的按钮 ----------------
    UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryButton.frame = CGRectMake(0, 0, 25, 25);
    [categoryButton setImage:[UIImage imageNamed:@"category"] forState:UIControlStateNormal];
    [categoryButton addTarget:self action:@selector(categoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:categoryButton];
    
}
#pragma mark ************** 替换数据源数组(轮播图) *****************
- (void)reciveDataArray:(NSMutableArray *)array
{
    for (int i = 0; i < array.count; i ++) {
        
        NSString *urlStr = [array[i] imagePathLandscape];
        [self.imageArray addObject:urlStr];
        
        NSString *nameStr = [array[i] name]; // 中文名字的数据源
        [self.nameArray addObject:nameStr];
        
        NSString *englishStr = [array[i] englishName]; // 英文名字的数据源
        [self.englishArray addObject:englishStr];
    }
    
    self.leftName = self.imageArray[self.imageArray.count - 1];
    self.centerName = self.imageArray[0];
    self.rightName = self.imageArray[1];

//-------------------------------------------------------------------------
    
    self.scrollView.frame = CGRectMake(0, 0, kViewWidth, kViewHeight - 113);
    self.scrollView.contentSize = CGSizeMake(kViewWidth * 3, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(kViewWidth, 0);
    [self.view addSubview:self.scrollView];

// ----------------- 左边的imageView ----------------
    
    // 创建imageView
    self.leftImageView.frame = CGRectMake(0, 0, kScrollWidth, kScrollHeight);
    self.leftImageView.userInteractionEnabled = YES;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.leftName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    [self.scrollView addSubview:self.leftImageView];
    
// ----------------- 中间的imageView ---------------
    
    self.centerImageView.frame = CGRectMake(kViewWidth, 0, kScrollWidth, kScrollHeight);
    self.centerImageView.userInteractionEnabled = YES;
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.centerName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    [self.scrollView addSubview:self.centerImageView];
    
    // 中文名字 lable
    self.nameLable.frame = CGRectMake(20, 30, 120, 20);
    self.nameLable.textAlignment = NSTextAlignmentCenter;
    self.nameLable.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.nameLable];
    self.nameLable.text = self.nameArray[0];
    self.nameLable.textColor = [UIColor purpleColor];
    
    // 英文名字lable
    self.englishLable.frame = CGRectMake(10, 50, 140, 20);
    self.englishLable.textAlignment = NSTextAlignmentCenter;
    self.englishLable.adjustsFontSizeToFitWidth = YES;
    self.englishLable.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.englishLable];
    self.englishLable.text = self.englishArray[0];
    self.englishLable.textColor = [UIColor purpleColor];
    
    // 添加轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickAction)];
    [self.centerImageView addGestureRecognizer:tap];
    
// ------------------ 右边的imageView -------------------
    
    self.rightImageView.frame = CGRectMake(kViewWidth * 2, 0, kScrollWidth, kScrollHeight);
    self.rightImageView.userInteractionEnabled = YES;
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.rightName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    [self.scrollView addSubview:self.rightImageView];
    
    // 添加pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(30, kViewHeight - 64 - 100, kViewWidth - 60, 10)];
    self.pageControl.numberOfPages = 10;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor]; // 选中圆点的颜色
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor]; // 未选中圆点的颜色
    [self.view addSubview:self.pageControl];
    
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
}
#pragma mark ************** 轻拍事件 ****************
- (void)tapClickAction
{
    NSInteger index = [self getImageName:self.centerName];
    //NSLog(@"index ======== %ld",index);
    
    CaiPuModel *model = self.dataArray[index];
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    
    detailVC.model = [self detailModelRequsetWithID:model.vegetable_id];
    
    detailVC.vegetableID = model.vegetable_id;
    
    [detailVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark *************** scrollView delegate ****************
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == kViewWidth * 2) {
        self.leftName = self.centerName;
        self.centerName = self.rightName;
        
        if ([self getImageName:self.rightName] == self.imageArray.count - 1) {
            
            self.rightName = self.imageArray[0];
            
        } else {
            
            self.rightName = self.imageArray[[self getImageName:self.rightName] + 1];
        }
        
        // ---------------------------------------------> pageControl 的操作
        if (self.pageControl.currentPage >= 9) {
            
            self.pageControl.currentPage = 0;
        }
        
        else {
            
            self.pageControl.currentPage ++;
        }
    }
    
    if (scrollView.contentOffset.x == 0) {
        self.rightName = self.centerName;
        self.centerName = self.leftName;
        
        if ([self getImageName:self.leftName] == 0) {
            
            self.leftName = self.imageArray[self.imageArray.count - 1];
            
        } else {
            
            self.leftName = self.imageArray[[self getImageName:self.leftName] - 1];
        }
        
        // ---------------------------------------------> pageControl 的操作
        if (self.pageControl.currentPage == 0) {
            
            self.pageControl.currentPage = 9;
        }
        
        else {
            
            self.pageControl.currentPage --;
        }
    }
    
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.centerName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    self.scrollView.contentOffset = CGPointMake(kViewWidth, 0);
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.leftName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.rightName] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    self.nameLable.text = self.nameArray[[self getImageName:self.centerName]];
    self.englishLable.text = self.englishArray[[self getImageName:self.centerName]];
}

- (NSInteger)getImageName:(NSString *)imageName
{
    for (int i = 0; i < self.imageArray.count; i ++) {
        if ([self.imageArray[i] isEqualToString:imageName]) {
            
            return i;
        }
    }
    return 0;
}
#pragma mark ************** 导航栏按钮的点击 ***************
- (void)categoryButtonClick // 分类按钮的点击
{
    CategoryVC *categoryVC = [[CategoryVC alloc] init];
    
    UINavigationController *navigaC = [[UINavigationController alloc] initWithRootViewController:categoryVC];
    
    [navigaC.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviga"] forBarMetrics:UIBarMetricsDefault];
    
    [self presentViewController:navigaC animated:YES completion:nil];
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
