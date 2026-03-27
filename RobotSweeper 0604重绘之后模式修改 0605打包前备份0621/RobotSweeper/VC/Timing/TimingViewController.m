//
//  TimingViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/3/22.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "TimingViewController.h"
#import "TimingTableViewCell.h"

@interface TimingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) NSMutableArray *arrOfsource;
@property (nonatomic,strong) NSMutableArray *arrOfselected;
@property (nonatomic,strong) UIView *topTimeView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@end

@implementation TimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self initData];
    [self initView];
    [self initItemBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- init
- (void)initData{
    _arrOfsource = [NSMutableArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    _arrOfselected = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
}
- (void)initView{
    //dataPicke
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 64, Y_mainW, 200)];
     _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    _datePicker.datePickerMode  = UIDatePickerModeTime;
    [self.view addSubview:_datePicker];
    
    //_tableV
    _tableV = [[UITableView alloc]init];
    _tableV.frame = CGRectMake(0, 264, Y_mainW, Y_mainH-200-64);
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.tableFooterView = [UIView new];
    [self.view addSubview:_tableV];
}

- (void)initItemBtn{
    
    UIBarButtonItem *rigthBtn =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rigthBtnAction:)];
    self.navigationItem.rightBarButtonItem = rigthBtn;
    
}

- (void)rigthBtnAction:(UIBarButtonItem *)sender{
    
    NSDate *date = _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString  *string = [[NSString alloc]init];
    string = [dateFormatter stringFromDate:date];
    NSLog(@"保存%@",string);
    
    NSLog(@"%@",_arrOfselected);
    
    
}


#pragma mark -- delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrOfsource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    TimingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimingTableViewCell"];
    if (!cell) {
        cell = [[TimingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimingTableViewCell"];
    }
    cell.textL.text = _arrOfsource[indexPath.row];
    cell.strOfSelected = _arrOfselected[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_arrOfselected[indexPath.row] isEqualToString:@"0"]) {
        [_arrOfselected replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }else{
        [_arrOfselected replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    
    [self.tableV reloadData];
    
    
}

#pragma mark -- 



@end
