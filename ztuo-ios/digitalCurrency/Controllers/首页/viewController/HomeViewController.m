//
//  HomeViewController.m
//  BIZZAN
//
//  Created by sunliang on 2019/1/26.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import "HomeViewController.h"
#import "WebViewController.h"
#import "JKBannarView.h"
#import "symbolModel.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"
#import "symbolModel.h"
#import "marketManager.h"
#import "KchatViewController.h"
#import "bannerModel.h"
#import "CustomSectionHeader.h"
#import "pageScrollView.h"
#import "MineNetManager.h"
#import "PlatformMessageModel.h"
#import "listCell.h"
#import "SecondHeader.h"
#import "ChatGroupMessageViewController.h"
#import "ChatGroupInfoModel.h"
#import "ChatGroupFMDBTool.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "PlatformMessageDetailViewController.h"
#import "Marketmodel.h"
#import "RegisterViewController.h"
#import "ZLGestureLockViewController.h"
#import "GestureViewController.h"
#import "HomeRecommendTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "HelpeCenterViewController.h"
#import "NoticeCenterViewController.h"
#import "VersionUpdateModel.h"
#import "FrenchCurrencyViewController.h"
#import "WalletManageModel.h"
#import "WalletSelectCurrencyViewController.h"
#import "RDVTabBarController.h"
#import "WalletManageViewController.h"
#import "ContractExchangeManager.h"
#import "WalletContractCoinModel.h"

@interface HomeViewController ()<SocketDelegate,chatSocketDelegate>
{
    CGFloat _endDeceleratingOffset;//停止滚动的偏移量
    BOOL _comeIn;
}
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic,strong)NSMutableArray *bannerArr;
@property(nonatomic,strong)JKBannarView *bannerView;
@property(nonatomic,copy)NSMutableArray *platformMessageArr;
@property(nonatomic,strong)ChatGroupInfoModel *groupInfoModel;
@property(nonatomic,strong)UIImageView *tipImageView;
@property (nonatomic,strong)Marketmodel *marketmodel;

@property (nonatomic, strong)SecondHeader *sectionView;
@property (nonatomic, strong)VersionUpdateModel *versionModel;
@property (nonatomic, strong) NSMutableArray *assetTotalArr;
@property (nonatomic, copy  ) NSString *asssetUSDT;
@property (nonatomic, copy  ) NSString *assetCNY;

@property (nonatomic, assign) BOOL isreload;

@property (nonatomic, strong) NSMutableArray *contractDataArray;
@property (nonatomic, strong) NSMutableDictionary *mhyDataDic;
@end

@implementation HomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.assetTotalArr = [[NSMutableArray alloc] init];
    [self setTablewViewHeard];
    [self headRefreshWithScrollerView:self.tableView];
    [self getBannerData];
    [self getUSDTToCNYRate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchImageViewDismiss) name:@"launchImageViewDismiss" object:nil];
}

- (void)launchImageViewDismiss{
//    [self gesturePassword];
    [self versionUpdate];
}

#pragma mark - 版本更新接口请求
//MARK:--版本更新接口请求
-(void)versionUpdate{
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
        NSLog(NSLocalizedString(@"版本更新接口请求 --- %@", nil),resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                // app当前版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSInteger curBuildVersion = [infoDictionary[@"CFBundleVersion"] integerValue];
                
                NSLog(@"app_Build ---- %zd",curBuildVersion);
                if (curBuildVersion < [self.versionModel.version integerValue]){
                    
                    if(self.versionModel.updateType == 1){
                        [LEEAlert alert].config
                        .LeeTitle(NSLocalizedString(@"更新提示", nil))
                        .LeeAddContent(^(UILabel *label) {
                            label.text = ISEMPTY_S(self.versionModel.content)?NSLocalizedString(@"当前有新的版本，请前往下载升级！", nil):self.versionModel.content;
                            label.font = [UIFont systemFontOfSize:16];
                        })
                        .LeeAction(NSLocalizedString(@"立即更新", nil), ^{
                            NSURL *urlString = [NSURL URLWithString:self.versionModel.downloadUrl];
                            [[UIApplication sharedApplication] openURL:urlString options:@{} completionHandler:nil];
                        })
                        .LeeAction(NSLocalizedString(@"暂不更新", nil), nil)
                        .LeeShow();
                    }
                    else{
                        [LEEAlert alert].config
                        .LeeTitle(NSLocalizedString(@"更新提示", nil))
                        .LeeAddContent(^(UILabel *label) {
                            label.text = ISEMPTY_S(self.versionModel.content)?NSLocalizedString(@"当前有新的版本，请前往下载升级！", nil):self.versionModel.content;
                            label.font = [UIFont systemFontOfSize:16];
                        })
                        .LeeAction(NSLocalizedString(@"立即更新", nil), ^{
                            NSURL *urlString = [NSURL URLWithString:self.versionModel.downloadUrl];
                            [[UIApplication sharedApplication] openURL:urlString options:@{} completionHandler:nil];
                            
                            [self exitApplication];
                        })
                        .LeeShow();
                    }
                }
            }else{

            }
        }else{

        }
    }];

}

- (void)exitApplication {
     
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
     
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

#pragma mark - 提示用户开启手势密码
- (void)gesturePassword{
    if ([ZLGestureLockViewController gesturesPassword].length > 0) {
        //已经创建手势密码
    }else{
        //提示用户开启手势密码
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kShowGesturePassword]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 200, 20);
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitle:LocalizationKey(@"noLongerReminding") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:RGBOF(0xe6e6e6) forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"walletNoSelect"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"walletSelected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(Nolongerreminding:) forControlEvents:UIControlEventTouchUpInside];

            [LEEAlert alert].config
            .LeeHeaderColor(mainColor)
            .LeeAddTitle(^(UILabel *label) {
                label.text = LocalizationKey(@"warmPrompt");
                label.textColor = RGBOF(0xe6e6e6);
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = LocalizationKey(@"RemindingMessage");
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = RGBOF(0xe6e6e6);
            })
            .LeeAddCustomView(^(LEECustomView *custom) {

                custom.view = btn;

                custom.positionType = LEECustomViewPositionTypeLeft;
            })
            .LeeItemInsets(UIEdgeInsetsMake(10, 0, -10, 0))
            .LeeAddAction(^(LEEAction *action) {
                action.title = LocalizationKey(@"ok");
                action.titleColor = RGBOF(0xe6e6e6);
                action.font = [UIFont systemFontOfSize:16];
                action.clickBlock = ^{
                    GestureViewController *safeVC = [[GestureViewController alloc] init];
                    safeVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:safeVC animated:YES];
                };
            })
            .LeeAddAction(^(LEEAction *action) {
                action.title = LocalizationKey(@"cancel");
                action.titleColor = RGBOF(0xe6e6e6);
                action.font = [UIFont systemFontOfSize:16];
            })
            .LeeShow();
        }
    }
}

- (void)Nolongerreminding:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:kShowGesturePassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//MARK:--自定义导航栏消息按钮
-(void)rightButton{
    /*屏蔽右上角消息按钮
     UIButton * issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
    [issueButton setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [issueButton addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    self.tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 10, 10)];
    self.tipImageView.hidden = YES;
    self.tipImageView.image = [UIImage imageNamed:@"chatTipImage"];
    [issueButton addSubview:self.tipImageView];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;*/
}

- (void)leftItem{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 116, 44)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"logo"];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = leftBarButtomItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
//    if(YLUserInfo.isLogIn) {
//        [self getTotalAssets];
//    }
    [self rightButton];
    [self leftItem];
    [self getData];
    [self getNotice];
    [self getindex_infodata];
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
}

//MARK:--国际化通知处理事件
- (void)languageSetting{
    [self getBannerData];
    [self getNotice];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (!_comeIn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"launchImageViewDismiss" object:nil];
        _comeIn = YES;
    }

    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=self;
    if ([YLUserInfo isLogIn]) {
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
        [ChatSocketManager share].delegate = self;
    }
    NSMutableArray *chatGroupArr = [ChatGroupFMDBTool getChatGroupDataArr];
    for (ChatGroupInfoModel *infoModel in chatGroupArr) {
        if ([infoModel.flagIndex isEqualToString:@"1"]) {
            self.tipImageView.hidden = NO;
        }
    }
    for (ChatGroupInfoModel *infoModel in chatGroupArr) {
        if (![infoModel.flagIndex isEqualToString:@"1"]) {
            self.tipImageView.hidden = YES;
        }
    }
}

-(void) reloadTabelData{
    if (self.isreload == NO) {
        self.isreload = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView performWithoutAnimation:^{
//                            [self.tableMain reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView reloadData];
                }];
                self.isreload = NO;
            });
        });
    }
}


#pragma mark-首页累计数据
-(void)getindex_infodata{
    [MineNetManager Getindex_infoCompleteHandle:^(id resPonseObj, int code) {
        NSLog(NSLocalizedString(@"首页累计数据 ---- %@", nil), resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSDictionary *dic = [resPonseObj objectForKey:@"data"];
                self.marketmodel = [Marketmodel mj_objectWithKeyValues:dic];
                [self reloadTabelData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark-获取平台消息
-(void)getNotice{
    [MineNetManager getPlatformMessageForCompleteHandleWithPageNo:@"1" withPageSize:@"20" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.platformMessageArr removeAllObjects];
                NSArray *arr = resPonseObj[@"data"][@"content"];
                NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in arr) {

                            [muArr addObject:dic];
                }
                NSArray *dataArr = [PlatformMessageModel mj_objectArrayWithKeyValuesArray:muArr];
                [self.platformMessageArr addObjectsFromArray:dataArr];
                [self reloadTabelData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];

}

- (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

-(void)RighttouchEvent{
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
        return;
    }
    self.tipImageView.hidden = YES;
    ChatGroupMessageViewController *groupVC = [[ChatGroupMessageViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
}
-(void)setTablewViewHeard{
    [self.tableView registerClass:[HomeRecommendTableViewCell class] forCellReuseIdentifier:@"HomeRecommendTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"listCell" bundle:nil] forCellReuseIdentifier:@"Cell2"];
     [self.tableView registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTableViewCell"];
    UIView *hedaview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW,  170 * kWindowWHOne )];
    hedaview.backgroundColor = mainColor;
    self.bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 10 * kWindowWHOne, kWindowW, 150 * kWindowWHOne) viewSize:CGSizeMake(kWindowW,150 * kWindowWHOne)];
    if (self.bannerArr.count > 0) {
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
        for (bannerModel *model in self.bannerArr) {
            [muArr addObject:model.url];
        }
        self.bannerView.items = muArr;
    }
    [hedaview addSubview:self.bannerView];
    //轮播图事件方法
    __weak typeof(self)weakself = self;
    [self.bannerView  imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
        bannerModel *banner = weakself.bannerArr[index];
        if (banner.linkUrl) {
            NSURL *url = [NSURL URLWithString:banner.linkUrl];
            if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{}
                                                 completionHandler:^(BOOL success) {

                                                 }];
                    } else {

                    }
                } else {
                    BOOL success = [[UIApplication sharedApplication] openURL:url];
                    if (success) {

                    }else{

                    }
                }

            } else {
                bool can = [[UIApplication sharedApplication] canOpenURL:url];
                if(can){
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }

    }];
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
    self.tableView.tableHeaderView=hedaview ;
    self.tableView.tableFooterView=[UIView new];

    if (@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;//防止刷新指定行时，偏移量改变
    }

}


-(void)getBannerData{

    [HomeNetManager advertiseBannerCompleteHandle:^(id resPonseObj, int code) {
        NSLog(NSLocalizedString(@"首页轮播图 --- %@", nil),resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.bannerArr removeAllObjects];
                [self.bannerArr addObjectsFromArray:[bannerModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]]];
                if (self.bannerArr.count>0) {
                    [self configUrlArrayWithModelArray:self.bannerArr];
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section==1) {
        return 150;
    }else if (indexPath.section == 0){
        return 167 * kWindowWHOne;
    }
    else{
        return 65;
    }
}
-(void)configUrlArrayWithModelArray:(NSMutableArray*)array{
    NSMutableArray*urlArray=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<array.count; i++) {
        bannerModel*model=array[i];
        [urlArray addObject:model.url];
    }
    self.bannerView.items=urlArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   if (section == 0 || section == 1){
        return 1;
    }
    else{
        if (self.contentArr.count>0) {
            NSArray*changeRankArr=self.contentArr[section - 2];
            return changeRankArr.count;
        }else{
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        HomeRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeRecommendTableViewCell"];
        if (!cell) {
            cell = [[HomeRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeRecommendTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.contentArr.count > 0) {
            cell.dataSourceArr = [self.contentArr firstObject];
        }
        return cell;

    }
    else if (indexPath.section == 0){

        NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeTableViewCell" forIndexPath:indexPath];
        cell.transactionlabel.text = LocalizationKey(@"Myassets");
        if ([YLUserInfo isLogIn]) { // && !ISEMPTY_S(self.asssetUSDT)
            cell.safelabel.text = LocalizationKey(@"totalAssets");
            cell.assestAmountLabel.hidden = YES;
//            cell.assestAmountLabel.text = [NSString stringWithFormat:@"$%@",self.asssetUSDT];
            cell.logionButton.hidden = NO;
            [cell.logionButton setTitle:LocalizationKey(@"点击查看") forState:UIControlStateNormal];
            cell.rechangeButton.hidden = YES;
            [cell.rechangeButton setTitle:LocalizationKey(@"top-up") forState:UIControlStateNormal];
        }else {
            cell.safelabel.text = LocalizationKey(@"login_look");
            cell.logionButton.hidden = NO;
            cell.rechangeButton.hidden =YES;
            [cell.logionButton setTitle:LocalizationKey(@"login_regist") forState:UIControlStateNormal];
            cell.assestAmountLabel.hidden = YES;
        }
        
        MJWeakSelf
        cell.loginBlock = ^{
            if([YLUserInfo isLogIn]){
                //我的资产
                WalletManageViewController *walletVC = [WalletManageViewController new];
                walletVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:walletVC animated:YES];
            }
            else{
                [self showLoginViewController];
            }
        };
        
        cell.rechangeBlock = ^{
            if (!YLUserInfo.isLogIn) {
                return;
            }
            //我的资产
            WalletManageViewController *walletVC = [WalletManageViewController new];
            walletVC.assetUSD = self.asssetUSDT;
            walletVC.assetCNY = self.assetCNY;
            walletVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:walletVC animated:YES];
            
//            WalletSelectCurrencyViewController *vc=[[WalletSelectCurrencyViewController alloc]init];
//            [vc.dataArray addObjectsFromArray:self.assetTotalArr];
//            vc.type=0;
//            [self.navigationController pushViewController:vc animated:YES];
        };
 
        cell.problemlabel.text = LocalizationKey(@"Findmeproblem");
        cell.helplebel.text = LocalizationKey(@"Helpcenter");
        cell.noticelabel.text = LocalizationKey(@"Noticecenter");
        cell.noticecontentlabel.text = LocalizationKey(@"NoticecenterBulletin");

//        cell.CtoCBlock = ^{
//            FrenchCurrencyViewController   *Section4VC = [[FrenchCurrencyViewController alloc] init];
//            
//            Section4VC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:Section4VC animated:YES];
////            [self.tabBarController setSelectedIndex:3];
//        };

        return cell;
    }else{
        listCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (self.contentArr.count>0) {
            [cell configModel:self.contentArr[indexPath.section - 2] withIndex:(int)indexPath.row];
        }
        if (indexPath.row > 2) {
            cell.titleIndex.backgroundColor = kRGBColor(92, 206, 167);
        }else{
            cell.titleIndex.backgroundColor = kRGBColor(42, 178, 114);

        }
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==2) {
        symbolModel*model=self.contentArr[indexPath.section - 2][indexPath.row];
        KchatViewController*klineVC=[[KchatViewController alloc]init];
        klineVC.symbol=model.symbol;
        [[AppDelegate sharedAppDelegate] pushViewController:klineVC withBackTitle:model.symbol];
    }
}
#pragma mark-获取首页推荐信息
-(void)getData{
    [HomeNetManager HomeDataCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取首页推荐信息 --- %@", resPonseObj);
        [self.contentArr removeAllObjects];
        if ([resPonseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *recommendArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"recommend"]];
            NSArray *changeRankArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"changeRank"]];
            if (changeRankArr&&recommendArr) {
                [self.contentArr addObject:recommendArr];//推荐
                [self.contentArr addObject:changeRankArr];//涨幅榜
                
                [self reloadTabelData];
            }
            symbolModel*model = [recommendArr firstObject];
            if (![marketManager shareInstance].symbol) {
                [marketManager shareInstance].symbol=model.symbol;//默认第一个
            }
        }else{

        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentArr.count + 1;
}
#pragma mark-自定义section头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 ) {
        return  10;
    }
    if (section == 0) {
        if (self.platformMessageArr.count>0){
            return 40;
        }
        else{
            return 10;
        }
    }
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        if (self.platformMessageArr.count>0) {
            NSMutableArray*titleArray=[[NSMutableArray alloc]init];
            [self.platformMessageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PlatformMessageModel*model=self.platformMessageArr[idx];
                [titleArray addObject:model.title];
            }];
            CustomSectionHeader*sectionView=[CustomSectionHeader instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 30)];
            [sectionView.morebut setTitle:[NSString stringWithFormat:@"%@>>", LocalizationKey(@"morekline")] forState:UIControlStateNormal];
            pageScrollView *noticeView = [[pageScrollView alloc] initWithFrame:CGRectMake(40, 0, kWindowW-110, 30)];
            noticeView.BGColor = mainColor;
            noticeView.titleArray =titleArray;
            __weak HomeViewController*weakSelf=self;
            [noticeView clickTitleLabel:^(NSInteger index,NSString *titleString) {
                PlatformMessageModel*model=self.platformMessageArr[index-100];
                PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
                detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.content = model.content;
                detailVC.navtitle = model.title;
                detailVC.ID = model.ID;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];

            }];
            [sectionView addSubview:noticeView];

            sectionView.moreBlock = ^{
                NoticeCenterViewController *helpVC = [NoticeCenterViewController new];
                helpVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:helpVC animated:YES];

            };

            return sectionView;
        }else{
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 30)];
            view.backgroundColor=[UIColor clearColor];//mainColor
            return view;
        }
    }else if (section == 1 ){

        UIView * headview = [[UIView alloc]init];
        return headview;
    }

    else{
//        SecondHeader*sectionView=[SecondHeader instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 45)];
        return self.sectionView;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0.01;

}

-(SecondHeader *)sectionView{
    if (!_sectionView) {
        _sectionView = [SecondHeader instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 45)];
    }
    [_sectionView.upbutton setTitle:LocalizationKey(@"Top") forState:UIControlStateNormal];
    return _sectionView;
}
#pragma mark-下拉刷新数据
- (void)refreshHeaderAction{
    [self getBannerData];
    [self getData];
    [self getindex_infodata];

}

- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
#pragma mark - SocketDelegate Delegate
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    if (cmd==SUBSCRIBE_GROUP_CHAT) {
        NSLog(@"订阅聊天组成功");
    }
    else if (cmd==UNSUBSCRIBE_GROUP_CHAT) {
        NSLog(@"取消订阅聊天组成功");
    }
    else if (cmd==SEND_CHAT) {//发送消息
        if (endStr) {
            NSLog(@"发送消息--%@-收到的回复命令--%d", endStr,cmd);
        }
    }
    else if (cmd==PUSH_GROUP_CHAT)//收到消息
    {

        if (endStr) {
            NSDictionary *dic =[SocketUtils dictionaryWithJsonString:endStr];
            //            NSLog(NSLocalizedString(@"接受消息--收到的回复-%@--%d--", nil),dic,cmd);
            _groupInfoModel = [ChatGroupInfoModel mj_objectWithKeyValues:dic];
            //存入数据库
            //NSLog(@"--%@",_groupInfoModel.content);
            [ChatGroupFMDBTool createTable:_groupInfoModel withIndex:1];
            [self setSound];
            self.tipImageView.hidden = NO;
        }
    }else{
        //        NSLog(NSLocalizedString(@"首页聊天消息-%@--%d", nil),endStr,cmd);
    }
}
//MARK:--设置音效
-(void)setSound{
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"m_click" withExtension:@"wav"];
    //对该音效标记SoundID
    SystemSoundID soundID1 = 0;
    //加载该音效
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID1);
    //播放该音效
    AudioServicesPlaySystemSound(soundID1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.y;
    _endDeceleratingOffset = offsetX;
}
#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    //缩略行情
    if (cmd==PUSH_SYMBOL_THUMB) {

        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
        //推荐
        if (self.contentArr.count>0) {
            NSMutableArray*recommendArr=(NSMutableArray*)self.contentArr[0];
            [recommendArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.symbol isEqualToString:model.symbol]) {
                    [recommendArr  replaceObjectAtIndex:idx withObject:model];
                    *stop = YES;
                    
                    [self reloadTabelData];
                }
            }];
            //涨幅榜
            if (self.contentArr.count < 1) {
                return;
            }
            NSMutableArray*changeRankArr=(NSMutableArray*)self.contentArr[1];
            [changeRankArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.symbol isEqualToString:model.symbol]) {
                    [changeRankArr  replaceObjectAtIndex:idx withObject:model];
                    *stop = YES;
                    [self reloadTabelData];
                }
            }];
        }
        [self asssetUSDT];
    }else if (cmd==UNSUBSCRIBE_SYMBOL_THUMB){
        NSLog(@"取消订阅首页消息");

    }else{

    }
    //    NSLog(NSLocalizedString(@"首页消息-%@--%d", nil),endStr,cmd);
}

#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    [MarketNetManager getusdTocnyRateCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate = [NSDecimalNumber decimalNumberWithString:[resPonseObj[@"data"] stringValue]];
                
                [self reloadTabelData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
- (NSMutableArray *)platformMessageArr {
    if (!_platformMessageArr) {
        _platformMessageArr = [NSMutableArray array];
    }
    return _platformMessageArr;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=nil;
    //    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
    //    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
}

- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _bannerArr;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:--请求总资产的接口
-(void)getTotalAssets{
    //    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager getMyWalletInfoForCompleteHandle:^(id resPonseObj, int code) {
        //        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.assetTotalArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                
                [self.assetTotalArr addObjectsFromArray:dataArr];
                
                //获取永续合约账户信息
                [self getContractWalletList];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

///获取永续合约等钱包数据
- (void)getContractWalletList{
    [self.contractDataArray removeAllObjects];
    [ContractExchangeManager getWalletListCompleteHandle:^(id  _Nonnull resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] intValue] == 0) {
                NSArray *data=resPonseObj[@"data"];
                NSArray *dataArr = [WalletContractCoinModel mj_objectArrayWithKeyValuesArray:data];
                
                [self.contractDataArray addObjectsFromArray:dataArr];
                
                [self getMhyWalletData];
            }
            
            else if ([resPonseObj[@"code"] integerValue] ==4000){
                
                [YLUserInfo logout];
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }
        else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

///获取秒合约钱包数据
- (void)getMhyWalletData {
//    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager getMhyWalletDataCompleteHandle:^(id resPonseObj, int code) {
//    [EasyShowLodingView hidenLoding];
        if (code) {
           if ([resPonseObj[@"code"] integerValue] == 0) {
               NSDictionary *dict=resPonseObj[@"data"];
                self.mhyDataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
               //| walletId |   long   |  秒合约钱包Id  |
               //| balance  |  double  | 秒合约钱包余额 |
               [self updateTotalAsset];
           }else{
               [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
           }
       }else{
           [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
       }
    }];
}

///更新总的资产值（币币、永续、秒合约等所有账户）
-(void)updateTotalAsset{
    CGFloat ass1 = 0.0;
    CGFloat cnyRate = 0.0;
    
    //币币总资产
    for (WalletManageModel *walletModel in self.assetTotalArr) {
        //计算总资产
        ass1 = ass1 +[walletModel.balance floatValue]*[walletModel.coin.usdRate floatValue];
        if(cnyRate == 0.0){
            cnyRate = [walletModel.coin.cnyRate floatValue];
        }
    }
    
    //永续总资产
    for (WalletContractCoinModel *model in self.contractDataArray) {
        ass1 += [model.usdtBalance floatValue];
    }
    
    //秒合约总资产
    ass1 += [self.mhyDataDic[@"balance"] floatValue];
    
    self.asssetUSDT = [NSString stringWithFormat:@"%f",ass1];
    self.assetCNY  = [NSString stringWithFormat:@"≈%.2fCNY",ass1*cnyRate];
    
}

-(NSMutableArray *)contractDataArray {
    
    if (!_contractDataArray) {
        _contractDataArray=[NSMutableArray array];
    }
    return _contractDataArray;
}
@end
