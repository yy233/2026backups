//
//  ZYContactPeopleVc.m
//  Community
//
//  Created by ZY on 2021/4/19.
//

#import "ZYContactPeopleVc.h"
#import "ZYAddFriendsVc.h"
#import "ZYGroupChatVc.h"
#import "ZYNewFriendsVc.h"
#import "ZYAddGroupFriendVc.h"
#import "ZYChatVc.h"
#import "ZYChatUserInfoVc.h"
#import "ScanHelper.h"
#import "ZYContactPeopleFunctionView.h"
#import "ZYContactPeopleTopCell.h"
#import "ZYContactPeopleCell.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"

//
#import "ChatManagerData.h"
//

static NSString * const contactPeopleTopCellID = @"ZYContactPeopleTopCell";
static NSString * const contactPeopleCellID = @"ZYContactPeopleCell";
#define kContactPeopleTopCellHeight 266
#define kContactPeopleCellHeight 66

@interface ZYContactPeopleVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) ZYContactPeopleFunctionView *contactPeopleFunctionView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isContactPeopleFunctionViewShow;

// 索引标题数组
@property (nonatomic, strong) NSMutableArray *indexArray;

// 索引视图
@property (nonatomic, strong) UIView *indexView;

@end

@implementation ZYContactPeopleVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"联系人";//改成好友列表数据
    self.isContactPeopleFunctionViewShow = NO;
    [self setUI];
    [self customTableView];
    [self initData];
}
- (void)initData{
    [self getFriendsList];
}
#pragma mark == 常用列表 好友数据暂代
- (void)getFriendsList{
    WEAKSELF
    STRONGSELF
    [ChatManagerData getFriendInfoListWithBlcok:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            strongSelf.dataArray = [NSMutableArray arrayWithArray: [ChatFriendModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //好友同意时 更改备注时  本页刷新列表
    [self getFriendsList];
}
- (void)viewDidAppear:(BOOL)animated {

   [super viewDidAppear:animated];
   
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {

   [super viewWillDisappear:animated];

    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

// 加载xib父类的视图
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    
    return self;
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
    /**
      //隐藏+右上+号
     [self.naviView addSubview:self.addButton];
     [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_addButton.superview);
         make.right.equalTo(_addButton.superview).with.offset(-6);
         make.width.height.offset(44);
     }];
     */
   
    
    [self.contentView addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(_tableView.superview);
    }];
    
    [self.contentView addSubview:self.contactPeopleFunctionView];
    [_contactPeopleFunctionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contactPeopleFunctionView.superview);
    }];
}

#pragma mark - 懒加载
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"plus_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addButton;
}

- (ZYContactPeopleFunctionView *)contactPeopleFunctionView {
    if (!_contactPeopleFunctionView) {
        _contactPeopleFunctionView = [[[NSBundle mainBundle] loadNibNamed:@"ZYContactPeopleFunctionView" owner:nil options:nil] lastObject];
        _contactPeopleFunctionView.hidden = YES;
        [_contactPeopleFunctionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactPeopleFunctionViewTap)]];
        [_contactPeopleFunctionView.addFriendsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFriendsViewTap)]];
        [_contactPeopleFunctionView.groupChatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupChatViewTap)]];
        [_contactPeopleFunctionView.scanView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanViewTap)]];
        [_contactPeopleFunctionView.receivingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receivingViewTap)]];
    }
    
    return _contactPeopleFunctionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView= [[UIView alloc] init];
    }
    
    return _tableView;
}

- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc] init];
        for(char c = 'A'; c<='Z'; c++) {
             [_indexArray addObject:[NSString stringWithFormat:@"%c", c]];
         }
        [_indexArray insertObject:@"☆" atIndex:0];
        [_indexArray addObject:[NSString stringWithFormat:@"#"]];
    }
    
    return _indexArray;
}

- (UIView *)indexView {
    if (!_indexView) {
        _indexView = [[UIView alloc] init];
        _indexView.backgroundColor = [UIColor clearColor];
    }
    
    return _indexView;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYContactPeopleTopCell" bundle:nil] forCellReuseIdentifier:contactPeopleTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYContactPeopleCell" bundle:nil] forCellReuseIdentifier:contactPeopleCellID];
}

#pragma mark - 加载数据
- (void)loadData {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    return self.indexArray.count;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else {
        
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZYContactPeopleTopCell *cell = [tableView dequeueReusableCellWithIdentifier:contactPeopleTopCellID forIndexPath:indexPath];
        cell.searchTextField.delegate = self;
        [cell.friendsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorfriendsViewTap)]];
        [cell.contactView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactViewTap)]];
        [cell.nfriendView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newFriendTap)]];
        [cell.groupManagerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(groupManagerViewTap)]];
        [cell.labelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelViewTap)]];
        
        return cell;
    }else {
        ZYContactPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:contactPeopleCellID forIndexPath:indexPath];
        [cell fillDataWithFriendModel:self.dataArray[indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kContactPeopleTopCellHeight;
    }else {
        
        return kContactPeopleCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 0) {
        ChatFriendModel *fmodel = self.dataArray[indexPath.row];
        
        if ( fmodel.type == 0 ) {
          //非联系人
            Y_SVP_SHOW_ERR_MES(@"非联系人！不可聊天");
            return;
            
        }else{ //好友类型 陌生人 都可以聊天 当前界面暂定好友列表数据
            
            WEAKSELF
            NSString *toUserNickName =  [TextShowWithModelStr textShowWithModelStr:fmodel.friendRemark].length>0 ? [TextShowWithModelStr textShowWithModelStr:fmodel.friendRemark] :[TextShowWithModelStr textShowWithModelStr:fmodel.nickName];
            NSString *toUserUUID = [TextShowWithModelStr textShowWithNotNullStr: fmodel.otherAccount];//此为占位
            NSString *imidStr = [TextShowWithModelStr textShowWithNotNullStr:fmodel.imId];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                ZYChatVc *vc = [[ZYChatVc alloc] init];
                ChatVc_Seesion_type thishatVc_Seesion_type = ChatVc_Seesion_type_Friend;
                BOOL isMoShengRenTypeBoolNotShowRightItemBool = NO;//好友类型 非陌生人
                NSString *fImid = imidStr;
                NSString *fAccountUUID = toUserUUID;
                NSString *fNickName = toUserNickName.length>0 ? toUserNickName  : @"未知好友";
                BOOL isFriendTypeIsDeletNotAllowSendMsgBool = NO;
                [vc fillThisNomalChatVcSubInfoWithClearnUseID:0 withSessionID:@"" withChatVcToUseType:thishatVc_Seesion_type withNotShowRightItemMSRBool:isMoShengRenTypeBoolNotShowRightItemBool withWillUseFImId:fImid withWillUseFAccountUUID:fAccountUUID withWillUseFNickName:fNickName withFriendTypeIsDeletPersonNotAllowedSendMsgBool:isFriendTypeIsDeletNotAllowSendMsgBool];
                weakSelf.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            });
        }
    }
}

// 设置索引section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0;
    }
    return 0;//去掉索引
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 10;
    }
    
    return 0;
}

// 返回自定义headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width, 30)];
//    label.text = self.indexArray[section];
//    label.textColor = [UIColor darkGrayColor];
//    label.font = [UIFont systemFontOfSize:14];
//    [view addSubview:label];
//    view.backgroundColor = [UIColor whiteColor];
//
    return [UIView new];
}

// 返回自定义footerView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    view.backgroundColor = Y_RGBA(245, 245, 245, 1);
    
    return view;
}

// 显示每组标题索引
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    // 设置右侧索引字体颜色
//    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
//    // 设置右侧索引背景色
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//
//    return self.indexArray;
//}

// 响应点击索引时的委托方法(点击右侧索引表项时调用)
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    NSLog(@"title=%@, index=%ld", title, index);
    return index;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 让cell中输入框失去第一响应
    [self.view endEditing:YES];
}

#pragma mark - 处理点击事件
// 添加
- (void)addButtonClicked {
    
    NSLog(@"添加");
    if (!self.isContactPeopleFunctionViewShow) {
        self.isContactPeopleFunctionViewShow = YES;
        self.contactPeopleFunctionView.hidden = NO;
    }else {
        self.isContactPeopleFunctionViewShow = NO;
        self.contactPeopleFunctionView.hidden = YES;
    }
}

// 点击contactPeopleFunctionView
- (void)contactPeopleFunctionViewTap {
    
    self.isContactPeopleFunctionViewShow = NO;
    self.contactPeopleFunctionView.hidden = YES;
}

/**
 contactPeopleFunctionView中的点击事件
 */
// 加好友
- (void)addFriendsViewTap {
    
    NSLog(@"加好友");
    self.isContactPeopleFunctionViewShow = NO;
    self.contactPeopleFunctionView.hidden = YES;
    ZYAddFriendsVc *vc = [[ZYAddFriendsVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 群聊
- (void)groupChatViewTap {
    
    NSLog(@"群聊列表");
    Y_SVP_SHOW_INFO_MES(@"当前社区，暂未开放");
    return;
//    ZYGroupChatVc *vc = [[ZYGroupChatVc alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    ZYAddGroupFriendVc *vc = [[ZYAddGroupFriendVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 扫一扫
- (void)scanViewTap {
    
    DLog(@"扫一扫");
    self.isContactPeopleFunctionViewShow = NO;
    self.contactPeopleFunctionView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    ScanQRViewController *vc = [[ScanHelper shareInstance] ScanVCWithStyle:ZhiFuBaoStyle qrResultCallBack:^(id result) {
        
        NSString *imid = @"";
        NSDictionary *scanResultDic = [Tool dictionaryWithJsonString:[NSString stringWithFormat:@"%@",result]];
        if ([[scanResultDic allKeys]containsObject:@"name"]) {
            imid = scanResultDic[@"name"];
        }else{
            Y_SVP_SHOW_ERR_MES(@"错误的用户信息!");
        }
        ZYChatUserInfoVc *vc = [[ZYChatUserInfoVc alloc] init];
        vc.imId = imid;//0909 改uuid 为imid
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        NSLog(@"result=%@", result);
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 收付款
- (void)receivingViewTap {
    
    NSLog(@"收付款");
}

/**
 tableViewCell中的点击事件
 */
// 添加好友
- (void)selectorfriendsViewTap {
    
    NSLog(@"添加好友");
    ZYAddFriendsVc *vc = [[ZYAddFriendsVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 联系人
- (void)contactViewTap {
    
    NSLog(@"手机联系人");
}

// 新的朋友
- (void)newFriendTap {
    
    NSLog(@"新的朋友");
    ZYNewFriendsVc *vc = [[ZYNewFriendsVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 群组
- (void)groupManagerViewTap {
    
    NSLog(@"群组");
    Y_SVP_SHOW_INFO_MES(@"当前社区，暂未开放");
    return;
//    ZYAddGroupFriendVc *vc = [[ZYAddGroupFriendVc alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    ZYGroupChatVc *vc = [[ZYGroupChatVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 标签
- (void)labelViewTap {
    
    NSLog(@"标签");
    Y_SVP_SHOW_INFO_MES(@"当前社区，暂未开放");
    return;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"搜索框 做跳转");
    NSLog(@"添加好友");
    [textField endEditing:YES];
    ZYAddFriendsVc *vc = [[ZYAddFriendsVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
 

#pragma mark - 返回
- (void)backButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
