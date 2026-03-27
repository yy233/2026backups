//
//  HistoryHolderTableViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/16.
//
 
#import "HistoryHolderTableViewController.h"
#import "HistoryHolderTableViewCell.h"
@interface HistoryHolderTableViewController ()
@property (nonatomic,strong) NSMutableArray *dataArr;
 @end

@implementation HistoryHolderTableViewController
#pragma mark ==
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}
 
#pragma mark ==
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史持有者";
    self.view.backgroundColor = rgba(248, 248, 248, 1);
    self.tableView.backgroundColor =  rgba(248, 248, 248, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initDatas];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarblackTextColorWithBackViewCustomColor:[UIColor whiteColor]];
}
- (void)initDatas{
    self.dataArr = @[@1,@2,@3].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryHolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryHolderTableViewCell_I];
    if(!cell){
        cell = [[HistoryHolderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HistoryHolderTableViewCell_I];
    }
     
    cell.timeTitleL.text = @"timeTitleLt";
    cell.timeCountL.text = @"timeCountLtimeCountLt";
    cell.typeL.text = @"typeLtypeLtypeLtypeLtypeL";
    cell.nickOrIdL.text = @"nickOrIdLnickOrIdLnickOrIdLnickOrIdLnickOrIdL";
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
  
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

@end
