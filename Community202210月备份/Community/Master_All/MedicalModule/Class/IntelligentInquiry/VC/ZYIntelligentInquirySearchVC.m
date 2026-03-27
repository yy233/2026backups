//
//  ZYIntelligentInquirySearchVC.m
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import "ZYIntelligentInquirySearchVC.h"
#import "MedicalWebViewVc.h"
#import "ZYIntelligentInquirySearchView.h"
#import "ZYIntelligentInquirySearchTitleView.h"
#import "ZYIntelligentInquirySearchBottomView.h"
#import "ZYIntelligentInquirySearchExpertCell.h"
#import "ZYMedicalMainNearServiceCell.h"
#import "ZYRecordAnimationPopView.h"

#import "IntelligentInquirySearchData.h"
#import "IntelligentInquirySearchModel.h"
#import "NUIManager.h"

static NSString * const intelligentInquirySearchExpertCellID = @"ZYIntelligentInquirySearchExpertCell";
static NSString * const medicalMainNearServiceCellID = @"ZYMedicalMainNearServiceCell";
#define kIntelligentInquirySearchViewHeight status_height+44
#define kIntelligentInquirySearchTitleViewHeight 45
#define kIntelligentInquirySearchBottomViewHeight kScreenW*68/375.0+30
#define kIntelligentInquirySearchExpertCellHeight 117
#define kMedicalMainNearServiceCellHeight 117

 
@interface ZYIntelligentInquirySearchVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, ZYIntelligentInquirySearchViewDelegate, ZYIntelligentInquirySearchBottomViewDelegate,UITextFieldDelegate, ZYRecordAnimationPopViewDelegate>
  
@property (nonatomic, strong) ZYIntelligentInquirySearchView *searchView;

@property (nonatomic, strong) ZYIntelligentInquirySearchBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYRecordAnimationPopView *popView;

@property (nonatomic, strong) NSMutableArray *goodsArray;

@property (nonatomic, strong) NSMutableArray *shopArray;

@property (nonatomic,strong) NUIManager *nUImanger;

@property (nonatomic,strong) IntelligentInquirySearchModel *dataSourceModel;

@property (nonatomic, copy) NSString *oldSearchStr;

@property (nonatomic, strong) NSMutableString *newSearchStr;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZYIntelligentInquirySearchVC

- (NUIManager *)nUImanger{
    if (!_nUImanger) {
        _nUImanger = [[NUIManager alloc]init];
    }
    return _nUImanger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self setupNavigationBarClearTransparentStyle];
    
    [self setUI];
    [self customTableView];
    if (!self.isRecord) {
        [self initData];
    }
    [self nuiManagerGetStrBlockInit];
    [self handleRcordPush];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self hiddenNavigationBar];
}

- (void)dealloc {
    [self deallocVoiceTimer];
}

- (void)setUI {
    [self.view addSubview:self.searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_searchView.superview);
        make.height.offset(kIntelligentInquirySearchViewHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

// 处理语音跳转
- (void)handleRcordPush {
    if (self.isRecord) {
        [self voiceButtonEventBegin];
    }
}

#pragma mark - 懒加载
- (ZYIntelligentInquirySearchView *)searchView {
    if (!_searchView) {
        _searchView = [[NSBundle mainBundle] loadNibNamed:@"ZYIntelligentInquirySearchView" owner:nil options:nil].lastObject;
        _searchView.delegate = self;
    }
    
    return _searchView;
}

- (ZYIntelligentInquirySearchBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYIntelligentInquirySearchBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (ZYRecordAnimationPopView *)popView {
    if (!_popView) {
        _popView = [[NSBundle mainBundle] loadNibNamed:@"ZYRecordAnimationPopView" owner:nil options:nil].lastObject;
        _popView.delegate = self;
    }
    
    return _popView;
}

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    
    return _goodsArray;
}

- (NSMutableArray *)shopArray {
    if (!_shopArray) {
        _shopArray = [NSMutableArray array];
    }
    
    return _shopArray;
}

- (NSMutableString *)newSearchStr {
    if (!_newSearchStr) {
        _newSearchStr = [NSMutableString string];
    }
    
    return _newSearchStr;
}

#pragma mark - 加载数据
- (void)initData {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"更新searchTF");
        self.searchView.searchTF.text = self.searchStr;
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"刷新列表tableView");
        [self.tableView reloadData];
    });
    [self getListShowInfo];
}
- (void)getListShowInfo{
    NSString *searchText = self.searchStr;
    WEAKSELF
    [IntelligentInquirySearchData getIntelligentInquiryListWithSearchText:searchText withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            weakSelf.dataSourceModel = [IntelligentInquirySearchModel mj_objectWithKeyValues:dic];
            weakSelf.shopArray = weakSelf.dataSourceModel.shopList;
            weakSelf.goodsArray = weakSelf.dataSourceModel.goodsList;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:intelligentInquirySearchExpertCellID bundle:nil] forCellReuseIdentifier:intelligentInquirySearchExpertCellID];
    [self.tableView registerNib:[UINib nibWithNibName:medicalMainNearServiceCellID bundle:nil] forCellReuseIdentifier:medicalMainNearServiceCellID];
    self.searchView.searchTF.delegate = self;
}
#pragma mark - UITextFieldDelegate
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    self.searchStr = textField.text;
//    [self initData];
//}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    self.searchStr = textField.text;
//    [self initData];//太频繁 去掉
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.searchStr = @"";
    
    return YES;
}
 
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.shopArray.count;
       
    }else if (section == 1) {
        return self.goodsArray.count;
       
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYIntelligentInquirySearchExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:intelligentInquirySearchExpertCellID forIndexPath:indexPath];
       //cell.consultButton.tag = 200 + indexPath.row;
       // [cell.consultButton addTarget:self action:@selector(consultButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell fillDataWithShopModel:self.shopArray[indexPath.row]];
 
        return cell;
    }else if (indexPath.section == 1) {
        ZYMedicalMainNearServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalMainNearServiceCellID forIndexPath:indexPath];
        [cell fillDataWithServiceModel:self.goodsArray[indexPath.row]];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return kIntelligentInquirySearchExpertCellHeight;
    }else if (indexPath.section == 1) {
        
        return kMedicalMainNearServiceCellHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZYIntelligentInquirySearchTitleView *titleView = [[NSBundle mainBundle] loadNibNamed:@"ZYIntelligentInquirySearchTitleView" owner:nil options:nil].lastObject;
        titleView.contentLabel.text = self.searchStr;
        titleView.decLabel.text = @"店铺";
        if (self.shopArray.count==0) {
            titleView.titleLabel.text = @"暂未查询到附近";
        }else{
            titleView.titleLabel.text = @"查询到附近";
        }
        
        return titleView;
    }else if (section == 1) {
        ZYIntelligentInquirySearchTitleView *titleView = [[NSBundle mainBundle] loadNibNamed:@"ZYIntelligentInquirySearchTitleView" owner:nil options:nil].lastObject;
        titleView.contentLabel.text = self.searchStr;
        titleView.decLabel.text = @"专业服务";
        if (self.goodsArray.count==0) {
            titleView.titleLabel.text = @"暂未查询到附近";
        }else{
            titleView.titleLabel.text = @"查询到附近";
        }
        return titleView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return kIntelligentInquirySearchTitleViewHeight;
    }else if (section == 1) {
        
        return kIntelligentInquirySearchTitleViewHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        return self.bottomView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        return kIntelligentInquirySearchBottomViewHeight;
    }else if (section == 2) {
        
        return 20;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        NSLog(@"商铺%ld", indexPath.row);
        MedicalStoresBaseModel *storeModel = self.shopArray[indexPath.row];
        MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
        vc.selfInitType = MedicalWebViewVc_ShowInitType_StoreDetail;
        vc.shopNameStr = [TextShowWithModelStr textShowWithNotNullStr:storeModel.shopName];
        vc.shopIdStr = [NSString stringWithFormat:@"%ld",(long)storeModel.ID];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];

    }else if (indexPath.section == 1) {
        NSLog(@"服务%ld", indexPath.row);
        MedicalServiceBaseModel  *serviceModel = self.goodsArray[indexPath.row];
        MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
        vc.selfInitType = MedicalWebViewVc_ShowInitType_ServicesDetail;
        vc.serviceIdStr = [NSString stringWithFormat:@"%ld",(long)serviceModel.ID];
        vc.serviceType = serviceModel.type;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}

#pragma mark - ZYIntelligentInquirySearchViewDelegate
// 返回
- (void)backButtonEvent {
    
    NSLog(@"返回");
    [self popVC];
}

// 搜索
- (void)searchButtonEvent {
    
    NSLog(@"搜索");
    [self.view endEditing:YES];
    if (!self.searchStr.length) {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入搜索内容!" toView:self.view];
        return;
    }
    [self initData];
}

#pragma  mark ===  语音
- (void)voiceButtonEventBegin {
    
    NSLog(@"语音识别转文字 开始");
    // 是否有麦克风权限
    if (![[ZYAuthorizationManager sharedManager] requestAuthorization:KAVAudioSession presentVc:self]) {
        return;
    }
    [self.view endEditing:YES];
    [self.nUImanger beginNui];
    [self.popView showRecordAnimationPopView];
}
- (void)voiceButtonEventEnd {
    
    NSLog(@"语音识别转文字 结束");
//    [self.nUImanger endNui];
}
- (void)nuiManagerGetStrBlockInit{
    WEAKSELF
    __weak typeof(self.searchView.searchTF) showTF = self.searchView.searchTF;
    self.nUImanger.getInfoBlock = ^(NSString * _Nonnull getStr) {
        NSLog(@"得到语音转文字 == %@ \n 赋予searchTF值+刷新本搜索列表 ",getStr);
//        if (getStr>0) {
//            //准备刷新本页面的 搜索框数据+搜索源数据
//            weakSelf.searchStr = getStr;
//            [weakSelf getNuiStr:getStr];
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([getStr containsString:weakSelf.newSearchStr]) {
                weakSelf.newSearchStr = [NSMutableString string];
            }
            [weakSelf.newSearchStr appendString:getStr];
            weakSelf.searchStr = [weakSelf.newSearchStr copy];
            showTF.text = [weakSelf.newSearchStr copy];
            weakSelf.popView.contentLabel.text = [weakSelf.newSearchStr copy];
            [weakSelf createVoiceTimer];
        });
    };
}
- (void)getNuiStr:(NSString *)getStr{
    WEAKSELF
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
       /** UI和数据先处理 在停止识别
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新searchTF 1 %@",getStr);
            weakSelf.searchView.searchTF.text = getStr;
            NSLog(@"刷新列表tableView 1 %@",getStr);
            [weakSelf.tableView reloadData];
        });
        */
        [weakSelf initData];
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        //停止识别占用
        [weakSelf.nUImanger endNui];
        NSLog(@"语音识别转文字 结束。%@",getStr);
    }];
    [op2 addDependency:op1];
    [queue addOperation:op1];
    [queue addOperation:op2];
}


#pragma mark - ZYIntelligentInquirySearchBottomViewDelegate
// 添加情况说明
- (void)bottomViewEvent {
    
    NSLog(@"添加情况说明");
    MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
    vc.selfInitType = MedicalWebViewVc_ShowInitType_FillInTheDiseaseExpertInformation;
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
- (void)consultButtonClicked:(UIButton *)sender {
    
    NSInteger index = sender.tag - 200;
    NSLog(@"咨询 %ld", index);
}

#pragma mark - ZYRecordAnimationPopViewDelegate
- (void)popViewEvent {
    
    [self.nUImanger endNui];
    self.popView.contentLabel.text = @"倾听中...";
    [self.popView hiddenRecordAnimationPopView];
}

- (void)closeButtonEvent {
    
    [self.nUImanger endNui];
    self.popView.contentLabel.text = @"倾听中...";
    [self.popView hiddenRecordAnimationPopView];
}

#pragma mark - 定时器方法
// 创建语音时长定时器
- (void)createVoiceTimer {
    if (!self.timer) {
        // 开启定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recordTimerBack:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

// 定时器回调
- (void)recordTimerBack:(NSTimer *)timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.newSearchStr isEqual:self.oldSearchStr]) {
            // 结束语音转文字并加载数据
            [self.nUImanger endNui];
            [self deallocVoiceTimer];
            self.newSearchStr = [NSMutableString string];
            self.oldSearchStr = @"";
            self.popView.contentLabel.text = @"倾听中...";
            [self.popView hiddenRecordAnimationPopView];
            [self initData];
        }else {
            self.oldSearchStr = [self.newSearchStr copy];
        }
    });
}

// 销毁定时器
- (void)deallocVoiceTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
