//
//  QuestionFinishedViewController.m
//  LankeProject
//
//  Created by 符丹 on 17/3/14.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "QuestionFinishedViewController.h"


@interface QuestionFinishedViewController ()

@end

@implementation QuestionFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showNavBarCustomByTitle:@"问卷调查"];
    [self initUI];
}

#pragma mark -- 初始化界面
-(void)initUI
{
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"questionIcon_1"]];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UILabel *lableOne = [UnityLHClass masonryLabel:@"您已参与过本次问卷调查" font:16.0 color:[UIColor colorWithHexString:@"666666"]];
    lableOne.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lableOne];
    [lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconImageView.mas_centerX);
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(40);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    
    UILabel *lableTwo = [UnityLHClass masonryLabel:@"请关注下次，谢谢" font:16.0 color:[UIColor colorWithHexString:@"666666"]];
    lableTwo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lableTwo];
    [lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconImageView.mas_centerX);
        make.top.mas_equalTo(lableOne.mas_bottom).offset(5);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
