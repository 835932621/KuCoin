//
//  BeforeTransferModel.h
//  digitalCurrency
//
//  Created by Darker on 2021/9/29.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeforeChargeModel : NSObject

///平台订单Id
@property (nonatomic, copy) NSString *orderId;

///钱包地址
@property (nonatomic, copy) NSString *walletAddress;

///转账钱包地址的Base64位图片信息
//@property (nonatomic, copy) NSString *transferImage;

///1未生成订单  2未上传截图   2已上传截图
@property (nonatomic, assign) NSInteger transferStatus;

///最小充值金额
@property (nonatomic, assign) double minTransferValue;
@end

NS_ASSUME_NONNULL_END
