//
//  SetManageOfRobotTableViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/6/14.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SetManageOfRobotTableViewController.h"
#import "ContentTableViewCell.h"

#import "SetManageDetailViewController.h"
#import "AddTwoPlanChooseViewController.h"
@interface SetManageOfRobotTableViewController ()

@property (nonatomic,strong) NSMutableArray *arrOflist;

@end

@implementation SetManageOfRobotTableViewController
//组
- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    return [super initWithStyle:UITableViewStyleGrouped];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    self.title = NSLocalizedString(@"设备管理", nil);
   
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    [self initView];
}
- (void)initData{
    _arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
}
- (void)initView{
    [self.tableView reloadData];
}

#pragma mark -- 
- (void)addRobotAction:(UIButton *)sender{
    NSLog(@"添加按钮");
    
    //新0108 
    AddTwoPlanChooseViewController *addTwoPalnChooseVc = [[AddTwoPlanChooseViewController alloc]init];
    [self.navigationController pushViewController:addTwoPalnChooseVc animated:YES];
    //旧
//    SearchNewViewController *searchVc = Y_storyBoard_id(@"SearchNewViewController");
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    [self.navigationController pushViewController:searchVc animated:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _arrOflist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSDictionary *dicOfRobot = _arrOflist[indexPath.row];
    NSString *strOfNickName = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"nickName"]];
    cell.textLabel.text = strOfNickName;
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//添加箭头
    
  /**
   ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentTableViewCell"];
   
   if (!cell) {
   cell = [[ContentTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ContentTableViewCell"];
   }
   NSDictionary *dicOfRobot = _arrOflist[indexPath.row];
   NSString *strOfNickName = [dicOfRobot objectForKey:@"nickName"];
   //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   //    cell.accessoryView = [[UIImageView alloc]initWithImage:Y_IMAGE(@"跳转")];
   cell.textL.text = strOfNickName;
   
   //    cell.detailTextLabel.text = @">";
   */
    return cell;
}
 
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *backFootV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 80)];
    UIButton *btnOfAddRobot = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOfAddRobot.frame = CGRectMake(50, 20, Y_mainW-100, 40);
    [btnOfAddRobot setTitle:NSLocalizedString(@"添加设备", nil)  forState:UIControlStateNormal];
    [btnOfAddRobot setBackgroundColor:[DataManager shareDataManager].colorOfMainType];
    [btnOfAddRobot addTarget:self action:@selector(addRobotAction:) forControlEvents:UIControlEventTouchUpInside];
    btnOfAddRobot.layer.cornerRadius = 5;
    [backFootV addSubview:btnOfAddRobot];
    return backFootV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//设备详情
    SetManageDetailViewController *detailVc = [[SetManageDetailViewController alloc]init];
    detailVc.dicOfS = [NSMutableDictionary dictionaryWithDictionary:_arrOflist[indexPath.row]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
