//
//  MyAccountXTableViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/8/28.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "MyAccountXTableViewController.h"
#import "PassWordChangeViewController.h"
@interface MyAccountXTableViewController ()
@property (nonatomic,strong)NSString *strOfHeader;
@end

@implementation MyAccountXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"我的账户", nil);
    self.tableView.tableFooterView = [UIView new];
    [self initData];
    [self initView];
}
- (void)initData{
    _strOfHeader = @"";
    NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    NSUInteger i = 0;
    if (arrOflist.count>0) {
        i = arrOflist.count;
    }
    _strOfHeader = [NSString stringWithFormat:NSLocalizedString(@"已经绑定了%lu台设备",nil),(unsigned long)i];
   
}
- (void)initView{
    
     self.tableView.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
     [self.tableView reloadData];
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text = NSLocalizedString(@"手机号",nil);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[ShareUser sharedUserInfo].userMode.userNameNoSuffix];
        cell.accessoryType = UITableViewCellAccessoryNone;//空
    }else{
        cell.textLabel.text = NSLocalizedString(@"修改密码",nil);
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//添加箭头
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backHeaderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW, 60)];
    backHeaderV.backgroundColor = [DataManager shareDataManager].colorOfGrayBack;
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, Y_mainW-40, 40)];
   
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.text = _strOfHeader;
    [backHeaderV addSubview:headerLabel];
    return backHeaderV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==1) {
        PassWordChangeViewController *passWordChangeVC = [[PassWordChangeViewController alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationController pushViewController:passWordChangeVC animated:YES];
    }
}

@end
