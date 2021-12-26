//
//  ChargerecordTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2019/8/7.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import "ChargerecordTableViewCell.h"

@implementation ChargerecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.Paymentdate.text = LocalizationKey(@"Paymenttime");
//    self.Chargeaddress.text = LocalizationKey(@"Address");
//    self.Amountrecharge.text = LocalizationKey(@"Amountrecharge");
    
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
    
    self.timelabel.text = [ToolUtil stampFormatterWithStamp:(NSInteger)model.time];;
    self.addresslabel.text = model.orderId;
    self.numlabel.text = [NSString stringWithFormat:@"%d", model.amount];
    self.walletAddressLabel.text = model.walletAddress;
    self.remarkLabel.text = [NSString stringWithFormat:LocalizationKey(@"备注：%@"), model.remark];
    
    if (model.status == 1) {
        self.statuslabel.text = LocalizationKey(@"待处理");
        self.statuslabel.textColor = [UIColor yellowColor];
    }
    else if (model.status == 2) {
        self.statuslabel.text = LocalizationKey(@"成功");
        self.statuslabel.textColor = GreenColor;
    }
    else if (model.status == 3){
        self.statuslabel.text = LocalizationKey(@"失败");
        self.statuslabel.textColor = RedColor;
    }
    else{
        self.statuslabel.text = LocalizationKey(@"处理中");
        self.statuslabel.textColor = GreenColor;
    }
    
}

@end
