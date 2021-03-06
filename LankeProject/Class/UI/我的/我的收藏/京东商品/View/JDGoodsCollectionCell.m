//
//  JDGoodsCollectionCell.m
//  LankeProject
//
//  Created by zhounan on 2017/12/20.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDGoodsCollectionCell.h"

@implementation JDGoodsCollectionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    JDGoodsCollectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JDGoodsCollectionCell"];
    if (!cell)
    {
        cell=[[JDGoodsCollectionCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"JDGoodsCollectionCell"];
    }
    return cell;
    
}

-(void)createCell
{
    self.icon=[[NetworkImageView alloc]init];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(self.icon.mas_height);
    }];
    
    self.name=[UnityLHClass masonryLabel:@"" font:15.0 color:BM_BLACK];
    self.name.numberOfLines=2;
    [self.contentView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.icon.mas_right).offset(15);
        make.top.mas_equalTo(self.icon.mas_top).offset(5);
    }];
    
    self.price=[UnityLHClass masonryLabel:@"" font:15.0 color:[UIColor colorWithRed:1.00 green:0.58 blue:0.09 alpha:1.00]];
    [self.contentView addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(15);
        make.bottom.mas_equalTo(self.icon.mas_bottom).offset(-5);
    }];
    
    self.goodOriginalPrice=[UnityLHClass masonryLabel:@"" font:12.0 color:BM_GRAY];
    [self.contentView addSubview:self.goodOriginalPrice];
    [self.goodOriginalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.price.mas_right).offset(5);
        make.centerY.mas_equalTo(self.price.mas_centerY);
    }];
    UIView *goodline=[[UIView alloc]init];
    goodline.backgroundColor=BM_GRAY;
    [self.goodOriginalPrice addSubview:goodline];
    [goodline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(self.goodOriginalPrice.mas_centerY);
    }];
    UIView *line=[[UIView alloc]init];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(self.icon.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
}

-(void)loadCellWithDataSource:(id)dataSource
{
    NSDictionary*dicData=dataSource[@"zkJdProductDetail"];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:dicData[@"imagePath"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    self.name.text=dicData[@"name"];
    self.price.text=[NSString stringWithFormat:@"¥%.2f",[dicData[@"zkPrice"] floatValue]];
    //self.goodOriginalPrice.text=[NSString stringWithFormat:@"%.2f",[dataSource[@"salePrice"] floatValue]];
}

@end

