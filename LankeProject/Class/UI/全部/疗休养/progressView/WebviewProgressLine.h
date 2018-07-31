//
//  WebviewProgressLine.h
//  LankeProject
//
//  Created by sai jiang on 2018/7/31.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebviewProgressLine : UIView
//进度条颜色
@property (nonatomic,strong) UIColor  *lineColor;

//开始加载
-(void)startLoadingAnimation;

//结束加载
-(void)endLoadingAnimation;
@end
