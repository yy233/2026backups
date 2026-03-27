//
//  ZYCommunityFairDetailVC.m
//  Community
//
//  Created by ZY on 2021/8/6.
//

#import "ZYCommunityFairDetailVC.h"
#import "ZYCommunityFairDetailCarouselCell.h"
#import "ZYCommunityFairDetailContentCell.h"
#import "ZYCommunityFairDetailUserInfoCell.h"
#import "ZYCommunityFairDetailIllustrateCell.h"
#import "ZYCommunityFairBottomView.h"

static NSString * const communityFairDetailCarouselCellID = @"ZYCommunityFairDetailCarouselCell";
static NSString * const communityFairDetailContentCellID = @"ZYCommunityFairDetailContentCell";
static NSString * const communityFairDetailUserInfoCellID = @"ZYCommunityFairDetailUserInfoCell";
static NSString * const communityFairDetailIllustrateCellID = @"ZYCommunityFairDetailIllustrateCell";

#define kCommunityFairDetailCarouselCellHeight 200.0/375.0*kScreenW
#define kCommunityFairDetailUserInfoCellHeight 106

@interface ZYCommunityFairDetailVC () <UITableViewDataSource, UITableViewDelegate, ZYCommunityFairDetailCarouselCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYCommunityFairBottomView *communityFairBottomView;

@property (nonatomic, strong) GKPhotoBrowser *photoBrowser;

@property (nonatomic, strong) ZYCommunityFairDetailDataModel *detailModel;

@end

@implementation ZYCommunityFairDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initMarketDetailData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithThemeColor];
}

- (void)setUI {
    
    [self.view addSubview:self.communityFairBottomView];
    [_communityFairBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_communityFairBottomView.superview);
        make.height.offset(50 + button_bottom_height);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_communityFairBottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYCommunityFairBottomView *)communityFairBottomView {
    if (!_communityFairBottomView) {
        _communityFairBottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairBottomView" owner:nil options:nil].lastObject;
        _communityFairBottomView.hidden = YES;
        [_communityFairBottomView.releaseButton setTitle:@"打电话" forState:UIControlStateNormal];
        [_communityFairBottomView.releaseButton addTarget:self action:@selector(releaseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _communityFairBottomView;
}

#pragma mark - 加载数据
// 加载商品详情数据
- (void)initMarketDetailData {
    NSDictionary *params = @{@"id" : self.ID};
    [[ToolOfNetWork sharedTools] YrequestGetALLURL:[NSString stringWithFormat:@"%@%@", BASE_URL, kSelectOneMarketUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                ZYCommunityFairDetailModel *model = [ZYCommunityFairDetailModel yy_modelWithJSON:responsObject];
                self.detailModel = model.data;
                [self setUI];
                [self customTableView];
                self.communityFairBottomView.hidden = NO;
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYCommunityFairDetailCarouselCell" bundle:nil] forCellReuseIdentifier:communityFairDetailCarouselCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYCommunityFairDetailContentCell" bundle:nil] forCellReuseIdentifier:communityFairDetailContentCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYCommunityFairDetailUserInfoCell" bundle:nil] forCellReuseIdentifier:communityFairDetailUserInfoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYCommunityFairDetailIllustrateCell" bundle:nil] forCellReuseIdentifier:communityFairDetailIllustrateCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ZYCommunityFairDetailCarouselCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairDetailCarouselCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.detailModel;
        
        return cell;
    }else if (indexPath.row == 1) {
        ZYCommunityFairDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairDetailContentCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.row == 2) {
        ZYCommunityFairDetailUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairDetailUserInfoCellID forIndexPath:indexPath];
        cell.model = self.detailModel;
        
        return cell;
    }else {
        ZYCommunityFairDetailIllustrateCell *cell = [tableView dequeueReusableCellWithIdentifier:communityFairDetailIllustrateCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}

// 配置cell数据
- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        ZYCommunityFairDetailContentCell *cell = (ZYCommunityFairDetailContentCell *)currentCell;
        cell.model = self.detailModel;
    }else if (indexPath.row == 3) {
        ZYCommunityFairDetailIllustrateCell *cell = (ZYCommunityFairDetailIllustrateCell *)currentCell;
        cell.model = self.detailModel;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return kCommunityFairDetailCarouselCellHeight;
    }else if (indexPath.row == 1) {
        
        return [tableView fd_heightForCellWithIdentifier:communityFairDetailContentCellID cacheByIndexPath:indexPath configuration:^(ZYCommunityFairDetailContentCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.row == 2) {
        
        return kCommunityFairDetailUserInfoCellHeight;
    }else {
        
        return [tableView fd_heightForCellWithIdentifier:communityFairDetailIllustrateCellID cacheByIndexPath:indexPath configuration:^(ZYCommunityFairDetailIllustrateCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
}

#pragma mark - ZYCommunityFairDetailCarouselCellDelegate
- (void)cycleScrollViewSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"点击图片 %ld", index);
    NSMutableArray *imagesArray = [NSMutableArray array];
    NSArray *array = [self.detailModel.images componentsSeparatedByString:@","];
    for (NSString *str in array) {
        if (str.length > 0) {
            [imagesArray addObject:str];
        }
    }
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < imagesArray.count; i++) {
        GKPhoto *photoModel = [[GKPhoto alloc] init];
        photoModel.url = [NSURL URLWithString:imagesArray[i]];
        photoModel.originUrl = [NSURL URLWithString:imagesArray[i]];
        [photos addObject:photoModel];
    }
    self.photoBrowser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    self.photoBrowser.showStyle = GKPhotoBrowserShowStyleNone;
    [self.photoBrowser showFromVC:self];
}

#pragma mark - 点击事件
// 打电话
- (void)releaseButtonClicked {
    
    NSLog(@"打电话");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        //设备系统为IOS 10.0或者以上的
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.detailModel.phone]] options:@{} completionHandler:nil];
    }else{
        //设备系统为IOS 10.0以下的
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.detailModel.phone]]];
    }
}

@end
