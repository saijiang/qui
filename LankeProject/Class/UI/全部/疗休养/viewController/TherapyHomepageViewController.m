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
@interface TherapyHomepageViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) UIProgressView *pro;
//@property(nonatomic,strong) UILabel *titleName;//标题
@end

@implementation TherapyHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rewriteBackButton];
    NSString *strMD5 = [NSString stringWithFormat:@"%d%@%@",15,[KeychainManager readMobileNum],[KeychainManager readUserId]];
    NSString *superStr = [strMD5 uppercaseString];
    superStr = [superStr md5];
    NSString *url = [NSString stringWithFormat:@"http://mpass.aoyou.com/unionlogin?uniontype=15&mobile=%@&unionid=%@&token=%@&jumptype=1",[KeychainManager readMobileNum],[KeychainManager readUserId],superStr];
//    NSLog(@"%@",url);
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
    // Do any additional setup after loading the view.
}
#pragma mark delegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.pro.hidden = NO;
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
            else
              self.title = self.webView.title;
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
   
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    //设置UIButton的图像
    [backButton setImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
    //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
//    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
  
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
/*
-(void)backItemClick{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
*/
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
