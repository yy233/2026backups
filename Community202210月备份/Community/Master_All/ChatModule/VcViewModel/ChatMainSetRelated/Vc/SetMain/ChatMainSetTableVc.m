//
//  ChatMianSetTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/17.
//

#import "ChatMainSetTableVc.h"
#import "ChatMainSetLefImgAndRightSwithTableViewCell.h"
#define  ChatMainSetLefImgAndRightSwithTableViewCell_Identifier         @"ChatMainSetLefImgAndRightSwithTableViewCell"
//
#import "ChatAccountSecurityTableVc.h"
#import "ChatNewMessageNoticeTableVc.h"
#import "ChatMessageDefineSetTableVc.h"
#import "ChatPrivacyTableVc.h"
#import "ChatBlackFriendListVc.h"
#import "ChatReportComplaintsVc.h"
#import "ChatAboutSelfVc.h"
#import "ChatHelpAndFeedbackTableVc.h"


@interface ChatMainSetTableVc ()
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *imgNameArr;
@end

@implementation ChatMainSetTableVc

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
    backBtn.title = self.titleArr[indexPath.row];
    [self.navigationItem setBackBarButtonItem:backBtn];
    // //@"帐号与安全",@"勿扰模式",@"新消息提醒",@"聊天",@"隐私",@"关于聊天",@"帮助与反馈"
    
    switch (indexPath.row) {
        case 0:
        {
            ChatAccountSecurityTableVc *vc = [[ChatAccountSecurityTableVc alloc]init];
            [self pushVc:vc];
            
        }
            break;
            //1"勿扰模式"
        case 2:
        {
            ChatNewMessageNoticeTableVc *vc = [[ChatNewMessageNoticeTableVc alloc]init];
            [self pushVc:vc];
        }
            break;
        case 3:
        {
            ChatMessageDefineSetTableVc *vc = [[ChatMessageDefineSetTableVc alloc]init];
            [self pushVc:vc];
        }
            break;
        case 4:
        {
            ChatPrivacyTableVc *vc = [[ChatPrivacyTableVc alloc]init];
            [self pushVc:vc];
        }
            break;
        case 5:
        {
            ChatAboutSelfVc *vc = [[ChatAboutSelfVc alloc]init];
            [self pushVc:vc];
        }
            break;
        case 6:
        {
            ChatHelpAndFeedbackTableVc *vc = [[ChatHelpAndFeedbackTableVc alloc]init];
            [self pushVc:vc];
        }
            break;
            
        default:
        {
            ChatReportComplaintsVc *vc = [[ChatReportComplaintsVc alloc]init];
            [self pushVc:vc];
        }
            break;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==1) {
        
        ChatMainSetLefImgAndRightSwithTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMainSetLefImgAndRightSwithTableViewCell_Identifier ];
        if (!cell) {
            cell = [[ChatMainSetLefImgAndRightSwithTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChatMainSetLefImgAndRightSwithTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArr[indexPath.row];
        cell.leftImgV.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font  = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = Y_ColorWith16FromRGB(0x333333);
        }
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
        return cell;
    }
   
}
 
 
#pragma mark ==
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"帐号与安全",@"勿扰模式",@"新消息提醒",@"聊天",@"隐私",@"关于聊天",@"帮助与反馈",@"投诉举报", nil];
    }
    return _titleArr;
}
- (NSMutableArray *)imgNameArr{
    if (!_imgNameArr) {
        _imgNameArr = [[NSMutableArray alloc]initWithObjects:@"set_safe",@"set_no",@"set_tips",@"set_chat",@"set_ys",@"set_about",@"set_help",@"set_help",  nil];
    }
    return _imgNameArr;
}
@end
