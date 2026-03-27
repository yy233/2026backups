//
//  ZYSOSSalvageServiceVC.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSSalvageServiceVC.h"
#import "SOSSalvageServiceDetailVc.h"

#import "ZYSOSSalvageServiceTopView.h"
#import "ZYSOSSalvageServiceCell.h"
#import "ZYRecordAnimationPopView.h"

#import "MedicalShopRelatedData.h"
#import "NUIManager.h"

static NSString * const SOSSalvageServiceCellID = @"ZYSOSSalvageServiceCell";
#define kSOSSalvageServiceTopViewHeight 70
#define kSOSSalvageServiceCellHeight 95

@interface ZYSOSSalvageServiceVC () <UITableViewDataSource, UITableViewDelegate, ZYSOSSalvageServiceTopViewDelegate,UITextFieldDelegate, ZYRecordAnimationPopViewDelegate>

@property (nonatomic,strong) NUIManager *nUImanger;

@property (nonatomic, strong) ZYSOSSalvageServiceTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYRecordAnimationPopView *popView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger pageNum;

@property (nonatomic, copy) NSString *oldSearchStr;

@property (nonatomic, strong) NSMutableString *newsSearchStr;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZYSOSSalvageServiceVC
- (NUIManager *)nUImanger{
    if (!_nUImanger) {
        _nUImanger = [[NUIManager alloc]init];
    }
    return _nUImanger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择救助机构";
    [self setUI];
    [self customTableView];
    [self initData];
    [self addRefresh];
    [self nuiManagerGetStrBlockInit];
    if (self.isEditType) {//本字段暂未使用 后页用的是机构model做添加or修改的判断 
    }else{
    }
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
}
- (SosAddressBookAgencyModel *)thisOldArchiveModel{
    if (!_thisOldArchiveModel) {
        _thisOldArchiveModel = [[SosAddressBookAgencyModel alloc]init];
    }
    return _thisOldArchiveModel;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithSOSColor];
}

- (void)dealloc {
    [self deallocVoiceTimer];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kSOSSalvageServiceTopViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(_topView.superview);
    }];
    //
    self.topView.searchTF.delegate = self;
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self initData];
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    [self initData];
}
 

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self initData];
    
    return YES;
}
 
#pragma mark - 懒加载
- (ZYSOSSalvageServiceTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYSOSSalvageServiceTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
    }
    
    return _topView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableString *)newsSearchStr {
    if (!_newsSearchStr) {
        _newsSearchStr = [NSMutableString string];
    }
    
    return _newsSearchStr;
}

#pragma mark - 加载数据
- (void)initData {
    self.pageNum = 1;
    WEAKSELF
    NSString *searchStr = self.topView.searchTF.text;
    
    [MedicalShopRelatedData getMedicalShopOfSOSAgencyFirstPageNumWithSearchShopNameStr:searchStr  WithBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray: [SosAddressBookAgencyModel mj_objectArrayWithKeyValuesArray:arr]];
            if (arr.count>=Y_PAGE_SIZE) {
                weakSelf.tableView.mj_footer.hidden = NO;
                weakSelf.pageNum += 1;
            }else{
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)moreData{
    WEAKSELF
    [MedicalShopRelatedData getMedicalShopOfSOSAgencyWithSearchShopNameStr:self.topView.searchTF.text andPageNum:self.pageNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_footer endRefreshing];
        });
        if (success) {
            [weakSelf.dataArray addObjectsFromArray: [SosAddressBookAgencyModel mj_objectArrayWithKeyValuesArray:arr]];
            if (arr.count>=Y_PAGE_SIZE) {
                weakSelf.tableView.mj_footer.hidden = NO;
                weakSelf.pageNum += 1;
            }else{
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.separatorColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:SOSSalvageServiceCellID bundle:nil] forCellReuseIdentifier:SOSSalvageServiceCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYSOSSalvageServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:SOSSalvageServiceCellID forIndexPath:indexPath];
    [cell fillDataWithAgencyModel:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kSOSSalvageServiceCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self chooseAgencyWithRowNum:indexPath.row];
    NSLog(@"%ld", indexPath.row);
}

#pragma mark - ZYSOSSalvageServiceTopViewDelegate
 
#pragma  mark ===  语音（暂时不用）
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
   // __weak typeof(self.searchView.searchTF) showTF = self.searchView.searchTF;
    self.nUImanger.getInfoBlock = ^(NSString * _Nonnull getStr) {
        NSLog(@"得到语音转文字 == %@ \n 赋予searchTF值+刷新本搜索列表 ",getStr);
//        if (getStr>0) {
//            //准备刷新本页面的 搜索框数据+搜索源数据
//            [weakSelf getNuiStr:getStr];
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([getStr containsString:weakSelf.newsSearchStr]) {
                weakSelf.newsSearchStr = [NSMutableString string];
            }
            [weakSelf.newsSearchStr appendString:getStr];
            weakSelf.topView.searchTF.text = [weakSelf.newsSearchStr copy];
            weakSelf.popView.contentLabel.text = [weakSelf.newsSearchStr copy];
            [weakSelf createVoiceTimer];
        });
    };
}
- (void)getNuiStr:(NSString *)getStr{
    WEAKSELF
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
     //UI和数据先处理 在停止识别
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新searchTF 1 %@",getStr);
            weakSelf.topView.searchTF.text = getStr;
            [weakSelf initData];
        });
      
      
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
#pragma mark ==
- (void)chooseAgencyWithRowNum:(NSInteger)rowNum{
//去详情界面
    SosAddressBookAgencyModel *model = self.dataArray[rowNum];
    NSLog(@"ShoppingSosAgencyGetModel== %@",[model mj_keyValues]);
    
    SOSSalvageServiceDetailVc *vc = [[SOSSalvageServiceDetailVc alloc]init];
    vc.isEditType = self.isEditType;
    vc.saveNowFamilyModel = self.saveNowFamilyModel;
    vc.thisOldArchiveModel = self.thisOldArchiveModel;//旧机构model
    vc.thisNowShowAgencyModel = model;
    [self pushVc:vc];
     
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
        if ([self.newsSearchStr isEqual:self.oldSearchStr]) {
            // 结束语音转文字并加载数据
            [self.nUImanger endNui];
            [self deallocVoiceTimer];
            self.newsSearchStr = [NSMutableString string];
            self.oldSearchStr = @"";
            self.popView.contentLabel.text = @"倾听中...";
            [self.popView hiddenRecordAnimationPopView];
            [self initData];
        }else {
            self.oldSearchStr = [self.newsSearchStr copy];
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
