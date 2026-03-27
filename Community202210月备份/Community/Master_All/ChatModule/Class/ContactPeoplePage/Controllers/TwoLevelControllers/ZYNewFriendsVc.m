//
//  ZYNewFriendsVc.m
//  Community
//
//  Created by ZY on 2021/4/27.
//

#import "ZYNewFriendsVc.h"
#import "ZYAddFriendsVc.h"
#import "ZYChatUserInfoVc.h"
#import "ZYNewFriendsCell.h"
//
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ChatManagerData.h"
#import "ChatFriendReqModel.h"
#define Tag_AgreeV        200
//

static NSString * const newFriendsCellID = @"ZYNewFriendsCell";
#define kEstimatedRowHeight 66

@interface ZYNewFriendsVc () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYNewFriendsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self customTableView];
    [self initData];
}
- (void)initData{//接收到的好友请求列表
    WEAKSELF
    STRONGSELF
    [ChatManagerData getImFriendReqInfoListWithBlcok:^(NSArray * arr, BOOL success) {
        if (success) {
            weakSelf.dataArray  = [[NSMutableArray alloc]initWithArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
    }];
    
}
- (void)setUI {
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.statusHeightConstraint.constant = status_height;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

#pragma mark - 定制TableView
- (void)customTableView {
    
//    self.tableView.tableFooterView= [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置单元格自适应
    self.tableView.estimatedRowHeight = kEstimatedRowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYNewFriendsCell" bundle:nil] forCellReuseIdentifier:newFriendsCellID];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYNewFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:newFriendsCellID forIndexPath:indexPath];
//    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
    [cell.agreeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreeViewTap:)]];
    cell.agreeView.tag = Tag_AgreeV + indexPath.row;
    [cell fillUserInfo:self.dataArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSLog(@"%ld", indexPath.row);
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: self.dataArray[indexPath.row]];
    ChatFriendReqModel *model = [ChatFriendReqModel mj_objectWithKeyValues:dic];
//    NSString *strOfOhterUUID = @"";
//    if ([[TextShowWithModelStr textShowWithModelStr:model.from_user] isEqualToString:[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].userUuid]) {//好友申请的列表数据里含有自己为主动的请求
//        strOfOhterUUID = model.to_user;
//    }else{
//        strOfOhterUUID = model.from_user;
//    }
    
    ZYChatUserInfoVc *vc = [[ZYChatUserInfoVc alloc] init];
    vc.imId = [TextShowWithModelStr textShowWithModelStr:model.imId];
//    vc.uuidStr = [TextShowWithModelStr textShowWithModelStr:model.userAccount];
    [self.navigationController pushViewController:vc animated:YES];
}

// 单元格编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: self.dataArray[indexPath.row]];
    ChatFriendReqModel *model = [ChatFriendReqModel mj_objectWithKeyValues:dic];
    if (model.verifyFlag==6) {//：1已添加，2已同意对方为好友，3已拒绝对方，4对方已同意，5对方已拒绝，6等待我方操作 同意、拒绝
        return YES;
    }else{
        return NO;
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"拒绝";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: self.dataArray[indexPath.row]];
        ChatFriendReqModel *model = [ChatFriendReqModel mj_objectWithKeyValues:dic];
        [self regAddFriendReqWithFriendNotifyId:[TextShowWithModelStr textShowWithModelIntType:model.id]];//己方拒绝
        [self performSelector:@selector(initData) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - 处理点击事件
- (IBAction)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonClicked:(UIButton *)sender {
    
    ZYAddFriendsVc *vc = [[ZYAddFriendsVc alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 同意
- (void)agreeViewTap:(UITapGestureRecognizer *)tap {
    NSInteger idx = tap.view.tag-Tag_AgreeV;
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary: self.dataArray[idx]];
 
     ChatFriendReqModel *model = [ChatFriendReqModel mj_objectWithKeyValues:dic];
//    [self agreeFriendReqWithFuuid:[TextShowWithModelStr textShowWithModelStr:model.to_user]];//己方同意 他人发起的请求。 //不带好友备注的同意
    [self agreeThisReqAndSetFriendRemarkWithFriendNotifyId:[TextShowWithModelStr textShowWithModelIntType:model.id]];

}
// 要填写备注的同意
- (void)agreeThisReqAndSetFriendRemarkWithFriendNotifyId:(NSString *)fid {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"设置备注" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"备注";
    }];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *Action) {
            UITextField *textField = alertVC.textFields.firstObject;
            NSLog(@"%@",textField.text);
            //调用方法
        //    //test
        [self agreeFriendReqWithFriendNotifyId:fid withFriendRemark:textField.text];
    }];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:okButton];
    [alertVC addAction:cancelButton];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)agreeFriendReqWithFriendNotifyId:(NSString *)fid{
    WEAKSELF
    [ChatManagerData agreeAddWithFriendNotifyId:fid withDicBlock:^(NSDictionary * dic, BOOL success) {
        if(success){
            [weakSelf initData];
        }
    }];
}
- (void)agreeFriendReqWithFriendNotifyId:(NSString *)fid withFriendRemark:(NSString *)friendRemark{
    WEAKSELF
    [ChatManagerData agreeAddWithFriendNotifyId:fid withFriendRemark:friendRemark withDicBlock:^(NSDictionary * dic, BOOL success) {
        if(success){
            [weakSelf initData];
        }
    }];
}
//拒绝
- (void)regAddFriendReqWithFriendNotifyId:(NSString *)fid{
    WEAKSELF
    [ChatManagerData rejectAddWithFriendNotifyId:fid withDicBlock:^(NSDictionary * dic, BOOL success) {
        if(success){
            [weakSelf initData];
        }
    }];
}

@end
