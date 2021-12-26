//
//  messageViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2019/1/26.
//  Copyright © 2019年 BIZZAN. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate,UIScrollViewDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *webView;
@property(nonatomic,strong) WKWebViewConfiguration *wkWebConfig;
@end

@implementation WebViewController

- (WKWebView *)webView{
    
    if (!_webView) {
        
        self.wkWebConfig = [[WKWebViewConfiguration alloc] init];
        self.wkWebConfig.userContentController = [[WKUserContentController alloc] init];
        // 自适应屏幕宽度js
        NSString *jsStr = [NSString stringWithFormat:
        @"var script = document.createElement('script');"
        "script.type = 'text/javascript';"
        "script.text = \"function ResizeImages() { "
        "var myimg,oldwidth,oldheight;"
        "var maxwidth=%f;" //缩放系数
        "for(var i=0;i <document.images.length;i++){"
        "myimg = document.images[i];"
        "oldwidth = myimg.width;"
        "oldheight = myimg.height;"
        "myimg.style.width = maxwidth+'px';"
        "myimg.style.height = (oldheight * (maxwidth/oldwidth))+'px';"
        "}"
        "}\";"
        "document.getElementsByTagName('head')[0].appendChild(script);",SCREEN_WIDTH_S];
        
        WKUserScript *wkScript = [[WKUserScript alloc] initWithSource:jsStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        //添加js调用
        [self.wkWebConfig.userContentController addUserScript:wkScript];
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_S, SCREEN_HEIGHT_S-SafeAreaBottomHeight-SafeAreaTopHeight-NAVIGATION_HEIGHT_S) configuration:self.wkWebConfig];
        webView.scrollView.bounces = NO;
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.scrollView.showsVerticalScrollIndicator = NO;
        webView.backgroundColor = [UIColor whiteColor];
        _webView = webView;
    }
    
    return _webView;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];

    self.navigationItem.title = LocalizationKey(@"客服");
    
    [self.view addSubview:self.webView];
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
  
    //监听标题
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)leftBtn:(UIButton *)sender{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -WKWebView Delegate
///开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
}

///当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

///页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
   
}

///加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.targetFrame == nil) {
        
        [webView loadRequest:navigationAction.request];
    }else{
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void*)context{

    NSLog(LocalizationKey(@"WKWebView加载的url == %@"),self.webView.URL.absoluteString);
    
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            
            if (!ISEMPTY_S(self.webView.title)) {
                self.navigationItem.title = self.webView.title;
            }else{
                self.navigationItem.title = LocalizationKey(@"客服");
            }
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.webView removeObserver:self forKeyPath:@"title" context:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
}
@end
