//
//  XXSRootVC.m
//  美味佳肴-专注美食
//
//  Created by lanou3g on 15/7/28.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "XXSRootVC.h"
#import "DetailVC.h"

// 第三方
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "UMSocial.h"


#import "XXSDetailModel.h"
#import "XXCollectCell.h"



// 底视图 bottomView
#define kBottomWidth self.bottomView.frame.size.width
#define kBottomHeight self.bottomView.frame.size.height

// 盛放文字的lable
#define kLableWidth self.contentLable.frame.size.width
#define kLableHeight self.contentLable.frame.size.height

// 集合视图
#define kCollectWidth self.collectionView.frame.size.width
#define kCollectHeight self.collectionView.frame.size.height

@interface XXSRootVC () <UICollectionViewDelegate,UICollectionViewDataSource,UMSocialUIDelegate>

@property (nonatomic, strong) UIScrollView *bottomScrollView; // 底视图scrollView

@property (nonatomic, strong) UIView *bottomView;// 底视图view
@property (nonatomic, strong) UIImageView *titleImageView; // 上边的图片
@property (nonatomic, strong) UIButton *shareButton; // 分享按钮
@property (nonatomic, strong) UILabel *contentLable; // 盛放文字的lable
@property (nonatomic, strong) UILabel *titleLable; // “推荐案例” lable
@property (nonatomic, strong) UICollectionView *collectionView; // 集合视图

@property (nonatomic, strong) NSMutableArray *dataArray; // 数据源数组

@property (nonatomic, assign) CGFloat height; // 计算好的字符串的高度
@property (nonatomic, assign) CGFloat collectHeight; // 集合视图的高度

@property (nonatomic, strong) NSMutableArray *detailArray; // 集合视图中每个图片对应的详情数据源

@end

@implementation XXSRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"正在为你加载" maskType:SVProgressHUDMaskTypeBlack];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.model.name;
    self.dataArray = [[NSMutableArray alloc] init]; // 开辟空间
    self.detailArray = [[NSMutableArray alloc] init];
    
    [self layoutMainView]; // 加载主视图
    [self requestNetworkData]; // 请求数据
    
}

#pragma mark ****************** 请求网络数据 *****************
- (void)requestNetworkData // 请求数据
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/found/tblFresh!getTblFreshDelicacyList.do?freshId=%@&is_traditional=0&phonetype=1",self.model.freshId];
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak XXSRootVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        NSArray *mainArray = dict[@"data"];
        NSDictionary *mainDict = mainArray.firstObject;
        XXSDetailModel *model = [[XXSDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:mainDict];
        [aSelf.dataArray addObject:model];
        [aSelf assignToSubviewsWithDataArray:aSelf.dataArray]; // 把数据源数组传出去
        [self.collectionView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

// 请求 传回详情界面所需要的数据
- (void)requestNewData:(NSInteger)index // 根据传过来的下标（被点击的图片的下标）来请求相应的数据
{
    XXSDetailModel *model = self.dataArray.firstObject;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.117.95:80/HandheldKitchen/api/vegetable/tblvegetable!getTblVegetables.do?vegetable_id=%@&phonetype=2&user_id=&is_traditional=0",[model.vegetableArray[index] vegetable_id]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    id tempObj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *dict = (NSDictionary *)tempObj;
    
    NSArray *mainArray = dict[@"data"];
    NSDictionary *mainDict = mainArray.firstObject;
    DetailModel *detailModel = [[DetailModel alloc] init];
    [detailModel setValuesForKeysWithDictionary:mainDict];
    [self.detailArray addObject:detailModel];
    
}
#pragma mark ****************** 给各控件赋值 ***************
- (void)assignToSubviewsWithDataArray:(NSMutableArray *)array
{
    XXSDetailModel *model = array.firstObject;
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.imageFilename] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    self.contentLable.text = model.content;
    
    self.height = [self getHeightWithstring:model.content]; // label的实际高度
    self.collectHeight = (model.vegetableArray.count / 2) *(((float)120 / (float)667) * kViewHeight + 20 + 10);
    
}
#pragma mark **************** 计算字符串高度 ****************
- (CGFloat)getHeightWithstring:(NSString *)string
{
    //获取字符串显示的高度
    NSDictionary *dic=@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGRect rect=[string boundingRectWithSize:CGSizeMake(kViewWidth - 10, 100000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return rect.size.height;
}
#pragma mark ******************* 布局视图 ******************
- (void)layoutMainView // 布局主视图
{
    // 替换导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    /**
        底视图
     */
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64)];
    self.bottomScrollView.backgroundColor = [UIColor colorWithRed:192/256.0 green:180/256.0 blue:96/256.0 alpha:0.5];
    self.bottomScrollView.contentSize = CGSizeMake(0, kViewHeight * 2);
    [self.view addSubview:self.bottomScrollView];
    
    /**
        上边的视图
     */
    // 底视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kViewWidth - 10, ((float)250 / (float)667)* kViewHeight)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:192/256.0 green:180/256.0 blue:96/256.0 alpha:0.5];
    [self.bottomScrollView addSubview:self.bottomView];
    
    // 底视图上边的图片
    self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kBottomWidth, kBottomHeight)];
    [self.bottomView addSubview:self.titleImageView];
    
    // 收藏按钮
    /*
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectButton.frame = CGRectMake(20, kBottomHeight - 40, 30, 30);
    //[self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.collectButton];
    [self.collectButton addTarget:self action:@selector(collectButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
     */
    
    // 在导航栏右侧添加 “分享”按钮
    // 分享按钮
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(0, 0, 25, 25);
    [self.shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self.bottomView addSubview:self.shareButton];
    [self.shareButton addTarget:self action:@selector(shareButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    
    // 显示文字的lable
    self.contentLable = [[UILabel alloc] initWithFrame:CGRectMake(5, kBottomHeight + 10, kViewWidth - 10, 100)];
    self.contentLable.backgroundColor = [UIColor whiteColor];
    self.contentLable.font = [UIFont systemFontOfSize:14];
    self.contentLable.numberOfLines = 0;
    [self.bottomScrollView addSubview:self.contentLable];
    
    // 添加 “展开”按钮
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(kLableWidth + 5 - 40, kBottomHeight + kLableHeight + 10 - 20, 40, 20);
    aButton.layer.cornerRadius = 5;
    aButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [aButton setTitle:@"展开" forState:UIControlStateNormal];
    aButton.backgroundColor = [UIColor orangeColor];
    [aButton addTarget:self action:@selector(aButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomScrollView addSubview:aButton];
    
    /**
        下边的集合视图
     */
    // 添加头部 lable “推荐案例”
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, kBottomHeight + 10 + kLableHeight + 5, kViewWidth, 20)];
    self.titleLable.backgroundColor = [UIColor whiteColor];
    self.titleLable.text = @"---------推荐案例---------";
    self.titleLable.adjustsFontSizeToFitWidth = YES;
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    [self.bottomScrollView addSubview:self.titleLable];
    
    // 集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kViewWidth - 30) / 2, ((float)120 / (float)667) * kViewHeight + 20);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kBottomHeight + 10 + kLableHeight + 5 + 20, kViewWidth, self.collectHeight) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.bottomScrollView addSubview:self.collectionView];
    [self.collectionView registerClass:[XXCollectCell class] forCellWithReuseIdentifier:@"Collect"];
    
    // 重新设置bottomScrollView的contentSize
    self.bottomScrollView.contentSize = CGSizeMake(0, 5 + kBottomHeight + 5 + kLableHeight + 5 + 20 + kCollectHeight + 10);
    
}

#pragma mark ************* 导航栏按钮的点击 ***************
/*
- (void)collectButtonClickAction //收藏
{
    NSLog(@"收藏");
}
 */
- (void)shareButtonClickAction // 分享
{
    NSString *textString = [NSString stringWithFormat:@"#新鲜事_%@#",self.model.name];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55b0624de0f55ab97a005aa8"
                                      shareText:textString
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,nil]
                                       delegate:self];
}

- (void)backButtonClick // 返回
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ************** “展开” 按钮的点击 ********************
- (void)aButtonClickAction:(UIButton *)sender
{
    if (sender.selected) {      // ---------------------------------> 恢复lable的frame
        
        [UIView animateWithDuration:0.8f animations:^{
           
            [sender setTitle:@"展开" forState:UIControlStateNormal];
            self.contentLable.frame = CGRectMake(5, kBottomHeight + 10, kViewWidth - 10, 100);
            sender.frame = CGRectMake(kLableWidth + 5 - 40, kBottomHeight + kLableHeight + 10 - 20, 40, 20);
            self.titleLable.frame = CGRectMake(0, kBottomHeight + 10 + kLableHeight + 5, kViewWidth, 20);
            self.collectionView.frame = CGRectMake(0, kBottomHeight + 10 + kLableHeight + 5 + 20, kViewWidth, self.collectHeight);
            self.bottomScrollView.contentSize = CGSizeMake(0, 5 + kBottomHeight + 5 + kLableHeight + 5 + 20 + kCollectHeight);
        }];
        
         sender.selected = NO;
        
    } else {                    // ---------------------------------> 增大lable的frame
        
        [UIView animateWithDuration:0.8f animations:^{
            
            [sender setTitle:@"收起" forState:UIControlStateNormal];
            // lable
            self.contentLable.frame = CGRectMake(5, kBottomHeight + 10, kViewWidth - 10, self.height);
            // button
            sender.frame = CGRectMake(kLableWidth + 5 - 40, kBottomHeight + kLableHeight + 10 - 20, 40, 20);
            // “推荐案例” lable
            self.titleLable.frame = CGRectMake(0, kBottomHeight + 10 + kLableHeight + 5, kViewWidth, 20);
            // 集合视图
            self.collectionView.frame = CGRectMake(0, kBottomHeight + 10 + kLableHeight + 5 + 20, kViewWidth, self.collectHeight);
            // 设置bottomScrollView的contentSize
            self.bottomScrollView.contentSize = CGSizeMake(0, 5 + kBottomHeight + 5 + kLableHeight + 5 + 20 + kCollectHeight);
        }];

        sender.selected = YES;
    }
    
}
#pragma mark *************** 集合视图 代理方法 *********************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 在这个代理方法内部 把计算好的frame重新赋值给控件
    self.collectionView.frame = CGRectMake(0, kBottomHeight + 10 + kLableHeight + 5 + 20, kViewWidth, self.collectHeight);
    self.bottomScrollView.contentSize = CGSizeMake(0, 5 + kBottomHeight + 5 + kLableHeight + 5 + 20 + kCollectHeight + 10);
    
    return [self.dataArray.firstObject vegetableArray].count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailModel *model = [self.dataArray.firstObject vegetableArray][indexPath.row];
    
    XXCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collect" forIndexPath:indexPath];
    
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePathThumbnails] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    cell.nameLable.text = model.name;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self requestNewData:indexPath.row];
    
    DetailModel *model = self.detailArray.lastObject;
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    
    detailVC.model = model;
    
    detailVC.vegetableID = model.vegetable_id;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [self.detailArray removeAllObjects];
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
