//
//  PlanWeatherView.h
//  LankeProject
//
//  Created by itman on 17/3/8.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanWeatherView : UIView

- (void) updateWeatherData;
- (void) configWeatherViewWithData:(id)data;
- (void) show;
- (void) hide;

@end
