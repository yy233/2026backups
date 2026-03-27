//
//  TimerListViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/4/16.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "TimerListViewController.h"

#import "TimmerListTableViewCell.h"
@interface TimerListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *timerListTableView;
@property (nonatomic,strong) NSMutableArray *arrOfThisRobotTimer;
@end

@implementation TimerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.timerListTableView.estimatedRowHeight = 100;
    self.timerListTableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)initView{
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTimerOfThisRobot:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.view addSubview:self.timerListTableView];
     
}
- (void)addTimerOfThisRobot:(UIBarButtonItem *)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _arrOfThisRobotTimer.count;
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimmerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimmerListTableViewCell"];
    if (!cell) {
        cell = [[TimmerListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimmerListTableViewCell"];
         cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
   
    [cell.offAndOnSwitch addTarget:self action:@selector(switchOfIndex:) forControlEvents:UIControlEventTouchUpInside];
    cell.offAndOnSwitch.tag = indexPath.row+TAG_BTN_C;
    return cell;
}
- (void)switchOfIndex:(UISwitch *)sender{
    int index = sender.tag-TAG_BTN_C;
    NSLog(@"switch index=%d",index);
    sender.selected = !sender.selected;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark -- getter
- (UITableView *)timerListTableView{
    if (!_timerListTableView) {
        _timerListTableView = [[UITableView alloc]init];
        _timerListTableView.frame = self.view.frame;
        _timerListTableView.delegate = self;
        _timerListTableView.dataSource = self;
        _timerListTableView.tableFooterView = [UIView new];
       
    }
    return _timerListTableView;
}


@end
