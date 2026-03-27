//
//  ZYMineVc.m
//  Community
//
//  Created by ZY on 2021/4/19.
//

#import "ZYMineVc.h"
#import "ZYMineInfoEditVc.h"
#import "ZYMineTopCell.h"
#import "ZYMineCell.h"
#import "ZYQcodeView.h"
//
#import "ChatManagerData.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ScanHelper.h"
#import "ZYChatUserInfoVc.h"
#import "ChatMainSetTableVc.h"
//
static NSString * const mineTopCellID = @"ZYMineTopCell";
static NSString * const mineCellID = @"ZYMineCell";
#define kMineTopCellHeight 170
#define kMineCellHeight 320

@interface ZYMineVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *codeButton;

@property (nonatomic, strong) UIButton *photographButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYQcodeView *qcodeView;
//
@property (nonatomic,strong) NSMutableDictionary *userInfoDic;

// 当前二维码背景图index
@property (nonatomic, assign) NSInteger qcodeIndex;

@end

@implementation ZYMineVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userInfoDic = [[NSMutableDictionary alloc]init];
    self.titleLabel.text = @"我的";
    self.contentView.hidden = YES;
    self.qcodeIndex = 1;
    [self setUI];
    [self customTableView];
}
#pragma mark ==== initData
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfo];
}
#pragma mark ==
- (void)getUserInfo{
    self.userInfoDic = [NSMutableDictionary dictionaryWithDictionary:[[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn mj_keyValues]];
    WEAKSELF
    STRONGSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf.qcodeView fillUserInfo:[NSMutableDictionary dictionaryWithDictionary:self.userInfoDic]];
        [strongSelf.tableView reloadData];
    });
//    WEAKSELF
//    STRONGSELF
//    [ChatManagerData chatUserInfoGetWithMyInfoWithBlock:^(NSDictionary * dic, BOOL success) {
//        if (success) {
//            DLog(@"");
//            self.userInfoDic  = [NSMutableDictionary dictionaryWithDictionary:dic];
//            [sharuu]
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf.qcodeView fillUserInfo:[NSMutableDictionary dictionaryWithDictionary:dic]];
//                [strongSelf.tableView reloadData];
//            });
//        }
//    }];
}

// 加载xib父类的视图
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    
    return self;
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

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
    
    [self.naviView addSubview:self.photographButton];
    [self.naviView addSubview:self.codeButton];
    [_photographButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_photographButton.superview);
        make.right.equalTo(_photographButton.superview).with.offset(-16);
    }];
    [_codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_photographButton.mas_left).with.offset(-20);
        make.top.bottom.equalTo(_codeButton.superview);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_tableView.superview);
        make.top.equalTo(_tableView.superview).with.offset(54 + status_height);
    }];
    
    [self.view addSubview:self.qcodeView];
    self.qcodeView.hidden = YES;
    [_qcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_qcodeView.superview);
    }];
}

#pragma mark - 懒加载
- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_codeButton setImage:[UIImage imageNamed:@"top_i_qr"] forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(codeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _codeButton;
}

- (UIButton *)photographButton {
    if (!_photographButton) {
        _photographButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_photographButton setImage:[UIImage imageNamed:@"top_i_camera"] forState:UIControlStateNormal];
        [_photographButton addTarget:self action:@selector(photographButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _photographButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMineTopCell" bundle:nil] forCellReuseIdentifier:mineTopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMineCell" bundle:nil] forCellReuseIdentifier:mineCellID];
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
        ZYMineTopCell *cell = [tableView dequeueReusableCellWithIdentifier:mineTopCellID forIndexPath:indexPath];
        cell.iconImageView.userInteractionEnabled = YES;
        [cell.iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap)]];
        cell.nameLabel.userInteractionEnabled = YES;
        [cell.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewTap)]];
        [cell.dynamicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dynamicViewTap)]];
        [cell.commentsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentsViewTap)]];
        [cell.giveLikeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giveLikeViewTap)]];
        [cell fillUserInfo:self.userInfoDic];
        return cell;
    }else {
        ZYMineCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellID forIndexPath:indexPath];
        [cell.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTap)]];
        [cell.photoAlbumView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoAlbumViewTap)]];
        [cell.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardViewTap)]];
        [cell.emojView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emojViewTap)]];
        [cell.fileView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fileViewTap)]];
        [cell.mineDynamicView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mineDynamicViewTap)]];
        [cell.systemSettingsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(systemSettingsViewTap)]];
        [cell.helpCenterView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpCenterViewTap)]];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kMineTopCellHeight;
    }else {
        
        return kMineCellHeight;
    }
}

#pragma mark - 处理点击事件
// 我的二维码
- (void)codeButtonClicked {
    
    NSLog(@"我的二维码");
    self.qcodeView.hidden = NO;
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    [window addSubview:self.qcodeView];
//    [_qcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_qcodeView.superview);
//    }];
}

// 拍照
- (void)photographButtonClicked {
    
//    NSLog(@"拍照");
    [self scanViewTap];
    //
}

// 扫一扫
- (void)scanViewTap {
    
    DLog(@"扫一扫");
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
        vc.imId = imid; //0909 改uuid 为imid
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        NSLog(@"result=%@", result);
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
// 头像
- (void)iconImageViewTap {
    
    NSLog(@"头像");
    ZYMineInfoEditVc *vc = [[ZYMineInfoEditVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 动态
- (void)dynamicViewTap {
    
    NSLog(@"动态");
}

// 评论
- (void)commentsViewTap {
    
    NSLog(@"评论");
}

// 点赞数
- (void)giveLikeViewTap {
    
    NSLog(@"点赞数");
}

// 收藏
- (void)collectionViewTap {
    
    NSLog(@"收藏");
}

// 相册
- (void)photoAlbumViewTap {
    
    NSLog(@"相册");
}

// 卡包
- (void)cardViewTap {
    
    NSLog(@"卡包");
}

// 表情
- (void)emojViewTap {
    
    NSLog(@"表情");
}

// 我的文件
- (void)fileViewTap {
    
    NSLog(@"我的文件");
}

// 我的动态
- (void)mineDynamicViewTap {
    
    NSLog(@"我的动态");
}

// 系统设置
- (void)systemSettingsViewTap {
    
    NSLog(@"系统设置");
    ChatMainSetTableVc *vc = [[ChatMainSetTableVc alloc]init];
    //
    vc.hidesBottomBarWhenPushed = YES;
    //
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]init];
    backBtn.title = @"系统设置";
    [self.navigationItem setBackBarButtonItem:backBtn];
    //
    [self.navigationController pushViewController:vc animated:YES];
}

// 帮助中心
- (void)helpCenterViewTap {
    
    NSLog(@"帮助中心");
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

#pragma mark - 返回
- (void)backButtonClicked:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
