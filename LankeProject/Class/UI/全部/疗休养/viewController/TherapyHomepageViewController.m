//
//  TherapyHomepageViewController.m
//  LankeProject
//
//  Created by issuser on 2018/7/8.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import "TherapyHomepageViewController.h"
#import <WebKit/WebKit.h>
#import "NSString+MHCommon.h"
#import "WebviewProgressLine.h"
@interface TherapyHomepageViewController ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) UIProgressView *pro;
@property(nonatomic,strong) UIWebView *web;
@property (nonatomic,strong) WebviewProgressLine  *progressLine;
@end

@implementation TherapyHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rewriteBackButton];
    NSString *strMD5 = [NSString stringWithFormat:@"%d%@%@",15,[KeychainManager readMobileNum],[KeychainManager readUserId]];
    NSString *superStr = [strMD5 uppercaseString];
    superStr = [superStr md5];
    NSString *url = [NSString stringWithFormat:@"http://mpass.aoyou.com/unionlogin?uniontype=15&mobile=%@&unionid=%@&token=%@&jumptype=1",[KeychainManager readMobileNum],[KeychainManager readUserId],superStr];
//    [self initWkView:url];//wkview
    [self initWebView:url];
    // Do any additional setup after loading the view.
}
#pragma mark webview
-(void)initWebView:(NSString *)url{
    self.web = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.web.delegate = self;
    self.web.scalesPageToFit = YES;
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]] cachePolicy:(NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:5]];
    [self.view addSubview:self.web];
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    self.progressLine = [[WebviewProgressLine alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 3)];
    self.progressLine.lineColor = [UIColor greenColor];
    [self.view addSubview:self.progressLine];
}



-(void)webViewDidStartLoad:(UIWebView *)webView{
     [self.progressLine startLoadingAnimation];
    self.title = @"";
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),         dispatch_get_main_queue(), ^{
        if ([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] length] > 14) {
            self.title = [NSString stringWithFormat:@"%@...",[[webView stringByEvaluatingJavaScriptFromString:@"document.title"] substringToIndex:14]];
        }
        else{
            self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
    });
    
    
    
    
    
//    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.title"] length] > 14) {
//        self.title = [NSString stringWithFormat:@"%@...",[[webView stringByEvaluatingJavaScriptFromString:@"document.title"] substringToIndex:14]];
//    }
//    else{
//        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    }
   [self.progressLine endLoadingAnimation];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progressLine endLoadingAnimation];
}



#pragma mark wekview
-(void)initWkView:(NSString *)url{
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
     [self.view addSubview:self.pro];
}


#pragma mark delegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.pro.hidden = NO;
}


#pragma mark 默认禁止调用 alert Tel
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    UIApplication *app = [UIApplication sharedApplication];
    // 打电话
    if ([scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:URL]) {
            [app openURL:URL];
            // 一定要加上这句,否则会打开新页面
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    

        decisionHandler(WKNavigationActionPolicyAllow);
}

-(UIProgressView *)pro{
    if (!_pro) {
        _pro  = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _pro.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5);
        
        [_pro setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _pro.progressTintColor = [UIColor greenColor];
    }
    return _pro;
}
//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.webView) {
        [self.pro setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.pro.progress;
        [self.pro setProgress:self.webView.estimatedProgress
                              animated:animated];
        
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.pro setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.pro setProgress:0.0f animated:NO];
                             }];
        }
    }
    else if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
            if ([self.webView.title length] > 14) {
                self.title = [NSString stringWithFormat:@"%@...",[self.webView.title substringToIndex:14]];
            }
            else{
                self.title = self.webView.title;
            }
            
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    
    
    else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
   
    
}

-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
     [self.webView removeObserver:self forKeyPath:@"title"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 重写返回按钮
-(void)rewriteBackButton{
   
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    //设置UIButton的图像
    [backButton setImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
    //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
  
    //nav_close
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    //设置UIButton的图像
    [closeButton setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeWeb) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    //覆盖返回按键
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.rightBarButtonItem = closeItem;


}

-(void)backItemClick{
    if ([self.web canGoBack]) {
        [self.web goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)closeWeb{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
