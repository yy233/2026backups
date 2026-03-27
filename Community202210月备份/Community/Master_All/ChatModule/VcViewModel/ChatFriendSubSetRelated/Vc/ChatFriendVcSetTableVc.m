//
//  ChatFriendVcTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/17.
//

#import "ChatFriendVcSetTableVc.h"
#import "ChatManagerData.h"
//
#import "ZYMessageVc.h"//chatvc主页
#import "ZYContactPeopleVc.h"//主页
#import "ZYMineVc.h"//主页
#import "ChatFriendVcSetPowerTableVc.h"
#import "RemarkSetVc.h"

//
#import "ChatFriendSetRightSiderTableViewCell.h"
#define  ChatFriendSetRightSiderTableViewCell_Identifier             @"ChatFriendSetRightSiderTableViewCell"

@interface ChatFriendVcSetTableVc ()
@property (nonatomic,strong) BaseTableViewFooterView *footerView;//删除好友
@property (nonatomic,strong) NSMutableArray *titleArr;
//
@property (nonatomic,assign) BOOL isStartFriend;
@property (nonatomic,assign) BOOL isBackFriend;

@property (nonatomic,strong) NSString *idStrNotUuid;//用来删好友 设备注的联系人ID

@end

@implementation ChatFriendVcSetTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    if (isNil(self.saveRelationInfoModel) || self.saveRelationInfoModel.imId.length<=0) {
        [self initData];
    }else{
        self.idStrNotUuid = [NSString stringWithFormat:@"%ld",(long)self.saveRelationInfoModel.id];
        if (self.saveRelationInfoModel.pullBlackOther ) {
            self.isBackFriend = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    [self initNotice];
}
- (void)initNotice{
    Y_NSNotificationCenter_Creat_NameAction(ChatSetFriendRemarkName_NoticeName, friendRemarkNameChangedNotice:);
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(ChatSetFriendRemarkName_NoticeName);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)initView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [self footerView];
   UIColor *beginColor = Y_ColorWith16FromRGB(0xF30303);
   UIColor *endColor = Y_ColorWith16FromRGB(0xFF4F4E);
   CGSize size = CGSizeMake(Screen_W-32, 50);
   self.footerView.footerBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionLevel startColor:beginColor endColor:endColor];
}
- (void)initData{
    //0909 idStrNotUuid 从会话列表和联系人列表传入之外 其他列表暂时无法 则请求本idStrNotUuid 用getone接口获取各类数据
    if (self.friendImId.length <= 0) {
        Y_SVP_SHOW_ERR_MES(@"数据有误！");
        return;
    }
    WEAKSELF
    [ChatManagerData chatOtherUserGetOneInfoWithImId:self.friendImId withBlock:^(NSDictionary * dic,  BOOL success) {
        if (success) {
            weakSelf.saveRelationInfoModel = [ChatOneUserAndOwnUserTheRelationWithChatVcUseModel mj_objectWithKeyValues:dic];
            weakSelf.idStrNotUuid = [NSString stringWithFormat:@"%ld",(long)weakSelf.saveRelationInfoModel.id];
            if (weakSelf.saveRelationInfoModel.pullBlackOther ) {
                weakSelf.isBackFriend = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
    
}
#pragma mark ==
- (void)setStartTypeFriend:(UISwitch *)sender{
    DLog(@"星标");
}
- (void)setBackOrWhiteFriend:(UISwitch *)sender{
     if (sender.on) {
        DLog(@"黑名单 on");
         [self setBackFriend];
    }else{
        DLog(@"黑名单 noon");
        [self setWhiteFriend];
    }
}
#pragma mark === 拉黑好友
- (void)setBackFriend{
    
    WEAKSELF
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [ChatManagerData backFriendWithFriendNotUuidIsInfoId:self.idStrNotUuid  withDic:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            weakSelf.isBackFriend = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark === 移除黑名单
- (void)setWhiteFriend{
    WEAKSELF
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [ChatManagerData whiteFriendWithFriendNotUuidIsInfoId:self.idStrNotUuid  withDic:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            weakSelf.isBackFriend = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark === footervaction
- (void)footerBtnRemoveFirendAction{
    //退出账号 提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除好友" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deletFriendAction];
        }];
        [alertController addAction:alertActionCancel];
        [alertController addAction:alertActionOk];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
   
}
- (void)deletFriendAction{
    WEAKSELF
    [ChatManagerData deletFriendWithFriendNotUuidIsInfoId:self.idStrNotUuid withDic:^(NSDictionary * dic, BOOL success) {
        if (success) {
            STRONGSELF
            [strongSelf popToMesageListVc];
        }
    }];
}
- (void)popToMesageListVc{
    Y_NSNotificationCenter_PostNotice_NilObject_Name(ChatDeletFriend_NoticeName);
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIViewController *vc in [self.navigationController viewControllers]) {
            if ([vc isKindOfClass:[ZYMessageVc class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
            if ([vc isKindOfClass:[ZYContactPeopleVc class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
            if ([vc isKindOfClass:[ZYMineVc class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    });
}
#pragma mark ==
- (void)friendRemarkNameChangedNotice:(NSNotification*)notice{
  NSString *remarkStr =  notice.object;
    self.friendNickName = remarkStr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        
        switch (indexPath.row) {
            case 0:
            {
                //备注
                UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
                backBtn.title = @"取消";
                [self.navigationItem setBackBarButtonItem:backBtn];
                
                RemarkSetVc *vc = [[RemarkSetVc alloc]init];
                vc.idStrNotUuid = self.idStrNotUuid; 
                
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                ChatFriendVcSetPowerTableVc *vc = [[ChatFriendVcSetPowerTableVc alloc]init];
//                vc.friendUUID = self.friendUUID;
                
                UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]init];
                backBtn.title = @"朋友权限";
                [self.navigationItem setBackBarButtonItem:backBtn];
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
     return 3; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 3;
    }else if(section==1){
        return 1;
    }else{
        return 2;
    }
     return self.titleArr.count;
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
    return 56;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1 || (indexPath.section==2 && indexPath.row==0)) {
        ChatFriendSetRightSiderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatFriendSetRightSiderTableViewCell_Identifier];
        if (!cell) {
            cell = [[ChatFriendSetRightSiderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChatFriendSetRightSiderTableViewCell_Identifier];
        }
        if (indexPath.section==1) {
            cell.cellSwith.on = self.isStartFriend;
            cell.titleL.text = self.titleArr[3+indexPath.row];
            cell.cellSwith.tag = 999;
            [cell.cellSwith addTarget:self action:@selector(setStartTypeFriend:) forControlEvents:UIControlEventValueChanged];
        }else{
            cell.cellSwith.on = self.isBackFriend;
            cell.titleL.text = self.titleArr[4+indexPath.row];
            cell.cellSwith.tag = 1000;
            [cell.cellSwith addTarget:self action:@selector(setBackOrWhiteFriend:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.textLabel.textColor = Y_ColorWith16FromRGB(0x333333);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
            cell.detailTextLabel.textColor = Y_ColorWith16FromRGB(0x888888);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
        }
        if (indexPath.section==0 && indexPath.row==0) {
            cell.detailTextLabel.text = self.friendNickName;//备注名 不可用昵称
        }else{
            cell.detailTextLabel.text = @"";
        }
        if (indexPath.section==0) {
            cell.textLabel.text = self.titleArr[indexPath.row];
        }else if (indexPath.section==1){
            cell.textLabel.text = self.titleArr[3+indexPath.row];
        }else{
            cell.textLabel.text = self.titleArr[4+indexPath.row];
        }
        
        return cell;
    }
    
}
 
#pragma mark ===
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr =  [[NSMutableArray alloc]initWithObjects:@"设置备注和标签",@"推荐给朋友",@"朋友权限",@"设置星标朋友",@"加入黑名单",@"举报投诉", nil];
    }
    return _titleArr;
}

- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"删除好友"];
         _footerView.footerBtn.layer.cornerRadius = 22;//h 50
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnRemoveFirendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
@end
