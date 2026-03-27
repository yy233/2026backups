//
//  ZYChatInformationVc.m
//  Community
//
//  Created by ZY on 2021/4/23.
//  群等信息页和设置页

#import "ZYChatInformationVc.h"
#import "ZYChatInformationTopCell.h"
#import "ZYChatInformationCell.h"
//
#import "ZYChatUserInfoVc.h"
#import "ChatManagerData.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
//
#import "ChatGroupAddNewMemberTableVc.h"

static NSString * const chatInformationTopCellID = @"ZYChatInformationTopCellID";
static NSString * const chatInformationCellID = @"ZYChatInformationCell";
#define kChatInformationTopCellHeight 130
#define kChatInformationCellHeight 310

@interface ZYChatInformationVc () <UITableViewDataSource, UITableViewDelegate, ZYChatInformationTopCellDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZYChatInformationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"聊天信息";
    self.contentView.backgroundColor = [UIColor clearColor];
    [self setUI];
    [self customTableView];
    [self initData];
    [self initNotice];
}
- (void)initNotice{
    Y_NSNotificationCenter_Creat_NameAction(ChatGroupAddOrDeletMember_NoticeName, groupAddMemberNoticeAction);
    
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(ChatGroupAddOrDeletMember_NoticeName);
}
- (void)groupAddMemberNoticeAction{
    [self initData];
}

// 加载xib父视图
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    
    return self;
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;

    [self.contentView addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYChatInformationTopCell" bundle:nil] forCellReuseIdentifier:chatInformationTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYChatInformationCell" bundle:nil] forCellReuseIdentifier:chatInformationCellID];
}
- (void)initData{
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {//群列表数据
        //群成员列表
        WEAKSELF
        [ChatManagerData chatGroupAllMemberListWithGroupId:self.groupUUID withlistBlock:^(NSArray * arr, BOOL success) {
            if (success) {
                DLog(@"%@",arr);
                STRONGSELF
                strongSelf.groupMemberList = [NSMutableArray arrayWithArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.tableView reloadData];
                });
            }
        }];
    }else{
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZYChatInformationTopCell *cell = [tableView dequeueReusableCellWithIdentifier:chatInformationTopCellID forIndexPath:indexPath];
        cell.delegate = self;
        if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
            [cell fillDataWithGroupMemberArr:self.groupMemberList withNickName:@"群昵称"];
        }else{
           
            [cell fillDataWithImgUrl:self.friendImgUrlStr withNickName:self.friendNickName];
        }
        return cell;
    }else {
        ZYChatInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:chatInformationCellID forIndexPath:indexPath];
        [cell.chatRecordView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatRecordViewTap)]];
        [cell.chatBackgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatBackgroundViewTap)]];
        [cell.topSwitch addTarget:self action:@selector(topSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.nodisturbSwitch addTarget:self action:@selector(nodisturbSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.strongReminderSwitch addTarget:self action:@selector(strongReminderSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kChatInformationTopCellHeight;
    }else {
        
        return kChatInformationCellHeight;
    }
}

#pragma mark - ZYChatInformationTopCellDelegate1
//点击 查看成员信息 + 去添加新人
- (void)chatInformationTopCollectionViewCellSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"");
    //群里：加人入群跳转到拉人  好友：加人入群拉更多人建群 //当前好友不再走本界面不走创建群聊 而是好友聊天设置相关界面
    ZYChatUserInfoVc *vc = [[ZYChatUserInfoVc alloc] init];
    if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {
        if (indexPath.row>=self.groupMemberList.count) {//加人入群跳转
            [self willToAddNewMemberVcToTheGroup];
            return;
        }
        NSDictionary *groupMemberDic = [[NSDictionary alloc]initWithDictionary:self.groupMemberList[indexPath.row]];
        vc.imId = [[groupMemberDic allKeys]containsObject:@"userUuid"] ? groupMemberDic[@"userUuid"] :@"";
    }else{
        if (indexPath.row!=0) {
            [self willToAddNewMemberVCAndCreatAnGroup];
            return;
        }
        vc.imId  = self.friendUUID;// 缺数据friendUUID 待改为imid"
    }
    NSLog(@"！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！chatInformationTopCollectionViewCellSelectItemAtIndexPath   缺数据friendUUID 待改为imid");
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)willToAddNewMemberVcToTheGroup{//已有群拉新成员 
    DLog(@"已有群拉新成员");
    //备注
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"加入群聊";
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    ChatGroupAddNewMemberTableVc *vc = [[ChatGroupAddNewMemberTableVc alloc]init];
    vc.groupUUID = self.groupUUID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (void)willToAddNewMemberVCAndCreatAnGroup{//拉人建群
    
}

#pragma mark - ZYChatInformationTopCellDelegate2
//长按 踢人
- (void)chatInformationTopCollectionViewCellLongPressItemAtIndex:(NSInteger)index{
    
    NSString *msgStr = @"";
    NSDictionary *memberDic =  self.groupMemberList[index];
    NSString *userUuid = [[memberDic allKeys]containsObject:@"userUuid"] ? memberDic[@"userUuid"] :@"";
    NSString *remarks = [[memberDic allKeys]containsObject:@"remarks"] ? memberDic[@"remarks"] :@"";
    msgStr = [NSString stringWithFormat:@"%@将被移除群聊",remarks];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"移除群成员" message:msgStr preferredStyle:UIAlertControllerStyleActionSheet];
    WEAKSELF
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"移除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf removeGroupWithUUID:userUuid];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:okAction];
    [alertVC addAction:cancleAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}
/////
//踢人
- (void)removeGroupWithUUID:(NSString *)uuidStr{
    WEAKSELF
    [ChatManagerData chatGroupRemoveMemberWithGroupId:self.groupUUID withMemberIdArr:@[uuidStr].mutableCopy withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            Y_NSNotificationCenter_PostNotice_NilObject_Name(ChatGroupAddOrDeletMember_NoticeName);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.tableView reloadData];
//            });
        }
    }];
    
}
#pragma mark - 处理点击事件
// 返回
- (void)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 聊天记录
- (void)chatRecordViewTap {
    
    NSLog(@"聊天记录");
}

// 聊天背景
- (void)chatBackgroundViewTap {
    NSLog(@"聊天背景");
    [self iconImgTap];
    
}

// 置顶
- (void)topSwitchChanged:(UISwitch *)sender {
    
    NSLog(@"置顶");
}

// 免打扰
- (void)nodisturbSwitchChanged:(UISwitch *)sender {
    
    NSLog(@"免打扰");
}

// 强提醒
- (void)strongReminderSwitchChanged:(UISwitch *)sender {
    
    NSLog(@"强提醒");
}
#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick
- (void)iconImgTap{
    DLog(@"");
        //非处理状态
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *photographAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片拍照
            [weakSelf chooseImageWithType:Photo_Choose_Type_Grapht];
        }];
        UIAlertAction *photoalbumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片相册选择
            [weakSelf chooseImageWithType:Photo_Choose_Type_Album];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:photographAction];
        [alertVC addAction:photoalbumAction];
        [alertVC addAction:cancleAction];
        alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertVC animated:YES completion:nil];
   
}

- (void)chooseImageWithType:(Photo_Choose_Type)type {
   
   UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
   pickVC.delegate = self;
   if (type == Photo_Choose_Type_Grapht) {
       
       pickVC.allowsEditing = NO;
       pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
   }else {
       
       pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
   }
   pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
   [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *strOfUIImagePickerControllerMediaType = info[UIImagePickerControllerMediaType];
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}
#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{
    if (isNil(photo)) {
        Y_SVP_SHOW_ERR_MES(@"空图片！");
    }
    [ChatManagerData chatWillSendImgFileWithImg:photo withGetDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            NSString *imgUrlStr = [[dic allKeys]containsObject:@"url"] ? dic[@"url"] : @"";
            if (self.thisChatVc_Seesion_type == ChatVc_Seesion_type_Group) {//当前群背景
                [ChatManagerData chatVcSetBackImgWithGroupId:self.groupUUID withImgUrlStr:imgUrlStr withBlock:^(NSDictionary * dic, BOOL success) {
                    if (success) {
                        Y_SVP_SHOW_SUCCESS_MES(@"当前群背景设置成功！");
                        Y_NSNotificationCenter_PostNotice_HaveObject_Name(ChatVcChangeBackImg_NoticeName, imgUrlStr);
                    }
                }];
            }else{//用户好友会话的背景 群背景为空时_群的背景
                [ChatManagerData chatVcSetBackImgWithImgUrlStr:imgUrlStr withBlock:^(NSDictionary * dic, BOOL success) {
                    if (success) {
                        Y_SVP_SHOW_SUCCESS_MES(@"默认背景设置成功");
                        Y_NSNotificationCenter_PostNotice_HaveObject_Name(ChatVcChangeBackImg_NoticeName, imgUrlStr);
                        [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.personalBackground = imgUrlStr;
                    }
                }];
            }
        }
    }];
}
@end
