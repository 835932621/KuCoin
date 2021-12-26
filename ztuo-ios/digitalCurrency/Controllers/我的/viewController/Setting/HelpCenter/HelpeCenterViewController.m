//
//  HelpeCenterViewController.m
//  digitalCurrency
//
//  Created by chu on 2019/8/6.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import "HelpeCenterViewController.h"
#import "HelpCenterTableViewCell.h"
#import "HelpCenterModel.h"
#import "HelpCenterMoreViewController.h"
#import "HelpCenterDetailsViewController.h"
#import "HelpCenterDetailViewController.h"
@interface HelpeCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation HelpeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"Helpcenter" value:nil table:@"English"];
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self getData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HelpCenterModel *model = self.dataSourceArr[section];
    return model.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *identifier = @"helpCell";
    HelpCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HelpCenterTableViewCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HelpCenterModel *model = self.dataSourceArr[indexPath.section];
    cell.model = model.content[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HelpCenterModel *model = self.dataSourceArr[section];
    UIView *view = [[UIView alloc] init];
    if (section == 1) {
        view.frame = CGRectMake(0, 0, kWindowW, 38);
    }
    UILabel *label = [[UILabel alloc] init];
//    label.text = @[[[ChangeLanguage bundle] localizedStringForKey:@"Noviceguide" value:nil table:@"English"], [[ChangeLanguage bundle] localizedStringForKey:@"Commonproblem" value:nil table:@"English"]][section];
    
    label.text = model.titleCN;
    label.textColor = RGBOF(0xe6e6e6);
    label.font = [UIFont fontWithName:@"PingFangSC-Heavy" size:17];
    [view addSubview:label];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"helpMore" value:nil table:@"English"] forState:UIControlStateNormal];
    [btn setBackgroundColor:RGBOF(0xF0A70A)];
    [btn setTitleColor:RGBOF(0xe6e6e6) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    [btn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 13;
    btn.layer.borderColor = RGBOF(0xF0A70A).CGColor;
    btn.layer.borderWidth = 1;
    btn.tag = section;
    [view addSubview:btn];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(16);
        make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(18);
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-16);
        make.centerY.mas_equalTo(view);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(56);
    }];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpCenterModel *model = self.dataSourceArr[indexPath.section];

    HelpCenterDetailsViewController *detail = [[HelpCenterDetailsViewController alloc] init];
    detail.title = LocalizationKey(@"Article details");
    detail.contentModel = model.content[indexPath.row];
    [[AppDelegate sharedAppDelegate] pushViewController:detail];
    
}

- (void)moreAction:(UIButton *)sender{
    HelpCenterModel *model = self.dataSourceArr[sender.tag];
    HelpCenterDetailViewController *more = [[HelpCenterDetailViewController alloc] init];
    more.content = model.detailDesc;
    more.navTitle = model.titleCN;
    [[AppDelegate sharedAppDelegate] pushViewController:more];
    
//    HelpCenterModel *model = self.dataSourceArr[sender.tag];
//    HelpCenterMoreViewController *more = [[HelpCenterMoreViewController alloc] init];
//    more.cate = model.cate;
//    more.title = model.title;
//    [[AppDelegate sharedAppDelegate] pushViewController:more];
}

- (void)getData{
    //前端先写死
    NSArray *titleAry = @[LocalizationKey(@"账户功能"),LocalizationKey(@"数字货币充值&提现"),LocalizationKey(@"现货交易"),LocalizationKey(@"合约交易"),LocalizationKey(@"期权合约交易"),LocalizationKey(@"秒合约交易")];
    
    NSArray *contentAry = @[LocalizationKey(@"1、如何完成个人身份认证\n在我的-安全设置界面，点击实名认证，输入姓名和身份证号码，并按提示拍摄上传您的身份证照片，即可完成身份认证。\n\n2、如何修改登录密码\n在我的-安全设置界面，点击登录密码，输入原始密码和新密码，通过手机短信验证，即可完成修改登录密码。\n\n3、如何设置和修改资金密码\n在我的-安全设置界面，点击资金密码，输入原始密码和新密码，即可完成修改资金密码。如果是未设置资金密码，则直接输入密码即可完成设置。"),
                            
        LocalizationKey(@"with_draw_key"),
                            
        LocalizationKey(@"点击“交易”进入现货交易界面，你会看到交易界面包含以下内容：\n\n1、买/卖单区\n2、买/卖单委托账本\n3、当前委托记录和历史委托记录\n4、右上角还可以查看：当前交易对24小时成交信息汇总、K线和买卖深度展示\n\n参考买卖区价格，在买/卖单区选择下单类型：限价/市价，输入合适的购买价、数量，点击买入完成购买。（卖单同理）"),
                            
        LocalizationKey(@"remind_order"),
                            
        LocalizationKey(@"1、简单易上手的期权合约交易，用户可以最大化利润的同时最大程度的减少响应风险。\n\n2、按期权的权利划分，分别有两种基本类型的选项，成为看涨期权和看跌期权。看涨期权允许交易者购买标的资产，而看跌期权允许交易者出售标的资产。当交易者预期相关资产的价格会上涨时，他们通常会选择看涨期权。相反，如果交易者预期价格下跌时，他们会购买看跌期权，期望标的资产的价格在未来会下降。"),
                            
        LocalizationKey(@"1、秒合约交易是一种更加简捷、快速、高效的交易结算方式。\n\n2、首先要选择要交易的数字货币（比如BTC、ETH、LTC、BCH、EOS、XRP），交易时间区间（60秒、120秒、180秒等），在我们可控的风险范围内设置好交易金额；最重要的是进行货币方向性走势的技术分析，也就是在我们设置的交易区间内的涨跌方向，根据分析下单。下单后，系统会自动倒计时，到了我们规定的时间后系统会自动结算盈亏至交易账户。\n\n3、秒合约的价格计算只是下单点和所设时间到期点的价格，也就是说结算前的任何价格变化与最终结果没有关系。收益和风险都是相对固定的，波动1%和10%的盈利是一样的，我们最大风险是损失该笔投资，不会有套牢或者是进一步的损失。")];
    
    for (int i=0; i<titleAry.count; i++) {
        HelpCenterModel *model = [HelpCenterModel new];
        model.titleCN = titleAry[i];
        model.cate = @0;
        model.content = @[];
        model.detailDesc = contentAry[i];
        [self.dataSourceArr addObject:model];
    }
    
    
    [self.tableView reloadData];
    
    /*[EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST, @"uc/ancillary/more/help/"];
    NSDictionary *param = @{@"total":@"3",@"lang":[ChangeLanguage networkLanguage]};
    [[XBRequest sharedInstance] postDataWithUrl:url Parameter:param ResponseObject:^(NSDictionary *responseResult) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"responseResult --- %@",responseResult);
        if (![responseResult objectForKey:@"resError"]) {
            NSArray *data = responseResult[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    HelpCenterModel *model = [HelpCenterModel modelWithDictionary:dic];
                    [self.dataSourceArr addObject:model];
                }
                [self.tableView reloadData];
            }
        }
    }];*/
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH - NEW_NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = mainColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArr;
}

@end
