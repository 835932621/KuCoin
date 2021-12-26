//
//  ExchangeTableViewCell.m
//  digitalCurrency
//
//  Created by Darker on 2021/7/17.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "ExchangeTableViewCell.h"
#import "OYCountDownManager.h"
#import "SecondContractViewController.h"

@implementation ExchangeTableViewCell

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
        CGFloat rightinterval = -10;
        
        CGFloat symbolWidth = 200;
        CGFloat buyTimeWidth = 200;
        CGFloat countWidth = 200;
        CGFloat priceWidth = 200;
        CGFloat countdownWidth = 100;
        
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
        _buyTime.textAlignment = NSTextAlignmentRight;
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
        
        _countdown = [[UILabel alloc]init];
        _countdown.text = LocalizationKey(@"倒计时:0s");
        _countdown.font = font;
        _countdown.textAlignment = NSTextAlignmentLeft;
        _countdown.textColor = lbColor;
//                _countdown.backgroundColor = [UIColor redColor];
        [self addSubview:_countdown];
        
        [_countdown mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
        UIView *line=[[UIView alloc] init];
        line.backgroundColor = UIColor.darkGrayColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(_buyPrice.mas_top).mas_offset(lbGap);
            make.size.mas_equalTo(CGSizeMake(kWindowW, 1));
        }];
    }
    
    
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.model = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)countDownNotification {
    if(!self.model || self.model.closePrice > 0){ //平仓价大于0 就说已完成的订单，不需要倒计时了
        return;
    }
    /// 计算倒计时
    NSInteger countDown = (NSInteger)self.model.leftTime - kCountDownManager.timeInterval;
    if (countDown < 0) {
        // 倒计时结束时回调
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeTableViewCell" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        return;
    }
    /// 重新赋值
    self.countdown.text = [NSString stringWithFormat:LocalizationKey(@"倒计时:%ld"), countDown];
    
    if (SecondContractViewController.symbolModel && [SecondContractViewController.symbolModel.symbol isEqual:self.model.symbol]) {
        
        //看涨公式 (当前价格/开仓价格 - 1) * 合约张数 * 合约面值
        //看跌公式   (1 - 当前价格/开仓价格) * 合约张数 * 合约面值
//        double value = 0;
//        if (1 == self.model.direction) { //涨
//            value = (SecondContractViewController.symbolModel.open / self.model.buyPrice - 1) * self.model.volume * SecondContractViewController.shareNumber;
//        }
//        else{
//            value = (1 - SecondContractViewController.symbolModel.open / self.model.buyPrice) * self.model.volume * SecondContractViewController.shareNumber;
//        }
//        self.profit.text = [NSString stringWithFormat:@"%.4f", value];
//        if(value < 0){
//            self.profit.textColor = RedColor;
//        }
//        else{
//            self.profit.textColor = GreenColor;
//        }
    }
    
    
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
    
    self.buyPrice.text = [NSString stringWithFormat:LocalizationKey(@"开仓价格:%.4f"), model.buyPrice];
    
    // 手动调用通知的回调
    [self countDownNotification];
    
    if (model.closePrice == 0) {
        // 监听倒计时通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
    }
    else{
        
//        self.profit.text = [NSString stringWithFormat:@"%.4f", model.profitOrLoss];
//        if(model.profitOrLoss < 0){
//            self.profit.textColor = RedColor;
//        }
//        else{
//            self.profit.textColor = GreenColor;
//        }
        
        self.countdown.text = [NSString stringWithFormat:LocalizationKey(@"倒计时:%ds"), model.cycleTime];
    }
}


- (void)setProfit:(NSString *)profitStr andCountdown:(NSString *)countdownStr{
//    self.profit.text = profitStr;
    self.countdown.text = countdownStr;
}
@end
