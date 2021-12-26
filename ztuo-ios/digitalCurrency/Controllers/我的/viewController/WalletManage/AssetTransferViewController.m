//
//  AssetTransferViewController.m
//  digitalCurrency
//
//  Created by ios on 2020/10/9.
//  Copyright © 2020 BIZZAN. All rights reserved.
//

#import "AssetTransferViewController.h"
#import "AssetTransferMenuView.h"
#import "MineNetManager.h"
#import "WalletContractCoinModel.h"
#import "WalletSelectCurrencyViewController.h"
#import "TransferCurrencyModel.h"
#import "ContractExchangeManager.h"



@interface AssetTransferViewController ()

@property (nonatomic, strong) AssetTransferMenuView *oneView;

@property (nonatomic, strong) AssetTransferMenuView *twoView;

@property (nonatomic, strong) UILabel *titleCoinlabel;

@property (nonatomic, strong) UITextField *inputNumberTextfield;

@property (nonatomic, strong) NSMutableDictionary *bbDataDic;
@property (nonatomic, strong) NSMutableDictionary *mhyDataDic;
///永续钱包数据数组
@property (nonatomic, strong) NSMutableArray *yxDataArray;

//@property (nonatomic, strong) WalletContractCoinModel *selectCoinModel;

@property (nonatomic, strong) UILabel *unitlabel;

///第一个钱包数据
@property (nonatomic, strong) TransferCurrencyModel *fromWalletData;
///第二个钱包数据
@property (nonatomic, strong) TransferCurrencyModel *toWalletData;

@end

@implementation AssetTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view.
    self.navigationItem.title=LocalizationKey(@"Wallet_Overturn");
    self.view.backgroundColor=mainColor;
    [self loadInitSubView];
    
    [self getAllData];
    
}

-(void)getAllData{
    //获取币币、永续、秒合约钱包数据，三个协议分别是一个个请求
    [self getWalletUsdtData];
}


- (void)loadInitSubView {
    MJWeakSelf;
    UIFont *txtfont=[UIFont systemFontOfSize:15*kWindowWHOne];
    UIFont *bigfont=[UIFont boldSystemFontOfSize:17*kWindowWHOne];
    UIView *topView= [[UIView alloc]initWithFrame:CGRectMake(15,15,SCREEN_WIDTH_S-30,120)];
    topView.layer.cornerRadius=5;
    topView.layer.borderWidth=1;
    topView.layer.borderColor=baseColor.CGColor;
    topView.layer.masksToBounds=YES;
    topView.clipsToBounds=YES;
    [self.view addSubview:topView];
    
    UILabel *fmlabel=[[UILabel alloc]init];
    fmlabel.text=LocalizationKey(@"from");
    fmlabel.textColor=baseColor;
    fmlabel.font=txtfont;
    [topView addSubview:fmlabel];
    CGSize maxsize = [fmlabel sizeThatFits:CGSizeMake(MAXFLOAT,20)];
    
    [fmlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(maxsize);
    }];
    UILabel *tolabel=[[UILabel alloc]init];
    tolabel.text=LocalizationKey(@"to");
    tolabel.textColor=baseColor;
    tolabel.font=txtfont;
    [topView addSubview:tolabel];
    CGSize maxsize2 = [tolabel sizeThatFits:CGSizeMake(MAXFLOAT,20)];
    [tolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fmlabel.mas_centerX).offset(0);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(maxsize2);
    }];
    UIImageView *xximgview=[[UIImageView alloc]init];
    xximgview.image=[UIImage imageNamed:@"czxuxian"];
    [topView addSubview:xximgview];
    
    [xximgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fmlabel.mas_centerX).offset(0);
        make.top.equalTo(fmlabel.mas_bottom).offset(5);
        make.bottom.equalTo(tolabel.mas_top).offset(-5);
        make.width.mas_equalTo(60);
    }];
    
    _oneView=[[AssetTransferMenuView alloc]init];
    _oneView.mtitlelabel.text=LocalizationKey(@"tv_coins");
    _oneView.mtitlelabel.textColor = VCBackgroundColor;
    _oneView.isShowArrow=YES;
    _oneView.tag=200;
    [_oneView addTarget:self action:@selector(menubtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_oneView];
    
    _twoView=[[AssetTransferMenuView alloc]init];
    _twoView.mtitlelabel.text=LocalizationKey(@"tv_constract");
    _twoView.mtitlelabel.textColor = VCBackgroundColor;
    _twoView.isShowArrow=YES;
    _twoView.tag=300;
    [_twoView addTarget:self action:@selector(menubtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:_twoView];
    
    _oneView.frame=CGRectMake(70,0,topView.frame.size.width-140,topView.frame.size.height/2);
    _twoView.frame=CGRectMake(70,topView.frame.size.height/2,topView.frame.size.width-140,topView.frame.size.height/2);
    
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=AppTextColor_999999;
    [topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70);
        make.right.mas_equalTo(-70);
        make.centerY.equalTo(topView.mas_centerY).offset(0);
        make.height.mas_equalTo(1);
    }];
        
    UIView *rightbackview=[[UIView alloc]init];
    rightbackview.backgroundColor=baseColor;
    rightbackview.frame=CGRectMake(topView.frame.size.width-60,0,60,topView.frame.size.height);
    [topView addSubview:rightbackview];
    UIImageView *upimgview=[[UIImageView alloc]init];
    upimgview.image=[UIImage imageNamed:@"huazhuan_uparrow"];
    [rightbackview addSubview:upimgview];
    UIImageView *downimgview=[[UIImageView alloc]init];
    downimgview.image=[UIImage imageNamed:@"huazhuan_downarrow"];
    [rightbackview addSubview:downimgview];
    [upimgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightbackview.mas_centerX).offset(0);
        make.bottom.equalTo(rightbackview.mas_centerY).offset(-5);
        make.size.mas_equalTo(CGSizeMake(20,20));
    }];
    [downimgview mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(rightbackview.mas_centerX).offset(0);
               make.top.equalTo(rightbackview.mas_centerY).offset(5);
               make.size.mas_equalTo(CGSizeMake(20,20));
    }];
    
    UIControl *rightupMenu=[[UIControl alloc]init];

    rightupMenu.frame=CGRectMake(0,0,rightbackview.frame.size.width,topView.frame.size.height/2);
    rightupMenu.tag=101;
    [rightupMenu addTarget:self action:@selector(menubtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [rightbackview addSubview:rightupMenu];

    UIControl *rightdownMenu=[[UIControl alloc]init];
    rightdownMenu.frame=CGRectMake(0,topView.frame.size.height/2,rightbackview.frame.size.width,topView.frame.size.height/2);
    rightdownMenu.tag=102;
      [rightdownMenu addTarget:self action:@selector(menubtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [rightbackview addSubview:rightdownMenu];


    UIView *centerBackView=[[UIView alloc]initWithFrame:CGRectMake(topView.frame.origin.x,topView.frame.size.height+topView.frame.origin.y+15,topView.frame.size.width,70)];
    [self.view addSubview:centerBackView];
    centerBackView.hidden=YES;
    UILabel *typeCoinlabel=[[UILabel alloc]init];
    typeCoinlabel.textAlignment=NSTextAlignmentLeft;
    typeCoinlabel.textColor=AppTextColor_Level_1;
    typeCoinlabel.font=txtfont;
    typeCoinlabel.text=LocalizationKey(@"currency");
    [centerBackView addSubview:typeCoinlabel];

    _titleCoinlabel=[[UILabel alloc]init];
    _titleCoinlabel.font=bigfont;
    _titleCoinlabel.textColor=AppTextColor_Level_1;
    _titleCoinlabel.textAlignment=NSTextAlignmentLeft;
    [centerBackView addSubview:_titleCoinlabel];
    _titleCoinlabel.text=@"BTC";
    
    UIImageView *rightarrow=[[UIImageView alloc]init];
    rightarrow.image=[UIImage imageNamed:@"back2"];
    [centerBackView addSubview:rightarrow];

    [typeCoinlabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];

    [_titleCoinlabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(30);
    }];

    [rightarrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(weakSelf.titleCoinlabel.mas_centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(10,20));
    }];

    UIControl *centermenu=[[UIControl alloc]init];
    centermenu.tag=103;
    [centermenu addTarget:self action:@selector(menubtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [centerBackView addSubview:centermenu];

    [centermenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(weakSelf.titleCoinlabel.mas_bottom).offset(0);
        make.height.mas_equalTo(30);
    }];

    UIView *line2=[[UIView alloc]init];
    line2.backgroundColor=AppTextColor_999999;
    [centerBackView addSubview:line2];

    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(topView.frame.origin.x,topView.frame.size.height+topView.frame.origin.y+15,topView.frame.size.width,70)];
    
    [self.view addSubview:bottomView];
    
    UILabel *numbertiplabel=[[UILabel alloc]init];
    numbertiplabel.textAlignment=NSTextAlignmentLeft;
    numbertiplabel.font=txtfont;
    numbertiplabel.text=LocalizationKey(@"tv_overturn_number");
    numbertiplabel.textColor = VCBackgroundColor;
    [bottomView addSubview:numbertiplabel];
    
    [numbertiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *qbbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [qbbtn setTitle:LocalizationKey(@"all") forState:UIControlStateNormal];
    [qbbtn setTitleColor:baseColor forState:UIControlStateNormal];
    qbbtn.titleLabel.font=txtfont;
    qbbtn.tag=104;
       [qbbtn addTarget:self action:@selector(menubtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:qbbtn];
    
    UILabel *uintlabel=[[UILabel alloc]init];
    uintlabel.textColor=AppTextColor_Level_3;
    uintlabel.text=@"USDT";
    uintlabel.font=txtfont;
    [bottomView addSubview:uintlabel];
    _unitlabel=uintlabel;
    CGSize maxsize3 = [qbbtn.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT,20)];
    CGSize maxsize4 = [uintlabel sizeThatFits:CGSizeMake(MAXFLOAT,20)];
    
    [qbbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(maxsize3);
    }];
    
    [uintlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(qbbtn.mas_bottom).offset(0);
        make.right.equalTo(qbbtn.mas_left).offset(-15);
        make.size.mas_equalTo(maxsize4);
    }];
    
    _inputNumberTextfield=[[UITextField alloc]init];
    _inputNumberTextfield.placeholder=LocalizationKey(@"tv_input_overturn_number");
    _inputNumberTextfield.textColor=AppTextColor_666666;
    _inputNumberTextfield.font=bigfont;
    _inputNumberTextfield.keyboardType=UIKeyboardTypeDecimalPad;
    [bottomView addSubview:_inputNumberTextfield];
    
    [_inputNumberTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.equalTo(uintlabel.mas_left).offset(-10);
        make.bottom.equalTo(uintlabel.mas_bottom).offset(0);
        make.height.mas_equalTo(25);
    }];
    
    UIView *line3=[[UIView alloc]init];
    line3.backgroundColor=AppTextColor_999999;
    [bottomView addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *transferBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [transferBtn setTitle:LocalizationKey(@"tv_overturn") forState:UIControlStateNormal];
    transferBtn.backgroundColor=baseColor;
    transferBtn.layer.cornerRadius=5;
    transferBtn.layer.masksToBounds=YES;
    transferBtn.frame=CGRectMake(topView.frame.origin.x,bottomView.frame.origin.y+bottomView.frame.size.height+20,topView.frame.size.width,40);
    transferBtn.tag=105;
          [transferBtn addTarget:self action:@selector(menubtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:transferBtn];
}

- (void)setinitData {
    if(self.fromWalletData == nil){
        //默认划转的type
        TransferCurrencyModel *model1 = [TransferCurrencyModel new];
        model1.walletId = self.bbDataDic[@"id"];
        model1.type = WalletType_BiBi;
        model1.balance = self.bbDataDic[@"balance"];
        model1.symbol = @"USDT";
        self.fromWalletData = model1;
    }
    else{
        if (self.fromWalletData.type == WalletType_BiBi) {
            self.fromWalletData.balance = self.bbDataDic[@"balance"];
        }
        else if (self.fromWalletData.type == WalletType_MiaoHeYue){
            self.fromWalletData.balance = self.mhyDataDic[@"balance"];
        }
        else{
            for (WalletContractCoinModel *model in self.yxDataArray) {
                if ([model.contractCoin.symbol isEqualToString:self.fromWalletData.symbol]) {
                    self.fromWalletData.balance = model.usdtBalance;
                    break;
                }
            }
        }
    }
    
    if(self.toWalletData == nil){
        TransferCurrencyModel *model2 = [TransferCurrencyModel new];
        model2.walletId = self.mhyDataDic[@"walletId"];
        model2.type = WalletType_MiaoHeYue;
        model2.balance = self.mhyDataDic[@"balance"];
        model2.symbol = @"USDT";
        self.toWalletData = model2;
    }
    else{
        if (self.toWalletData.type == WalletType_BiBi) {
            self.toWalletData.balance = self.bbDataDic[@"balance"];
        }
        else if (self.toWalletData.type == WalletType_MiaoHeYue){
            self.toWalletData.balance = self.mhyDataDic[@"balance"];
        }
        else{
            for (WalletContractCoinModel *model in self.yxDataArray) {
                if ([model.contractCoin.symbol isEqualToString:self.toWalletData.symbol]) {
                    self.toWalletData.balance = model.usdtBalance;
                    break;
                }
            }
        }
    }
    
    [self updateWalletInfo:YES];
    [self updateWalletInfo:NO];
}

- (void)updateWalletInfo:(BOOL)isFirstView{ //(WalletContractCoinModel *)model
    TransferCurrencyModel *model;
    AssetTransferMenuView *view;
    
    if(isFirstView){
        view = _oneView;
        model = self.fromWalletData;
    }
    else{
        view = _twoView;
        model = self.toWalletData;
    }
    
    WalletType type = model.type;
    NSString *balance = model.balance;
    NSString *symbol = model.symbol;
    
    
    if (type == WalletType_BiBi) {
        view.mtitlelabel.text = LocalizationKey(@"币币账户");
    }
    else if (type == WalletType_YongXu){
        view.mtitlelabel.text = [NSString stringWithFormat:LocalizationKey(@"%@ 永续合约账户"), symbol];
    }
    else{
        view.mtitlelabel.text = LocalizationKey(@"秒合约账户");
    }
    
    view.mtxtlabel.text=[NSString stringWithFormat:LocalizationKey(@"余额:%.4f USDT"), [balance floatValue]];
    
    /*_selectCoinModel=model;
    
    view.mtitlelabel.text=[NSString stringWithFormat:@"%@  %@%@",model.contractCoin.symbol,model.contractCoin.name,LocalizationKey(@"account")];

    view.mtxtlabel.text=[NSString stringWithFormat:@"%@:%@%@",LocalizationKey(@"tv_balance"),[ToolUtil stringFromNumber:[self getkeyongPriceCoinModel:model] withlimit:4],model.contractCoin.baseSymbol];

    _titleCoinlabel.text=model.contractCoin.coinSymbol;
    _unitlabel.text=model.contractCoin.baseSymbol;

    CGSize size= [_unitlabel sizeThatFits:CGSizeMake(MAXFLOAT,20)];

    [_unitlabel mas_updateConstraints:^(MASConstraintMaker *make) {
           make.size.mas_equalTo(size);
    }];*/
}

//合约获取可用余额
-(CGFloat)getkeyongPriceCoinModel:(WalletContractCoinModel *)model {
    
    CGFloat price=0;
    if (model.usdtTotalProfitAndLoss.doubleValue<0&&[model.usdtPattern isEqualToString:@"CROSSED"]) {
        
        price= model.usdtBalance.doubleValue+model.usdtTotalProfitAndLoss.doubleValue;
    }else
        price=model.usdtBalance.doubleValue;
    
    return price;
}

-(void)menubtnclick:(id)sender {
    MJWeakSelf;
    UIView *view=(UIView*)sender;
    
    switch (view.tag) {
        case 200:
            { //顶部第一个合约账户选择
                WalletType type = self.toWalletData.type;
                NSString *symbol = self.toWalletData.symbol;
                
                WalletSelectCurrencyViewController *vc=[[WalletSelectCurrencyViewController alloc]init];
                //添加可以转化的钱包数据
                for (WalletContractCoinModel *model in self.yxDataArray) {
                    if(![symbol isEqualToString:model.contractCoin.symbol]){
                        TransferCurrencyModel *tmpModel = [TransferCurrencyModel new];
                        tmpModel.balance = model.usdtBalance;
                        tmpModel.symbol = model.contractCoin.symbol;
                        tmpModel.type = WalletType_YongXu;
                        tmpModel.walletId = model.id;
                        [vc.dataArray addObject:tmpModel];
                    }
                }
                if(type != WalletType_BiBi){
                    TransferCurrencyModel *tmpModel = [TransferCurrencyModel new];
                    tmpModel.balance = self.bbDataDic[@"balance"];
                    tmpModel.symbol = @"USDT";
                    tmpModel.type = WalletType_BiBi;
                    tmpModel.walletId = self.bbDataDic[@"id"];
                    [vc.dataArray addObject:tmpModel];
                }
                if(type != WalletType_MiaoHeYue){
                    TransferCurrencyModel *tmpModel = [TransferCurrencyModel new];
                    tmpModel.balance = self.mhyDataDic[@"balance"];
                    tmpModel.symbol = @"USDT";
                    tmpModel.type = WalletType_MiaoHeYue;
                    tmpModel.walletId = self.mhyDataDic[@"walletId"];
                    [vc.dataArray addObject:tmpModel];
                }
                
                vc.type=2;
                [self.navigationController pushViewController:vc animated:YES];
                vc.selectCellItemBlock = ^(NSInteger type, id  _Nonnull data) {
                    if (type==2) {
                        self.fromWalletData = data;
                        [weakSelf updateWalletInfo:YES];
                    }
                };
                
            }
            break;
        case 300:
            { //顶部第二个合约账户选择
                WalletType type = self.fromWalletData.type;
                NSString *symbol = self.fromWalletData.symbol;
                
                WalletSelectCurrencyViewController *vc=[[WalletSelectCurrencyViewController alloc]init];
                //添加可以转化的钱包数据
                for (WalletContractCoinModel *model in self.yxDataArray) {
                    if(![symbol isEqualToString:model.contractCoin.symbol]){
                        TransferCurrencyModel *tmpModel = [TransferCurrencyModel new];
                        tmpModel.balance = model.usdtBalance;
                        tmpModel.symbol = model.contractCoin.symbol;
                        tmpModel.type = WalletType_YongXu;
                        tmpModel.walletId = model.id;
                        [vc.dataArray addObject:tmpModel];
                    }
                }
                if(type != WalletType_BiBi){
                    TransferCurrencyModel *tmpModel = [TransferCurrencyModel new];
                    tmpModel.balance = self.bbDataDic[@"balance"];
                    tmpModel.symbol = @"USDT";
                    tmpModel.type = WalletType_BiBi;
                    tmpModel.walletId = self.bbDataDic[@"id"];
                    [vc.dataArray addObject:tmpModel];
                }
                if(type != WalletType_MiaoHeYue){
                    TransferCurrencyModel *tmpModel = [TransferCurrencyModel new];
                    tmpModel.balance = self.mhyDataDic[@"balance"];
                    tmpModel.symbol = @"USDT";
                    tmpModel.type = WalletType_MiaoHeYue;
                    tmpModel.walletId = self.mhyDataDic[@"walletId"];
                    [vc.dataArray addObject:tmpModel];
                }
                
                vc.type=2;
                [self.navigationController pushViewController:vc animated:YES];
                vc.selectCellItemBlock = ^(NSInteger type, id  _Nonnull data) {
                    if (type==2) {
                        self.toWalletData = data;
                        [weakSelf updateWalletInfo:NO];
                    }
                };
            }
            break;
        case 101:
        case 102:
            { //顶部右边下箭头点击
                TransferCurrencyModel *tmpDic = self.fromWalletData;
                self.fromWalletData = self.toWalletData;
                self.toWalletData = tmpDic;
                
                [self updateWalletInfo:YES];
                [self updateWalletInfo:NO];
            }
            break;
        case 103:
            { //币种选择
            }
            break;
        case 104:
            { //全部按钮
                CGFloat price= [self.fromWalletData.balance floatValue];
                self.inputNumberTextfield.text=[ToolUtil stringFromNumber:price withlimit:4];
            }
                       
            break;
        case 105:
            { //划转
                
                if (_inputNumberTextfield.text.length==0) {
                     [self.view makeToast:LocalizationKey(@"tv_input_overturn_number") duration:1.5 position:CSToastPositionCenter];
                    return;
                }
                
                NSMutableDictionary *mdict=[NSMutableDictionary dictionary];
                [mdict setObject:@"USDT" forKey:@"unit"];
                [mdict setObject:@(self.fromWalletData.type) forKey:@"from"];
                [mdict setObject:@(self.toWalletData.type) forKey:@"to"];
                [mdict setObject:self.fromWalletData.walletId forKey:@"fromWalletId"];
                [mdict setObject:self.toWalletData.walletId forKey:@"toWalletId"];
                [mdict setObject:_inputNumberTextfield.text forKey:@"amount"];

                [self sendTransferParam:mdict];
            }
                       
            break;
        default:
            break;
    }
}


- (void)getWalletUsdtData {
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager getWalletUsdtdataCompleteHandle:^(id resPonseObj, int code) {
//    [EasyShowLodingView hidenLoding];
        if (code) {
           if ([resPonseObj[@"code"] integerValue] == 0) {
               NSDictionary *dict=resPonseObj[@"data"];
               self.bbDataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
               [self getYongXuWalletList];
           }else{
               [EasyShowLodingView hidenLoding];
               [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
           }
       }else{
           [EasyShowLodingView hidenLoding];
           [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
       }
    }];
}

///获取秒合约钱包数据
- (void)getMhyWalletData {
//    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager getMhyWalletDataCompleteHandle:^(id resPonseObj, int code) {
    [EasyShowLodingView hidenLoding];
        if (code) {
           if ([resPonseObj[@"code"] integerValue] == 0) {
               NSDictionary *dict=resPonseObj[@"data"];
                self.mhyDataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
               //| walletId |   long   |  秒合约钱包Id  |
               //| balance  |  double  | 秒合约钱包余额 |
               [self setinitData];
           }else{
               [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
           }
       }else{
           [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
       }
    }];
}

-(void)sendTransferParam:(NSDictionary *)dict {
    
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager sentTransferCoinParam:dict CompleteHandle:^(id resPonseObj, int code) {
    [EasyShowLodingView hidenLoding];
        if (code) {
          if ([resPonseObj[@"code"] integerValue] == 0) {
//                  NSDictionary *dict=resPonseObj[@"data"];
            [self.view makeToast:LocalizationKey(@"划转成功") duration:1.5 position:CSToastPositionCenter];
//            [self calculationPrice];
//            [self.navigationController popViewControllerAnimated:YES];
              
              [self getAllData];
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


//- (void)calculationPrice {
//
//    CGFloat sendPrice= [self.inputNumberTextfield.text doubleValue];
//
//    double formPrice = [self.fromWalletData.balance doubleValue];
//    double toPrice = [self.fromWalletData.balance doubleValue];
//
//    double newFormPrice=formPrice -sendPrice;
//    double newToPrice=toPrice +sendPrice;
//    [self.bbDataDic setObject:@(newFormPrice) forKey:@"balance"];
//    _selectCoinModel.usdtBalance=[NSString stringWithFormat:@"%@",@(newToPrice)];
//
//    CGFloat price=[self.bbDataDic[@"balance"] doubleValue];
//    self.oneView.mtxtlabel.text=[NSString stringWithFormat:@"%@:%@%@",LocalizationKey(@"tv_balance"),[ToolUtil stringFromNumber:price withlimit:4],self.bbDataDic[@"coin"][@"unit"]];
//    self.twoView.mtxtlabel.text=[NSString stringWithFormat:@"%@:%@%@",LocalizationKey(@"tv_balance"),[ToolUtil stringFromNumber:[self getkeyongPriceCoinModel:_selectCoinModel] withlimit:4],_selectCoinModel.contractCoin.baseSymbol];
//    self.inputNumberTextfield.text=@"";
//}

///获取永续合约等钱包数据
- (void)getYongXuWalletList{
    [self.yxDataArray removeAllObjects];
    [ContractExchangeManager getWalletListCompleteHandle:^(id  _Nonnull resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] intValue] == 0) {
                NSArray *data=resPonseObj[@"data"];
                NSArray *dataArr = [WalletContractCoinModel mj_objectArrayWithKeyValuesArray:data];
                
                [self.yxDataArray addObjectsFromArray:dataArr];
                
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

-(NSMutableArray *)yxDataArray{
    if(!_yxDataArray){
        _yxDataArray = [NSMutableArray new];
    }
    return _yxDataArray;
}

@end
