//
//  DDMenuButton.m
//  DropDownMenuButton
//
//  Created by ryhx on 16/2/16.
//  Copyright © 2016年 lay. All rights reserved.
//

#import "DDMenuButton.h"

#define lKeyWindow [(UIApplication *)[UIApplication sharedApplication] keyWindow]
/*系统屏幕的高*/
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/*系统屏幕的宽*/
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface DDMenuButton ()
@property (nonatomic,copy) UIView * enabledView;
@property (nonatomic,assign) CGFloat menuHeight;
@end

@implementation DDMenuButton

-(instancetype)initWithFrame:(CGRect)frame fromView:(UIView *)superView{
    self = [super initWithFrame:frame];
    if (self) {
        
        _mainTableDataArray = [[NSArray alloc] init];
        
        // _menuHeight = kScreenHeight/2-self.frame.size.height;
        _menuRowHeight = 44;
        _menuHeight = _menuRowHeight*4;
        CGRect frame = self.frame;
        
        //获取superView所在的UIViewController
        id target=superView;
        while (target) {
            target = ((UIResponder *)target).nextResponder;
            if ([target isKindOfClass:[UIViewController class]]) {
                break;
            }
        }
        UIViewController * vc = (UIViewController *)target;
        
        //计算button所在ViewController的相对位置
        CGRect rc = [vc.view convertRect:self.frame fromView:superView];
        rc.origin.y += frame.size.height;
        rc.origin.x = 0;
        rc.size = CGSizeMake(kScreenWidth, 0);
        
        _dropDownMenu = [[UIView alloc] initWithFrame:rc];
        [self config];
    }
    return self;
    
}

-(void)config{
    [self addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    _enabledView = [[UIView alloc] initWithFrame:CGRectMake(0, _dropDownMenu.frame.origin.y,_dropDownMenu.frame.size.width, kScreenHeight)];
    _enabledView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _enabledView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu)];
    [_enabledView addGestureRecognizer:tap];
    
    //下拉箭头
    UIImage * image = [UIImage imageNamed:@"下拉箭头"];
    _arrowView = [[UIImageView alloc] initWithImage:image];
    [_arrowView sizeToFit];
    _arrowView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:_arrowView];
    
}

-(void)clickButton{
    if ([self.delegate respondsToSelector:@selector(willSelectedDDMenuButton:)]) {
        [self.delegate willSelectedDDMenuButton:self];
    }
    self.selected = !self.selected;
}

-(void)userEnabled:(BOOL)enabled{
    if(enabled){
        [lKeyWindow addSubview:_enabledView];
        [lKeyWindow addSubview:_dropDownMenu];
    }
    
    CGRect frame = _dropDownMenu.frame;
    CGRect lFrame = self.mainTableView.frame;
    CGRect rFrame = self.supportTableView.frame;
    
    
    if (enabled == YES) {
        frame.size.height = _menuHeight;
    }else{
        frame.size.height = 0;
    }
    lFrame.size.height = frame.size.height;
    rFrame.size.height = frame.size.height;
    
    __weak __typeof(self)  weakSelf = self;
    weakSelf.userInteractionEnabled = NO;
    [UIView animateWithDuration:enabled?0.5:0.3 delay:0 usingSpringWithDamping:enabled?0.55:1 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _arrowView.transform = CGAffineTransformMakeScale (1 , 1-2*enabled );
        
        weakSelf.dropDownMenu.frame = frame;
        weakSelf.mainTableView.frame = lFrame;
        weakSelf.supportTableView.frame = rFrame;
        //_dropDownMenu.alpha = enabled;
        weakSelf.enabledView.alpha = enabled;
    } completion:^(BOOL finished) {
        weakSelf.userInteractionEnabled = YES;
        if (!enabled) {
            [weakSelf.dropDownMenu removeFromSuperview];
            [weakSelf.enabledView removeFromSuperview];
        }
        
    }];
}
-(void)closeMenu{
    self.selected = NO;
}
#pragma mark - Set/Get
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self userEnabled:selected];
}

-(void)setMenuMode:(MenuMode)menuMode{
    _menuMode = menuMode;
    if(menuMode == DoubleMenu){
        CGRect frame = _mainTableView.frame;
        frame.size.width = _dropDownMenu.frame.size.width/2;
        _mainTableView.frame = frame;
    }else{
        CGRect frame = _mainTableView.frame;
        frame.size.width = _dropDownMenu.frame.size.width;
        _mainTableView.frame = frame;
    }
}
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self layoutSubviews];
    
    CGRect frame =  _arrowView.frame;
    frame.origin.x =self.titleLabel.frame.origin.x+self.titleLabel.frame.size.width+10;
    _arrowView.frame = frame;
}
-(void)setMainTableDataArray:(NSArray *)mainTableDataArray{
    if (_mainTableDataArray != mainTableDataArray) {
        _mainTableDataArray = nil;
        _mainTableDataArray = mainTableDataArray;
    }
    //根据数据容量改变Menu高度、限制极限值
    NSInteger count = _mainTableDataArray.count;
    count = _mainTableDataArray.count>9?9:count;
    count = _mainTableDataArray.count<4?4:count;
    _menuHeight = count*_menuRowHeight;
    
    [_mainTableView reloadData];
}
-(void)setSupportTableDataArray:(NSArray *)supportTableDataArray{
    if (_supportTableDataArray != supportTableDataArray) {
        _supportTableDataArray = nil;
        _supportTableDataArray = supportTableDataArray;
    }
    [_supportTableView reloadData];
}

-(UITableView *)mainTableView{
    if(!_mainTableView){
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _dropDownMenu.frame.size.width,0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        //_mainTableView.bounces = NO;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        //去除无数据时tableView的横线
        _mainTableView.tableFooterView = [[UIView alloc] init];
        
        [_dropDownMenu addSubview:_mainTableView];
        
    }
    return _mainTableView;
}
-(UITableView *)supportTableView{
    if (_menuMode == SingleMenu) {
        return nil;
    }
    if (!_supportTableView) {
        _supportTableView = [[UITableView alloc] initWithFrame:CGRectMake(_dropDownMenu.frame.size.width/2, 0, _dropDownMenu.frame.size.width/2, 0) style:UITableViewStylePlain];
        _supportTableView.delegate = self;
        _supportTableView.dataSource = self;
        _supportTableView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        
        
        [_dropDownMenu addSubview:_supportTableView];
    }
    return _supportTableView;
}


#pragma mark - UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _mainTableView) {
        return _mainTableDataArray.count;
    }else{
        return _supportTableDataArray.count;
    }
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(ddButton:tableView:cellForRowAtIndexPath:)]) {
        return [self.delegate ddButton:self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    if (tableView == self.mainTableView) {
        static NSString * cellID = @"mainCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            
        }
        if (indexPath.row == 0) {
            cell.selected = YES;
        }
        cell.textLabel.text = _mainTableDataArray[indexPath.row];
        return cell;
    }
    
    static NSString * cellID = @"supportCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = _supportTableDataArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(ddButton:tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate ddButton:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    if (_menuMode == SingleMenu) {
        self.selected = NO;
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else{
        if (tableView == self.supportTableView) {
            self.selected = NO;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _menuRowHeight;
}

-(void)removeMenuView{
    [_dropDownMenu removeFromSuperview];
    [_enabledView removeFromSuperview];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if([keyPath isEqualToString:@"lastObject"])
    {
        [self removeMenuView];
    }
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    //    UINavigationController * nv = (UINavigationController *)[RLPDate findViewController:self];
    //     NSLog(@"%lu",nv.viewControllers.count);
    //    [nv addObserver:self forKeyPath:@"viewControllers" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
    //    UINavigationController * nv = (UINavigationController *)[RLPDate findViewController:self];
    //    NSLog(@"%lu",nv.viewControllers.count);
    //    [nv.viewControllers removeObserver:self forKeyPath:@"lastObject"];
}
@end
