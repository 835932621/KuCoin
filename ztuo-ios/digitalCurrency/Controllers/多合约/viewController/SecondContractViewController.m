//
//  SecondContractViewController.m
//  digitalCurrency
//
//  Created by Darker on 2021/7/13.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "SecondContractViewController.h"
#import "ContractLeftMenuViewController.h"
#import "SecondContractTableHeaderView.h"
#import "KchatViewController.h"
#import "CustomContraclItem.h"
#import "LeveragesView.h"
#import "ContractExchangeManager.h"
#import "ExchangeTableViewCell.h"
#import "ExchangedTableViewCell.h"
#import "TradeNetManager.h"
#import "SecondContractNetManager.h"
#import "SecondExchangeSymbolModel.h"
#import "OYCountDownManager.h"

@interface SecondContractViewController ()<UITableViewDelegate,UITableViewDataSource,SocketDelegate>
{
    ///精确度(小数点后几位)
    int _baseCoinScale;
    ///精确度(小数点后几位)
    int _coinScale;
}

@property (nonatomic, strong) ContractLeftMenuViewController *menu;
@property (nonatomic, strong) UILabel *topTitlelabel;
@property (nonatomic, copy  ) NSString *symbol;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) SecondContractTableHeaderView *headerView;

@property (nonatomic, strong) LeveragesView *leveragesView;

/**左上角选择货币按钮*/
@property (nonatomic, strong) UIButton *selectCurencyBtn;
/**杠杠倍数选择btn*/
@property (nonatomic, strong) CustomContraclItem *leverageBtn;
/**杠杆倍数文本*/
@property (nonatomic, copy  ) NSString *leverageStr;

//@property (nonatomic, strong) NSDictionary *symbolInfo; //合约币种详情

@property (nonatomic, strong) NSMutableArray *exchangeDataAry;

///所有的交易货币数据
@property (nonatomic, strong) NSMutableArray<SecondExchangeSymbolModel *> *symbolModelAry;
///当前选中的交易货币数据
@property (nonatomic, strong) SecondExchangeSymbolModel *curSymbolModel;

@property (nonatomic, assign) SecondTableCellType cellType;

///http请求返回的handler
@property (nonatomic, copy ) void (^completeHandle)(id _Nonnull, int);

@end

@implementation SecondContractViewController

#pragma mark - Getter or Setter
+ (symbolModel *)symbolModel {
    return _symbolModel;
}

//+ (int)shareNumber{
//    return _shareNumber;
//}

-(UILabel *)topTitlelabel{
    
    if (!_topTitlelabel) {
        _topTitlelabel=[[UILabel alloc]init];
        _topTitlelabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        _topTitlelabel.textAlignment=NSTextAlignmentLeft;
        _topTitlelabel.textColor=VCBackgroundColor;
        _topTitlelabel.frame=CGRectMake(12,3,SCREEN_WIDTH_S-105,30);
        [self.view addSubview:_topTitlelabel];
    }
    return _topTitlelabel;
}

- (UIButton *)selectCurencyBtn{
    if (!_selectCurencyBtn) {
        _selectCurencyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_selectCurencyBtn setBackgroundImage:[UIImage imageNamed:@"tradeLeft"] forState:UIControlStateNormal];
        _selectCurencyBtn.frame = CGRectMake(10,8,20,20);
        
        [_selectCurencyBtn addTarget:self action:@selector(LefttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectCurencyBtn;
}

- (CustomContraclItem *)leverageBtn{
    if(!_leverageBtn){
        _leverageBtn = [[CustomContraclItem alloc]init];
        _leverageBtn.leftlabel.text = NSLocalizedString(@"杠杆 10x", nil);
        _leverageBtn.layer.borderWidth = 1;
        _leverageBtn.layer.borderColor = AppTextColor_E6E6E6.CGColor;
        _leverageBtn.frame = CGRectMake(kWindowW - 160, 8, 100, 20);
        [_leverageBtn addTarget:self action:@selector(onClickLeverageBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leverageBtn;
}

- (NSMutableArray *)exchangeDataAry{
    if (!_exchangeDataAry) {
        _exchangeDataAry = [NSMutableArray array];
    }
    return _exchangeDataAry;
}

- (NSMutableArray<SecondExchangeSymbolModel *> *)symbolModelAry{
    if (!_symbolModelAry) {
        _symbolModelAry = [NSMutableArray array];
    }
    return _symbolModelAry;
}

- (SecondContractTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [SecondContractTableHeaderView new];
        __weak typeof(self)weakself = self;
        _headerView.didClickBuy = ^(BOOL isBuyUp) {
            //            NSLog(NSLocalizedString(@"买涨 %d", nil), isBuyUp);
            NSInteger direction = [isBuyUp ? @1 : @2 integerValue];
            [weakself reqExchangeWithDirection:direction];
        };
        
        _headerView.didExchangeData = ^(BOOL isExchanging) {
            if(isExchanging){
//                [weakself.headerView setProfit:NSLocalizedString(@"预计盈利", nil) andCountdown:NSLocalizedString(@"倒计时", nil)];
                weakself.cellType = SecondTableCellTypeExchanging;
            }
            else{
//                [weakself.headerView setProfit:NSLocalizedString(@"盈利", nil) andCountdown:@""];
                weakself.cellType = SecondTableCellTypeExchanged;
            }
            [weakself reqExchangeList];
        };
    }
    return  _headerView;
}

- (UITableView *)myTableView {
    if (!_myTableView) {
        if (!_myTableView) {
            _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
            _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
            _myTableView.separatorColor = UIColor.darkGrayColor;
            _myTableView.dataSource = self;
            _myTableView.delegate = self;
            _myTableView.rowHeight = 100;
            _myTableView.sectionFooterHeight = 0.00001f;
            _myTableView.tableHeaderView = self.headerView;
//            _myTableView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0);
            _myTableView.backgroundColor = mainColor;
            
            [_myTableView registerClass:[ExchangeTableViewCell class] forCellReuseIdentifier:@"ExchangeTableViewCellId"];
            [_myTableView registerClass:[ExchangedTableViewCell class] forCellReuseIdentifier:@"ExchangedTableViewCellId"];
            
            [self.view addSubview:_myTableView];
        }
    }
    return  _myTableView;
}

#pragma mark-viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mainColor;
    _curSymbolModel = nil;
    _symbol = @"BTC/USDT";
    self.leverageStr = @"";
    
    MJWeakSelf
    //接收到秒合约交易列表数据的处理
    self.completeHandle = ^(id _Nonnull resPonseObj, int code) {
        if (code) {
            if (code == 1 && [resPonseObj[@"code"] isEqual:@0]) {
                [weakSelf.exchangeDataAry removeAllObjects];
                
                id array = resPonseObj[@"data"];
                if ([array isKindOfClass:[NSArray class]]) {
                    NSArray *data = (NSArray *)array;
                    for (int i=0; i<data.count; i++) {
                        SecondExchangeModel *model= [SecondExchangeModel mj_objectWithKeyValues:data[i]];
                        [weakSelf.exchangeDataAry addObject:model];
                    }
                }
                
                [kCountDownManager reload];
                [weakSelf.myTableView reloadData];
            }
            else{
                [weakSelf.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }
        else{
            [weakSelf.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    };
    
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(MULTI_CONTRACT_TABBAR_HEIGHT);
        make.bottom.mas_equalTo(-kTabbarHeight);
    }];
    
    //    [self LeftsetupNavgationItemWithpictureName:@"tradeLeft"];
    
    [self initTopView];
    
    [self getSingleAccuracy:self.symbol];
}

-(void) initTopView{
//    [self.view addSubview:self.selectCurencyBtn]; 不需要切换交易对
//    [self.view addSubview:self.leverageBtn]; 不需要杠杆功能了
    
    UIButton *tradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tradeButton.frame= CGRectMake(kWindowW - 40, 3, 30, 30);
    [tradeButton setImage:[UIImage imageNamed:@"tradeRight"] forState:UIControlStateNormal];
    [tradeButton addTarget:self action:@selector(tradeRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tradeButton];
    
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0,tradeButton.frame.origin.y+self.selectCurencyBtn.frame.size.height+10,SCREEN_WIDTH_S, 1)];
    line.backgroundColor=ViewBackgroundColor;
    [self.view addSubview:line];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    // 启动倒计时管理
    [kCountDownManager start];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setChangedSymbol:_symbol];
    [self getSymbolListInfo];
    [self setContractSoccket];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerAction) name:@"KTimerNotification" object:nil];
    
    // 监听倒计时结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:@"ExchangeTableViewCell" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self cancelContractSocket];
    
    // 销毁倒计时管理
    [kCountDownManager invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)countDownNotification {
    [self reqExchangeList];
}

- (void) updateSymbolInfoUI{
    if (!self.curSymbolModel) {
        return;
    }
    
    [self setChangedSymbol:self.curSymbolModel.symbol];
    [self.headerView updateUI:self.curSymbolModel];
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exchangeDataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.cellType == SecondTableCellTypeExchanging){
        ExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangeTableViewCellId" forIndexPath:indexPath];
        
        cell.model = self.exchangeDataAry[indexPath.row];
        return  cell;
    }
    else if(self.cellType == SecondTableCellTypeExchanged){
        ExchangedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExchangedTableViewCellId" forIndexPath:indexPath];
        
        cell.model = self.exchangeDataAry[indexPath.row];
        return  cell;
    }
    else{
        return nil;
    }
    
}

#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.cellType == SecondTableCellTypeExchanging){
        return 90;
    }
    else{
        return 115;
    }
}

#pragma mark-左侧弹出菜单
-(void)LefttouchEvent{
    
    /*if (!self.menu) {
        self.menu = [[ContractLeftMenuViewController alloc]init];
        CGRect frame = self.menu.view.frame;
        frame.origin.x = - CGRectGetWidth(self.view.frame);
        self.menu.view.frame = CGRectMake(- CGRectGetWidth(self.view.frame), 0,  kWindowW, kWindowH);
        [[UIApplication sharedApplication].windows[0] addSubview:self.menu.view];
        MJWeakSelf
        self.menu.selcetContractcoinSymbolModelBlock = ^(symbolModel * _Nonnull model) {
            
            [weakSelf cancelContractSocket];
            [weakSelf setChangedSymbol:model.symbol];
            [weakSelf setContractSoccket];
            
            [weakSelf getSingleAccuracy:weakSelf.symbol];
        };
    }
    else{
        self.menu.isObserverNotificantion=YES;
    }
    
    [self.menu showLeftContractMenu];*/
}


#pragma mark-导航栏右侧的进入K线按钮点击事件
-(void)tradeRightBtnClick{
    [self cancelContractSocket];
    KchatViewController*klineVC=[[KchatViewController alloc]init];
    klineVC.isShowContract=YES;
    klineVC.symbol=_symbol;
    klineVC.istype = @"2";
    [[AppDelegate sharedAppDelegate] pushViewController:klineVC withBackTitle:_symbol];
}

#pragma mark-切换币种
- (void)setChangedSymbol:(NSString *)symbol{
    _symbol = symbol;
    self.topTitlelabel.text = [NSString stringWithFormat:@"%@",symbol];//LocalizationKey(@"Option_contract")
    
    for (SecondExchangeSymbolModel *model in self.symbolModelAry) {
        if ([model.symbol isEqualToString:_symbol]) {
            self.curSymbolModel = model;
//            _shareNumber = model.shareNumber;
            break;
        }
    }
    
    if (YLUserInfo.isLogIn) {
        [self reqExchangeList];
    }
}

#pragma mark -选择杠杆倍数
- (void)onClickLeverageBtn{
    /*if(self.curSymbolModel){
        MJWeakSelf
        NSNumber *leverageType = @1;
        
        if (self.curSymbolModel.leverageGroup.count > 0) {
            
            NSMutableArray *titles = [NSMutableArray new];
            for (id num in self.curSymbolModel.leverageGroup) {
                [titles addObject: [NSString stringWithFormat:@"%@", num]];
            }
            
            if (!_leveragesView) {
                _leveragesView=[[LeveragesView alloc]init];
                _leveragesView.selcetLeverageblock = ^(NSInteger idx, NSString * _Nonnull selectStr) {
                    [weakSelf setleverageNumbers:selectStr];
                };
            }
            _leveragesView.leverageType = leverageType;
            _leveragesView.titles = titles;
            _leveragesView.selectLeverString = self.leverageStr;
            [_leveragesView showsLevergesView];
            if(leverageType.longValue == 1){
                [_leveragesView showMyScrollView];
            }else {
                [_leveragesView showSliderView];
            }
        }
    }*/
    
    /*if (self.symbolInfo) {
     MJWeakSelf
     NSString *leverage=self.symbolInfo[@"leverage"];
     NSNumber *leverageType = self.symbolInfo[@"leverageType"];
     
     if (leverage && leverage.length!=0) {
     
     NSArray *titles= [leverage componentsSeparatedByString:@","];
     
     if (!_leveragesView) {
     _leveragesView=[[LeveragesView alloc]init];
     _leveragesView.selcetLeverageblock = ^(NSInteger idx, NSString * _Nonnull selectStr) {
     [weakSelf setleverageNumbers:selectStr];
     };
     }
     _leveragesView.leverageType = leverageType;
     _leveragesView.titles = titles;
     _leveragesView.selectLeverString = self.leverageStr;
     [_leveragesView showsLevergesView];
     if(leverageType.longValue == 1){
     [_leveragesView showMyScrollView];
     }else {
     [_leveragesView showSliderView];
     }
     }
     }*/
}

//修改杠杆倍率
-(void)setleverageNumbers:(NSString *)leverage{
    self.leverageStr = leverage;
    self.leverageBtn.leftlabel.text=[NSString stringWithFormat:NSLocalizedString(@"杠杆 %@x", nil),self.leverageStr];
}



/*- (void)getContractSymbolInfo:(NSString *)symbol {
    
    if (symbol.length==0) {
        return;
    }
    
    [ContractExchangeManager getContractSymbolinfo:symbol CompleteHandle:^(id  _Nonnull resPonseObj, int code) {
        if (code) {
            NSLog(NSLocalizedString(@"darker 获取到币种数据：%@", nil), resPonseObj);
            if ([resPonseObj[@"code"] intValue] == 0) {
                self.symbolInfo = (NSDictionary *)resPonseObj;
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
    
}*/

#pragma mark - socket消息订阅
- (void)setContractSoccket{
    NSLog(NSLocalizedString(@"秒合约界面开始订阅socket", nil));
    
    NSDictionary*dic;
    if ([YLUserInfo isLogIn]) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:_symbol,@"symbol",[YLUserInfo shareUserInfo].ID,@"uid",nil];
    }
    else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:_symbol,@"symbol",nil];
    }
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:CONTRACT_SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId:0 withbody:@{}];
    
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_EXCHANGE_TRADE_CONTRACT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    
    [SocketManager share].delegate = self;
    
}

- (void)cancelContractSocket{
//    NSLog(NSLocalizedString(@"秒合约界面取消订阅socket", nil));
//    NSDictionary*dic;
//    if ([YLUserInfo isLogIn]) {
//        dic=[NSDictionary dictionaryWithObjectsAndKeys:_symbol,@"symbol",[YLUserInfo shareUserInfo].ID,@"uid",nil];
//    }
//    else{
//        dic=[NSDictionary dictionaryWithObjectsAndKeys:_symbol,@"symbol",nil];
//    }
//
//    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:CONTRACT_UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId:0 withbody:@{}];
//    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE_CONTRACT withVersion:COMMANDS_VERSION withRequestId:0 withbody:dic];
//    [SocketManager share].delegate = nil;
}

#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr = [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd = [SocketUtils uint16FromBytes:cmdData];
    //    NSLog(NSLocalizedString(@"盘口信息-- PUSH_SYMBOL_THUMB--", nil));
    //缩略行情
    
    if (cmd == CONTRACT_PUSH_SYMBOL_THUMB) {
        NSDictionary*dic = [SocketUtils dictionaryWithJsonString:endStr];
//        NSLog(NSLocalizedString(@"darker 缩略行情 -- %@", nil),dic);
        symbolModel *model = [symbolModel mj_objectWithKeyValues:dic];
        if ([model.symbol isEqualToString:self.symbol]) {
            _symbolModel = model;
            [self updateThumbUIInfo:model];
        }
    }else if (cmd == CONTRACT_UNSUBSCRIBE_SYMBOL_THUMB){
        NSLog(NSLocalizedString(@"darker 取消订阅K线缩略行情消息", nil));
    }
}

#pragma mark-获取单个交易对的精确度
-(void)getSingleAccuracy:(NSString*)symbol{
    [TradeNetManager getSingleSymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        if ([resPonseObj isKindOfClass:[NSDictionary class]]) {
            _baseCoinScale = [resPonseObj[@"baseCoinScale"]intValue];
            _coinScale = [resPonseObj[@"coinScale"] intValue];
        }
    }];
}

///更新缩略行情
-(void)updateThumbUIInfo:(symbolModel*)model{
    [self.headerView updateKlineHeaderCel:model baseCoinScale:_baseCoinScale CoinScale:_coinScale];
}


#pragma mark - http请求

///获取秒合约交易对数据
- (void)getSymbolListInfo {
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    MJWeakSelf
    [SecondContractNetManager getSymbolListInfo:^(id  _Nonnull resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        //        NSLog(NSLocalizedString(@"darker 获取秒合约交易对数据 %@", nil),resPonseObj);
        
        if (code) {
            if (code == 1) {
                if ([resPonseObj[@"data"] isKindOfClass:[NSArray class]]) {
                    [weakSelf.symbolModelAry removeAllObjects];
                    NSArray *array = (NSArray*)resPonseObj[@"data"];
                    
                    for (int i=0; i<array.count; i++) {
                        SecondExchangeSymbolModel *model= [SecondExchangeSymbolModel mj_objectWithKeyValues:array[i]];
                        [weakSelf.symbolModelAry addObject:model];
                    }
                    
                    weakSelf.curSymbolModel = weakSelf.symbolModelAry.firstObject;
                    //获取到数据后更新UI
                    [weakSelf updateSymbolInfoUI];
                    [weakSelf getBalanceAndProfit];
                    
                    //更新杠杆数据,默认设置第一个倍数
//                    if (weakSelf.curSymbolModel.leverageGroup.count > 0) {
//                        NSString *leverage = [NSString stringWithFormat:@"%@", weakSelf.curSymbolModel.leverageGroup[0]];
//                        [weakSelf setleverageNumbers:leverage];
//                    }
                }
            }
            else{
                [weakSelf.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }
        else{
            [weakSelf.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
}

///通过symbol获取coinid
-(NSInteger) getCoinIdWithSymbol:(NSString *) symbol{
    for (SecondExchangeSymbolModel *model in self.symbolModelAry) {
        if ([model.symbol isEqualToString:_symbol]) {
            
            return [model.coinId integerValue];
        }
    }
    return 0;
}

///获取余额和盈利率
- (void)getBalanceAndProfit {
    if (![YLUserInfo isLogIn]) {
        return;
    }
    
    NSInteger coidId = [self getCoinIdWithSymbol:_symbol];
    [SecondContractNetManager getBalanceAndProfitWithCoinId:coidId CompleteHandle:^(id  _Nonnull resPonseObj, int code) {
        NSLog(NSLocalizedString(@"darker 获取到余额盈利率 %@", nil),resPonseObj);
        if (code) {
            if (code == 1) {
                NSDictionary *dic = resPonseObj[@"data"];
                //获取到数据后更新余额、盈利率
                if(dic[@"profitPercent"]){
                    NSString *balance = [[NSString alloc] initWithFormat:@"%@", dic[@"balance"]];
                    double profitPercent = [dic[@"profitPercent"] doubleValue];
                    [self.headerView updateBalance:balance andProfit:profitPercent];
                }else{
                    [self.headerView updateBalance:@"" andProfit:0];
                }
                
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

///请求交易看📈或📉
- (void) reqExchangeWithDirection:(NSInteger)direction{
    if (![YLUserInfo isLogIn]) {
        [self showLoginViewController];
        return;
    }
    
    NSInteger coidId = [self getCoinIdWithSymbol:_symbol];
    NSInteger cycleTime = [self.headerView getExchangeTime];
    NSString * volume = [self.headerView getExchangeCount];
    NSInteger leverage = [self.leverageStr integerValue];
    [SecondContractNetManager reqExchangeWithCoinId:coidId withDirection:direction withCycleTime:cycleTime withVolume:volume withLeverage:leverage CompleteHandle:^(id  _Nonnull resPonseObj, int code) {
        
        NSLog(NSLocalizedString(@"darker 请求买涨买跌返回 %@", nil),resPonseObj);
        if (code) {
            if (code == 1 && [resPonseObj[@"code"] isEqual:@0]) {
                //下单成功
                [self getBalanceAndProfit];
                [self reqExchangeList];
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
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

///请求交易中或者交易完成的列表数据
- (void) reqExchangeList{
    if (![YLUserInfo isLogIn]) {
        [self showLoginViewController];
        return;
    }
    
    BOOL isExchanging = self.cellType == SecondTableCellTypeExchanging;
    if (isExchanging) {
        [SecondContractNetManager getExchangingListWithSymbol:_symbol CompleteHandle:self.completeHandle];
    }
    else{
        [SecondContractNetManager getExchangedListWithSymbol:_symbol CompleteHandle:self.completeHandle];
    }
}
@end
