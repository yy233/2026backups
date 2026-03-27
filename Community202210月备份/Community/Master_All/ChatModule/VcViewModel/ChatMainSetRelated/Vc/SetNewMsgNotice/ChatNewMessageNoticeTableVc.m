//
//  ChatNewMessageTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatNewMessageNoticeTableVc.h"
#import "ChatMainSetRightSwichTableViewCell.h"
#define  ChatMainSetRightSwichTableViewCell_Identifier         @"ChatMainSetRightSwichTableViewCell"


@interface ChatNewMessageNoticeTableVc ()
@property (nonatomic,strong) NSMutableArray *titleArr;
@end

@implementation ChatNewMessageNoticeTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
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
    if (indexPath.row<=3) {
        
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
        cell.textLabel.text = self.titleArr[indexPath.row];
        return cell;
    }
   
}
 
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"开启免打扰",@"语音和视频通话邀请提醒",@"新消息通知显示详情",@"动态评论点赞通知",@"开启自启动",@"新消息通知",@"语音和视频通话邀请通知类型", nil];
    }
    return _titleArr;
}
@end
