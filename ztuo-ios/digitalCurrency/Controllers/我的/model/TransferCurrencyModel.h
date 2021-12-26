// 资产划转的数据模型
//  TransferCurrencyModel.h
//  digitalCurrency
//
//  Created by Darker on 2021/9/10.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///钱包类型 0:币币。1:永续 2:秒合约
typedef enum WalletType : NSUInteger {
    WalletType_BiBi = 0,
    WalletType_YongXu,
    WalletType_MiaoHeYue
} WalletType;

@interface TransferCurrencyModel : NSObject

///钱包类型 0:币币。1:永续 2:秒合约
@property (nonatomic, assign) WalletType type;
@property (nonatomic, copy) NSString *balance;
///交易对，暂时只有永续钱包用
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *walletId;

@end

NS_ASSUME_NONNULL_END
