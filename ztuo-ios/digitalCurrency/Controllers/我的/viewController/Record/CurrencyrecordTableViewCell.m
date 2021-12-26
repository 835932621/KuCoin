//
//  CurrencyrecordTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2019/8/7.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import "CurrencyrecordTableViewCell.h"

@implementation CurrencyrecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Presenttime.text = LocalizationKey(@"Presenttime");
    self.Presentmoney.text = LocalizationKey(@"poundage");
    self.Presentaddress.text = LocalizationKey(@"PresentAdd");
    self.PresentNum.text = LocalizationKey(@"PresentNum");
    
    // 禁止cell点击选中
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.model = nil;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.model = nil;
}

- (void)setModel:(RecordModel *)model {
    _model = model;
    if (![model isKindOfClass:[RecordModel class]] || !model) {
        return;
    }
    
}

@end
