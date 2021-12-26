//
//  RecordModel.h
//  digitalCurrency
//
//  Created by startlink on 2019/8/9.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import <Foundation/Foundation.h>


//@class Coin;
@interface RecordModel : NSObject

///数量
@property(nonatomic, assign) int amount;
///订单状态  1待处理  2成功  3失败
@property(nonatomic, assign) int status;
///充值时间   时间毫秒为单位
@property(nonatomic, assign) long time;
///平台订单Id
@property (nonatomic,copy)NSString *orderId;
///钱包地址
@property (nonatomic,copy)NSString *walletAddress;
///备注
@property (nonatomic,copy)NSString *remark;



//@property (nonatomic,copy)NSString *ID;
//@property (nonatomic,copy)NSString *memberId;
//@property (nonatomic,copy)NSString *totalAmount;
//@property (nonatomic,copy)NSString *fee;
//@property (nonatomic,copy)NSString *arrivedAmount;
//@property (nonatomic,copy)NSString *createTime;
//@property (nonatomic,copy)NSString *dealTime;
//@property (nonatomic,copy)NSString *admin;
//@property (nonatomic,copy)NSString *transactionNumber;
//@property (nonatomic,copy)NSString *address;
//@property (nonatomic,copy)NSString *remark;
//@property (nonatomic,assign)NSInteger status;
//@property (nonatomic,assign)BOOL isAuto;
//@property (nonatomic,assign)BOOL canAutoWithdraw;
//
//@property (nonatomic,strong)Coin *coin;
//
//@end
//
//
//@interface Coin : NSObject;
//@property (nonatomic,copy)NSString *name;
//@property (nonatomic,copy)NSString *unit;

@end
