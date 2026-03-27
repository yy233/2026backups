//
//  ZYCommunityFairVC.m
//  Community
//
//  Created by ZY on 2021/8/5.
//

#import "ZYCommunityFairVC.h"
#import "ZYCommunityFairNextVC.h"
#import "ZYCommunityFairMyIssueVC.h"
#import "ZYCommunityFairEditVC.h"
#import "NinaPagerView.h"
#import "ZYCommunityFairTypeModel.h"
#import "ZYCommunityFairBottomView.h"

@interface ZYCommunityFairVC ()

// 分段选择控制视图
@property (nonatomic, strong) NinaPagerView *ninaPagerView;

@property (nonatomic, strong) ZYCommunityFairBottomView *communityFairBottomView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYCommunityFairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"社区集市";
    [self rightBarButtonItemCustom];
    [self setUI];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initMarketCategoryData];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"ZY_CUSTOM_POP_BACK", customPopBack);
}

// 通知回调
- (void)customPopBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self popVC];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"ZY_CUSTOM_POP_BACK")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    
    [self.view addSubview:self.communityFairBottomView];
    [_communityFairBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_communityFairBottomView.superview);
        make.height.offset(50 + button_bottom_height);
    }];
}

// 定制右barButtonItem
- (void)rightBarButtonItemCustom {

    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [navRightBtn setTitle:@"我的发布" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:[ZYThemeManager shareManager].navigationItemThemeColor forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [navRightBtn addTarget:self action:@selector(navRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem animated:YES];
}

#pragma mark - 懒加载
- (ZYCommunityFairBottomView *)communityFairBottomView {
    if (!_communityFairBottomView) {
        _communityFairBottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairBottomView" owner:nil options:nil].lastObject;
        [_communityFairBottomView.releaseButton addTarget:self action:@selector(releaseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _communityFairBottomView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
// 加载商品类别数据
- (void)initMarketCategoryData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kEditSelectMarketCategoryUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYCommunityFairTypeModel *model = [ZYCommunityFairTypeModel yy_modelWithJSON:responsObject];
                [self.dataArray addObjectsFromArray:model.data];
                if (self.dataArray.count > 0) {
                    [self createNinaPagerView];
                }
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - createNinaPagerView
- (void)createNinaPagerView {
    
    NSMutableArray *titlesArray = [NSMutableArray array];
    NSMutableArray *vcsArray = [NSMutableArray array];
    for (ZYCommunityFairTypeDataModel *tempModel in self.dataArray) {
        [titlesArray addObject:tempModel.category];
        ZYCommunityFairNextVC *communityFairNextVC = [[ZYCommunityFairNextVC alloc] init];
        communityFairNextVC.categoryId = tempModel.categoryId;
        [vcsArray addObject:communityFairNextVC];
    }
    CGRect rect = CGRectMake(0, 0, kScreenW, kScreenH - status_height - 44 - 50 - button_bottom_height);
    self.ninaPagerView = [[NinaPagerView alloc] initWithFrame:rect WithTitles:titlesArray WithObjects:vcsArray];
    self.ninaPagerView.backgroundColor = [UIColor clearColor];
    self.ninaPagerView.ninaPagerStyles = NinaPagerStyleBottomLine;
    self.ninaPagerView.topTabBackGroundColor = [ZYThemeManager shareManager].navigationBarBackgroundThemeColor;
    self.ninaPagerView.selectTitleColor = [ZYThemeManager shareManager].titleThemeColor;
    self.ninaPagerView.unSelectTitleColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.ninaPagerView.underlineColor = [UIColor zy_colorWithHexString:@"#2672F9"];
    self.ninaPagerView.titleScale = 1.05;
    self.ninaPagerView.selectBottomLinePer = 0.5;
    self.ninaPagerView.loadWholePages = NO;
    self.ninaPagerView.underLineHidden = YES;
    [self.view addSubview:self.ninaPagerView];
    [_ninaPagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_ninaPagerView.superview);
        make.bottom.equalTo(_communityFairBottomView.mas_top);
    }];
}

#pragma mark - 点击事件
// 我的发布
- (void)navRightBtnAction {
    
    NSLog(@"我的发布");
    ZYCommunityFairMyIssueVC *vc = [[ZYCommunityFairMyIssueVC alloc] init];
    [self pushVc:vc];
}

// 我要发布
- (void)releaseButtonClicked {
    
    NSLog(@"我要发布");
    ZYCommunityFairEditVC *vc = [[ZYCommunityFairEditVC alloc] init];
    vc.typeStr = @"发布";
    vc.listModel = [[ZYCommunityFairListDataListModel alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
