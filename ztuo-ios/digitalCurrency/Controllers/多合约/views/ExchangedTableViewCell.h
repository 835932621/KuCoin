//
//  ExchangedTableViewCell.h
//  digitalCurrency
//
//  Created by Darker on 2021/8/12.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondExchangeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExchangedTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *type;
@property (nonatomic, strong) UILabel *buyTime;
@property (nonatomic, strong) UILabel *direction;
@property (nonatomic, strong) UILabel *count;
///周期时间
@property (nonatomic, strong) UILabel *cycleTime;
///开仓价格
@property (nonatomic, strong) UILabel *buyPrice;
///平仓价格
@property (nonatomic, strong) UILabel *closePrice;
///盈利或亏损值
@property (nonatomic, strong) UILabel *profitOrLoss;
///状态
@property (nonatomic, strong) UILabel *status;


@property (nonatomic, strong, nullable) SecondExchangeModel *model;

@end

NS_ASSUME_NONNULL_END
