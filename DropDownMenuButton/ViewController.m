//
//  ViewController.m
//  DropDownMenuButton
//
//  Created by ryhx on 16/2/16.
//  Copyright © 2016年 lay. All rights reserved.
//

#import "ViewController.h"
#import "DDMenuButton.h"
@interface ViewController () <DDMenuButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    DDMenuButton * ddBtn = [[DDMenuButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64) fromView:self.view];
    [self.view addSubview:ddBtn];
    
    ddBtn.backgroundColor = [UIColor redColor];
    [ddBtn setTitle:@"DropDownMenuButton" forState:UIControlStateNormal];
    ddBtn.delegate = self;
    ddBtn.mainTableDataArray = @[@"hello",@"every body",@"come on"];
    ddBtn.menuMode = DoubleMenu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ddButton:(DDMenuButton *)ddbtn tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%@",[tableView cellForRowAtIndexPath:indexPath].textLabel.text);

}

@end
