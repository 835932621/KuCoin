//
//  ExchangedTableViewCell.m
//  digitalCurrency
//
//  Created by Darker on 2021/8/12.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "ExchangedTableViewCell.h"

@implementation ExchangedTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = mainColor;
    // 禁止cell点击选中
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.model = nil;
    
    if (self) {
        //        MJWeakSelf;
        UIFont *font = [UIFont systemFontOfSize:12*kWindowWHOne];
        UIColor *lbColor = UIColor.whiteColor;
        CGFloat leftinterval = 10;
        CGFloat rightinterval = 0;
        
        CGFloat symbolWidth = 200;
        CGFloat buyTimeWidth = 130;
        CGFloat countWidth = 200;
        CGFloat priceWidth = 200;
        CGFloat countdownWidth = 130;
        
        CGFloat lbGap = 22;
        
        _type = [[UILabel alloc]init];
        _type.text = @"BTC/USDT";
        _type.font = font;
        _type.textAlignment=NSTextAlignmentLeft;
        _type.textColor=lbColor;
        //        _type.backgroundColor = [UIColor redColor];
        [self addSubview:_type];
        
        [_type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftinterval);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(symbolWidth, 20));
        }];
        
        _buyTime = [[UILabel alloc]init];
        _buyTime.text = LocalizationKey(@"购买时间");
        _buyTime.font = font;
        _buyTime.textAlignment = NSTextAlignmentLeft;
        _buyTime.textColor = lbColor;
//                _buyTime.backgroundColor = baseColor;
        [self addSubview:_buyTime];
        
        [_buyTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightinterval);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(buyTimeWidth, 20));
        }];
        
        _direction = [[UILabel alloc]init];
        _direction.text = LocalizationKey(@"看涨");
        _direction.font = font;
        _direction.textAlignment = NSTextAlignmentLeft;
        _direction.textColor = GreenColor;
        [self addSubview:_direction];
        
        [_direction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftinterval);
            make.top.mas_equalTo(lbGap);
            make.size.mas_equalTo(CGSizeMake(symbolWidth, 20));
        }];
        
        _count = [[UILabel alloc]init];
        _count.text = LocalizationKey(@"开仓数量:");
        _count.font = font;
        _count.textAlignment = NSTextAlignmentLeft;
        _count.textColor=lbColor;
        //        _count.backgroundColor = [UIColor whiteColor];
        [self addSubview:_count];
        
        [_count mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftinterval);
            make.top.mas_equalTo(lbGap * 2);
            make.size.mas_equalTo(CGSizeMake(countWidth, 20));
        }];
        
        _cycleTime = [[UILabel alloc]init];
        _cycleTime.text = LocalizationKey(@"周期:0s");
        _cycleTime.font = font;
        _cycleTime.textAlignment = NSTextAlignmentLeft;
        _cycleTime.textColor = lbColor;
//                _countdown.backgroundColor = [UIColor redColor];
        [self addSubview:_cycleTime];
        
        [_cycleTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightinterval);
            make.top.mas_equalTo(lbGap * 2);
            make.size.mas_equalTo(CGSizeMake(countdownWidth, 20));
        }];
        
        _buyPrice = [[UILabel alloc]init];
        _buyPrice.text = LocalizationKey(@"开仓价格:");
        _buyPrice.font = font;
        _buyPrice.textAlignment = NSTextAlignmentLeft;
        _buyPrice.textColor = lbColor;
        //        _profit.backgroundColor = [UIColor purpleColor];
        [self addSubview:_buyPrice];

        [_buyPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftinterval);
            make.top.mas_equalTo(lbGap * 3);
            make.size.mas_equalTo(CGSizeMake(priceWidth, 20));
        }];
        
        _closePrice = [[UILabel alloc]init];
        _closePrice.text = LocalizationKey(@"平仓价格:");
        _closePrice.font = font;
        _closePrice.textAlignment = NSTextAlignmentLeft;
        _closePrice.textColor = lbColor;
        //        _profit.backgroundColor = [UIColor purpleColor];
        [self addSubview:_closePrice];

        [_closePrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightinterval);
            make.top.mas_equalTo(lbGap * 3);
            make.size.mas_equalTo(CGSizeMake(countdownWidth, 20));
        }];
        
        
        _profitOrLoss = [[UILabel alloc]init];
        _profitOrLoss.text = LocalizationKey(@"盈利");
        _profitOrLoss.font = font;
        _profitOrLoss.textAlignment = NSTextAlignmentLeft;
        _profitOrLoss.textColor = lbColor;
        [self addSubview:_profitOrLoss];

        [_profitOrLoss mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftinterval);
            make.top.mas_equalTo(lbGap * 4);
            make.size.mas_equalTo(CGSizeMake(priceWidth, 20));
        }];
        
        
        _status = [[UILabel alloc]init];
        _status.text = LocalizationKey(@"状态:");
        _status.font = font;
        _status.textAlignment = NSTextAlignmentLeft;
        _status.textColor = lbColor;
        [self addSubview:_status];

        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightinterval);
            make.top.mas_equalTo(lbGap * 4);
            make.size.mas_equalTo(CGSizeMake(countdownWidth, 20));
        }];
        
        UIView *line=[[UIView alloc] init];
        line.backgroundColor = UIColor.darkGrayColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(_status.mas_top).mas_offset(lbGap);
            make.size.mas_equalTo(CGSizeMake(kWindowW, 1));
        }];
    }
    
    
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.model = nil;
}

- (void)setModel:(SecondExchangeModel *)model {
    _model = model;
    if (![model isKindOfClass:[SecondExchangeModel class]] || !model) {
        return;
    }
    
    self.type.text = model.symbol;
    
    self.direction.text = model.directionDesc;
    if(model.direction == 2){
        self.direction.textColor = RedColor;
    }
    else{
        self.direction.textColor = GreenColor;
    }
    
    self.buyTime.text = model.createTime;
    self.count.text = [NSString stringWithFormat:LocalizationKey(@"开仓金额:%0.8f"), model.volume];
    self.cycleTime.text = [NSString stringWithFormat:LocalizationKey(@"周期:%ds"), model.cycleTime];
    
    self.buyPrice.text = [NSString stringWithFormat:LocalizationKey(@"开仓价格:%.2f"), model.buyPrice];
    self.closePrice.text = [NSString stringWithFormat:LocalizationKey(@"平仓价格:%.2f"), model.closePrice];
    
    self.profitOrLoss.text = [NSString stringWithFormat:LocalizationKey(@"盈利:%@"), model.profitOrLoss];
        
    self.status.text = [NSString stringWithFormat:@"%@", [model.profitOrLoss floatValue] > 0 ? LocalizationKey(@"成功") : LocalizationKey(@"失败")];
    if([model.profitOrLoss floatValue] > 0){
        self.status.textColor = GreenColor;
    }
    else{
        self.status.textColor = RedColor;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
