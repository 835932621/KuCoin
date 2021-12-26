//
//  VersionUpdateModel.h
//  digitalCurrency
//
//  Created by iDog on 2019/5/7.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUpdateModel : NSObject

@property(nonatomic,copy)NSString *downloadUrl;
///更新类型 非1就说要强制更新
@property(nonatomic,assign)NSInteger updateType;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *version;

@end
