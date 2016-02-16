//
//  DDMenuButton.h
//  DropDownMenuButton
//
//  Created by ryhx on 16/2/16.
//  Copyright © 2016年 lay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MenuMode) {
    SingleMenu = 0,//单个tableView,默认
    DoubleMenu = 1,//带子TableView的菜单
    
};
@class DDMenuButton;
@protocol DDMenuButtonDelegate <NSObject>
@optional
-(void)willSelectedDDMenuButton:(DDMenuButton *)button;
-(void)ddButton:(DDMenuButton *)ddbtn tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//定制tableCell
-(UITableViewCell *)ddButton:(DDMenuButton *)ddbtn tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface DDMenuButton : UIButton <UITableViewDataSource,UITableViewDelegate>


//下拉菜单
@property (nonatomic,copy) UIView * dropDownMenu;
//
@property (nonatomic,assign) CGFloat menuRowHeight;
//左tableView
@property (nonatomic,strong) UITableView * mainTableView;
//右tableView
@property (nonatomic,strong) UITableView * supportTableView;
//tableView代理
@property (nonatomic,assign) id<DDMenuButtonDelegate>delegate;
//菜单类型
@property (nonatomic,assign) MenuMode menuMode;

@property (nonatomic,copy) NSArray * mainTableDataArray;
@property (nonatomic,copy) NSArray * supportTableDataArray;
/**
 *  下拉箭头
 */
@property (nonatomic,strong) UIImageView * arrowView;


//收起菜单
-(void)closeMenu;
-(void)removeMenuView;
-(instancetype)initWithFrame:(CGRect)frame fromView:(UIView *)superView;
@end
