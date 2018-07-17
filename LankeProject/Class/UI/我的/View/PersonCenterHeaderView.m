//
//  PersonCenterHeaderView.m
//  LankeProject
//
//  Created by itman on 17/2/22.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PersonCenterHeaderView.h"
#import "PersonCenterOrderView.h"
#import "UserInfoViewController.h"
#import "IntegralCenterViewController.h"
#import "WalletViewController.h"
#import "MyThreapayDeatilsViewController.h"

@interface PersonCenterHeaderView ()

@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIButton *userHeadBtn;
/** 积分 */
@property (nonatomic, strong) UIButton * integralButton;
/** i币 */
@property (nonatomic, strong) UIButton * ibiButton;
/*  疗养券  */
@property(nonatomic,strong)  UIButton *therayButton;
/*  分割  */
@property(nonatomic,strong) UILabel *centerLineLabel;

//为了设置居中
@property(nonatomic,assign) CGFloat ibiButtonWidth;
@property(nonatomic,assign) CGFloat therayButtonWidth;
@property(nonatomic,assign) CGFloat lastWidth;


@property(nonatomic,copy) NSArray *therapyDetailsArr;//疗养券信息


@end

@implementation PersonCenterHeaderView

-(void)remakeUI{
    [super layoutIfNeeded];
    self.ibiButtonWidth = self.ibiButton.frame.size.width;
    self.therayButtonWidth = self.therayButton.frame.size.width;
    self.lastWidth = [UIScreen mainScreen].bounds.size.width - self.ibiButtonWidth - self.therayButtonWidth - 10;
    
    NSLog(@"%lf %lf %lf",self.ibiButtonWidth,self.therayButtonWidth,self.lastWidth);
    
    [self.ibiButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.integralButton.mas_bottom).offset(5);
        make.left.mas_equalTo(self.topImage.mas_left).offset(self.lastWidth / 2);
    }];
    [self.therayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ibiButton.mas_top);
        make.right.mas_equalTo(self.topImage.mas_right).offset(-(self.lastWidth / 2));
    }];
}

-(void)getUserInfo
{
    if ([KeychainManager islogin])
    {
        [UserServices getUserInfoWithuserId:[KeychainManager readUserId]
                            completionBlock:^(int result, id responseObject)
         {
             if (result == 0)
             {
                 id data=responseObject[@"data"];
                 self.dataDic=[[NSDictionary alloc]initWithDictionary:data];
                 [self loadViewWithDataSource:data];
                 NSString * nickName = data[@"nickName"];
                 self.topViewController.navigationItem.title =nickName.length > 0?nickName:data[@"userName"];
             }else
             {
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
         }];
        
    }
    else
    {
        [(BaseViewController *)self.topViewController showNavBarCustomByTitle:@"用户中心"];
        [self loadViewWithDataSource:nil];
    }
}
#pragma mark 疗养券
-(void)getTherapyBalance{
    [UserServices getThreapayBalanceWithuserId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
        if (result == 0) {
           
          self.therapyDetailsArr = responseObject[@"data"][@"detail"];
          
           
            NSString *str =[NSString stringWithFormat:@"疗养券: %.2f",[responseObject[@"data"][@"amount"] floatValue]];
          
            [self.therayButton setTitle:str forState:UIControlStateNormal];
        }
        else{

        }
    }];
}
-(void)getWalletBalance
{
    
    [UserServices
     getWalletBalanceWithuserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
            NSString*str=[NSString stringWithFormat:@"i币: %.2f",[responseObject[@"data"][@"WalletBalance"] floatValue]];
             [self.ibiButton setTitle:str forState:UIControlStateNormal];
             
            }
         else
         {
            // [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}


-(void)loadViewWithDataSource:(id)data
{
    
    if ([KeychainManager islogin])
        
    {
        self.ibiButton.hidden=NO;
        self.therayButton.hidden = NO;
        [self.integralButton setTitle:[NSString stringWithFormat:@"积分: %@",data[@"integral"]] forState:UIControlStateNormal];
     
        [self.userHeadBtn sd_setImageWithURL:[NSURL URLWithString:data[@"headImage"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
    
    }
    else
    {
        [self.integralButton setTitle:[NSString stringWithFormat:@"注册/登录"] forState:UIControlStateNormal];
        self.ibiButton.hidden=YES;
        self.therayButton.hidden = YES;
        
        [self.userHeadBtn setImage:[UIImage imageNamed:@"detault_user_icon"] forState:UIControlStateNormal];
        
     
        
    }
    [self.integralButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        if ([KeychainManager islogin])
        {
            IntegralCenterViewController *integral=[[IntegralCenterViewController alloc]init];
            integral.dataArray=data;
            [self.topViewController.navigationController pushViewController:integral animated:YES];
        }
        
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:nil];
        return ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [KAPPDELEGATE.tabBar setSelectedIndex:0];
        });
        
    }];
    [self.ibiButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
            
            WalletViewController *wallet = [[WalletViewController alloc] init];
            [self.topViewController.navigationController pushViewController:wallet animated:YES];
        }];
    }];

    [self.therayButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        MyThreapayDeatilsViewController *wallet = [[MyThreapayDeatilsViewController alloc] init];
        wallet.testArray = self.therapyDetailsArr;
        [self.topViewController.navigationController pushViewController:wallet animated:YES];
    }];
    
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self initUI];
        [self getUserInfo];
        [self getWalletBalance];
        [self getTherapyBalance];
    }
    return self;
}
- (void)initUI
{
    self.topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT*3/7 - 50)];
    self.topImage.image = [UIImage imageNamed:@"UserCenter-Top"];
    self.topImage.userInteractionEnabled = YES;
    [self addSubview:self.topImage];
    [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    
    self.userHeadBtn = [[UIButton alloc] init];
    [self.userHeadBtn setImage:[UIImage imageNamed:@"detault_user_icon"] forState:UIControlStateNormal];
    [self.userHeadBtn addTarget:self action:@selector(userInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userHeadBtn.layer.masksToBounds = YES;
    self.userHeadBtn.layer.cornerRadius = 25;
    self.userHeadBtn.layer.borderWidth = 1;
    self.userHeadBtn.layer.borderColor = BM_WHITE.CGColor;
    
    [self.topImage addSubview:self.userHeadBtn];
    [self.userHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.topImage.mas_top).offset(50);
        make.width.and.height.offset(50);
    }];
    
    //积分
    self.integralButton = [UnityLHClass masonryButton:@"注册/登录" font:16 color:[UIColor whiteColor]];
    self.integralButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.topImage addSubview:self.integralButton];
 
    //积分
    self.ibiButton = [UnityLHClass masonryButton:@"i币:" font:16 color:[UIColor whiteColor]];
    self.ibiButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.ibiButton.hidden=YES;
    [self.topImage addSubview:self.ibiButton];
    //疗养券
    self.therayButton = [UnityLHClass masonryButton:@"疗养券:" font:16 color:[UIColor whiteColor]];
    self.therayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.therayButton.hidden=YES;
    [self.topImage addSubview:self.therayButton];
    //分割label
    self.centerLineLabel = [UnityLHClass masonryLabel:@"" font:2 color:[UIColor redColor]];
    [self.topImage addSubview:self.centerLineLabel];
    
 

    
    
  // old
    [self.integralButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topImage.mas_centerX);
        make.top.mas_equalTo(self.userHeadBtn.mas_bottom).offset(15);
        make.width.mas_equalTo(self.topImage.mas_width);
    }];
   

    [self.centerLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topImage.mas_centerX);
        make.top.mas_equalTo(self.integralButton.mas_bottom).offset(5);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(10);
    }];
    
    [self.ibiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.centerLineLabel.mas_left).offset(-5);
        make.top.mas_equalTo(self.centerLineLabel.mas_top);
       

    }];
    [self.therayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ibiButton.mas_top);
     
        make.left.mas_equalTo(self.centerLineLabel.mas_right).offset(5);
       
    }];
 

    
    PersonCenterOrderView *orderListView=[[PersonCenterOrderView alloc]init];
    [self.topImage addSubview:orderListView];
    [orderListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [orderListView receiveObject:^(id object) {
        
    }];
    
}

#pragma mark - 事件处理
- (void)userInfoAction:(UIButton *)sender
{
    [LKUserAccessManager userNextStepJudgeAccessLoginHandle:nil normalHandle:^{
        
        UserInfoViewController *userInfo = [[UserInfoViewController alloc] init];
        [self.topViewController.navigationController pushViewController:userInfo animated:YES];
    }];
}
@end
