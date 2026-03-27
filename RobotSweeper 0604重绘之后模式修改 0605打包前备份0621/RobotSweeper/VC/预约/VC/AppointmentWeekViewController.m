//
//  TimingViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/3/22.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "AppointmentWeekViewController.h"
#import "AppointmentWeekTableViewCell.h"

@interface AppointmentWeekViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableV;
@property (nonatomic,strong) NSMutableArray *arrOfWeakTitlesource;
@property (nonatomic,strong) NSMutableArray *arrOfselected;

@end

@implementation AppointmentWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = NSLocalizedString(@"设置", nil);
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    [self initView];
    
}
#pragma mark -- init
- (void)initData{
    _arrOfWeakTitlesource = [NSMutableArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",@"单次", nil];
    
    _arrOfselected= [NSMutableArray arrayWithArray:[_weekNumStr componentsSeparatedByString:@" "]];

}
- (void)initView{
       [self.view addSubview:self.tableV];
}
#pragma mark -- delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrOfWeakTitlesource.count+1;//一空行
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    AppointmentWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentWeekTableViewCell"];
    if (!cell) {
        cell = [[AppointmentWeekTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentWeekTableViewCell"];
    }
    if (indexPath.row==7) {//第8行
        cell.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selected = NO;
    }else if(indexPath.row == 8){
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textL.text = NSLocalizedString(_arrOfWeakTitlesource[indexPath.row-1], nil) ;
        cell.strOfSelected = _arrOfselected[indexPath.row-1];
        
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textL.text = NSLocalizedString(_arrOfWeakTitlesource[indexPath.row],nil);
        cell.strOfSelected = _arrOfselected[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==8) {//单次 1-7全清空 8=1
        _arrOfselected  = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"1", nil];
    }else if (indexPath.row == 7){
        //空行
    }else{//重复0-7
        if ([_arrOfselected[indexPath.row] isEqualToString:@"0"]) {
            
            [_arrOfselected replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }else{
            [_arrOfselected replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
        
        [_arrOfselected replaceObjectAtIndex:7 withObject:@"0"];//第8行
    }

    [self.tableV reloadData];
    [self popNoticeOfweek];
}
- (void)popNoticeOfweek{
//    NSString *strOfweek = @"";
//    if ([_arrOfselected.lastObject isEqualToString:@"1"]) {
//        strOfweek = @"0 0 0 0 0 0 0";
//    }else{
//        [_arrOfselected removeObjectAtIndex:_arrOfselected.count-1];
//        strOfweek = [_arrOfselected componentsJoinedByString:@" "];
//        [_arrOfselected addObject:@"0"];
//    }
     NSString *strOfweek = [_arrOfselected componentsJoinedByString:@" "];//8位
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"noticeOfWeekChange" object:strOfweek];
}

#pragma mark -- getter
- (UITableView *)tableV{
    if (!_tableV) {
        //_tableV
        _tableV = [[UITableView alloc]init];
        _tableV.frame = self.view.frame;
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}



@end
