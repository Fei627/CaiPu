//
//  TangDetailVC.m
//  美味佳肴-专注美食
//
//  Created by JLItem on 15/8/4.
//  Copyright (c) 2015年 高建龙. All rights reserved.
//

#import "TangDetailVC.h"
#import <MediaPlayer/MediaPlayer.h>

#import "AFNetworking.h"
#import "Networking.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"

#import "LIView.h"
#import "TangDetailModel.h"

#define kPlayerViewHeight self.playerView.frame.size.height

@interface TangDetailVC () <UMSocialUIDelegate>

@property (nonatomic, strong) UIScrollView *bottomScrollView; // 底视图
@property (nonatomic, strong) UIView *playerView; // 播放器视图
@property (nonatomic, strong) UIImageView *playImageView; // 占位图
@property (nonatomic, strong) MPMoviePlayerViewController *player;

@property (nonatomic, strong) UIView *buttonView; // 存放button的视图
@property (nonatomic, strong) UIButton *oneButton;
@property (nonatomic, strong) UIButton *twoButton;
@property (nonatomic, strong) UIButton *threeButton;
@property (nonatomic, strong) UIButton *fourButton;

@property (nonatomic, strong) UIView *aView; // 材料准备视图
@property (nonatomic, strong) UILabel *ylLable; // 原料
@property (nonatomic, strong) UIImageView *oneImageView; // 原料图片
@property (nonatomic, strong) UILabel *tlLable; // 调料
@property (nonatomic, strong) UIImageView *tlImageView; // 调料图片
@property (nonatomic, strong) UILabel *imageLable; // 调料图片上的文字lable

@property (nonatomic, strong) UIView *bView; // 制作指导视图
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) UILabel *bLable; // 温馨提示

@property (nonatomic, strong) UIView *cView; // 科学食用视图
@property (nonatomic, strong) UIImageView *cImageView; // 图片
@property (nonatomic, strong) UIView *bottomView; // 底视图
@property (nonatomic, strong) UILabel *scienceLable; // 科学食用说明
@property (nonatomic, strong) UILabel *promptLable; // 温馨提示

// 营养图解
@property (nonatomic, strong) UIView *dView;
@property (nonatomic, strong) UIImageView *dImageView;

@property (nonatomic, strong) NSMutableArray *dataArray; // 数据源数组

@end

@implementation TangDetailVC

- (void)dealloc // 在dealloc方法里移除通知
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 在导航栏右侧添加“分享”按钮
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, 25, 25);
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    // 替换导航栏左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    self.title = self.model.name;
    self.dataArray = [[NSMutableArray alloc] init]; // 开辟空间
    
    [self layoutMainView]; // 视图加载
    
    [self requestNetworkData]; // 请求网络数据
    
}

#pragma mark ************ 分享按钮的点击 *************
- (void)shareButtonClick // 分享
{
    NSString *textString = [NSString stringWithFormat:@"#群汤荟萃_%@#",self.model.name];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55b0624de0f55ab97a005aa8"
                                      shareText:textString
                                     shareImage:[UIImage imageNamed:@"icon60.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,nil]
                                       delegate:self];
}

#pragma mark ************ 给各控件赋值 ***************
- (void)reciveDataArray:(NSMutableArray *)array
{
    TangDetailModel *model = array.lastObject;
    
#pragma mark ------------- 播放器视图 -----------
    
    [self.playImageView sd_setImageWithURL:[NSURL URLWithString:model.imageFilename] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
#pragma mark ------------- 材料准备 -------------
    
    self.ylLable.text = model.materialPrepare;
    [self.oneImageView sd_setImageWithURL:[NSURL URLWithString:model.materialImage] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    if (model.TblSeasoningArray.count == 0) {
        
        self.tlImageView.hidden = YES;
        self.tlLable.text = nil;
        //self.tlImageView.frame = CGRectMake(20, 100 + self.oneImageView.frame.size.height + 20, kViewWidth - 40, -60);
        
    } else {
        
        self.tlLable.text = model.flavor;
        [self.tlImageView sd_setImageWithURL:[NSURL URLWithString:[model.TblSeasoningArray.firstObject imagePath]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        self.imageLable.text = [model.TblSeasoningArray.firstObject name];
    }
    
#pragma mark ------------- 制作指导 -------------

    //TangZhiDaoModel *zhiDaoModel = model.TblProcessArray
    for (int i = 0; i < model.TblProcessArray.count; i ++) {

        LIView *aLIView = [[LIView alloc] initWithFrame:CGRectMake(30, 10 + i * (((float)200 / (float) 667) * kViewHeight + 20), kViewWidth - 60, ((float)200 / (float) 667) * kViewHeight)];
        [aLIView.titleImageView sd_setImageWithURL:[NSURL URLWithString:[model.TblProcessArray[i] imageProcess]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        aLIView.pageLable.text = [model.TblProcessArray[i] orderid];
        aLIView.nameLable.text = [model.TblProcessArray[i] describe];

        [self.bView addSubview:aLIView];
    }
    
    self.number = model.TblProcessArray.count;
    
    // 温馨提示
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + self.number * (((float)200 / (float) 667) * kViewHeight + 20), 80, 20)];
    lable.text = @"温馨提示";
    lable.font = [UIFont boldSystemFontOfSize:15];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.layer.cornerRadius = 10;
    lable.layer.masksToBounds = YES;
    lable.backgroundColor = [UIColor grayColor];
    [self.bView addSubview:lable];
    
    self.bLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 40 + self.number * (((float)200 / (float) 667) * kViewHeight + 20), kViewWidth - 40, 40)];
    self.bLable.text = model.cookPrompt;
    self.bLable.numberOfLines = 0;
    self.bLable.font = [UIFont boldSystemFontOfSize:14];
    [self.bView addSubview:self.bLable];
    
#pragma mark ------------- 科学食用 -------------

    [self.cImageView sd_setImageWithURL:[NSURL URLWithString:model.nousImage] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    self.scienceLable.text = model.scienceNous;
    self.promptLable.text = model.meekPrompt;
    
#pragma mark ------------- 营养图解 -------------
    
    [self.dImageView sd_setImageWithURL:[NSURL URLWithString:model.purchaseImage] placeholderImage:nil];
}

#pragma mark ************ 数据请求 *******************
- (void)requestNetworkData
{
    NSString *urlStr = [NSString stringWithFormat:@"http://121.41.88.194:80/HandheldKitchen/api/more/hotwater!getHotwaterDetail.do?id=%@&is_traditional=0&phonetype=1",self.model.detailID];
    
    NSString *urlPath = urlStr;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSDictionary *params = @{@"page" : @"2"};//表示第几页
    
    __weak TangDetailVC *aSelf = self;
    [manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"parase opreation is %@",dict);
        
        TangDetailModel *model = [[TangDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [aSelf.dataArray addObject:model];
        
        [self reciveDataArray:aSelf.dataArray]; // 把数据源数组传出去
        //NSLog(@"%ld",aSelf.dataArray.count);
        //NSLog(@"%@",model.name);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark ************ 加载视图 ********************
- (void)layoutMainView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark ------------- 底视图 -------------
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight - 64)];
    self.bottomScrollView.backgroundColor = [UIColor colorWithRed:201.0 / 255.0 green:192.0 / 255.0 blue:123.0 / 255.0 alpha:1];
    self.bottomScrollView.contentSize = CGSizeMake(0, kViewHeight * 2);
    [self.view addSubview:self.bottomScrollView];
    
#pragma mark ------------- 播放器视图 -------------
    
    // 播放器视图
    self.playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, ((float)220 / (float)667) * kViewHeight)];
    self.playerView.backgroundColor = [UIColor whiteColor];
    [self.bottomScrollView addSubview:self.playerView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickAction)];
    [self.playerView addGestureRecognizer:tap];
    
    self.playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, self.playerView.frame.size.height)];
    self.playImageView.userInteractionEnabled = YES;
    [self.playerView addSubview:self.playImageView];
    
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    aImageView.image = [UIImage imageNamed:@"play"];
    aImageView.center = CGPointMake(kViewWidth / 2, self.playerView.frame.size.height / 2);
    [self.playerView addSubview:aImageView];
    
#pragma mark ------------- buttonView -------------
    
    // buttonView
    self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.playerView.frame.size.height, kViewWidth, 40)];
    self.buttonView.backgroundColor =[UIColor colorWithRed:229.0 / 255.0 green:125.0 / 255.0 blue:67.0 / 255.0 alpha:0.5];
    [self.bottomScrollView addSubview:self.buttonView];
    
    // 在buttonView上边创建button
    NSArray *titleArray = @[@"材料准备",@"制作指导",@"科学食用",@"营养图解"];
    for (int i = 0; i < 4; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kViewWidth / 4) * i, 0, kViewWidth / 4, 40);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.buttonView addSubview:button];
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

#pragma mark ------------- 材料准备 -------------
    
    // 为对应button创建对应的View
    
    // <1> 材料准备
    self.aView = [[UIView alloc] initWithFrame:CGRectMake(0, kPlayerViewHeight + 40, kViewWidth, 200)];
    self.aView.backgroundColor = [UIColor colorWithRed:201.0 / 255.0 green:192.0 / 255.0 blue:123.0 / 255.0 alpha:1];
    [self.bottomScrollView addSubview:self.aView];
    
    // 原料 lable
    UILabel *aLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 50, 20)];
    aLable.text = @"原料：";
    aLable.font = [UIFont boldSystemFontOfSize:15];
    aLable.textColor = [UIColor purpleColor];
    [self.aView addSubview:aLable];
    
    self.ylLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, kViewWidth - 90, 60)];
    self.ylLable.font = [UIFont systemFontOfSize:14];
    //self.ylLable.text = @"小米白扁豆七谷养生粥是由含安神、助眠的多种杂粮及安神的药食同源的莲子组成的。其中小米对失眠";
    self.ylLable.numberOfLines = 0;
    [self.aView addSubview:self.ylLable];
    
    // 原料图片
    self.oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10 + 60 + 10, kViewWidth - 40, ((float)200 / (float)667) * kViewHeight)];
    self.oneImageView.image = [UIImage imageNamed:@"zhanwei"];
    [self.aView addSubview:self.oneImageView];
    
    // 调料
    UILabel *bLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 80 + self.oneImageView.frame.size.height + 10, 50, 20)];
    bLable.text = @"调料：";
    bLable.font = [UIFont boldSystemFontOfSize:15];
    bLable.textColor = [UIColor purpleColor];
    [self.aView addSubview:bLable];
    
    self.tlLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 80 + self.oneImageView.frame.size.height + 10, kViewWidth - 90, 20)];
    //self.tlLable.text = @"盐2克";
    self.tlLable.font = [UIFont systemFontOfSize:14];
    [self.aView addSubview:self.tlLable];
    
    // 调料图片
    self.tlImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100 + self.oneImageView.frame.size.height + 20, kViewWidth - 40, ((float)200 / (float)667) * kViewHeight)];
    self.tlImageView.image = [UIImage imageNamed:@"zhanwei"];
    [self.aView addSubview:self.tlImageView];
    
    // 调料图片上的文字
    self.imageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 40, 20)];
    self.imageLable.textAlignment = NSTextAlignmentCenter;
    self.imageLable.font = [UIFont boldSystemFontOfSize:15];
    [self.tlImageView addSubview:self.imageLable];
    
    self.aView.frame = CGRectMake(0, kPlayerViewHeight + 40, kViewWidth, 80 + self.oneImageView.frame.size.height + 20 + 20 + self.tlImageView.frame.size.height + 20);
    self.bottomScrollView.contentSize = CGSizeMake(0, kPlayerViewHeight + 40 + self.aView.frame.size.height);
    
#pragma mark ------------- 制作指导 -------------

    // <2> 制作指导
    self.bView = [[UIView alloc] initWithFrame:CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 1000)];
    self.bView.backgroundColor = [UIColor colorWithRed:201.0 / 255.0 green:192.0 / 255.0 blue:123.0 / 255.0 alpha:1];
    [self.bottomScrollView addSubview:self.bView];
    
#pragma mark ------------- 科学食用 -------------

    // <3> 科学食用
    self.cView = [[UIView alloc] initWithFrame:CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 500)];
    self.cView.backgroundColor = [UIColor colorWithRed:201.0 / 255.0 green:192.0 / 255.0 blue:123.0 / 255.0 alpha:1.0];
    [self.bottomScrollView addSubview:self.cView];
    
    // 图片
    self.cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, kViewWidth - 100, ((float)150 / (float)667) * kViewHeight)];
    self.cImageView.image = [UIImage imageNamed:@"zhanwei"];
    [self.cView addSubview:self.cImageView];
    
    // 加一个底视图
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + self.cImageView.frame.size.height + 20, kViewWidth, self.cView.frame.size.height - 40 - self.cImageView.frame.size.height)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:229.0 / 255.0 green:125.0 / 255.0 blue:67.0 / 255.0 alpha:0.5];
    [self.cView addSubview:self.bottomView];
    
    // 科学食用说明
    self.scienceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kViewWidth - 40, 190)];
    self.scienceLable.font = [UIFont boldSystemFontOfSize:14];
    self.scienceLable.adjustsFontSizeToFitWidth = YES;
    self.scienceLable.numberOfLines = 0;
    [self.bottomView addSubview:self.scienceLable];
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, self.scienceLable.frame.size.height + 10, kViewWidth - 10, 1)];
    lineView.backgroundColor = [UIColor purpleColor];
    [self.bottomView addSubview:lineView];
    
    // 温馨提示
    UILabel *constLable = [[UILabel alloc] initWithFrame:CGRectMake(20, self.scienceLable.frame.size.height + 30, 80, 20)];
    constLable.text = @"温馨提示";
    constLable.font = [UIFont boldSystemFontOfSize:16];
    constLable.textAlignment = NSTextAlignmentCenter;
    constLable.backgroundColor = [UIColor grayColor];
    constLable.layer.cornerRadius = 10;
    constLable.layer.masksToBounds = YES;
    [self.bottomView addSubview:constLable];
    
    // 提示内容
    self.promptLable = [[UILabel alloc] initWithFrame:CGRectMake(20, self.scienceLable.frame.size.height + 50, kViewWidth - 40, 100)];
    self.promptLable.font = [UIFont boldSystemFontOfSize:14];
    self.promptLable.adjustsFontSizeToFitWidth = YES;
    self.promptLable.numberOfLines = 0;
    [self.bottomView addSubview:self.promptLable];
    
    // 计算好高度 重新给cView设定frame
    self.bottomView.frame = CGRectMake(0, self.cImageView.frame.size.height + 40, kViewWidth, self.scienceLable.frame.size.height + 10 + 20 + 20 + 65 + 30);
    self.cView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 20 + self.cImageView.frame.size.height + 20 + self.bottomView.frame.size.height);
    
#pragma mark ------------- 营养图解 -------------

    // <4>
    self.dView = [[UIView alloc] initWithFrame:CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 1000)];
    self.dView.backgroundColor = [UIColor colorWithRed:201.0 / 255.0 green:192.0 / 255.0 blue:123.0 / 255.0 alpha:1];
    [self.bottomScrollView addSubview:self.dView];
    
    // 图片
    self.dImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, kViewWidth - 10 , self.dView.frame.size.height - 20)];
    [self.dView addSubview:self.dImageView];
    
    // 重新设置dView的frame
    self.dView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, self.dImageView.frame.size.height + 20);
}

#pragma mark ************ 播放器视图的轻拍事件 ****************
- (void)tapClickAction
{
    TangDetailModel *model = self.dataArray.firstObject;
    self.player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:model.hotwaterVideo]];
    [self.player.moviePlayer setControlStyle:MPMovieControlStyleDefault];
    [self.player.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    [self.player.view setFrame:self.playerView.frame]; // 设置player.view的frame
    [self.playerView addSubview:self.player.view]; // 添加播放器的视图到self.playerView上边
    [self.player.moviePlayer play];

    // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)doFinished
{
    self.player.view = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ************ buttonView 上边按钮的点击 **************
- (void)buttonClickAction:(UIButton *)sender
{
    //NSLog(@"title ========== %@",sender.titleLabel.text);
    if (sender == self.oneButton) {                 // --------->材料准备
        self.oneButton.selected = YES;
        self.twoButton.selected = NO;
        self.threeButton.selected = NO;
        self.fourButton.selected = NO;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.twoButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.threeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.fourButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        self.aView.frame = CGRectMake(0, kPlayerViewHeight + 40, kViewWidth, 80 + self.oneImageView.frame.size.height + 20 + 20 + self.tlImageView.frame.size.height + 20);
        self.bView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 1000);
        self.cView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 500);
        self.dView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 0);
        
        self.bottomScrollView.contentSize = CGSizeMake(0, kPlayerViewHeight + 40 + self.aView.frame.size.height);
        
    } else if (sender == self.twoButton) {          // --------->制作指导
        self.oneButton.selected = NO;
        self.twoButton.selected = YES;
        self.threeButton.selected = NO;
        self.fourButton.selected = NO;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.threeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.fourButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        self.aView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 200);
        self.cView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 500);
        self.dView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 0);
        self.bView.frame = CGRectMake(0, kPlayerViewHeight + 40, kViewWidth, 30 + self.number * (((float)200 / (float) 667) * kViewHeight + 20) + 60);

        self.bottomScrollView.contentSize = CGSizeMake(0, kPlayerViewHeight + 40 + self.bView.frame.size.height);
        
    } else if (sender == self.threeButton) {        // --------->科学食用
        self.oneButton.selected = NO;
        self.twoButton.selected = NO;
        self.threeButton.selected = YES;
        self.fourButton.selected = NO;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.twoButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.fourButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];

        self.aView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 200);
        self.bView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 1000);
        self.dView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 0);
        self.cView.frame = CGRectMake(0, kPlayerViewHeight + 40, kViewWidth, 20 + self.cImageView.frame.size.height + 20 + self.bottomView.frame.size.height);
        
        self.bottomScrollView.contentSize = CGSizeMake(0, kPlayerViewHeight + 40 + self.cView.frame.size.height);
        
    } else {                                       // --------->营养图解
        self.oneButton.selected = NO;
        self.twoButton.selected = NO;
        self.threeButton.selected = NO;
        self.fourButton.selected = YES;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.twoButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.threeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        self.aView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 200);
        self.bView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 1000);
        self.cView.frame = CGRectMake(-kViewWidth, kPlayerViewHeight + 40, kViewWidth, 500);
        self.dView.frame = CGRectMake(0, kPlayerViewHeight + 40, kViewWidth, self.dImageView.frame.size.height + 20);
        
        self.bottomScrollView.contentSize = CGSizeMake(0, kPlayerViewHeight + 40 + self.dView.frame.size.height);
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
