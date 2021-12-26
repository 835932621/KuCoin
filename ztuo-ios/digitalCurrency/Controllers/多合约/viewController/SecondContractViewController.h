//
//  SecondContractViewController.h
//  digitalCurrency
//
//  Created by Darker on 2021/7/13.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "symbolModel.h"

NS_ASSUME_NONNULL_BEGIN

static symbolModel *_symbolModel = nil;
///合约面值 即1张=多少usdt
//static int _shareNumber = 0;

@interface SecondContractViewController : UIViewController

+ (symbolModel *)symbolModel;

///合约面值 即1张=多少usdt
//+ (int)shareNumber;
@end

NS_ASSUME_NONNULL_END
