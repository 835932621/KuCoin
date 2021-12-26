//
//  SecondContractNetManager.h
//  digitalCurrency
//
//  Created by Darker on 2021/7/19.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "BaseNetManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecondContractNetManager : BaseNetManager

///获取秒合约币种列表
+(void)getSymbolListInfo:(void(^)(id resPonseObj,int code))completeHandle;

///获取秒合约余额和盈利率
+(void)getBalanceAndProfitWithCoinId:(NSInteger)coinId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


/**
 请求秒合约交易

 @param coinId 交易对币种Id
 @param direction 方向   1 看涨  2看跌
 @param cycleTime 时间周期  如60秒 120秒 180秒
 @param volume 买入量 即多少手
 @param leverage 杠杆倍数
 */
+(void)reqExchangeWithCoinId:(NSInteger)coinId withDirection:(NSInteger)direction withCycleTime:(NSInteger)cycleTime withVolume:(NSString*)volume withLeverage:(NSInteger)leverage CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;



///获取当前持仓订单列表(/swap/second/transaction)
+(void)getExchangingListWithSymbol:(NSString *)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;


///获取委托历史订单列表(/swap/second/transaction/history)
+(void)getExchangedListWithSymbol:(NSString *)symbol CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;

@end

NS_ASSUME_NONNULL_END
