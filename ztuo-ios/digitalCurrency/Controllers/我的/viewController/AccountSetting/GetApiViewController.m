//
//  GetApiViewController.m
//  digitalCurrency
//
//  Created by Darker on 2021/9/1.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "GetApiViewController.h"
#import "BaseNetManager.h"

@interface GetApiViewController ()

@property (nonatomic, weak)UILabel *lbApiKey;
@property (nonatomic, weak)UILabel *lbSecretKey;

@end

@implementation GetApiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = mainColor;
    self.title = LocalizationKey(@"获取API");
    
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = ViewBackgroundColor;
    [self.view addSubview:item1];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kWindowW, 80));
    }];
    
    UILabel *lbApi = [[UILabel alloc] init];
    lbApi.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    lbApi.textAlignment = NSTextAlignmentLeft;
    lbApi.textColor = [UIColor whiteColor];
    lbApi.text = @"api_key";
    [item1 addSubview:lbApi];
    lbApi.frame = CGRectMake(10,3,105,30);
    
    UILabel *lbApiKey = [[UILabel alloc] init];
    lbApiKey.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    lbApiKey.textAlignment = NSTextAlignmentLeft;
    lbApiKey.textColor = [UIColor grayColor];
//    lbApiKey.text = @"api_keyapi_keyapi_keyapi_keyapi_keyapi_";
    [item1 addSubview:lbApiKey];
    lbApiKey.frame = CGRectMake(10,40,kWindowW-20,30);
    self.lbApiKey = lbApiKey;
    
    UIButton *btnCopy1 = [[UIButton alloc] init];
    [btnCopy1 setBackgroundColor:baseColor];
    btnCopy1.tag = 1;
    btnCopy1.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnCopy1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCopy1 setTitle:LocalizationKey(@"复制") forState:UIControlStateNormal];
    btnCopy1.frame = CGRectMake(kWindowW - 90,8,70,30);
    [btnCopy1 addTarget:self action:@selector(copyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [item1 addSubview:btnCopy1];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = ViewBackgroundColor;
    [self.view addSubview:item2];
    
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(item1).mas_offset(100);
        make.size.mas_equalTo(CGSizeMake(kWindowW, 80));
    }];
    
    UILabel *lbSecret = [[UILabel alloc] init];
    lbSecret.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    lbSecret.textAlignment = NSTextAlignmentLeft;
    lbSecret.textColor = [UIColor whiteColor];
    lbSecret.text = @"secret_key";
    [item2 addSubview:lbSecret];
    lbSecret.frame = CGRectMake(10,3,105,30);
    
    UILabel *lbSecretKey = [[UILabel alloc] init];
    lbSecretKey.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    lbSecretKey.textAlignment = NSTextAlignmentLeft;
    lbSecretKey.textColor = [UIColor grayColor];
    [item2 addSubview:lbSecretKey];
    lbSecretKey.frame = CGRectMake(10,40,kWindowW-20,30);
    self.lbSecretKey = lbSecretKey;
    
    UIButton *btnCopy2 = [[UIButton alloc] init];
    [btnCopy2 setBackgroundColor:baseColor];
    btnCopy2.tag = 2;
    btnCopy2.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnCopy2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCopy2 setTitle:LocalizationKey(@"复制") forState:UIControlStateNormal];
    btnCopy2.frame = CGRectMake(kWindowW - 90,8,70,30);
    [btnCopy2 addTarget:self action:@selector(copyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [item2 addSubview:btnCopy2];
    
    [self reqApi];
}

-(void)reqApi{
    NSString *path = @"uc/open/get/api/key";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HOST,path];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    MJWeakSelf

    [BaseNetManager requestWithPost:urlStr header:nil parameters:dict successBlock:^(id resultObject, int isSuccessed) {
        if (isSuccessed) {
            NSLog(@"%@",resultObject);
            weakSelf.lbApiKey.text = resultObject[@"data"][@"apiKey"];
            weakSelf.lbSecretKey.text = resultObject[@"data"][@"secretKey"];
        }else{
            [self.view makeToast:LocalizationKey(@"获取apikey失败，请稍后再试") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

- (void)copyBtnClicked:(UIButton *)sender{
    if (sender.tag == 1) {
        if(self.lbApiKey.text == nil || [self.lbApiKey.text isEqualToString:@""]){
            return;
        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.lbApiKey.text;
    }else{
        if(self.lbSecretKey.text == nil || [self.lbSecretKey.text isEqualToString:@""]){
            return;
        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.lbSecretKey.text;
    }
    
    [self.view makeToast:LocalizationKey(@"复制成功") duration:1.5 position:CSToastPositionCenter];
}

@end
