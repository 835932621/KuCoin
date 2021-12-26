//
//  MultiContractViewController.m
//  digitalCurrency
//
//  Created by darker on 2021/7/7.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "MultiContractViewController.h"
#import "SLSegmentView.h"
#import "ContractExchangeViewController.h"
#import "OptionViewController.h"
#import "SecondContractViewController.h"


@interface MultiContractViewController ()
{
    ///当前选中的tabIndex
    int curSegmentIndex;
}

@property (nonatomic, strong) SLSegmentView *segment;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) NSArray *segmentTitleArray;

@property (nonatomic, strong) NSMutableArray *vcArray; //vc数组

@end

@implementation MultiContractViewController

-(NSMutableArray *)vcArray {
    
    if (!_vcArray) {
        _vcArray =[NSMutableArray array];
    }
    return _vcArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    curSegmentIndex = 0;
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = mainColor;
    ///TODO: hidden first
    self.segmentTitleArray= @[LocalizationKey(@"option"),LocalizationKey(@"second_contract")];  //@[LocalizationKey(@"Professional_contract"),LocalizationKey(@"option"),LocalizationKey(@"second_contract")];
    [self.view addSubview:self.segment];
    
    [self createChildCtrls];
}

- (void)createChildCtrls
{
    OptionViewController *vc0 = [[OptionViewController alloc]init];
    int posY = NEW_StatusBarHeight+MULTI_CONTRACT_TABBAR_HEIGHT;
    int height = kWindowH - NEW_StatusBarHeight - MULTI_CONTRACT_TABBAR_HEIGHT;//kTabbarHeight - SafeAreaBottomHeight
    [vc0.view setFrame:CGRectMake(0, posY, kWindowW, height)];
    
    //添加子控制器
    [self addChildViewController:vc0];
    
    [vc0 didMoveToParentViewController:self];//addChildViewController 会调用 [child willMoveToParentViewController:self] 方法，但是不会调用 didMoveToParentViewController:方法，官方建议显示调用
    
    self.currentVC = vc0;
    [self.view addSubview:self.currentVC.view];
    
    SecondContractViewController *vc1 = [[SecondContractViewController alloc]init];
    [vc1.view setFrame:CGRectMake(0, posY, kWindowW, height)];
        
    [self.vcArray addObject:vc0];
    [self.vcArray addObject:vc1];

}

//- (void)createChildCtrls
//{
//    ContractExchangeViewController *vc0 = [[ContractExchangeViewController alloc]init];
//    int posY = NEW_StatusBarHeight+MULTI_CONTRACT_TABBAR_HEIGHT;
//    int height = kWindowH - NEW_StatusBarHeight - MULTI_CONTRACT_TABBAR_HEIGHT;//kTabbarHeight - SafeAreaBottomHeight
//    [vc0.view setFrame:CGRectMake(0, posY, kWindowW, height)];
//
//    //添加子控制器
//    [self addChildViewController:vc0];
//
//    [vc0 didMoveToParentViewController:self];//addChildViewController 会调用 [child willMoveToParentViewController:self] 方法，但是不会调用 didMoveToParentViewController:方法，官方建议显示调用
//
//    self.currentVC = vc0;
//    [self.view addSubview:self.currentVC.view];
//
//
//    OptionViewController *vc1 = [[OptionViewController alloc]init];
//    [vc1.view setFrame:CGRectMake(0, posY, kWindowW, height)];
//
//    SecondContractViewController *vc2 = [[SecondContractViewController alloc]init];
//    [vc2.view setFrame:CGRectMake(0, posY, kWindowW, height)];
//
//
//    [self.vcArray addObject:vc0];
//    [self.vcArray addObject:vc1];
//    [self.vcArray addObject:vc2];
//}

#pragma mark -国际化通知处理事件
- (void)languageSetting{
    [self.segment modifyButtonTitle:LocalizationKey(@"collect")];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.segment movieToCurrentSelectedSegment:curSegmentIndex];
    [self changeControllerFromOldController:self.currentVC toNewController:self.vcArray[curSegmentIndex]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self cancelContractSocket];
}

-(void)cancelContractSocket{
//    NSLog(NSLocalizedString(@"U本位合约界面取消订阅socket", nil));
    NSString *symbol = @"BTC/USDT";
    NSMutableDictionary *dic;
    if ([YLUserInfo isLogIn]) {
        dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:symbol,@"symbol",[YLUserInfo shareUserInfo].ID,@"uid",nil];
    }
    else{
        dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:symbol,@"symbol",nil];
    }

    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:CONTRACT_UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId:0 withbody:nil];

    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE_CONTRACT withVersion:COMMANDS_VERSION withRequestId:0 withbody:dic];
    
    dic[@"symbol"] = @"ETH/USDT";
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE_CONTRACT withVersion:COMMANDS_VERSION withRequestId:0 withbody:dic];
    
    dic[@"symbol"] = @"LTC/USDT";
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE_CONTRACT withVersion:COMMANDS_VERSION withRequestId:0 withbody:dic];
    
    [SocketManager share].delegate = nil;
}


#pragma mark - 懒加载
- (SLSegmentView *)segment
{
    if (!_segment) {
        _segment = [[SLSegmentView alloc] initWithSegmentWithTitleArray:self.segmentTitleArray];
        _segment.frame=CGRectMake(0,NEW_StatusBarHeight, kWindowW, MULTI_CONTRACT_TABBAR_HEIGHT);
        __weak typeof(self)weakSelf = self;
        _segment.clickSegmentButton = ^(NSInteger index) {
//            NSLog(@"darker clickSegmentButton %ld", index);
            curSegmentIndex = (int)index;
            [weakSelf changeControllerFromOldController:weakSelf.currentVC toNewController:weakSelf.vcArray[index]];
            
        };
    }
    return _segment;
}


#pragma mark - 切换viewController
- (void)changeControllerFromOldController:(UIViewController *)oldController toNewController:(UIViewController *)newController
{
    if (oldController == newController) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    
    [self addChildViewController:newController];
    
    /**
     *  切换ViewController
     */
    [self transitionFromViewController:oldController toViewController:newController duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            //            NSLog(@"darker transitionFromViewController finished");
            //移除oldController，但在removeFromParentViewController：方法前不会调用willMoveToParentViewController:nil 方法，所以需要显示调用
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            
            weakSelf.currentVC = newController;
        }
        else {
            weakSelf.currentVC = oldController;
        }
        
    }];
}

@end
