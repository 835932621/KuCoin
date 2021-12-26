//
//  SecondExchangeModel.m
//  digitalCurrency
//
//  Created by Darker on 2021/7/17.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "SecondExchangeModel.h"

@implementation SecondExchangeModel

//- (instancetype)init {
//    if (self = [super init]) {
//    }
//    return self;
//}

- (NSString *)directionDesc{
    if (1 == _direction) {
        return LocalizationKey(@"看涨");
    }
    return LocalizationKey(@"看跌");
}

//- (NSString *)createTime{
//    NSDateFormatter * dateFormatter = [NSDateFormatter new];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    [dateFormatter setTimeZone:ChangeLanguage.timeZone];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_createTime doubleValue]/1000];
//    NSString *dateStr = [dateFormatter stringFromDate:date];
//    return dateStr;
//}

@end
