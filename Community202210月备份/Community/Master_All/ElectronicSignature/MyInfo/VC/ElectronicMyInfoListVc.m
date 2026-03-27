//
//  ElectronicMyInfoListVc.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectronicMyInfoListVc.h"
#import "ZYZhangManagerVc.h"
#import "ElectronicSignatureFeedBackVc.h"
#import "ZYElectronicSignPasswordSettingVc.h"
#import "ZYElectronicSignPasswordChangedVc.h"
#import "ZYElectronicSignAboutVc.h"
#import "ElectronicMyInfoHeaderView.h"
#import "ZYMoulageHelperBarView.h"
#import "ZYElectronicMyInfoListCell.h"
#import "ZYElectronicSignatureModelData.h"

static NSString * const electronicMyInfoListCellID = @"ZYElectronicMyInfoListCell";
#define kElectronicMyInfoListCellHeight 70

@interface ElectronicMyInfoListVc () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
//@property (nonatomic,strong) ElectronicSignatureBaseFooterView *footerView;
@property (nonatomic, strong) ZYMoulageHelperBarView *barView;
@property (nonatomic,strong) ElectronicMyInfoHeaderView *headerView;
@property (nonatomic,strong) UITableView *tableView;
//
@property (nonatomic,strong) NSMutableArray *cellTitleTextArr;
@property (nonatomic,strong) NSMutableArray *cellImgNameArr;
@end

@implementation ElectronicMyInfoListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.view bringSubviewToFront:self.barView];
    [self initData];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hiddenNavigationBar];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self setupNavigationBarClearTransparentStyle];
}
- (void)setUI {
    
    [self.view addSubview:self.barView];
    [_barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_barView.superview);
        make.height.offset(44 + status_height);
    }];
    [self.view addSubview:self.headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_headerView.superview);
        make.height.offset(120 + KStatusBarHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}
- (void)initData{
//    self.cellTitleTextArr = [NSMutableArray arrayWithObjects:@"我的印章",@"签署密码",@"意见反馈",@"关于电子签章", nil];
//    self.cellImgNameArr = [NSMutableArray arrayWithObjects:@"hetong(5)",@"ic_qs_pw",@"yijianfankui",@"xinxi(1)", nil];
    self.cellTitleTextArr = [NSMutableArray arrayWithObjects:@"我的印章",@"意见反馈",@"关于电子签章", nil];
    self.cellImgNameArr = [NSMutableArray arrayWithObjects:@"hetong(5)",@"yijianfankui",@"xinxi(1)", nil];
    UserModel *userModel = [ShareUserInfo sharedUserInfo].userInfo;
    self.headerView.nameL.text = userModel.realName;
    if (userModel.avatarUrl.length > 0) {
        [self.headerView.headImgV sd_setImageWithURL:[UrlWithString getURLWithStr:userModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }else {
        self.headerView.headImgV.image = [UIImage imageNamed:@"My_headportrait"];
    }
    self.headerView.renZhengShowBtn.selected = YES;
}

// 签署密码是否存在数据
- (void)initIsSignPasswordData {
    [ZYElectronicSignatureModelData isSignPasswordCompletion:^(id  _Nullable responsObject, BOOL success) {
        if (success) {
            NSDictionary *dict = responsObject;
            BOOL status = [dict[@"status"] boolValue];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (status) {
                ZYElectronicSignPasswordChangedVc *vc = [[ZYElectronicSignPasswordChangedVc alloc] init];
                [self pushVc:vc];
                [userDefaults setValue:@"1" forKey:@"isSignPassword"];
            }else {
                ZYElectronicSignPasswordSettingVc *vc = [[ZYElectronicSignPasswordSettingVc alloc] init];
                [self pushVc:vc];
                [userDefaults setValue:@"" forKey:@"isSignPassword"];
            }
            [userDefaults synchronize];
        }
    }];
}

#pragma mark ==
- (void)backButtonClicked {
    [self popVC];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
//        case 0:
//        {
//            ZYZhangManagerVc *vc = [[ZYZhangManagerVc alloc] init];
//            [self pushVc:vc];
//        }
//            break;
//        case 1:
//        {
//            NSLog(@"签署密码");
//            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isSignPassword"] isEqual:@"1"]) {
//                ZYElectronicSignPasswordChangedVc *vc = [[ZYElectronicSignPasswordChangedVc alloc] init];
//                [self pushVc:vc];
//            }else {
//                [self initIsSignPasswordData];
//            }
//        }
//            break;
//        case 2:
//        {
//            ElectronicSignatureFeedBackVc *vc = [[ElectronicSignatureFeedBackVc alloc]init];
//            [self pushVc:vc];
//        }
//            break;
//        case 3:
//        {
//            ZYElectronicSignAboutVc *vc = [[ZYElectronicSignAboutVc alloc] init];
//            [self pushVc:vc];
//        }
//            break;
//        default:
//
//            break;
            
        case 0:
        {
            ZYZhangManagerVc *vc = [[ZYZhangManagerVc alloc] init];
            [self pushVc:vc];
        }
            break;
        case 1:
        {
            ElectronicSignatureFeedBackVc *vc = [[ElectronicSignatureFeedBackVc alloc]init];
            [self pushVc:vc];
        }
            break;
        case 2:
        {
            ZYElectronicSignAboutVc *vc = [[ZYElectronicSignAboutVc alloc] init];
            [self pushVc:vc];
        }
            break;
        default:

            break;
    }
}
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitleTextArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZYElectronicMyInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:electronicMyInfoListCellID forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    cell.iconImageView.image = [UIImage imageNamed:self.cellImgNameArr[indexPath.row]];
    cell.titleLabel.text = self.cellTitleTextArr[indexPath.row];
    cell.titleLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kElectronicMyInfoListCellHeight;
}

- (ElectronicMyInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ElectronicMyInfoHeaderView alloc]init];
    }
    return _headerView;
}
- (ZYMoulageHelperBarView *)barView {
    if (!_barView) {
        _barView = [[NSBundle mainBundle] loadNibNamed:@"ZYMoulageHelperBarView" owner:nil options:nil].lastObject;
        [_barView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _barView.titleLabel.hidden = YES;
        _barView.rightButton.hidden = YES;
    }
    
    return _barView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ZYElectronicMyInfoListCell" bundle:nil] forCellReuseIdentifier:electronicMyInfoListCellID];
    }
    return _tableView;
}
//
- (NSMutableArray *)cellTitleTextArr{
    if (!_cellTitleTextArr) {
        _cellTitleTextArr = [[NSMutableArray alloc]init];
    }
    return _cellTitleTextArr;
}
- (NSMutableArray *)cellImgNameArr{
    if (!_cellImgNameArr) {
        _cellImgNameArr = [[NSMutableArray alloc]init];
    }
    return _cellImgNameArr;
}
@end
