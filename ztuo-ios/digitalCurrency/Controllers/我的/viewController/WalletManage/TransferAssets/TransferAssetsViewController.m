//
//  TransferAssetsViewController.m
//  digitalCurrency
//
//  Created by Darker on 2021/9/29.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "TransferAssetsViewController.h"
#import "MineNetManager.h"

@interface TransferAssetsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usdtNumLabel;
@property (weak, nonatomic) IBOutlet UITextView *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *transferNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (nonatomic, assign) CGFloat minTransferNum;
@end

@implementation TransferAssetsViewController

- (IBAction)onStartTransfer:(id)sender {
    CGFloat transferNum = [self.transferNumTF.text floatValue];
    if(transferNum < self.minTransferNum){
        [self.view makeToast:[NSString stringWithFormat:LocalizationKey(@"转账金额不能低于%0.2fUSDT"),self.minTransferNum] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if(ISEMPTY_S(self.accountLabel.text)){
        [self.view makeToast:LocalizationKey(@"账号不能为空") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if(ISEMPTY_S(self.passwordTF.text)){
        [self.view makeToast:LocalizationKey(@"交易密码不能为空") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [EasyShowLodingView showLodingText:LocalizationKey(@"请求中")];
    [MineNetManager reqTransferAssets:self.accountLabel.text :transferNum :self.passwordTF.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.usdtCount -= transferNum;
                [self resetUI];
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
}

- (IBAction)onTransferAll:(id)sender {
    self.transferNumTF.text = [NSString stringWithFormat:@"%f",self.usdtCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _minTransferNum = 10.0;
    
    self.view.backgroundColor = mainColor;
    self.navigationItem.title=LocalizationKey(@"转账");
    
    self.usdtNumLabel.text = [NSString stringWithFormat:@"%0.8f USDT",self.usdtCount];
    
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:LocalizationKey(@"最小转账数量10.0") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    self.transferNumTF.attributedPlaceholder = attrString;
    
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:LocalizationKey(@"请输入资金密码") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    self.passwordTF.attributedPlaceholder = str1;
}

-(void)resetUI{
    self.usdtNumLabel.text = [NSString stringWithFormat:@"%0.8f USDT",self.usdtCount];
    self.accountLabel.text = @"";
    self.transferNumTF.text = @"";
    self.passwordTF.text = @"";
}

@end
