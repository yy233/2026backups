//
//  LdleGoodDetailVC.m
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "LdleGoodDetailVC.h"
#import "LdleGoodDetailHeaderView.h"
#import "LdleGoodDetailVcTableViewCell.h"
#import "JuBaoReasonPopView.h"

#import "LdleGoodsData.h"

#define RowNum_UserInfo     (0)
#define RowNum_TitleInfo    (1)
#define RowNum_Mp4Info      (2)
#define RowNum_ContentText  (3)


@interface LdleGoodDetailVC () <UITableViewDelegate,UITableViewDataSource,BasePopTableViewChooseDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *bottomBtn;
@property (nonatomic,strong) LdleGoodDetailHeaderView *headerView;
@property (nonatomic,strong) JuBaoReasonPopView *juBaoReasonPopView;
@property (nonatomic,assign) BOOL isHaveMp4Bool;
@property (nonatomic,strong) LdleGoodsModel *detailLdleGoodsModel;

@end

@implementation LdleGoodDetailVC
- (LdleGoodsModel *)detailLdleGoodsModel{
    if (!_detailLdleGoodsModel) {
        _detailLdleGoodsModel = [[LdleGoodsModel alloc]init];
    }
    return _detailLdleGoodsModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self changeNavBackColorWithDIsCountBlueAndWW];
    [self initView];
    [self initData];
}
- (void)initView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomBtn.superview);
        make.height.offset(54.0);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 54)];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView.forwardingBtn addTarget:self action:@selector(forwardingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark ===
- (void)initData{
    WEAKSELF
    if (self.idStr.length == 0 && isNotNil(self.yuLanInfoModel)) {
        self.detailLdleGoodsModel = self.yuLanInfoModel;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ((self.detailLdleGoodsModel.mvUrl.length>0) && ( isNotNil(self.detailLdleGoodsModel) )) {//非空 有长度 则存在视频
                self.isHaveMp4Bool = YES;
            }else{
                self.isHaveMp4Bool = NO;
            }
            [self.headerView fillDetailInfoWithModel:self.detailLdleGoodsModel];
            [self.tableView reloadData];
        });
    }else{
        [LdleGoodsData getLdleOneGoodsDetailInfoWithIdStr:self.idStr withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
            if (success) {
                weakSelf.detailLdleGoodsModel = [LdleGoodsModel mj_objectWithKeyValues:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ((weakSelf.detailLdleGoodsModel.mvUrl.length>0) && ( isNotNil(weakSelf.detailLdleGoodsModel) )) {//非空 有长度 则存在视频
                        weakSelf.isHaveMp4Bool = YES;
                    }else{
                        weakSelf.isHaveMp4Bool = NO;
                    }
                    [weakSelf.headerView fillDetailInfoWithModel:weakSelf.detailLdleGoodsModel];
                    [weakSelf.tableView reloadData];
                });

            }
        }];
    }
    
}


#pragma mark === 转发
- (void)forwardingBtnAction{
    DLog(@"转发");
}

#pragma mark === 举报
- (void)juBaoBtnAction{
    DLog(@"举报");
    //popView show
     [self.juBaoReasonPopView showInView:self.view thePopViewTableViewHeight:0 WithArray:@[@0,@1].mutableCopy];
}
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    DLog(@"举报 ReasonPopView  touchcell row == %ld",indexPath.row);
    NSString *reasonStr = @"";
    if (indexPath.row == 0) {
        reasonStr = @"违禁商品";
    }else{
        reasonStr = @"滥发消息";
    }

    [[AlertManager shareManager] creatAlertWithTitle:[NSString stringWithFormat:@"确认举报该商品属于“%@”吗？",reasonStr]
                                             message:@""
                                      preferredStyle:UIAlertControllerStyleAlert
                                  beignIsCancelTitle:@"我再想想"
                        otherTitleArrOfAllIsRedColor:@[@"确认举报"].mutableCopy];
    WEAKSELF
    [[AlertManager shareManager] showWithViewController:self IndexBlock:^(NSInteger index) {
        if (index==AlertManagerCancelIndex) {
        }else{
            [weakSelf juBaoYesUpDataWithIndex:indexPath.row];
        }
    }];
}
- (void)juBaoYesUpDataWithIndex:(NSInteger)index{
    NSString *reasonStr = @"";
    if (index == 0) {
        reasonStr = @"违禁商品";
    }else{
        reasonStr = @"滥发消息";
    }

    DLog(@"举报 提交 type index == %ld %@",index,reasonStr)
    [LdleGoodsData juBaoThisLdleGoodsWithIdStr:self.detailLdleGoodsModel.idStr withWeiGuiType:index withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"举报成功！");
            });
        }
    }];
  
}
#pragma mark === 播放 停止

- (void)mp4Begin{
    NSLog(@"播放 mp4Begin");
}
- (void)mp4Stop{
    NSLog(@"停止 mp4Stop");
}


#pragma mark ==

- (void)bottomBtnAction{
    NSLog(@"想要按钮 -- 去聊天界面");
    //暂时无imid
//    WEAKSELF
//    [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:0 withImIdStr:self.detailLdleGoodsModel.userId withThisStrangerChatType:ChatVc_Stranger_Chat_Application_customerSevice withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
//        if (success) {
//            [weakSelf pushVc:willPushVc];
//        }
//    }];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    NSArray *imgArr = [[TextShowWithModelStr textShowWithModelStr:self.detailLdleGoodsModel.imagesUrl] componentsSeparatedByString:@","];
    if ([imgArr.firstObject isEqualToString:@""]) {
        return 4;
    }else{
        return imgArr.count +4;//基础总数4固定
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == RowNum_UserInfo) {
        LdleGoodDetailVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodDetailVcTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodDetailVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodDetailVcTableViewCell_I];
        }
     
        [cell fillDetailInfoWithModel:self.detailLdleGoodsModel];
        WEAKSELF
        cell.touchJuBaoBtnBlock = ^{
            DLog(@"举报");
            [weakSelf juBaoBtnAction];
        };
        return cell;
    }else if (indexPath.row == RowNum_TitleInfo){
        LdleGoodDetailVcTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodDetailVcTitleTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodDetailVcTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodDetailVcTitleTableViewCell_I];
        }
        return cell;
    }else if (indexPath.row == RowNum_Mp4Info){//视频数据
        LdleGoodDetailVcMp4TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodDetailVcMp4TableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodDetailVcMp4TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodDetailVcMp4TableViewCell_I];
        }
        [cell fillDetailInfoWithModel:self.detailLdleGoodsModel];
        [cell fillIsHaveMp4Bool:self.isHaveMp4Bool];
        WEAKSELF
        cell.touchMp4CenterIsOpenTypeBlock = ^(BOOL isOpenMp4) {
            if (isOpenMp4 == YES) {//播放
                [weakSelf mp4Begin];
            }else{//停止
                [weakSelf mp4Stop];
            }
        };
        return cell;
        
    }else if (indexPath.row == RowNum_ContentText){
        LdleGoodDetailVcContentTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodDetailVcContentTextTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodDetailVcContentTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodDetailVcContentTextTableViewCell_I];
        }
        [cell fillDetailInfoWithModel:self.detailLdleGoodsModel];
        return cell;
    }else{
        //图片
        LdleGoodDetailVcImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LdleGoodDetailVcImgTableViewCell_I];
        if (!cell) {
            cell = [[LdleGoodDetailVcImgTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LdleGoodDetailVcImgTableViewCell_I];
        }
        NSArray *imgArr = [[TextShowWithModelStr textShowWithModelStr:self.detailLdleGoodsModel.imagesUrl] componentsSeparatedByString:@","];
        NSInteger useIndex = indexPath.row - 4;//img之前有4个固定cell
        [cell fillDetailInfoWithImgStr:imgArr[useIndex]];
        return cell;
    }
 
 
}
 
#pragma mark ===

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
    }
    return _tableView;
}

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn newAnBtnWithTextStr:@"想要"];
        [_bottomBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_bottomBtn newAnBtnWithFont: [UIFont systemFontOfSize:15]];
        [_bottomBtn newAnBtnWithImg:[UIImage imageNamed:@"xixin_icon"]];
        [_bottomBtn newAnBtnWithBackColor: Y_ColorWith16FromRGB(0xFF3A3A)];
        [_bottomBtn addTarget:self action:@selector(bottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}
- (LdleGoodDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[LdleGoodDetailHeaderView alloc]initWithFrame:CGRectZero];
    }
    return _headerView;
}
- (JuBaoReasonPopView *)juBaoReasonPopView{
    _juBaoReasonPopView = [[JuBaoReasonPopView alloc]init];
    _juBaoReasonPopView.delegate = self;
    return _juBaoReasonPopView;
}
@end
