//
//  ChatPrivacyTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatPrivacyTableVc.h"
#import "ChatMainSetRightSwichTableViewCell.h"
#define  ChatMainSetRightSwichTableViewCell_Identifier         @"ChatMainSetRightSwichTableViewCell"

#import "ChatBlackFriendListVc.h"
@interface ChatPrivacyTableVc ()
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *twoTitleArr;

@end

@implementation ChatPrivacyTableVc


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]init];
    if (indexPath.section==0) {
        backBtn.title = self.titleArr[indexPath.row];
        [self.navigationItem setBackBarButtonItem:backBtn];
        ChatBlackFriendListVc *vc = [[ChatBlackFriendListVc alloc]init];
        [self pushVc:vc];
        
    }else{
        backBtn.title = self.twoTitleArr[indexPath.row];
        [self.navigationItem setBackBarButtonItem:backBtn];
        //
        switch (indexPath.row) {
            case 0:
            {
                ChatBlackFriendListVc *vc = [[ChatBlackFriendListVc alloc]init];
                [self pushVc:vc];
            }
                break;
            case 1:
            {
                ChatBlackFriendListVc *vc = [[ChatBlackFriendListVc alloc]init];
                [self pushVc:vc];
            }
                break;
                
            default:
                break;
        }
    }
   
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.titleArr.count;
    }else{
        return self.twoTitleArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return 33;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        UILabel *sectionHeaderLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Screen_W-32*2, 20)];
        sectionHeaderLabel.backgroundColor = [UIColor whiteColor];
        sectionHeaderLabel.textColor = [Y_ColorWith16FromRGB(0x333333) colorWithAlphaComponent:0.5];
        sectionHeaderLabel.font = [UIFont boldSystemFontOfSize:12];
        sectionHeaderLabel.text = @"    动态设置";
        return sectionHeaderLabel;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && (indexPath.row==1||indexPath.row==2||indexPath.row==3)) {
        ChatMainSetRightSwichTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMainSetRightSwichTableViewCell_Identifier ];
        if (!cell) {
            cell = [[ChatMainSetRightSwichTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChatMainSetRightSwichTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArr[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font  = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = Y_ColorWith16FromRGB(0x333333);
        }
        if (indexPath.section==0) {
            cell.textLabel.text = self.titleArr[indexPath.row];
             
        }else{
            cell.textLabel.text = self.twoTitleArr[indexPath.row];
        }
        return cell;
    }
}
 
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"黑名单",@"好友直接邀请进群",@"隐藏手机机型",@"好友推荐", nil];
    }
    return _titleArr;
}
- (NSMutableArray *)twoTitleArr{
    if (!_twoTitleArr) {
        _twoTitleArr = [[NSMutableArray alloc]initWithObjects:@"不让他(她)看",@"不看他(她)", nil];
    }
    return _twoTitleArr;
}

@end
