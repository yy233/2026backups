//
//  ZYChatUserInfoVc.m
//  Community
//
//  Created by ZY on 2021/4/23.
// 用户信息页面

#import "ZYChatUserInfoVc.h"
#import "ChatOneUserAndOwnUserTheRelationWithOneUserHomeVcUseModel.h"


#import "ZYChatUserInfoTopCell.h"
#import "ZYChatUserInfoCenterCell.h"
#import "ZYChatUserInfoBottomCell.h"

//
#import "ChatManagerData.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "RemarkSetVc.h"
//
#import "ZYChatVc.h"//非好友时也做跳转
//
static NSString * const chatUserInfoTopCellID = @"ZYChatUserInfoTopCell";
static NSString * const chatUserInfoCenterCellID = @"ZYChatUserInfoCenterCell";
static NSString * const chatUserInfoBottomCellID = @"ZYChatUserInfoBottomCell";
#define kChatUserInfoTopCellHeight 210
#define kChatUserInfoCenterCellHeight ((kScreenW - 88) / 4) * 69 / 72 + 97
#define kChatUserInfoBottomCellHeight 66
 
@interface ZYChatUserInfoVc ()  <UITableViewDataSource, UITableViewDelegate, ZYChatUserInfoCenterCellDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIView *sendMessageView;

@property (weak, nonatomic) IBOutlet UIView *videocallView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *iconImageArray;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *subTitleArray;
//
@property (nonatomic,assign) BOOL isFriendState;//是否为好友 默认是好友 不展示右上角加好友按钮

@property (nonatomic,strong) ChatUserModel *userInfoModel;
@property (nonatomic,strong) ChatOneUserAndOwnUserTheRelationWithOneUserHomeVcUseModel *otherInfoAndRelationInfoModel;


@end

@implementation ZYChatUserInfoVc

- (void)viewDidLoad {
    self.isFriendState = YES;
    [super viewDidLoad];
    self.userInfoModel =   [[ChatUserModel alloc]init];
    self.otherInfoAndRelationInfoModel = [[ChatOneUserAndOwnUserTheRelationWithOneUserHomeVcUseModel alloc]init];
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self setUI];
    [self customTableView];
    [self initData];
}
- (void)initData{

    if (self.imId.length<=0) {
        return;
    }
    WEAKSELF
    
    if ([self.imId isEqualToString: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken]) {//自己的信息
        [ChatManagerData chatUserInfoGetWithMyInfoWithBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                weakSelf.userInfoModel =   [ChatUserModel mj_objectWithKeyValues:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }else{//查询他人的信息 待接口出来后继续
        [ChatManagerData chatOtherUserInfoWithOthterImId:self.imId withBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                weakSelf.otherInfoAndRelationInfoModel =   [ChatOneUserAndOwnUserTheRelationWithOneUserHomeVcUseModel mj_objectWithKeyValues:dic];
                weakSelf.isFriendState =  !weakSelf.otherInfoAndRelationInfoModel.allowToAdd;//可以添加则非好友 不可添加则是好友
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
           
        }];
        
    }
   
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
    self.toolBarHeightConstraint.constant = 80 + bottom_height;

    self.sendMessageView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake((kScreenW - 72) / 2, 46) direction:IHGradientChangeDirectionLevel startColor:Y_RGBA(37, 88, 255, 1) endColor:Y_RGBA(61, 142, 252, 1)];
    self.videocallView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake((kScreenW - 72) / 2, 46) direction:IHGradientChangeDirectionLevel startColor:Y_RGBA(0, 146, 86, 1) endColor:Y_RGBA(0, 202, 119, 1)];
    
    [self.sendMessageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendMessageViewTap)]];
    [self.videocallView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videocallViewTap)]];
}

#pragma mark - 懒加载
- (NSArray *)iconImageArray {
    if (!_iconImageArray) {
        _iconImageArray = @[@"userinfo_fun_setbz", @"userinfo_fun_pyq"];
    }
    
    return _iconImageArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"设置备注和标签", @"朋友圈权限设置"];
    }
    
    return _titleArray;
}

- (NSArray *)subTitleArray {
    if (!_subTitleArray) {
        _subTitleArray = @[@"备注好友信息", @"浏览权限"];
    }
    
    return _subTitleArray;
}

#pragma mark - 定制TableView
- (void)customTableView {
    
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYChatUserInfoTopCell" bundle:nil] forCellReuseIdentifier:chatUserInfoTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYChatUserInfoCenterCell" bundle:nil] forCellReuseIdentifier:chatUserInfoCenterCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYChatUserInfoBottomCell" bundle:nil] forCellReuseIdentifier:chatUserInfoBottomCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZYChatUserInfoTopCell *cell = [tableView dequeueReusableCellWithIdentifier:chatUserInfoTopCellID forIndexPath:indexPath];
        cell.addFriendView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(118, 32) direction:IHGradientChangeDirectionLevel startColor:Y_RGBA(253, 169, 98, 1) endColor:Y_RGBA(252, 94, 40, 1)];
        [cell.addFriendButton addTarget:self action:@selector(addFriendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
         cell.addFriendView.hidden =  self.isFriendState;
        if ([self.imId isEqualToString: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken]) {//自己的信息
            [cell fillMyInfoDataWithModel:self.userInfoModel];
        }else{
            [cell fillOtherUserInfoWithModel:self.otherInfoAndRelationInfoModel];
        }
        return cell;
    }else if (indexPath.section == 1) {
        ZYChatUserInfoCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:chatUserInfoCenterCellID forIndexPath:indexPath];
        cell.delegate = self;
       // [cell fillDataWithModel:self.userInfoModel];//暂留空间数据位置
        return cell;
    }else {
        ZYChatUserInfoBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:chatUserInfoBottomCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:self.iconImageArray[indexPath.row]];
        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.subTitleLabel.text = self.subTitleArray[indexPath.row];
        //[cell fillDataWithModel:self.userInfoModel];//暂留地步按钮数据位置
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kChatUserInfoTopCellHeight;
    }else if (indexPath.section == 1) {
        
        return kChatUserInfoCenterCellHeight;
    }else {
        
        return kChatUserInfoBottomCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            NSLog(@"设置备注和标签");
            [self agreeRemark];
        }else if (indexPath.row == 1) {
            NSLog(@"朋友圈权限设置");
        }
    }
}

#pragma mark - ZYChatUserInfoCenterCellDelegate
- (void)chatUserInfoCenterCollectionViewCellSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"ZYChatUserInfoCenterCellDelegate %ld", indexPath.row);
}

#pragma mark - 处理点击事件
// 返回
- (IBAction)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 更多
- (IBAction)moreButtonClicked:(UIButton *)sender {
    
    NSLog(@"更多");
}

// 发送消息
- (void)sendMessageViewTap {
    
    NSLog(@"发送消息");
    if (self.otherInfoAndRelationInfoModel.allowToAdd) {//非好友
        Y_SVP_SHOW_ERR_MES(@"非好友，暂不可发送信息");
        return;
    }else if ([self.imId isEqualToString: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken]) {//自己
        Y_SVP_SHOW_ERR_MES(@"自己的账户，暂不可发送信息");
        return;
    }else{
    }
    ZYChatVc *vc = [[ZYChatVc alloc]init];
    
    NSString *fImid = self.otherInfoAndRelationInfoModel.imId;
    NSString *fAccountUUID = self.otherInfoAndRelationInfoModel.account;//他人账户
    NSString *fNickName = [TextShowWithModelStr textShowWithModelStr: self.otherInfoAndRelationInfoModel.friendRemark].length>0 ? [TextShowWithModelStr textShowWithModelStr: self.otherInfoAndRelationInfoModel.friendRemark] : [TextShowWithModelStr textShowWithModelStr:self.otherInfoAndRelationInfoModel.nickName];
   
    
    [vc fillThisNomalChatVcSubInfoWithClearnUseID:0 withSessionID:@"" withChatVcToUseType:ChatVc_Seesion_type_Friend withNotShowRightItemMSRBool:NO withWillUseFImId:fImid withWillUseFAccountUUID:fAccountUUID withWillUseFNickName:fNickName withFriendTypeIsDeletPersonNotAllowedSendMsgBool:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
    
//
//    if ([self.imId isEqualToString: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken]) {//自己
//        vc.friendNickName =  self.userInfoModel.nickName;
//        vc.friendUUID =  self.userInfoModel.account;//自己账户
//         vc.chatVcWillUseImId = self.userInfoModel.imId;
//        vc.thisChatVc_Seesion_type = ChatVc_Seesion_type_Friend;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{//他人
//        if (self.otherInfoAndRelationInfoModel.allowToAdd) {//非好友
//            vc.friendNickName  = [TextShowWithModelStr textShowWithModelStr:self.otherInfoAndRelationInfoModel.nickName];
//            vc.isMoShengRenTypeBoolNotShowRightItem = YES;//
//        }else{
//            vc.friendNickName  = [TextShowWithModelStr textShowWithModelStr: self.otherInfoAndRelationInfoModel.friendRemark].length>0 ? [TextShowWithModelStr textShowWithModelStr: self.otherInfoAndRelationInfoModel.friendRemark] : [TextShowWithModelStr textShowWithModelStr:self.otherInfoAndRelationInfoModel.nickName];
//        }
//        vc.chatVcWillUseImId = self.otherInfoAndRelationInfoModel.imId;
//        vc.friendUUID =  self.otherInfoAndRelationInfoModel.account;//他人账户
//      //imid 缺失 待chatvc增后再加
//        vc.thisChatVc_Seesion_type = ChatVc_Seesion_type_Friend;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

// 音视频通话
- (void)videocallViewTap {
    
    NSLog(@"音视频通话");
}

// 添加好友
- (void)addFriendButtonClicked {
    
    NSLog(@"添加好友");
    
    if (self.isFriendState) {
        Y_SVP_SHOW_INFO_MES(@"已经是好友关系");
        return;
    }else   if ([self.imId isEqualToString: [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userToken]) {//自己的信息
        Y_SVP_SHOW_INFO_MES(@"不能加自己为好友");
        return;
    }
    // 发送
//    [ChatManagerData addFriendWithFriendUUID:self.uuidStr withVerifyMessage:@"" withFriendRemark:@""];//旧版
    [ChatManagerData addFriendWithFriendImIdStr:self.imId withVerifyMessage:@"" withFriendRemark:@""]; 
   
}
#pragma mark ===

// 填写备注
- (void)agreeRemark {
    if (self.otherInfoAndRelationInfoModel.allowToAdd) {
        Y_SVP_SHOW_ERR_MES(@"非好友关系，不能做备注。");
        return;
    }else{
        Y_SVP_SHOW_ERR_MES(@"此界面暂时不支持备注。请在好友聊天资料中设置。");
        return;
    }
//    WEAKSELF
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"设置备注" preferredStyle:UIAlertControllerStyleAlert];
//    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.placeholder = @"备注";
//    }];
//    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *Action) {
//            UITextField *textField = alertVC.textFields.firstObject;
//            NSLog(@"%@",textField.text);
//        if (textField.text.length<=0) {
//            Y_SVP_SHOW_ERR_MES(@"备注不能为空");
//            return;
//        }
//        [ChatManagerData changeFriendRemarkWithFriendUUID:weakSelf.uuidStr  withFriendRemark:textField.text withDic:^(NSDictionary * dic, BOOL success) {
//            if (success) {
//                Y_SVP_SHOW_SUCCESS_MES(@"备注成功！");
//            }else{
//            }
//        }];
//    }];
//    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertVC addAction:okButton];
//    [alertVC addAction:cancelButton];
//    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:alertVC animated:YES completion:nil];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"取消";
    [self.navigationItem setBackBarButtonItem:backBtn];
    
//    RemarkSetVc *vc = [[RemarkSetVc alloc]init];
//    vc.uuidStr = self.uuidStr;
//    vc.idStrNotUuid = self.idStrNotUuid;
//    [self.navigationController pushViewController:vc animated:YES];
 
}

@end
