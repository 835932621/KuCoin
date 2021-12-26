//
//  SecondContractTableHeaderView.h
//  digitalCurrency
//
//  Created by Darker on 2021/7/14.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "symbolModel.h"
#import "SecondExchangeSymbolModel.h"

typedef NS_ENUM(NSUInteger,SecondTableCellType ) {
    SecondTableCellTypeExchanging,   //交易中
    SecondTableCellTypeExchanged,    //交易完成
};

NS_ASSUME_NONNULL_BEGIN

@interface SecondContractTableHeaderView : UIView

///当前是否上显示交易中数据
//@property (nonatomic, assign) BOOL isShowExchanging;

@property (nonatomic, copy  ) void(^didClickBuy)(BOOL isBuyUp);

@property (nonatomic, copy  ) void(^didExchangeData)(BOOL isExchanging);

///更新顶部货币实时数据
- (void)updateKlineHeaderCel:(symbolModel*)model baseCoinScale:(int)baseCoinScale CoinScale:(int)CoinScale;

///更新UI展示数据
- (void)updateUI:(SecondExchangeSymbolModel*)model;

///更新余额和盈利率
- (void)updateBalance:(NSString *)balance andProfit:(double)profit;

///获取当前选中的开仓时间
- (NSInteger)getExchangeTime;
///获取当前选中的开仓数量
- (NSString *)getExchangeCount;


- (void) setProfit:(NSString *)profitStr andCountdown:(NSString *)countdownStr;

+(instancetype)secondContractTableHeaderView;
@end

NS_ASSUME_NONNULL_END
