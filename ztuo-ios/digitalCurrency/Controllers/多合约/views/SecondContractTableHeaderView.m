//
//  SecondContractTableHeaderView.m
//  digitalCurrency
//
//  Created by Darker on 2021/7/14.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "SecondContractTableHeaderView.h"
#import "KlineHeaderCell.h"
#import "ExchangeTableViewCell.h"

@interface SecondContractTableHeaderView ()<UITextFieldDelegate>
{
}

@property (nonatomic, weak) KlineHeaderCell *klineHeaderCell;
@property (nonatomic, strong) NSMutableArray *openCountBtnAry;
@property (nonatomic, strong) NSMutableArray *openTimeBtnAry;
///开仓数量选中图片
@property (nonatomic, strong) UIImageView *openCountImg;
///开仓时间选中图片
@property (nonatomic, strong) UIImageView *openTimeImg;
///开仓数量手动输入框
@property (nonatomic, strong) UITextField *tfOpenCount;
///当前选中的开仓数量 索引
@property (nonatomic, assign) NSUInteger openCountIndex;
///当前选中的开仓时间 索引
@property (nonatomic, assign) NSUInteger openTimeIndex;
///余额
@property (nonatomic, strong) UILabel *lbBalance;
///盈利率文本
@property (nonatomic, strong) UILabel *lbProfitTxt;
///盈利率
@property (nonatomic, strong) UILabel *lbProfitability;
///买涨按钮
@property (nonatomic, strong) UIButton *btnBuyUp;
///买跌按钮
@property (nonatomic, strong) UIButton *btnBuyDown;

///交易中tab按钮
@property (nonatomic, strong) UIButton *btnExchanging;
///交易完成tab按钮
@property (nonatomic, strong) UIButton *btnExchanged;
///交易tab线条
@property (nonatomic, strong) UIView *exchangeLineview;

//@property (nonatomic, strong) ExchangeTableViewCell *exchangeTitleView;

@property (nonatomic, weak) SecondExchangeSymbolModel *symbolModel;

@end

@implementation SecondContractTableHeaderView

#pragma mark -懒加载
- (KlineHeaderCell *)klineHeaderCell{
    if(!_klineHeaderCell){
        UINib *nib = [UINib nibWithNibName:@"KlineHeaderCell" bundle:nil];
        NSArray *xibArray = [nib instantiateWithOwner:nil options:nil];
        
        _klineHeaderCell = xibArray.firstObject;
        _klineHeaderCell.contentView.backgroundColor = mainColor;
        _klineHeaderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return _klineHeaderCell;
}

- (UIButton *)btnBuyUp{
    if (!_btnBuyUp) {
        _btnBuyUp = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnBuyUp.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnBuyUp.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0];
        _btnBuyUp.backgroundColor = GreenColor;
        _btnBuyUp.tag = 200;
        [_btnBuyUp setTitle:LocalizationKey(@"buy_up") forState:UIControlStateNormal];
        [_btnBuyUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_btnBuyUp];
    }
    return _btnBuyUp;
}
- (UIButton *)btnBuyDown{
    if (!_btnBuyDown) {
        _btnBuyDown = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnBuyDown.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnBuyDown.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0];
        _btnBuyDown.backgroundColor = RedColor;
        _btnBuyDown.tag = 201;
        [_btnBuyDown setTitle:LocalizationKey(@"buy_fall") forState:UIControlStateNormal];
        [_btnBuyDown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_btnBuyDown];
    }
    return _btnBuyDown;
}

- (UIView *)exchangeLineview{
    if (!_exchangeLineview) {
        _exchangeLineview=[[UIView alloc]initWithFrame:CGRectMake(0,0,80,1)];
        _exchangeLineview.backgroundColor=baseColor;
        
        [self addSubview:_exchangeLineview];
    }
    return _exchangeLineview;
}

- (NSMutableArray *)openCountBtnAry{
    if (!_openCountBtnAry) {
        _openCountBtnAry = [NSMutableArray new];
    }
    return _openCountBtnAry;
}

- (NSMutableArray *)openTimeBtnAry{
    if (!_openTimeBtnAry) {
        _openTimeBtnAry = [NSMutableArray new];
    }
    return _openTimeBtnAry;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.isShowExchanging = YES;
        //        UINib * nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
        //        self = [nib instantiateWithOwner:self options:nil].firstObject;
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

+(instancetype)secondContractTableHeaderView{
    return [[self alloc] init];
}

-(void)initUI{
    CGFloat btnGap = 15;
    CGFloat btnWidth = (kWindowW-btnGap*5)/4;
    
    self.backgroundColor = mainColor;
    [self addSubview:self.klineHeaderCell];//需要在👇添加约束的代码之前执行，不然会报错
    
    [self.klineHeaderCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    //添加线条
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0,self.klineHeaderCell.frame.origin.y+self.klineHeaderCell.frame.size.height,SCREEN_WIDTH_S, 1)];
    line.backgroundColor=ViewBackgroundColor;
    [self addSubview:line];
    
    UILabel *lbExchangeMode = [[UILabel alloc]init];
    lbExchangeMode.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    lbExchangeMode.textAlignment = NSTextAlignmentLeft;
    lbExchangeMode.textColor = [UIColor whiteColor];
    lbExchangeMode.frame = CGRectMake(15, CGRectGetMaxY(line.frame), 200, 24);
    lbExchangeMode.text = LocalizationKey(@"second_contract");
    [self addSubview:lbExchangeMode];
    
    UIButton *exchangeModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeModeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    exchangeModeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
    [exchangeModeBtn setTitle:@"USDT" forState:UIControlStateNormal];
    [exchangeModeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exchangeModeBtn.frame = CGRectMake(15, CGRectGetMaxY(lbExchangeMode.frame)+8, btnWidth, 30);
    exchangeModeBtn.layer.borderWidth = 2.0f;
    exchangeModeBtn.layer.borderColor = ViewBackgroundColor.CGColor;
    exchangeModeBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:exchangeModeBtn];
    
    //选中的图片
    UIImageView *selectImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    selectImg.frame = CGRectMake(btnWidth-30, 0, 30, 30);
    [exchangeModeBtn addSubview:selectImg];
    
    _openCountImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    _openCountImg.frame = CGRectMake(btnWidth-30, 0, 30, 30);
    
    _openTimeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    _openTimeImg.frame = CGRectMake(btnWidth-30, 0, 30, 30);
    
    
    UILabel *lbOpenCount = [[UILabel alloc]init];
    lbOpenCount.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    lbOpenCount.textAlignment = NSTextAlignmentLeft;
    lbOpenCount.textColor = [UIColor whiteColor];
    lbOpenCount.frame = CGRectMake(15, CGRectGetMaxY(exchangeModeBtn.frame)+8, 200, 24);
    lbOpenCount.text = LocalizationKey(@"opening_amount");
    [self addSubview:lbOpenCount];
    
    NSArray *openCount = @[LocalizationKey(@"fifty"),LocalizationKey(@"one_hundred"),LocalizationKey(@"two_hundred"),LocalizationKey(@"five_hundred")];
    for (int i=0; i<openCount.count; i++) {
        UIButton *openCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openCountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        openCountBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
        [openCountBtn setTitle:openCount[i] forState:UIControlStateNormal];
        [openCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        CGFloat x = btnGap + (i%4)*btnGap + (i%4)*btnWidth;
        openCountBtn.frame = CGRectMake(x, CGRectGetMaxY(lbOpenCount.frame)+8, btnWidth, 30);
        openCountBtn.layer.borderWidth = 2.0f;
        openCountBtn.layer.borderColor = ViewBackgroundColor.CGColor;
        openCountBtn.backgroundColor = [UIColor clearColor];
        [openCountBtn addTarget:self action:@selector(onSelectOpenCount:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:openCountBtn];
        
        [self.openCountBtnAry addObject:openCountBtn];
    }
    
    UIButton *lastBtn = self.openCountBtnAry.lastObject;
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(btnGap, CGRectGetMaxY(lastBtn.frame)+8, btnWidth*1.5, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField setBackgroundColor:[UIColor clearColor]];
    textField.layer.borderWidth = 2.0f;
    textField.layer.borderColor = ViewBackgroundColor.CGColor;
    // 设置提示文字
    textField.placeholder = LocalizationKey(@"manual_input");
    // "通过KVC修改占位文字的颜色"
    [textField setValue:UIColor.whiteColor forKeyPath:@"placeholderLabel.textColor"];
    // 设置字体颜色
    textField.textColor = [UIColor whiteColor];
    // 设置字体
    textField.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
    // 设置对齐模式
    textField.textAlignment = NSTextAlignmentCenter;
    //数字键盘(只有数字)
    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textField.delegate = self;
    
    [self addSubview:textField];
    [self.openCountBtnAry addObject:textField];
    _tfOpenCount = textField;
    
    
    UILabel *lbOpenTime = [[UILabel alloc]init];
    lbOpenTime.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    lbOpenTime.textAlignment = NSTextAlignmentLeft;
    lbOpenTime.textColor = [UIColor whiteColor];
    lbOpenTime.frame = CGRectMake(15, CGRectGetMaxY(_tfOpenCount.frame)+8, 100, 24);
    lbOpenTime.text = LocalizationKey(@"open_time");
    [self addSubview:lbOpenTime];
    
    NSArray *openTime = @[LocalizationKey(@"open_time_60"),LocalizationKey(@"open_time_120"),LocalizationKey(@"open_time_180")];
    for (int i=0; i<openTime.count; i++) {
        UIButton *openTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openTimeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        openTimeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
        [openTimeBtn setTitle:openTime[i] forState:UIControlStateNormal];
        [openTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        CGFloat x = btnGap + (i%4)*btnGap + (i%4)*btnWidth;
        openTimeBtn.frame = CGRectMake(x, CGRectGetMaxY(lbOpenTime.frame)+8, btnWidth, 30);
        openTimeBtn.layer.borderWidth = 2.0f;
        openTimeBtn.layer.borderColor = ViewBackgroundColor.CGColor;
        openTimeBtn.backgroundColor = [UIColor clearColor];
        [openTimeBtn addTarget:self action:@selector(onSelectOpenTime:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:openTimeBtn];
        
        [self.openTimeBtnAry addObject:openTimeBtn];
    }
    UIButton *lastOpenTimeBtn = self.openTimeBtnAry.lastObject;
    
    UILabel *lbBalance = [[UILabel alloc]init];
    lbBalance.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    lbBalance.textAlignment = NSTextAlignmentLeft;
    lbBalance.textColor = [UIColor whiteColor];
    lbBalance.frame = CGRectMake(15, CGRectGetMaxY(lastOpenTimeBtn.frame)+8, 130, 24);
    lbBalance.text = LocalizationKey(@"account_balance");
    [self addSubview:lbBalance];
    
    _lbBalance = [[UILabel alloc]init];
    _lbBalance.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    _lbBalance.textAlignment = NSTextAlignmentLeft;
    _lbBalance.textColor = UIColor.whiteColor;
    CGSize size = [lbBalance.text boundingRectWithSize:CGSizeMake(200, 24) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lbBalance.font} context:nil].size;
    _lbBalance.frame = CGRectMake(lbBalance.frame.origin.x+ceil(size.width), lbBalance.frame.origin.y, 100, 24);
    _lbBalance.text = @"0.00";
    [self addSubview:_lbBalance];
    
    
    _lbProfitTxt = [[UILabel alloc]init];
    _lbProfitTxt.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    _lbProfitTxt.textAlignment = NSTextAlignmentRight;
    _lbProfitTxt.textColor = [UIColor whiteColor];
    _lbProfitTxt.frame = CGRectMake(kWindowW-150, lbBalance.frame.origin.y, 100, 24);
    _lbProfitTxt.text = LocalizationKey(@"profit_rate");
    [self addSubview:_lbProfitTxt];
    
    _lbProfitability = [[UILabel alloc]init];
    _lbProfitability.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    _lbProfitability.textAlignment = NSTextAlignmentLeft;
    _lbProfitability.textColor = UIColor.whiteColor;
    _lbProfitability.frame = CGRectMake(kWindowW-50, _lbProfitTxt.frame.origin.y, 50, 24);
    _lbProfitability.text = @"0.00%";
    [self addSubview:_lbProfitability];
    
    //买涨买跌按钮创建
    CGFloat tmpBtnWidth = (kWindowW-btnGap)*0.5;//按钮宽度
    
    self.btnBuyUp.frame = CGRectMake(0, CGRectGetMaxY(_lbProfitability.frame)+8, tmpBtnWidth, 40);
    [self.btnBuyUp addTarget:self action:@selector(touchMenuclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btnBuyDown.frame = CGRectMake(kWindowW-tmpBtnWidth, self.btnBuyUp.frame.origin.y, tmpBtnWidth, 40);
    [self.btnBuyDown addTarget:self action:@selector(touchMenuclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnExchanging = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnExchanging.frame = CGRectMake(0,CGRectGetMaxY(self.btnBuyDown.frame)+8,120,30);
    _btnExchanging.tag = 100;
    [self addSubview:_btnExchanging];
    
    _btnExchanged = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnExchanged.frame = CGRectMake(CGRectGetMaxX(_btnExchanging.frame)+10,_btnExchanging.frame.origin.y,180,30);
    _btnExchanged.tag = 101;
    [self addSubview:_btnExchanged];
    
    [_btnExchanging setTitleColor:baseColor forState:UIControlStateSelected];
    [_btnExchanged setTitleColor:baseColor forState:UIControlStateSelected];
    [_btnExchanging setTitleColor:AppTextColor_Level_2 forState:UIControlStateNormal];
    [_btnExchanged setTitleColor:AppTextColor_Level_2 forState:UIControlStateNormal];
    
    _btnExchanging.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
    _btnExchanged.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
    
    [_btnExchanging setTitle:LocalizationKey(@"current_position") forState:UIControlStateNormal];
    [_btnExchanged setTitle:LocalizationKey(@"historical_entrustment") forState:UIControlStateNormal];
    
    //    UIView *line2=[[UIView alloc]init];
    //    line2.frame=CGRectMake(0,_btnExchanging.frame.origin.y+_btnExchanging.frame.size.height+5,SCREEN_WIDTH_S,1);
    //    line2.backgroundColor=self.backgroundColor;
    //    [self addSubview:line2];
    
    [_btnExchanging addTarget:self action:@selector(touchMenuclick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnExchanged addTarget:self action:@selector(touchMenuclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    _exchangeTitleView = [[ExchangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exchangeTitleView"];
//    [self addSubview:_exchangeTitleView];
//    _exchangeTitleView.frame = CGRectMake(0, CGRectGetMaxY(_btnExchanging.frame)+10, kWindowW, 30);
    
    self.frame = CGRectMake(0, 0, kWindowW, CGRectGetMaxY(_btnExchanging.frame));
    
    [self setOpenCount:0];
    [self setOpenTime:0];
    [self touchMenuclick:_btnExchanging];
}

#pragma mark -所有该界面按钮触发方法
- (void)touchMenuclick:(id) sender {
    MJWeakSelf
    UIControl *menu= (UIControl *)sender;
    switch (menu.tag) {
        case 100: //交易中按钮
        {
            _btnExchanging.selected=YES;
            _btnExchanged.selected=NO;
            
            CGRect rect= self.exchangeLineview.frame;
            rect.size.width = _btnExchanging.frame.size.width;
            rect.origin.y = _btnExchanging.frame.origin.y + _btnExchanging.frame.size.height - rect.size.height;
            rect.origin.x = _btnExchanging.frame.origin.x;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.exchangeLineview.frame=rect;
            }];
            
            if (self.didExchangeData) {
                self.didExchangeData(YES);
            }
            
            break;
        }
            
        case 101: //交易完成tab按钮
        {
            _btnExchanging.selected=NO;
            _btnExchanged.selected=YES;
            
            CGRect rect= self.exchangeLineview.frame;
            rect.size.width = _btnExchanged.frame.size.width;
            rect.origin.y = _btnExchanged.frame.origin.y + _btnExchanged.frame.size.height - rect.size.height;
            rect.origin.x = _btnExchanged.frame.origin.x;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.exchangeLineview.frame=rect;
            }];
            
            if (self.didExchangeData) {
                self.didExchangeData(NO);
            }
            
            break;
        }
        case 200: //买涨
        {
            if (self.didClickBuy) {
                self.didClickBuy(YES);
            }
            break;
        }
        case 201: //买跌
        {
            if (self.didClickBuy) {
                self.didClickBuy(NO);
            }
            break;
        }
    }
}

-(void)onSelectOpenCount:(UIButton*) button{
//    NSLog(@"%@",button);
    [self endEditing:YES];
    
    NSUInteger index = [self.openCountBtnAry indexOfObject:button];
    
    [self setOpenCount:index];
}

-(void)onSelectOpenTime:(UIButton*) button{
    [self endEditing:YES];
    
    NSUInteger index = [self.openTimeBtnAry indexOfObject:button];
    [self setOpenTime:index];
}

///更新顶部货币实时数据
- (void)updateKlineHeaderCel:(symbolModel*)model baseCoinScale:(int)baseCoinScale CoinScale:(int)CoinScale{
    [self.klineHeaderCell configModel:model baseCoinScale:baseCoinScale CoinScale:CoinScale];
}


- (void)updateUI:(SecondExchangeSymbolModel*)model{
    self.symbolModel = model;
    NSUInteger len = MIN(4, model.volumeGroup.count);
    for (int i=0; i<len; i++) {//更新开仓数量的btn文本
        NSString *count = [[NSString alloc] initWithFormat:@"%@", model.volumeGroup[i]];
        UIButton *btn = self.openCountBtnAry[i];
        [btn setTitle:count forState:UIControlStateNormal];
    }
    
    len = MIN(3, model.cycleTimeGroup.count);
    for (int i=0; i<len; i++) {//更新开仓时间的btn文本
        NSString *count= [[NSString alloc] initWithFormat:@"%@s", model.cycleTimeGroup[i]];
        UIButton *btn = self.openTimeBtnAry[i];
        [btn setTitle:count forState:UIControlStateNormal];
    }
}

- (void)updateBalance:(NSString *)balance andProfit:(double)profit{
    self.lbBalance.text = balance;
    NSString *profitStr = [NSString stringWithFormat:@"%.2f%%",profit];
    self.lbProfitability.text = profitStr;
//    if(profit < 0){
//        self.lbProfitability.textColor = RedColor;
//    }
//    else{
//        self.lbProfitability.textColor = GreenColor;
//    }
    
    CGFloat width = [profitStr boundingRectWithSize:CGSizeMake(1000, self.lbProfitability.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lbProfitability.font} context:nil].size.width + 10;

    CGRect rect = CGRectMake(kWindowW - width - self.lbProfitTxt.frame.size.width, self.lbProfitTxt.frame.origin.y, self.lbProfitTxt.frame.size.width, self.lbProfitTxt.frame.size.height);
    self.lbProfitTxt.frame = rect;

    CGRect rect1 = CGRectMake(kWindowW - width, self.lbProfitability.frame.origin.y, width, self.lbProfitability.frame.size.height);
    self.lbProfitability.frame = rect1;
}

- (void)setOpenCount:(NSUInteger) index{
    self.openCountIndex = index;
    UIView *btn = self.openCountBtnAry[index];
    [btn addSubview:self.openCountImg];
    self.openCountImg.frame = CGRectMake(btn.frame.size.width-30, 0, 30, 30);
}

- (void)setOpenTime:(NSUInteger) index{
    self.openTimeIndex = index;
    UIView *btn = self.openTimeBtnAry[index];
    [btn addSubview:self.openTimeImg];
}

#pragma mark - textField代理
//点击UITextField的响应事件
-(void)textFieldDidBeginEditing:(UITextField*)textField
{
    //    NSLog(@"%@",textField);
    [self setOpenCount:self.openCountBtnAry.count-1];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if(string.length > 0){
//        // 判断是否为数字
//        if([string characterAtIndex:0] <'0' || [string characterAtIndex:0] >'9'){
//            NSLog(LocalizationKey(@"请输入数字"));
//            return NO;
//        }
//        // 判断总长度不能大于6位
//        if(textField.text.length + string.length > 6){
//            NSLog(LocalizationKey(@"超过6位"));
//            return NO;
//        }
//    }
//    return YES;
//}

//点击UITextField--Return响应事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (NSInteger)getExchangeTime{
    NSInteger time = [(NSNumber *)self.symbolModel.cycleTimeGroup[self.openTimeIndex] integerValue];
    return time;
}

- (NSString *)getExchangeCount{
    NSString * count;
    if(self.openCountIndex >= 4){//当前选中的说手动输入的数量
        count = self.tfOpenCount.text;
    }
    else{
        count = [NSString stringWithFormat:@"%@", self.symbolModel.volumeGroup[self.openCountIndex]];
    }
    return count;
}


-(void)setProfit:(NSString *)profitStr andCountdown:(NSString *)countdownStr{
//    [self.exchangeTitleView setProfit:profitStr andCountdown:countdownStr];
}
@end
