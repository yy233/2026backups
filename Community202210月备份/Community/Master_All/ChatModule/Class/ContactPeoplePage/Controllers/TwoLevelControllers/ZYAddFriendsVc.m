//
//  ZYAddFriendsVc.m
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import "ZYAddFriendsVc.h"
#import "ZYSearchVc.h"
#import "ZYAddFriendsTopCell.h"
#import "ZYAddFriendsCell.h"
//
#import "ScanHelper.h"
#import "ZYChatUserInfoVc.h"
#import "ZYQcodeView.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
//

static NSString * const addFriendsTopCellID = @"ZYAddFriendsTopCell";
static NSString * const addFriendsCellID = @"ZYAddFriendsCell";
#define kAddFriendsTopCellHeight 115
#define kAddFriendsCellHeight 66

@interface ZYAddFriendsVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//
@property (nonatomic,strong) ZYQcodeView *qcodeView;

@property (nonatomic, strong) NSArray *iconImageViewArray;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *subTitleArray;

// 当前二维码背景图index
@property (nonatomic, assign) NSInteger qcodeIndex;

@property (nonatomic, assign) BOOL isOnlyhaveScanCell;

@end

@implementation ZYAddFriendsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOnlyhaveScanCell = YES;//只显示扫一扫cell
    
    self.titleLabel.text = @"添加朋友";
    self.qcodeIndex = 1;
    [self setUI];
    [self customTableView];
    [self initQcodeView];
}
- (void)initQcodeView{
  
    [self.view addSubview:self.qcodeView];
    self.qcodeView.hidden = YES;
    [_qcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_qcodeView.superview);
    }];
   NSDictionary *userInfoDic = [[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn mj_keyValues];
    [self.qcodeView fillUserInfo:[NSMutableDictionary dictionaryWithDictionary:userInfoDic]];
}

// 加载xib父类的视图
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
        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView= [[UIView alloc] init];
    }
    
    return _tableView;
}

- (NSArray *)iconImageViewArray {
    if (!_iconImageViewArray) {
        if (_isOnlyhaveScanCell) {
            _iconImageViewArray = @[@"addf_sao"];
        }else{
            _iconImageViewArray = @[@"addf_radar", @"addf_group", @"addf_sao", @"addf_phone"];
        }
    }
    
    return _iconImageViewArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        if (_isOnlyhaveScanCell) {
            _titleArray = @[@"扫一扫"];
        }else{
            _titleArray = @[@"雷达加朋友", @"面对面建群", @"扫一扫", @"手机联系人"];
        }
    }
    
    return _titleArray;
}

- (NSArray *)subTitleArray {
    if (!_subTitleArray) {
        if (_isOnlyhaveScanCell) {
            _subTitleArray = @[@"扫描二维码名片"];

        }else{
            _subTitleArray = @[@"扫描周边的智慧好友", @"与身边的朋友进入同一个智慧群聊", @"扫描二维码名片", @"添加或邀请通讯录中的朋友"];

        }
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYAddFriendsTopCell" bundle:nil] forCellReuseIdentifier:addFriendsTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYAddFriendsCell" bundle:nil] forCellReuseIdentifier:addFriendsCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else {
        
        return self.iconImageViewArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZYAddFriendsTopCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendsTopCellID forIndexPath:indexPath];
        [cell.searchView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchViewTap)]];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        [cell.scanTouchBtn addTarget:self action:@selector(scanShowAction) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else {
        ZYAddFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:addFriendsCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:self.iconImageViewArray[indexPath.row]];
        cell.titleStrLabel.text = self.titleArray[indexPath.row];
        cell.subTitleStrLabel.text = self.subTitleArray[indexPath.row];
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kAddFriendsTopCellHeight;
    }else {
        
        return kAddFriendsCellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (_isOnlyhaveScanCell) {
            DLog(@"扫一扫");
            [self scanAction];
        }else{
            if (indexPath.row == 0) {
                NSLog(@"雷达加朋友");
            }else if (indexPath.row == 1) {
                NSLog(@"面对面建群");
            }else if (indexPath.row == 2) {
                DLog(@"扫一扫");
                [self scanAction];
            }else if (indexPath.row == 3) {
                NSLog(@"手机联系人");
            }
        }
      
    }
}

#pragma mark ==   扫一扫
- (void)scanAction{
    WEAKSELF
    ScanQRViewController *vc = [[ScanHelper shareInstance] ScanVCWithStyle:ZhiFuBaoStyle qrResultCallBack:^(id result) {
        NSString *imid = @"";
        NSDictionary *scanResultDic = [Tool dictionaryWithJsonString:[NSString stringWithFormat:@"%@",result]];
        if ([[scanResultDic allKeys]containsObject:@"name"]) {
            imid = scanResultDic[@"name"];
        }else{
            Y_SVP_SHOW_ERR_MES(@"错误的用户信息!");
        }
        ZYChatUserInfoVc *vc = [[ZYChatUserInfoVc alloc] init];
        vc.imId = imid;
        //0909 改uuid 为imid
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        NSLog(@"result=%@", result);
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 处理点击事件
// 返回
- (void)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 搜索
- (void)searchViewTap {
    
    NSLog(@"搜索");
    ZYSearchVc *vc = [[ZYSearchVc alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark == 自己二维码数据展示
- (void)scanShowAction{
    self.qcodeView.hidden = NO;
}
- (ZYQcodeView *)qcodeView {
    if (!_qcodeView) {
        _qcodeView = [[NSBundle mainBundle] loadNibNamed:@"ZYQcodeView" owner:nil options:nil].lastObject;
        _qcodeView.hidden = YES;
        [_qcodeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qcodeViewTap)]];
        [_qcodeView.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap)]];
        [_qcodeView.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_qcodeView.saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_qcodeView.refreshButton addTarget:self action:@selector(refreshButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _qcodeView;
}

// 点击qcodeView
- (void)qcodeViewTap {
    
    self.qcodeView.hidden = YES;
//    [self.qcodeView removeFromSuperview];
}

- (void)contentViewTap {
}

// 关闭qcodeView
- (void)closeButtonClicked {
    
    self.qcodeView.hidden = YES;
//    [self.qcodeView removeFromSuperview];
}

// 保存二维码
- (void)saveButtonClicked {
    
    NSLog(@"保存二维码");
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"保存中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.qcodeView.closeButton.hidden = YES;
        self.qcodeView.saveButton.hidden = YES;
        self.qcodeView.saveLabel.hidden = YES;
        self.qcodeView.refreshButton.hidden = YES;
        self.qcodeView.refreshLabel.hidden = YES;
        [SaveScreenViewImgToLocalTool saveImgToPhonePhotoLocalWithView:self.qcodeView];
        self.qcodeView.closeButton.hidden = NO;
        self.qcodeView.saveButton.hidden = NO;
        self.qcodeView.saveLabel.hidden = NO;
        self.qcodeView.refreshButton.hidden = NO;
        self.qcodeView.refreshLabel.hidden = NO;
    });
}

// 刷新二维码
- (void)refreshButtonClicked {
    
    NSLog(@"刷新二维码");
    self.qcodeIndex++;
    if (self.qcodeIndex > 11) {
        self.qcodeIndex = 1;
    }
    self.qcodeView.qcodeBackgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"QRCode%ld", self.qcodeIndex]];
}

@end
