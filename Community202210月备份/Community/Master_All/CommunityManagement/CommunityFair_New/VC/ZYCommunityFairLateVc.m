//
//  ZYCommunityFairLateVc.m
//  Community
//
//  Created by ZY on 2022/6/6.
//

#import "ZYCommunityFairLateVc.h"
#import "ZYCommunityFairNextLateVc.h"
#import "ZYCommunityFairSearchRecordsVc.h"
#import "ZYCommunityFairLateTopView.h"
#import "NinaPagerView.h"
#import "ZYCommunityFairTypeModel.h"

#define kZYCommunityFairLateTopViewHeight 70+status_height+120.0/343*(kScreenW-32)

@interface ZYCommunityFairLateVc () <ZYCommunityFairLateTopViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) ZYCommunityFairLateTopView *topView;

// 分段选择控制视图
@property (nonatomic, strong) NinaPagerView *ninaPagerView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZYCommunityFairLateVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    [self hiddenNavigationBar];
    [self setUI];
    [self initData];
//    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
//    [self initMarketCategoryData];
    
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
    [self hiddenNavigationBar];
}

// 侧滑返回
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.2)) {
        [self popVC];
    }
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kZYCommunityFairLateTopViewHeight);
    }];
}

#pragma mark - 懒加载
- (ZYCommunityFairLateTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairLateTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
    }
    
    return _topView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    NSArray *titlesArray = @[@"看推荐", @"逛附件", @"苹果", @"摄影器材", @"移动电源"];
    NSMutableArray *vcsArray = [NSMutableArray array];
    for (int i = 0; i < titlesArray.count; i++) {
        ZYCommunityFairNextLateVc *communityFairNextLateVc = [[ZYCommunityFairNextLateVc alloc] init];
        [vcsArray addObject:communityFairNextLateVc];
    }
    CGRect rect = CGRectMake(0, kZYCommunityFairLateTopViewHeight, kScreenW, kScreenH - kZYCommunityFairLateTopViewHeight);
    self.ninaPagerView = [[NinaPagerView alloc] initWithFrame:rect WithTitles:titlesArray WithObjects:vcsArray];
    self.ninaPagerView.backgroundColor = [UIColor clearColor];
    self.ninaPagerView.ninaPagerStyles = NinaPagerStyleBottomLine;
    self.ninaPagerView.topTabBackGroundColor = [UIColor clearColor];
    self.ninaPagerView.selectTitleColor = [ZYThemeManager shareManager].titleThemeColor;
    self.ninaPagerView.unSelectTitleColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    self.ninaPagerView.underlineColor = [UIColor zy_colorWithHexString:@"#2672F9"];
    self.ninaPagerView.titleScale = 1.05;
    self.ninaPagerView.selectBottomLinePer = 0.5;
    self.ninaPagerView.loadWholePages = NO;
    self.ninaPagerView.underLineHidden = YES;
    [self.view addSubview:self.ninaPagerView];
}

// 加载商品分类数据
- (void)initMarketCategoryData {
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kCommunityFairCategoryUrl] withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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
        [titlesArray addObject:tempModel.categoryName];
        ZYCommunityFairNextLateVc *communityFairNextLateVc = [[ZYCommunityFairNextLateVc alloc] init];
        communityFairNextLateVc.categoryId = tempModel.ID;
        [vcsArray addObject:communityFairNextLateVc];
    }
    CGRect rect = CGRectMake(0, kZYCommunityFairLateTopViewHeight, kScreenW, kScreenH - kZYCommunityFairLateTopViewHeight);
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
        make.left.right.bottom.equalTo(_ninaPagerView.superview);
        make.top.equalTo(_topView.mas_bottom);
    }];
}

#pragma mark - ZYCommunityFairLateTopViewDelegate
- (void)backButtonEvent {
    [self popVC];
}

- (void)searchViewEvent {
    NSLog(@"搜索");
    ZYCommunityFairSearchRecordsVc *vc = [[ZYCommunityFairSearchRecordsVc alloc] init];
    [self pushVc:vc];
}

- (void)chatButtonEvent {
    NSLog(@"消息");
}

@end
