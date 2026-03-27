//
//  ElectronicNewsDetailShowVc.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "ElectronicNewsDetailShowVc.h"
#import "ZYElectronicNewsDetailShowCell.h"
#import "ZYElectronicNewsDetailShowFooterView.h"
#import "ZYElectronicNewsCommentsListVc.h"

static NSString * const electronicNewsDetailShowCellID = @"ZYElectronicNewsDetailShowCell";

@interface ElectronicNewsDetailShowVc () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYElectronicNewsDetailShowFooterView *footerView;

// 是否收藏
@property (nonatomic, assign) BOOL isCollection;

// 是否点赞
@property (nonatomic, assign) BOOL isLike;

// 点赞数
@property (nonatomic, assign) NSInteger likeNum;

@end

@implementation ElectronicNewsDetailShowVc

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.detailModel.title;
    self.isCollection = NO;
    self.isLike = NO;
    [self viewsConstraintSetting];
    self.footerView.likeCountLabel.text = [NSString stringWithFormat:@"%ld", self.detailModel.likeNumber];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initLikeNumData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.footerView.commentsCountLabel.text = [NSString stringWithFormat:@"%ld", self.detailModel.commentNumber];
    
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 430;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        // 注册单元格
        [_tableView registerNib:[UINib nibWithNibName:@"ZYElectronicNewsDetailShowCell" bundle:nil] forCellReuseIdentifier:electronicNewsDetailShowCellID];
    }
    
    return _tableView;
}

- (ZYElectronicNewsDetailShowFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"ZYElectronicNewsDetailShowFooterView" owner:nil options:nil].lastObject;
        [_footerView.collectionButton addTarget:self action:@selector(collectionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.commentsButton addTarget:self action:@selector(commentsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _footerView;
}

#pragma mark - 加载数据
// 收藏数据
- (void)initCollectionData {
    NSDictionary *params = [NSDictionary dictionary];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractKnowledgeCollectionUrl withBody:params finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 点赞数据
- (void)initLikeData {
    NSDictionary *params = @{@"informationUuid" : self.detailModel.uuid, @"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractKnowledgeLikeUrl withBody:params finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                [self initLikeNumData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 点赞数数据
- (void)initLikeNumData {
    NSDictionary *params = @{@"informationUuid" : self.detailModel.uuid, @"userUuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestGetURL:kContractKnowledgeSelectLikeUrl withParams:params.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.isLike = [responsObject[@"data"][@"liked"] boolValue];
                self.likeNum = [responsObject[@"data"][@"number"] integerValue];
                self.footerView.likeButton.selected = self.isLike;
                self.footerView.likeCountLabel.text = [NSString stringWithFormat:@"%ld", self.likeNum];
                [self.view reloadInputViews];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 视图约束设置
- (void)viewsConstraintSetting {
    
    [self.view addSubview:self.footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.bottom.equalTo(_footerView.superview);
        make.height.offset(49 + bottom_height);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_tableView.superview);
        make.bottom.equalTo(_footerView.mas_top);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYElectronicNewsDetailShowCell *cell = [tableView dequeueReusableCellWithIdentifier:electronicNewsDetailShowCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.detailModel;
    
    return cell;
}

#pragma mark - 处理点击事件
- (void)collectionButtonClicked {
    DLog(@"点击收藏");
    
    if (!self.isCollection) {
        self.isCollection = YES;
        self.footerView.collectionButton.selected = YES;
    }else {
        self.isCollection = NO;
        self.footerView.collectionButton.selected = NO;
    }
}

- (void)commentsButtonClicked {
    DLog(@"点击评论");
    
    ZYElectronicNewsCommentsListVc *commentsListVc = [[ZYElectronicNewsCommentsListVc alloc] init];
    commentsListVc.detailModel = self.detailModel;
    [self pushVc:commentsListVc];
}

- (void)likeButtonClicked {
    DLog(@"点赞");
    
    NSString *msg = [NSString string];
    if (self.isLike) {
        msg = @"取消中...";
    }else {
        msg = @"点赞中...";
    }
    [SVProgressHUD showLoadingMaskTypeCustomHUDWithStatus:msg];
    [self initLikeData];
}

@end
