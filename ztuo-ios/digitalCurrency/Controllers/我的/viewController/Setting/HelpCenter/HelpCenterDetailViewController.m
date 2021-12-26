//
//  HelpCenterDetailViewController.m
//  digitalCurrency
//
//  Created by Darker on 2021/9/11.
//  Copyright © 2021 BIZZAN. All rights reserved.
//

#import "HelpCenterDetailViewController.h"

@interface HelpCenterDetailViewController ()

@end

@implementation HelpCenterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mainColor;
    self.title = self.navTitle;
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kWindowW-20, kWindowH-NEW_NavHeight)];
//    label.text = self.content;
//    label.backgroundColor = [UIColor yellowColor];
//    label.textColor = [UIColor whiteColor];
//    [self.view addSubview:label];
    
    UILabel *about = [[UILabel alloc] init];
    about.text = self.content;
    about.textColor = RGBOF(0xe6e6e6);
    about.font = [UIFont systemFontOfSize:14];
    about.numberOfLines = 0;
    CGFloat height = [ToolUtil heightForString:LocalizationKey(self.content) andWidth:kWindowW - 30 fontSize:14];
    about.frame = CGRectMake(15, 5, kWindowW - 30, height);
    [self.view addSubview:about];
    
}



@end
