//
//  ElectronicSignatureVC.m
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#import "ElectronicSignatureVC.h"
#import "ElectronicSignatureTipComplianceVC.h"
#import "ElectronicSignatureTipBlockChainVC.h"
#import "ElectronicMyInfoListVc.h"
#import "ZYContrectManageVC.h"
#import "HelpAndFeedbackVC.h"
#import "DigitalCerVc.h"
#import "ZYDigitalCerDetailVC.h"
#import "ContrectAllListVC.h"
#import "ElectronicNewsDetailShowVc.h"
#import "ZYAlreadyElectronicRealNameAuthenticationVc.h"
#import "ZYMoulageHelperVc.h"
#import "ContrectLocallySigningVC.h"
#import "ZYContractKnowledgeListModel.h"

#import "ElectronicSigbatureTextAndRightBtnTableViewCell.h"
#define  ElectronicSigbatureTextAndRightBtnTableViewCell_Identifier     @"ElectronicSigbatureTextAndRightBtnTableViewCell"
#import "ElectronicSignatureWaitingForSignatureTableViewCell.h"
#define  ElectronicSignatureWaitingForSignatureTableViewCell_Identifier @"ElectronicSignatureTopMainTableViewCell"
#import "ElectronicSignatureNomalInfoItemsTableViewCell.h"
#define  ElectronicSignatureNomalInfoItemsTableViewCell_Identifier      @"ElectronicSignatureNomalInfoItemsTableViewCell"
//s1
#import "ElectronicSignatureCenterAdTableViewCell.h"
#define  ElectronicSignatureCenterAdTableViewCell_Identifier            @"ElectronicSignatureCenterAdTableViewCell"
//s2
#import "ElectronicSigbatureTextLabelTableViewCell.h"
#define  ElectronicSigbatureTextLabelTableViewCell_Identifier            @"ElectronicSigbatureTextLabelTableViewCell"
//s3
#import "ElectronicSignatureNewsTableViewCell.h"
#define  ElectronicSignatureNewsTableViewCell_Identifier            @"ElectronicSignatureNewsTableViewCell"


#define Height_TextCell  40
#define RowNum_TextCell  0

#define Height_WaitingSignature  (kScreenW - 60 - 32) / 3 * (112.0 / 94.0) + 20
#define RowNum_WaitingSignature  1

#define Height_NomalInfoItemsCell  110
#define RowNum_NomalInfoItemsCell  2
//
#define Height_AdCell  95
#define RowNum_AdCell  0
//
#define Height_NewsCell  85

#define ElectronicSignatureSectionHeaderViewWithTextLabelColor Y_RGBA(60, 73, 111, 1)


@interface ElectronicSignatureVC () <UITableViewDelegate,UITableViewDataSource,ElectronicSignatureHeaderSearchViewDelegate,ElectronicSignatureWaitingForSignatureTableViewCellDelegate,ElectronicSignatureNomalInfoItemsTableViewCellDelegate>

// 待签合同数
@property (nonatomic, copy) NSString *signContractCount;

// 合同知识数组
@property (nonatomic, strong) NSMutableArray *contractKnowledgeArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) MJRefreshNormalHeader *header;

@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation ElectronicSignatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.headerView.delegate = self;
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initSignContractData];
        [weakSelf initContractKnowledgeListData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initContractKnowledgeListData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        self.header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        self.footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = self.header;
    self.tableView.mj_footer = self.footer;
    
    self.currentPage = 1;
    [self initContractKnowledgeListData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        self.header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        self.footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }else {
        self.header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    
    // 实名查询
    [ZYRealNameAuthenticationTool realNameqQeryAuthentication];
    
    // 加载待签合同数据
    [self initSignContractData];
}

#pragma mark - 懒加载
- (NSMutableArray *)contractKnowledgeArray {
    if (!_contractKnowledgeArray) {
        _contractKnowledgeArray = [NSMutableArray array];
    }
    
    return _contractKnowledgeArray;
}

#pragma mark - 加载数据
// 待签合同数据
- (void)initSignContractData {
    
    NSDictionary *parms = @{@"pageNum" : @(0), @"pageSize" : @(0), @"userId" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kAllContractsAwaitingAttentionUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                ZYContractKnowledgeListDataModel *model = [ZYContractKnowledgeListDataModel yy_modelWithJSON:jsonStr];
                self.signContractCount = [NSString stringWithFormat:@"%ld", model.total];
                [self.tableView reloadData];
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 合同知识列表数据
- (void)initContractKnowledgeListData {
    
    NSDictionary *parms = @{@"pageNum" : @(self.currentPage), @"pageSize" : @(10)};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestGetURL:kContractKnowledgeListUrl withParams:parms.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 移除所有数据
                if (self.currentPage == 1) {
                    [self.contractKnowledgeArray removeAllObjects];
                }
                ZYContractKnowledgeListModel *model = [ZYContractKnowledgeListModel yy_modelWithJSON:responsObject];
                ZYContractKnowledgeListDataModel *dataModel = model.data;
                NSArray *array = dataModel.list;
                [self.contractKnowledgeArray addObjectsFromArray:array];
                // 判断数据是否加载完了
                if (self.contractKnowledgeArray.count >= dataModel.total) {
                    if (dataModel.total > 10) {
                        // 表示没有数据可以请求，设置UITableView footer的状态
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        self.tableView.mj_footer.hidden = YES;
                    }
                }else {
                    // 重置提示加载更多数据
                    [self.tableView.mj_footer resetNoMoreData];
                }
                // 刷新tableView
                [self.tableView reloadData];
            }else {
                if (self.currentPage > 1) {
                    self.currentPage -= 1;
                }
                if (self.currentPage == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            if (self.currentPage > 1) {
                self.currentPage -= 1;
            }
            if (self.currentPage == 1) {
                self.tableView.mj_footer.hidden = YES;
            }
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark ==
- (void)touchSacnBtnAction{
    DLog(@"扫码");
    
//    __weak typeof(self) weakSelf = self;
    ScanQRViewController *vc = [[ScanHelper shareInstance] ScanVCWithStyle:qqStyle qrResultCallBack:^(id result) {

        NSLog(@"result=%@", result);
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchUpItemWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            DLog(@"实名认证");
            if (ZY_IsRealName) {
                ZYAlreadyElectronicRealNameAuthenticationVc *vc = [[ZYAlreadyElectronicRealNameAuthenticationVc alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else {
                ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
        }
            break;
        case 1:
        {
            DLog(@"合同合规");
            ElectronicSignatureTipComplianceVC *vc = [[ElectronicSignatureTipComplianceVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
            
          
            break;
        case 2:
        {
            DLog(@"区块链存在");
            ElectronicSignatureTipBlockChainVC *vc = [[ElectronicSignatureTipBlockChainVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark ==
- (void)waitingForSignatureCellTouchUpItemWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
            DLog(@"合同管理");
        {
            if (ZY_IsRealName) {
                ZYContrectManageVC *vc = [[ZYContrectManageVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else {
                ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
        }
        
            break;
        case 1:
            DLog(@"在线签约");
        {
            
            if (ZY_IsRealName) {
                ZYMoulageHelperVc  *vc = [[ZYMoulageHelperVc alloc]init];
                vc.type = @"在线签约";
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else {
                ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
        }
            
            break;
        case 2:
            DLog(@"草稿箱");
        {
            if (ZY_IsRealName) {
                ContrectLocallySigningVC *vc = [[ContrectLocallySigningVC alloc] init];
                vc.type = @"在线签约";
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else {
                ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)nomalInfoItemsCellTouchUpItemWithIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            DLog(@"我的资料");isIphoneX;
            if (ZY_IsRealName) {
                ElectronicMyInfoListVc *vc = [[ElectronicMyInfoListVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else {
                ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
        }
            break;
        case 1:
        {
            NSLog(@"即将截止");
            if (ZY_IsRealName) {
                ContrectAllListVC *vc = [[ContrectAllListVC alloc]init];
                vc.listVcType = ContrectList_Type_Expire;
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else {
                ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
        }
            break;
        case 2:
        {
            DLog(@"合同模板");
            if (ZY_IsRealName) {
                ZYMoulageHelperVc  *vc = [[ZYMoulageHelperVc alloc]init];
                vc.type = @"合同模板";
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else {
                ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
        }
            break;
        case 3:
          
        {
            DLog(@"帮助");
            HelpAndFeedbackVC *vc = [[HelpAndFeedbackVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case RowNum_TextCell:
                NSLog(@"待签合同");
            {
                if (ZY_IsRealName) {
                    ContrectAllListVC *vc = [[ContrectAllListVC alloc]init];
                    vc.listVcType = ContrectList_Type_MyWait;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self pushVc:vc];
                }else {
                    ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self pushVc:vc];
                }
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1) {
        NSLog(@"便捷高效管理");
    }else if (indexPath.section == 2) {
        NSLog(@"合同知识");
        ElectronicNewsListVc *vc = [[ElectronicNewsListVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
    else{
        NSLog(@"news %ld",(long)indexPath.row);
        {
            DLog(@"合同知识详情");
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            ZYContractKnowledgeListDataListModel *model = self.contractKnowledgeArray[indexPath.row];
            ElectronicNewsDetailShowVc *detaiVc = [[ElectronicNewsDetailShowVc alloc]init];
            detaiVc.hidesBottomBarWhenPushed = YES;
            detaiVc.detailModel = model;
            [self pushVc:detaiVc];
        }
    }
}
#pragma mark ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if(section == 1){ 
        return 1;
    }else if (section == 2) {
        return 1;
    }else{
        return self.contractKnowledgeArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case RowNum_TextCell:
                return Height_TextCell;
                break;
            case RowNum_WaitingSignature:
                return Height_WaitingSignature;
                break;
            case RowNum_NomalInfoItemsCell:
                return Height_NomalInfoItemsCell;
                break;
            default:
                return Height_TextCell;
                break;
        }
    }else if(indexPath.section == 1){
        return Height_AdCell;
    }else if (indexPath.section == 2) {
        return Height_TextCell;
    }else{//s2
        return Height_NewsCell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = NO;
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 3) {
        return 25;
    }else {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case RowNum_TextCell:
            {
                ElectronicSigbatureTextAndRightBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSigbatureTextAndRightBtnTableViewCell_Identifier];
                if (!cell) {
                    cell = [[ElectronicSigbatureTextAndRightBtnTableViewCell alloc]init];
                }
                if (self.signContractCount.length > 0) {
                    cell.detailLabel.text = self.signContractCount;
                }else {
                    cell.detailLabel.text = @"--";
                }
                
                return cell;
            }
                break;
            case RowNum_WaitingSignature:
            {  ElectronicSignatureWaitingForSignatureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSignatureWaitingForSignatureTableViewCell_Identifier];
                if (!cell) {
                    cell = [[ElectronicSignatureWaitingForSignatureTableViewCell alloc]init];
                }
               [cell showCellWithData];
                cell.delegate = self;
                return cell;
            }
                break;
                
            default: //RowNum_NomalInfoItemsCell
            {
                ElectronicSignatureNomalInfoItemsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSignatureNomalInfoItemsTableViewCell_Identifier];
                if (!cell) {
                    cell = [[ElectronicSignatureNomalInfoItemsTableViewCell alloc]init];
                }
                [cell showInfoItemsCellWithData];
                cell.delegate = self;
                return cell;
            };
                break;
        }
    }else if(indexPath.section == 1){
        ElectronicSignatureCenterAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSignatureCenterAdTableViewCell_Identifier];
        if (!cell) {
            cell = [[ElectronicSignatureCenterAdTableViewCell alloc]init];
        }
        return cell;
    }else if (indexPath.section == 2) {
        ElectronicSigbatureTextLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSigbatureTextLabelTableViewCell_Identifier];
        if (!cell) {
            cell = [[ElectronicSigbatureTextLabelTableViewCell alloc] init];
        }
        return cell;
    }else{
        ElectronicSignatureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSignatureNewsTableViewCell_Identifier];
        if (!cell) {
            cell = [[ElectronicSignatureNewsTableViewCell alloc]init];
        }
        ZYContractKnowledgeListDataListModel *model = self.contractKnowledgeArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
    
}
 
@end
