//
//  RechargeAssetsViewController.h
//  digitalCurrency
//
//  Created by Darker on 2021/9/28.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "BaseViewController.h"
#import "BeforeChargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeAssetsViewController : BaseViewController

@property(nonatomic, strong)BeforeChargeModel *beforeChargeModel;
@property(nonatomic, copy)NSString * chargeCount;

@end

NS_ASSUME_NONNULL_END
