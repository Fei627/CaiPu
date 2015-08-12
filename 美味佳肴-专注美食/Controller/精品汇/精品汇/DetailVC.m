    //
//  DetailVC.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/7/25.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "DetailVC.h"
#import "TableCell.h"
#import "XXSRootVC.h"

//第三方
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"

//数据模型
#import "BuZhouModel.h"
#import "CaiLiaoModel.h"
#import "ChangShiModel.h"
#import "XiangYiModel.h"

//封装
#import "PackageView.h"

#import <MediaPlayer/MediaPlayer.h>


#define kScrollHeight self.mainScrollView.frame.size.height

@interface DetailVC () <UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) UIView *playerView;// 播放器视图
@property (nonatomic, strong) MPMoviePlayerViewController *player;

@property (nonatomic, strong) UIView *barView;// 中间的标签索引索引视图
@property (nonatomic, strong) UIButton *oneButton;
@property (nonatomic, strong) UIButton *twoButton;
@property (nonatomic, strong) UIButton *threeButton;
@property (nonatomic, strong) UIButton *fourButton;
@property (nonatomic, strong) NSArray *titleArray;// 盛放button标题的数组

@property (nonatomic, strong) UIScrollView *mainScrollView;// 底视图
@property (nonatomic, strong) UITableView *oneTabelView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, strong) UIScrollView *twoScrollView;
@property (nonatomic, strong) NSMutableArray *twoArray;

@property (nonatomic, strong) UIScrollView *threeScrollView;
@property (nonatomic, strong) NSMutableArray *threeArray;

@property (nonatomic, strong) UIScrollView *fourScrollView;
@property (nonatomic, strong) NSMutableArray *fourArray;

@property (nonatomic, strong) UIView *bottomView;// 最下边标签视图

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation DetailVC

- (void)dealloc //移除通知 要在dealloc方法里
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:self];
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [[NSArray alloc] init];
    }
    return _titleArray;
}

-(NSMutableArray *)tableArray
{
    if (!_tableArray) {
        _tableArray = [[NSMutableArray alloc] init];
    }
    return _tableArray;
}

-(NSMutableArray *)twoArray
{
    if (!_twoArray) {
        _twoArray = [[NSMutableArray alloc] init];
    }
    return _twoArray;
}

-(NSMutableArray *)threeArray
{
    if (!_threeArray) {
        _threeArray = [[NSMutableArray alloc] init];
    }
    return _threeArray;
}

-(NSMutableArray *)fourArray
{
    if (!_fourArray) {
        _fourArray = [[NSMutableArray alloc] init];
    }
    return _fourArray;
}

- (UIAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"已经收藏" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    }
    return _alertView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.model.name;
    
    [self layoutViews];// 加载底视图
    [self oneTableViewrequestData];// 制作步骤的数据源
    [self twoScrollViewRequestData];// 所需材料的数据源
    [self threeScrollViewRequestData];// 相关常识的数据源
    [self fourScrollViewRequestData];// 相宜相克的数据源
    [self addItemToPlayerView]; // 播放器视图
    
}

#pragma mark *********** 计时器绑定的方法 ***********
- (void)timeOver
{
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark *************数据请求*****************
-(void)oneTableViewrequestData // 制作步骤的数据源
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/vegetable/tblvegetable!getIntelligentChoice.do?vegetable_id=%@&type=2&phonetype=0&is_traditional=0",self.vegetableID];
    
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak DetailVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        for (NSDictionary *dictionary in mainArray) {
            BuZhouModel *model = [[BuZhouModel alloc] init];
            [model setValuesForKeysWithDictionary:dictionary];
            [aSelf.tableArray addObject:model];
        }
        [aSelf.oneTabelView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)twoScrollViewRequestData // 所需材料的数据源
{
    NSString *urlStr =[NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/vegetable/tblvegetable!getIntelligentChoice.do?vegetable_id=%@&type=1&phonetype=0&is_traditional=0",self.vegetableID];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak DetailVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        CaiLiaoModel *model = [[CaiLiaoModel alloc] init];
        [model setValuesForKeysWithDictionary:mainArray.lastObject];
        [aSelf.twoArray addObject:model];
        
        [aSelf addImageViewToTwoScrollView:aSelf.twoArray];
//        NSLog(@"%ld",aSelf.twoArray.count);
//        for (int i = 0; i < model.imageArray.count; i ++) {
//            NSLog(@"%@",[model.imageArray[i] imagePath]);
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)threeScrollViewRequestData // 相关常识的数据源
{
    NSString *urlStr =[NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/vegetable/tblvegetable!getIntelligentChoice.do?vegetable_id=%@&type=4&phonetype=0&is_traditional=0",self.vegetableID];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak DetailVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        ChangShiModel *model = [[ChangShiModel alloc] init];
        [model setValuesForKeysWithDictionary:mainArray.lastObject];
        [aSelf.threeArray addObject:model];
        
        [aSelf addItemToThreeScrollView:aSelf.threeArray]; // 将请求下来的数据源数组传出去
        //        NSLog(@"%ld",aSelf.twoArray.count);
        //        for (int i = 0; i < model.imageArray.count; i ++) {
        //            NSLog(@"%@",[model.imageArray[i] imagePath]);
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)fourScrollViewRequestData // 相宜相克的数据源
{
    NSString *urlStr =[NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/vegetable/tblvegetable!getIntelligentChoice.do?vegetable_id=%@&type=3&phonetype=0&is_traditional=0",self.vegetableID];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak DetailVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        
        for (NSDictionary *dict in mainArray) {

            XiangYiModel *model = [[XiangYiModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [aSelf.fourArray addObject:model];
        }
        
        [aSelf addItemToFourScrollView:aSelf.fourArray]; // 将请求下来的数据源数组传出去
        //        NSLog(@"%ld",aSelf.twoArray.count);
        //        for (int i = 0; i < model.imageArray.count; i ++) {
        //            NSLog(@"%@",[model.imageArray[i] imagePath]);
        //        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark *************布局视图******************
-(void)layoutViews // 加载底视图
{
    // 替换导航栏左侧的返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    // 播放器视图
    self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, ((float)200 / (float)667) * kViewHeight)];
    [self.view addSubview:self.playerView];
    
    // 标签索引
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, ((float)200 / (float)667) * kViewHeight, kViewWidth, 40)];
    self.barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.barView];
    
    // 索引上边的按钮
    self.titleArray = @[@"制作步骤",@"所需材料",@"相关常识",@"相宜相克"];
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kViewWidth / 4) * i, 0, kViewWidth / 4, 40);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.barView addSubview:button];
        [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.oneButton = button;
            self.oneButton.selected = YES;
            self.oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        } else if (i == 1) {
            self.twoButton = button;
        } else if (i == 2) {
            self.threeButton = button;
        } else {
            self.fourButton = button;
        }
    }
    
    // 底视图
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ((float)200 / (float)667) * kViewHeight + 40, kViewWidth, kViewHeight - (((float)200 / (float)667) * kViewHeight + 40) - 64 - 40)];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.contentSize = CGSizeMake(4 * kViewWidth, 0);
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];

    // 底视图上边的子视图
    // <1>
    self.oneTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kScrollHeight) style:UITableViewStylePlain];
    self.oneTabelView.rowHeight = ((float)200 / (float)667) * kViewHeight;
    self.oneTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.oneTabelView.delegate = self;
    self.oneTabelView.dataSource = self;
    [self.mainScrollView addSubview:self.oneTabelView];
    [self.oneTabelView registerClass:[TableCell class] forCellReuseIdentifier:@"ONE"];
    // <2>
    self.twoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kViewWidth, 0, kViewWidth, kScrollHeight)];
    self.twoScrollView.contentSize = CGSizeMake(0, kScrollHeight *2);
    self.twoScrollView.backgroundColor = [UIColor colorWithRed:192/256.0 green:180/256.0 blue:96/256.0 alpha:0.7];
    [self.mainScrollView addSubview:self.twoScrollView];
    // <3>
    self.threeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kViewWidth * 2, 0, kViewWidth, kScrollHeight)];
    self.threeScrollView.backgroundColor = [UIColor colorWithRed:192/256.0 green:180/256.0 blue:96/256.0 alpha:0.7];
    self.threeScrollView.contentSize = CGSizeMake(0, kScrollHeight * 3);
    [self.mainScrollView addSubview:self.threeScrollView];
    
    // <4>
    self.fourScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kViewWidth * 3, 0, kViewWidth, kScrollHeight)];
    self.fourScrollView.backgroundColor = [UIColor colorWithRed:192/256.0 green:180/256.0 blue:96/256.0 alpha:0.7];
    self.fourScrollView.contentSize = CGSizeMake(0, kScrollHeight * 2);
    [self.mainScrollView addSubview:self.fourScrollView];
    
    // 最下边标签视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kViewHeight - 64 - 40, kViewWidth, 40)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    // 在标签视图上添加按钮
    // 收藏
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(20, 8, 25, 25);
    [aButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [aButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [self.bottomView addSubview:aButton];
    
    [[DataBaseManager shareDataBaseManager] openDB];
    
    NSArray *dataArray = [[DataBaseManager shareDataBaseManager] selectAll];
    for (DetailModel *model in dataArray) {
        
        if ([model.name isEqualToString:self.model.name]) {
            
            [aButton setImage:[UIImage imageNamed:@"collect1"] forState:UIControlStateNormal];
            break;
        }
        else {
            
            [aButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        }
    }

    // 分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(kViewWidth - 45, 8, 25, 25);
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:shareButton];
    
}
-(void)addImageViewToTwoScrollView:(NSMutableArray *)array // 所需材料视图 添加imageView
{
    CaiLiaoModel *clModel = self.twoArray.lastObject;
    
    UILabel *firstLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 40)];
    firstLable.textAlignment = NSTextAlignmentLeft;
    firstLable.font = [UIFont boldSystemFontOfSize:18];
    firstLable.textColor = [UIColor purpleColor];
    firstLable.text = @"原料：";
    [self.twoScrollView addSubview:firstLable];
    
    UILabel *aLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, kViewWidth - 100, 40)];
    aLable.font = [UIFont boldSystemFontOfSize:12];
    aLable.numberOfLines = 0;
    [self.twoScrollView addSubview:aLable];
    aLable.text = self.model.fittingRestriction;
    
    UIImageView *constImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, kViewWidth - 60, ((float)200 / (float)667) * kViewHeight)];
    [constImageView sd_setImageWithURL:[NSURL URLWithString:clModel.imagePath] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    [self.twoScrollView addSubview:constImageView];
    
    UILabel *secondLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 55 + ((float)200 / (float)667) * kViewHeight, 60, 50)];
    secondLable.font = [UIFont boldSystemFontOfSize:18];
    secondLable.textColor = [UIColor purpleColor];
    secondLable.text = @"调料：";
    [self.twoScrollView addSubview:secondLable];
    
    UILabel *bLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 55 + ((float)200 / (float)667) * kViewHeight, kViewWidth - 100, 50)];
    bLable.font = [UIFont boldSystemFontOfSize:12];
    bLable.numberOfLines = 0;
    [self.twoScrollView addSubview:bLable];
    bLable.text = self.model.method;
    
    self.twoScrollView.contentSize = CGSizeMake(0, 310 + ((((float)200 / (float)667) * kViewHeight+ 10) * clModel.imageArray.count));
    for (int i = 0; i < clModel.imageArray.count; i ++) {
        UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 110 + ((float)200 / (float)667) * kViewHeight + ((((float)200 / (float)667) * kViewHeight + 10) * i), kViewWidth - 60, ((float)200 / (float)667) * kViewHeight)];
        [aImageView sd_setImageWithURL:[NSURL URLWithString:[clModel.imageArray[i] imagePath]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        [self.twoScrollView addSubview:aImageView];
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 20)];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.font = [UIFont boldSystemFontOfSize:13];
        nameLable.text = [clModel.imageArray[i] name];
        [aImageView addSubview:nameLable];
    }
}
-(void)addItemToThreeScrollView:(NSMutableArray *)array // 相关常识视图
{
    ChangShiModel *model = array.lastObject;
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((float)100 / (float)375) * kViewWidth, 20, kViewWidth - 2 * (((float)100 / (float)375) * kViewWidth), ((float)130 / (float)667) * kViewHeight)];
    [titleImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    [self.threeScrollView addSubview:titleImageView];
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(((float)130 / (float)667) * kViewHeight) + 40, kViewWidth, 300)];
    bottomImageView.image = [UIImage imageNamed:@"bottom"];
    [self.threeScrollView addSubview:bottomImageView];
    
    UILabel *firstLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, bottomImageView.frame.size.width - 60, 120)];
    firstLable.font = [UIFont boldSystemFontOfSize:14];
    firstLable.text = model.nutritionAnalysis;
    firstLable.numberOfLines = 0;
    [bottomImageView addSubview:firstLable];
    
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, kViewWidth - 10, 1)];
    lineLable.adjustsFontSizeToFitWidth = YES;
    lineLable.backgroundColor = [UIColor purpleColor];
    lineLable.textColor = [UIColor greenColor];
    [bottomImageView addSubview:lineLable];
    
    UILabel *aLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 80, 20)];
    aLable.text = @"制作指导";
    aLable.layer.cornerRadius = 10;
    aLable.layer.masksToBounds = YES;
    aLable.font = [UIFont boldSystemFontOfSize:16];
    aLable.textAlignment = NSTextAlignmentCenter;
    aLable.backgroundColor = [UIColor grayColor];
    [bottomImageView addSubview:aLable];
    
    UILabel *secondLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, bottomImageView.frame.size.width - 60, 120)];
    secondLable.font = [UIFont boldSystemFontOfSize:14];
    secondLable.numberOfLines = 0;
    secondLable.textAlignment = NSTextAlignmentJustified;
    secondLable.text = model.productionDirection;
    [bottomImageView addSubview:secondLable];
    
    self.threeScrollView.contentSize = CGSizeMake(0, (((float)130 / (float)667) * kViewHeight) + 40 + 300);
    
}
-(void)addItemToFourScrollView:(NSMutableArray *)array // 相宜相克视图
{
    XiangYiModel *firstModel = array.firstObject;
    XiangYiModel *secondModel = array.lastObject;
    
    // 相宜
    XiangYiView *xiangyiView = [[XiangYiView alloc] initWithFrame:CGRectMake(20, 10, kViewWidth - 40, 30)];
    xiangyiView.leftLable.text = @"相宜";
    NSString *str = [NSString stringWithFormat:@"%@与下列食物相宜",firstModel.materialName];
    xiangyiView.centerLable.text = str;
    [xiangyiView.rightImageView sd_setImageWithURL:[NSURL URLWithString:firstModel.imageName]];
    [self.fourScrollView addSubview:xiangyiView];
    
    for (int i = 0; i < firstModel.FitArray.count; i ++) {

        PackageView *aPackView = [[PackageView alloc] initWithFrame:CGRectMake(20, 60 + (45 * i), kViewWidth - 40, 40)];
        [aPackView.leftImageView sd_setImageWithURL:[NSURL URLWithString:[firstModel.FitArray[i] imageName]]];
        aPackView.leftLable.text = [firstModel.FitArray[i] materialName];
        aPackView.rightLable.text = [firstModel.FitArray[i] contentDescription];
        [self.fourScrollView addSubview:aPackView];
    }
    
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20 + 60 + 45 *(firstModel.FitArray.count - 1) + 40, kViewWidth - 20, 1)];
    lineLable.backgroundColor = [UIColor purpleColor];
    [self.fourScrollView addSubview:lineLable];
    
    // 相克
    XiangYiView *xiangkeView = [[XiangYiView alloc] initWithFrame:CGRectMake(20, 20 + 120 + 45 *(firstModel.FitArray.count - 1), kViewWidth - 40, 30)];
    xiangkeView.leftLable.text = @"相克";
    
    if (secondModel.GramArray.count != 0) {

        NSString *str1 = [NSString stringWithFormat:@"%@与下列食物相克",secondModel.materialName];
        xiangkeView.centerLable.text = str1;
        [xiangkeView.rightImageView sd_setImageWithURL:[NSURL URLWithString:secondModel.imageName]];
        
        // 相克的内容
        for (int i = 0; i < secondModel.GramArray.count; i ++) {
            
            PackageView *bPackageView = [[PackageView alloc] initWithFrame:CGRectMake(20, 190 + 45 *(firstModel.FitArray.count - 1) + 45 * i, kViewWidth - 40, 40)];
            [bPackageView.leftImageView sd_setImageWithURL:[NSURL URLWithString:[secondModel.GramArray[i] imageName]]];
            bPackageView.leftLable.text = [secondModel.GramArray[i] materialName];
            bPackageView.rightLable.text = [secondModel.GramArray[i] contentDescription];
            [self.fourScrollView addSubview:bPackageView];
        }
        
    } else {
        xiangkeView.centerLable.text = @"无相克内容";;
        xiangkeView.rightImageView.backgroundColor = [UIColor whiteColor];
    }
    [self.fourScrollView addSubview:xiangkeView];
    xiangkeView.leftLable.backgroundColor = [UIColor colorWithRed:158/256.0 green:15/256.0 blue:24/256.0 alpha:0.8];
    xiangkeView.centerLable.textColor = [UIColor colorWithRed:158/256.0 green:15/256.0 blue:24/256.0 alpha:0.7];
    
    self.fourScrollView.contentSize = CGSizeMake(0, 20 + 49 + 190 + 45 * (firstModel.FitArray.count - 1) + 45 * (secondModel.GramArray.count - 1));
    
}
-(void)addItemToPlayerView // 播放器视图
{
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:self.playerView.frame];
    [aImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imagePathThumbnails] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    aImageView.userInteractionEnabled = YES;
    [self.playerView addSubview:aImageView];
    
    UIImageView *bImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    bImageView.center = CGPointMake(aImageView.frame.size.width / 2, aImageView.frame.size.height / 2);
    bImageView.image = [UIImage imageNamed:@"play"];
    [self.playerView addSubview:bImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickAction)];
    [self.playerView addGestureRecognizer:tap];
    
    // 使用 通知中心 监察播放状态，当播完当前视频时 切换下一个视频
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
}
#pragma mark ***************索引上边的按钮 点击事件***********
-(void)buttonClickAction:(UIButton *)sender
{
    if (sender == self.oneButton) {                 // --------->制作步骤
        self.oneButton.selected = YES;
        self.twoButton.selected = NO;
        self.threeButton.selected = NO;
        self.fourButton.selected = NO;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.twoButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.threeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.fourButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
        
    } else if (sender == self.twoButton) {          // --------->所需材料
        self.oneButton.selected = NO;
        self.twoButton.selected = YES;
        self.threeButton.selected = NO;
        self.fourButton.selected = NO;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.threeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.fourButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.mainScrollView.contentOffset = CGPointMake(kViewWidth, 0);
        
    } else if (sender == self.threeButton) {        // --------->相关常识
        self.oneButton.selected = NO;
        self.twoButton.selected = NO;
        self.threeButton.selected = YES;
        self.fourButton.selected = NO;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.twoButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.fourButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.mainScrollView.contentOffset = CGPointMake(kViewWidth * 2, 0);
        
    } else {                                       // --------->相宜相成
        self.oneButton.selected = NO;
        self.twoButton.selected = NO;
        self.threeButton.selected = NO;
        self.fourButton.selected = YES;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.twoButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.threeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.mainScrollView.contentOffset = CGPointMake(kViewWidth * 3, 0);
    }
}
#pragma mark ************** 标签视图上边按钮的点击 ***************
- (void)collectButtonClick:(UIButton *)sender // 收藏按钮的点击
{
    // 操作数据库
    [[DataBaseManager shareDataBaseManager] openDB];
    
    NSArray *dataArray = [[DataBaseManager shareDataBaseManager] selectAll];
    for (DetailModel *model in dataArray) {
        
        if ([model.name isEqualToString:self.model.name]) {
            
            [sender setImage:[UIImage imageNamed:@"collect1"] forState:UIControlStateNormal];
            
            [self.alertView show];
            
            // 添加一个计时器
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timeOver) userInfo:nil repeats:NO];
            return;
        }
    }
    
    [[DataBaseManager shareDataBaseManager] createTable];
    [[DataBaseManager shareDataBaseManager] insertDetailModel:self.model];
    [sender setImage:[UIImage imageNamed:@"collect1"] forState:UIControlStateNormal];
}
- (void)shareButtonClick // 分享按钮的点击
{
    NSString *textString = [NSString stringWithFormat:@"#美味佳肴_%@#",self.model.name];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55b0624de0f55ab97a005aa8"
                                      shareText:textString
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,nil]
                                       delegate:self];
}
#pragma mark *************** scrollView delegate ****************
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.oneTabelView) {
        return;
    }
    UIButton *button = nil;
    NSInteger index = scrollView.contentOffset.x / kViewWidth;
    if (index == 0) {
        button = self.oneButton;
    } else if (index == 1) {
        button = self.twoButton;
    } else if (index == 2) {
        button = self.threeButton;
    } else {
        button = self.fourButton;
    }
    [self buttonClickAction:button];
}
#pragma mark *************** oneTableView delegate 制作步骤-视图 ***************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuZhouModel *model = self.tableArray[indexPath.row];
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ONE"];
    
    [cell.pictureView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    cell.titleLable.text = model.describe;
    
    return cell;
}
#pragma mark *************** playerView 的轻拍事件*********************
- (void)tapClickAction
{
    self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.model.materialVideoPath]];
    [self.player.moviePlayer setControlStyle:MPMovieControlStyleDefault];
    [self.player.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [self.player.view setFrame:self.playerView.frame]; // 设置player.view的frame
    [self.playerView addSubview:self.player.view]; // 添加播放器的视图到self.playerView上边
    [self.player.moviePlayer play];
    
    // 通知中心，当播放完毕时触发下边的doFinished方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}
- (void)doFinished
{
    self.player.view = nil; // 这句代码是将self.player.view置为空，播放完显示占位图片，不置为空的话，再次点击播放会崩溃（因为每次点击 都会创建一个新的self.payer 对象）

    [self dismissMoviePlayerViewControllerAnimated];
}
#pragma mark ************** 播放器 通知中心 会触发的方法 监测播放状态的变化 ****************
- (void)moviePlayerPlaybackStateChanged:(NSNotification *)notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playbackState = moviePlayer.playbackState;
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
        {
            //NSLog(@"停止");
            break;
        }
            
        case MPMoviePlaybackStatePlaying:
        {
            //NSLog(@"播放");
            break;
        }
            
        case MPMoviePlaybackStatePaused:
        {
            //NSLog(@"暂停");
            break;
        }
            
        case MPMoviePlaybackStateInterrupted:
        {
            //NSLog(@"未知");
            break;
        }
            
        case MPMoviePlaybackStateSeekingForward:
        {
            //NSLog(@"快进/快退");
            break;
        }
            
        case MPMoviePlaybackStateSeekingBackward:
        {
            //NSLog(@"啦啦");
            break;
        }
            
        default:
            break;
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
