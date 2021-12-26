//
//  SecondContractNetManager.m
//  digitalCurrency
//
//  Created by Darker on 2021/7/19.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "SecondContractNetManager.h"

@implementation SecondContractNetManager

///获取秒合约币种列表
+(void)getSymbolListInfo:(void(^)(id resPonseObj,int code))completeHandle{
    
    NSString *path = @"swap/second/symbol/thumb";
    [self ylNonTokenRequestWithGET:path parameters:@{} successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

+(void)getBalanceAndProfitWithCoinId:(NSInteger)coinId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    
    NSString *path = @"swap/second/contract/info";
    NSDictionary *dic = @{@"coinId":@(coinId)};
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject, isSuccessed);
    }];
}

+(void)reqExchangeWithCoinId:(NSInteger)coinId withDirection:(NSInteger)direction withCycleTime:(NSInteger)cycleTime withVolume:(NSString*)volume withLeverage:(NSInteger)leverage CompleteHandle:(void (^)(id _Nonnull, int))completeHandle{
    
    NSString *path = @"swap/second/open";
    NSDictionary *dic = @{
                            @"coinId":@(coinId),
                            @"direction":@(direction),
                            @"cycleTime":@(cycleTime),
                            @"volume":volume,
                            @"leverage":@(leverage)
                        };
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject, isSuccessed);
    }];
}

+ (void)getExchangingListWithSymbol:(NSString *)symbol CompleteHandle:(void (^)(id _Nonnull, int))completeHandle{
    
    NSString *path = @"swap/second/transaction";
    NSDictionary *dic = @{@"symbol":symbol};
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject, isSuccessed);
    }];
}

+ (void)getExchangedListWithSymbol:(NSString *)symbol CompleteHandle:(void (^)(id _Nonnull, int))completeHandle{
    
    NSString *path = @"swap/second/transaction/history";
    NSDictionary *dic = @{
                            @"symbol":symbol,
                            @"pageNo":@1,
                            @"pageSize":@50
                        };
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject, isSuccessed);
    }];
}

@end
