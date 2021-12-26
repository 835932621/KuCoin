//
//  SecondExchangeSymbolModel.h
//  digitalCurrency
//
//  Created by Darker on 2021/7/19.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecondExchangeSymbolModel : NSObject

///交易对Id
@property (nonatomic, copy) NSString *coinId;
///交易币种名称 如BTC/USDT  ETH/USDT  LTC/USDT
@property (nonatomic, copy) NSString *symbol;
///最大购买合约数
@property (nonatomic, assign) int maxBuyCount;
///最小购买合约数
@property (nonatomic, assign) int minBuyCount;
///合约面值
//@property (nonatomic, assign) int shareNumber;
///推荐的购买合约数  如 10  50  100 200
@property (nonatomic, strong) NSArray *volumeGroup;
///时间周期 如 60  120  180
@property (nonatomic, strong) NSArray *cycleTimeGroup;
///杠杆倍数 如 20 50 100 125
//@property (nonatomic, strong) NSArray *leverageGroup;

@end

NS_ASSUME_NONNULL_END
