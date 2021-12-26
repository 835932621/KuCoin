//
//  RechargeAssetsViewController.m
//  digitalCurrency
//
//  Created by Darker on 2021/9/28.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "RechargeAssetsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MineNetManager.h"

@interface RechargeAssetsViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *addressLb;
@property (nonatomic, strong) UIImageView *qrCodeImg;
@property (nonatomic, strong) UIButton *chargeBtn;
@property (nonatomic, strong) UIButton *uploadBtn;
@property (nonatomic, strong) UILabel *chargeFinishedLb;

//相机控制器
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;

@end

@implementation RechargeAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mainColor;
    self.navigationItem.title=LocalizationKey(@"USDT充币");
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = RGBOF(0x171e26);
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(360);
    }];
    
    UILabel *titleLb = [UILabel new];
    titleLb.font = [UIFont systemFontOfSize:18];
    titleLb.text = LocalizationKey(@"充币地址");
    titleLb.textColor = [UIColor whiteColor];
    [bgView addSubview:titleLb];
    
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
    }];
    
    UILabel *addressLb = [UILabel new];
    addressLb.font = [UIFont systemFontOfSize:18];
    addressLb.text = self.beforeChargeModel.walletAddress;
    addressLb.textColor = RGBOF(0x646b76);
    [bgView addSubview:addressLb];
    self.addressLb = addressLb;
    
    [addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLb.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    _qrCodeImg = [UIImageView new];
    [bgView addSubview:_qrCodeImg];
//    _qrCodeImg.image = UIIMAGE(@"loadQRCodeImage");
    
    CIImage *codeCIImage = [self createQRForString:self.beforeChargeModel.walletAddress];
    _qrCodeImg.image = [self createNonInterpolatedUIImageFormCIImage:codeCIImage withSize:170];
    
    [_qrCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressLb.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(170);
    }];
    
    UIButton *copyBtn=[[UIButton alloc]init];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:LocalizationKey(@"复制地址")];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [copyBtn setAttributedTitle:title
                    forState:UIControlStateNormal];
    [copyBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [copyBtn setTitleColor:baseColor forState:UIControlStateNormal];
    [bgView addSubview:copyBtn];
    [copyBtn addTarget:self action:@selector(onCopyAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_qrCodeImg.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(0);
    }];
    
    UIButton *chargeBtn=[[UIButton alloc]init];
    [self.view addSubview:chargeBtn];
    chargeBtn.backgroundColor = baseColor;
    [chargeBtn setTitle:LocalizationKey(@"确定\n(已完成充币)") forState:UIControlStateNormal];
    chargeBtn.titleLabel.numberOfLines = 2;
    chargeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [chargeBtn addTarget:self action:@selector(onChargeClick) forControlEvents:UIControlEventTouchUpInside];
    self.chargeBtn = chargeBtn;
    
    [chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).mas_offset(40);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    _uploadBtn=[[UIButton alloc]init];
    [self.view addSubview:_uploadBtn];
    _uploadBtn.backgroundColor = RGBOF(0x006bbe);
    [_uploadBtn setTitle:LocalizationKey(@"提交交易凭证") forState:UIControlStateNormal];
    [_uploadBtn addTarget:self action:@selector(onUploadClick) forControlEvents:UIControlEventTouchUpInside];
//    _uploadBtn.hidden = YES;
    
    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).mas_offset(40);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    _chargeFinishedLb = [UILabel new];
    _chargeFinishedLb.font = [UIFont systemFontOfSize:18];
    _chargeFinishedLb.text = LocalizationKey(@"网络节点同步中");
    _chargeFinishedLb.textColor = RGBOF(0x646b76);
    [self.view addSubview:_chargeFinishedLb];
    _chargeFinishedLb.hidden = YES;
    
    [_chargeFinishedLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).mas_offset(40);
        make.centerX.mas_equalTo(0);
    }];
    
    [self updateStatus];
}

-(void)updateStatus{
    if(self.beforeChargeModel.transferStatus == 1){
        self.chargeBtn.hidden = NO;
        self.uploadBtn.hidden = YES;
        self.chargeFinishedLb.hidden = YES;
    }
    else if(self.beforeChargeModel.transferStatus == 2){
        self.chargeBtn.hidden = YES;
        self.uploadBtn.hidden = NO;
        self.chargeFinishedLb.hidden = YES;
    }
    else{
        self.chargeBtn.hidden = YES;
        self.uploadBtn.hidden = YES;
        self.chargeFinishedLb.hidden = NO;
    }
}

-(void)onChargeClick{
    [MineNetManager reqRecharge:self.chargeCount CompleteHandle:^(id resPonseObj, int code) {
        
        NSLog(LocalizationKey(@"darker 请求充值返回 %@"),resPonseObj);
        if (code) {
            if (code == 1 && [resPonseObj[@"code"] isEqual:@0]) {
                self.beforeChargeModel.orderId = resPonseObj[@"data"];
                self.beforeChargeModel.transferStatus = 2;
                [self updateStatus];
                [self.view makeToast:LocalizationKey(@"请提交交易凭证") duration:1.5 position:CSToastPositionCenter];
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


///复制地址按钮的点击事件
-(void)onCopyAddress{
    if ([self.addressLb.text isEqualToString:@""]) {
        [self.view makeToast:LocalizationKey(@"复制失败") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.addressLb.text;
    [self.view makeToast:LocalizationKey(@"复制成功") duration:1.5 position:CSToastPositionCenter];
}

-(void)onUploadClick{
    __block NSUInteger sourceType = 0;
    [LEEAlert actionsheet].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = [[ChangeLanguage bundle] localizedStringForKey:@"projectNameTip" value:nil table:@"English"];
        label.textColor = RGBOF(0xe6e6e6);
        label.backgroundColor = mainColor;
    })
    .LeeAddContent(^(UILabel *label){
        label.text = LocalizationKey(@"请选择添加方式");
        label.textColor = RGBOF(0xe6e6e6);
        label.backgroundColor = mainColor;
    })
    .LeeHeaderColor(mainColor)
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"takingPictures" value:nil table:@"English"];
        action.backgroundColor = mainColor;
        action.titleColor = RGBOF(0xe6e6e6);
        action.borderColor = mainColor;
        action.clickBlock = ^{
            //判断是否已授权
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
                    [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"cameraPermissionsTips" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
                    return ;
                }
            }
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self chooseImage:sourceType];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"tips" value:nil table:@"English"] message:[[ChangeLanguage bundle] localizedStringForKey:@"unSupportTakePhoto" value:nil table:@"English"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"ok" value:nil table:@"English"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        };
    }).LeeAddAction(^(LEEAction *action){
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"photoAlbumSelect" value:nil table:@"English"];
        action.backgroundColor = mainColor;
        action.titleColor = RGBOF(0xe6e6e6);
        action.borderColor = mainColor;
        action.clickBlock = ^{
            //判断是否已授权
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {

                ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
                if (authStatus == ALAuthorizationStatusDenied) {
                    [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"cameraPermissionsTips" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
                    return;
                }
            }
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self chooseImage:sourceType];
        };
    }).LeeAddAction(^(LEEAction *action){
        action.type = LEEActionTypeCancel;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"cancel" value:nil table:@"English"];
        action.titleColor = RGBOF(0xe6e6e6);
        action.backgroundColor = mainColor;
    })
    .LeeShow();


}
//从本地选择照片（拍照或从相册选择）
-(void)chooseImage:(NSInteger)sourceType
{
    //创建对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerVC = imagePickerController;
    //设置代理
    imagePickerController.delegate = self;
    //是否允许图片进行编辑
    imagePickerController.allowsEditing = YES;
    //选择图片还是开启相机
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerController代理 已经选择了图片,上传到服务器中,返回上传结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //选择图片
    UIImage *headImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5);
    //将图片上传到服务器
    [EasyShowLodingView showLodingText:LocalizationKey(@"上传图片中")];

    NSString *str=@"uc/upload/oss/image";
    NSString *urlString=[HOST stringByAppendingString:str];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.设置非校验证书模式
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"x-auth-token"] = [YLUserInfo shareUserInfo].token;
    dic[@"Content-Type"] = @"application/x-www-form-urlencoded";
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageDatas = imageData;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageDatas
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [EasyShowLodingView hidenLoding];
//        NSLog(LocalizationKey(@"上传图片完成url=%@"), responseObject[@"data"]);
        //上传成功
        if ([responseObject[@"code"] integerValue] == 0) {
            NSString *picUrl = responseObject[@"data"];
            [self reqUploadChargeOrder:self.beforeChargeModel.orderId imgUrl:picUrl];
            
        }else if([responseObject[@"code"] integerValue] == 4000) {
            [ShowLoGinVC showLoginVc:self withTipMessage:responseObject[MESSAGE]];
        }else{
            [self.view makeToast:responseObject[MESSAGE] duration:1.5 position:CSToastPositionCenter];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [EasyShowLodingView hidenLoding];
        //上传失败
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureFailure" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
     
 ///上传充值订单截图
-(void)reqUploadChargeOrder:(NSString*)orderId imgUrl:(NSString*)transferImageUrl{
    
    [MineNetManager reqUploadChargeOrder:orderId imgUrl:transferImageUrl CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                self.beforeChargeModel.transferStatus = 3;
                [self updateStatus];
                [self.view makeToast:LocalizationKey(@"提交成功") duration:1.5 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--字符串生成二维码
- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    

    //水印图
//    UIImage *waterimage = [UIImage imageNamed:@""];
//    [waterimage drawInRect:CGRectMake((size-waterimage.size.width)/2.0, (size-waterimage.size.height)/2.0, waterimage.size.width, waterimage.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newPic;
}
@end
