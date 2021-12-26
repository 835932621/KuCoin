//
//  ExchangeTableViewCell.h
//  digitalCurrency
//
//  Created by Darker on 2021/7/17.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondExchangeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *type;
@property (nonatomic, strong) UILabel *buyTime;
@property (nonatomic, strong) UILabel *direction;
@property (nonatomic, strong) UILabel *count;
///盈利
//@property (nonatomic, strong) UILabel *profit;
///倒计时
@property (nonatomic, strong) UILabel *countdown;
///开仓价格
@property (nonatomic, strong) UILabel *buyPrice;

@property (nonatomic, strong, nullable) SecondExchangeModel *model;

- (void) setProfit:(NSString *)profitStr andCountdown:(NSString *)countdownStr;
@end

NS_ASSUME_NONNULL_END
