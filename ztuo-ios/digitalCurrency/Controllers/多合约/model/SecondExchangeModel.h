//
//  SecondExchangeModel.h
//  digitalCurrency
//
//  Created by Darker on 2021/7/17.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecondExchangeModel : NSObject

///是否是正在交易中的数据，否则是已经完成的交易
//@property(nonatomic, assign) BOOL isExchanging; 改成用closePrice是否为0来判断

///交易对 比如BTC/USDT ETH/USDT
@property(nonatomic, copy) NSString *symbol;
///方向  1看涨 2看跌
@property(nonatomic, assign) int direction;
///数量
@property(nonatomic, assign) double volume;
///杠杆倍数
@property(nonatomic, assign) int leverage;
///购买价格
@property(nonatomic, assign) double buyPrice;
///平仓价格 即结束时的价格
@property(nonatomic, assign) double closePrice;
///盈利或亏损值
@property(nonatomic, copy) NSString * profitOrLoss;
///时间周期 比如60  120 180
@property(nonatomic, assign) int cycleTime;
///创建时间  毫秒为单位
@property(nonatomic, copy) NSString *createTime;
///剩余时间 秒为单位
@property(nonatomic, assign) int leftTime;

-(NSString *)directionDesc;

@end

NS_ASSUME_NONNULL_END
