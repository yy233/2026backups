//
//  ChatFriendVcSetPowerTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/17.
// 设置好友权限

#import "ChatFriendVcSetPowerTableVc.h"
#import "ChatFriendSetRightSiderTableViewCell.h"
#import "ChatFriendSetRightChooseTableViewCell.h"
#define  ChatFriendSetRightSiderTableViewCell_Identifier             @"ChatFriendSetRightSiderTableViewCell"
#define  ChatFriendSetRightChooseTableViewCell_Identifier            @"ChatFriendSetRightChooseTableViewCell"

@interface ChatFriendVcSetPowerTableVc ()
//
@property (nonatomic,assign) NSInteger friendPowerNum;
//
@property (nonatomic,assign) BOOL setFriendCantLookMeBool;
@property (nonatomic,assign) BOOL setMeDontLookFriendBool;
@end

@implementation ChatFriendVcSetPowerTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
 
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark ==
- (void)setFriendCantLookMeAction{
    DLog(@"");
}
- (void)setDontLookFriendAction{
    DLog(@"");
}
- (void)setFriendPowerNumWithIsAllPowNumBool:(BOOL)isAllPowNumBool{
    DLog(@"");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            [self setFriendPowerNumWithIsAllPowNumBool:YES];
        }else if (indexPath.row==2){
            [self setFriendPowerNumWithIsAllPowNumBool:NO];
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return 10;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        UIView *sectionHeaderV  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 10)];
        sectionHeaderV.backgroundColor = Color_245Gray;
        return sectionHeaderV;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 40;
    }
    return 56;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = Y_ColorWith16FromRGB(0x888888);
        }
        cell.textLabel.text = (indexPath.section==0) ? @"朋友权限" : @"其他权限";
        return cell;
    }else{
        if (indexPath.section==0) {
            ChatFriendSetRightChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatFriendSetRightChooseTableViewCell_Identifier];
            if (!cell) {
                cell = [[ChatFriendSetRightChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChatFriendSetRightChooseTableViewCell_Identifier];
            }
            if (indexPath.row==1) {
                cell.titleL.text = @"聊天、社区动态、朋友圈等";
                [cell cellSetChooseBool:self.friendPowerNum];
//                cell.rightChooseImgView.hidden =  self.friendPowerNum==1 ? YES : NO;
            
            }else{
                cell.titleL.text = @"仅聊天";
                [cell cellSetChooseBool:(!self.friendPowerNum)];
//                cell.rightChooseImgView.hidden =  self.friendPowerNum==0 ? YES : NO;
            }
            return cell;
        }else{
            ChatFriendSetRightSiderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatFriendSetRightSiderTableViewCell_Identifier];
            if (!cell) {
                cell = [[ChatFriendSetRightSiderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChatFriendSetRightSiderTableViewCell_Identifier];
            }
            if (indexPath.row==1) {
                cell.cellSwith.on = self.setFriendCantLookMeBool;
                cell.titleL.text = @"不让他看我";
                [cell.cellSwith addTarget:self action:@selector(setFriendCantLookMeAction) forControlEvents:UIControlEventValueChanged];
            }else{
                cell.cellSwith.on = self.setMeDontLookFriendBool;
                cell.titleL.text = @"不看他";
                [cell.cellSwith addTarget:self action:@selector(setDontLookFriendAction) forControlEvents:UIControlEventValueChanged];
            }
            return cell;
        }
    }
    
   
}
 

@end
