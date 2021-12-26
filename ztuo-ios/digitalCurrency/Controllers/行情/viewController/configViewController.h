//
//  configViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2019/1/26.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface configViewController : UIViewController
typedef enum : NSUInteger {
    ChildViewType_USDT=0,
    ChildViewType_BTC=1,
    ChildViewType_ETH=3,
    ChildViewType_Collection=2
} ChildViewType;
- (instancetype)initWithChildViewType:(ChildViewType)childViewType;
-(void)reloadData;//刷新数据
@end
