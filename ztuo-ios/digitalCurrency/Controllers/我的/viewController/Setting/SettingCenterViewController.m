//
//  SettingCenterViewController.m
//  digitalCurrency
//
//  Created by iDog on 2019/2/2.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import "SettingCenterViewController.h"
#import "SettingCenterTableViewCell.h"
#import "LanguageSetViewController.h"
#import "FeedbackViewController.h"
#import "ContactViewController.h"
#import "LoginNetManager.h"
#import "ChangeAccountViewController.h"
#import "NewTabBarViewController.h"
#import "LoginNetManager.h"
#import "VersionUpdateModel.h"
#import "MineNetManager.h"
#import "HelpeCenterViewController.h"//帮助中心
#import "NoticeCenterViewController.h"//公告中心
#import "WebViewController.h"
@interface SettingCenterViewController ()<UITableViewDataSource,UITableViewDelegate,chatSocketDelegate>
{
    BOOL updateFlag;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VersionUpdateModel *versionModel;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIButton *loginOutButton;
@end

@implementation SettingCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mainColor;

    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"settingCenter" value:nil table:@"English"];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.tableFooterView;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingCenterTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([SettingCenterTableViewCell class])];
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];

}
//MARK:--国际化通知处理事件
- (void)languageSetting{
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"settingCenter" value:nil table:@"English"];
    [self.loginOutButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"loginOut" value:nil table:@"English"] forState:UIControlStateNormal];
    [self.tableView reloadData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LanguageChange object:nil];
}

//推出登录
- (void)loginoutAction{
    __weak SettingCenterViewController*weakSelf=self;

    [LEEAlert alert].config
    .LeeHeaderColor(mainColor)
    .LeeAddTitle(^(UILabel *label) {
        label.textColor = AppTextColor_E6E6E6;
        label.text = [[ChangeLanguage bundle] localizedStringForKey:@"warmPrompt" value:nil table:@"English"];
    })
    .LeeAddContent(^(UILabel *label) {
        label.textColor = AppTextColor_E6E6E6;
        label.text = [[ChangeLanguage bundle] localizedStringForKey:@"certainLogOutTip" value:nil table:@"English"];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.titleColor = AppTextColor_E6E6E6;
        action.borderColor = baseColor;
        action.title = LocalizationKey(@"ok");
        action.clickBlock = ^{
            [weakSelf logout];
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.titleColor = AppTextColor_E6E6E6;
        action.borderColor = baseColor;
        action.title = LocalizationKey(@"cancel");
    })
    .LeeShow();

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0 || section == 2) {
//        return 1;
//    }
//    return 4;

    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(NSArray *)getNameArr{

//    NSArray * nameArr = @[@[[[ChangeLanguage bundle] localizedStringForKey:@"languageSettings" value:nil table:@"English"]], @[[[ChangeLanguage bundle] localizedStringForKey:@"feedback" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"aboutUS" value:nil table:@"English"], [[ChangeLanguage bundle] localizedStringForKey:@"Noticecenter" value:nil table:@"English"], [[ChangeLanguage bundle] localizedStringForKey:@"Helpcenter" value:nil table:@"English"]], @[[[ChangeLanguage bundle] localizedStringForKey:@"versionUpdate" value:nil table:@"English"]]];

    //[[ChangeLanguage bundle] localizedStringForKey:@"languageSetting" value:nil table:@"English"],
     NSArray * nameArr = @[@[/*[[ChangeLanguage bundle] localizedStringForKey:@"feedback" value:nil table:@"English"],*/[[ChangeLanguage bundle] localizedStringForKey:@"aboutUS" value:nil table:@"English"], [[ChangeLanguage bundle] localizedStringForKey:@"Noticecenter" value:nil table:@"English"], [[ChangeLanguage bundle] localizedStringForKey:@"Helpcenter" value:nil table:@"English"]], @[[[ChangeLanguage bundle] localizedStringForKey:@"versionUpdate" value:nil table:@"English"]]];
    return nameArr;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   SettingCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SettingCenterTableViewCell class])];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SettingCenterTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.leftLabel.text = [self getNameArr][indexPath.section][indexPath.row];


    if (indexPath.section == 1) {
        cell.rightLabel.hidden = NO;
        // app当前版本
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.rightLabel.text = app_Version;
        if (updateFlag) {
            cell.updateLabel.hidden = NO;
        }else{
            cell.updateLabel.hidden = YES;
        }
    }else{
        cell.rightLabel.hidden = YES;
        cell.updateLabel.hidden = YES;
    }

    if (indexPath.section == 1) {
        cell.lineView.hidden = YES;
    }else{
        if (indexPath.row == 3) {
            cell.lineView.hidden = YES;
        }else{
            cell.lineView.hidden = NO;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        //语言设置
//        LanguageSettingsViewController *languageVC = [[LanguageSettingsViewController alloc] init];
//        languageVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:languageVC animated:YES];
//    }else
        if (indexPath.section == 0){
        switch (indexPath.row) {
//            case 0:
//            {
//                LanguageSetViewController *languageVC = [[LanguageSetViewController alloc] init];
//                languageVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:languageVC animated:YES];
//            }
//                break;
                /*case 0:
                {
                    //反馈意见
                    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
                    feedbackVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:feedbackVC animated:YES];
                }
                break;*/
            case 0:
            {
                //关于我们
                ContactViewController *aboutUSVC = [[ContactViewController alloc] init];
                aboutUSVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutUSVC animated:YES];
            }
                break;
            case 1:
            {
                //公告中心
                NoticeCenterViewController *notice = [[NoticeCenterViewController alloc] init];
                [[AppDelegate sharedAppDelegate] pushViewController:notice];
            }
                break;
            case 2:
            {
                //帮助中心
                HelpeCenterViewController *help = [[HelpeCenterViewController alloc] init];
                [[AppDelegate sharedAppDelegate] pushViewController:help];
            }
                break;
                
            case 3:
            {
                //客服中心
//                WebViewController *vc = [WebViewController new];
//                vc.urlStr = @"https://chatlink123.meiqia.cn/widget/standalone.html?eid=424a1dcc220c7f9b518b2eb83cf09adf";
//                [[AppDelegate sharedAppDelegate] pushViewController:vc];
                
//                HelpeCenterViewController *help = [[HelpeCenterViewController alloc] init];
//                [[AppDelegate sharedAppDelegate] pushViewController:help];
            }
                break;

            default:
                break;
        }
    }else{
        //版本更新
        [self versionUpdate];
//        else{
//            [self.view makeToast:LocalizationKey(@"versionUpdateTip") duration:1.5 position:CSToastPositionCenter];
//            return;
//        }
    }

}

-(void)logout{

    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"logOutTip" value:nil table:@"English"]];

    [LoginNetManager LogoutForCompleteHandle:^(id resPonseObj, int code) {
      [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
                    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];//断开聊天socket
                    [ChatSocketManager share].delegate = self;
                   [YLUserInfo logout];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NewTabBarViewController *SectionTabbar = [[NewTabBarViewController alloc] init];
                    APPLICATION.window.rootViewController=SectionTabbar;
                });
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{

            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - 版本更新接口请求
//MARK:--版本更新接口请求
-(void)versionUpdate{
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
        NSLog(LocalizationKey(@"版本更新接口请求 --- %@"),resPonseObj);

        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                // app当前版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSInteger curBuildVersion = [infoDictionary[@"CFBundleVersion"] integerValue];
                
                NSLog(@"app_Build ---- %zd",curBuildVersion);
                if (curBuildVersion < [self.versionModel.version integerValue]){
                    
                    if(self.versionModel.updateType == 1){
                        [LEEAlert alert].config
                        .LeeTitle(LocalizationKey(@"更新提示"))
                        .LeeAddContent(^(UILabel *label) {
                            label.text = ISEMPTY_S(self.versionModel.content)?LocalizationKey(@"当前有新的版本，请前往下载升级！"):self.versionModel.content;
                            label.font = [UIFont systemFontOfSize:16];
                        })
                        .LeeAction(LocalizationKey(@"立即更新"), ^{
                            NSURL *urlString = [NSURL URLWithString:self.versionModel.downloadUrl];
                            [[UIApplication sharedApplication] openURL:urlString options:@{} completionHandler:nil];
                        })
                        .LeeAction(LocalizationKey(@"暂不更新"), ^{
                            
                        })
                        .LeeShow();
                    }
                    else{
                        [LEEAlert alert].config
                        .LeeTitle(LocalizationKey(@"更新提示"))
                        .LeeAddContent(^(UILabel *label) {
                            label.text = ISEMPTY_S(self.versionModel.content)?LocalizationKey(@"当前有新的版本，请前往下载升级！"):self.versionModel.content;
                            label.font = [UIFont systemFontOfSize:16];
                        })
                        .LeeAction(LocalizationKey(@"立即更新"), ^{
                            NSURL *urlString = [NSURL URLWithString:self.versionModel.downloadUrl];
                            [[UIApplication sharedApplication] openURL:urlString options:@{} completionHandler:nil];
                            
                            [self exitApplication];
                        })
                        .LeeShow();
                    }
                }
                else{
                    [self.view makeToast:LocalizationKey(@"已是最新版本") duration:1.5 position:CSToastPositionCenter];
                }
            }
            else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
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

#pragma mark - SocketDelegate Delegate
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    if (cmd==UNSUBSCRIBE_GROUP_CHAT) {

    }
    NSLog(LocalizationKey(@"取消订阅聊天组-%@"),endStr);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [ChatSocketManager share].delegate = nil;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - NEW_NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 170 * kWindowHOne)];
        _tableFooterView.backgroundColor = [UIColor blackColor];

        self.loginOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginOutButton.frame = CGRectMake(15, 120, kWindowW - 30, 50);
        [self.loginOutButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"loginOut" value:nil table:@"English"] forState:UIControlStateNormal];
        [self.loginOutButton setBackgroundColor:RGBOF(0xF0A70A)];
        self.loginOutButton.layer.cornerRadius = 25;
        [self.loginOutButton addTarget:self action:@selector(loginoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_tableFooterView addSubview:self.loginOutButton];
    }
    return _tableFooterView;
}

@end
