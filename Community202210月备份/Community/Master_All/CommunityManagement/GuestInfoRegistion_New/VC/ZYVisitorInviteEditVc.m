//
//  ZYVisitorInviteEditVc.m
//  Community
//
//  Created by ZY on 2022/5/20.
//

#import "ZYVisitorInviteEditVc.h"
#import "GuestInfoRegistionOkShowQrCardLateVC.h"
#import "ZYVisitorInviteEditBottomView.h"
#import "ZYVisitorInviteEditCell.h"
#import "ZYAccessRecordMemberPopView.h"
#import "GuestInfoWillRegisterModel.h"
#import "GuestUseTimeChoosePopView.h"

static NSString * const ZYVisitorInviteEditCellID = @"ZYVisitorInviteEditCell";
#define kZYVisitorInviteEditBottomViewHeight 84+button_bottom_height
#define kZYVisitorInviteEditCellHeight 280

@interface ZYVisitorInviteEditVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZYVisitorInviteEditCellDelegate, ZYVisitorInviteEditBottomViewDelegate, ZYAccessRecordMemberPopViewDelegate, PopViewChooseVisitTimeDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYVisitorInviteEditBottomView *bottomView;

@property (nonatomic, strong) ZYAccessRecordMemberPopView *popView;

@property (nonatomic,strong) GuestUseTimeChoosePopView *timePopView;

// 当前选中的index
@property (nonatomic, assign) NSInteger currentSelectedIndex;

// 小区房屋数组
@property (nonatomic, strong) NSMutableArray *houseArray;

// 来访事由数组
@property (nonatomic, strong) NSMutableArray *reasonArray;

@end

@implementation ZYVisitorInviteEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邀请访客信息";
    [self setUI];
    [self customTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setupNavigationBarStyleWithThemeColor];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_bottomView.superview);
        make.height.offset(kZYVisitorInviteEditBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(_tableView.superview);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    
    return _tableView;
}

- (ZYVisitorInviteEditBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYVisitorInviteEditBottomView" owner:nil options:nil].lastObject;
        [_bottomView.okButton setTitle:@"提交信息" forState:UIControlStateNormal];
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (ZYAccessRecordMemberPopView *)popView {
    if (!_popView) {
        _popView = [[NSBundle mainBundle] loadNibNamed:@"ZYAccessRecordMemberPopView" owner:nil options:nil].lastObject;
        _popView.delegate = self;
    }
    
    return _popView;
}

- (GuestUseTimeChoosePopView *)timePopView {
    _timePopView = [[GuestUseTimeChoosePopView alloc] init];
    _timePopView.delegate = self;
    
    return _timePopView;
}

- (NSMutableArray *)houseArray {
    if (!_houseArray) {
        _houseArray = [NSMutableArray array];
    }
    
    return _houseArray;
}

- (NSMutableArray *)reasonArray {
    if (!_reasonArray) {
        _reasonArray = [NSMutableArray array];
    }
    
    return _reasonArray;
}

#pragma mark - 加载数据
// 加载房屋数据
- (void)initHouseData {
    [UserHouseOrCommunityListModel getUserAllHouseListWithBlock:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            self.houseArray = [NSMutableArray arrayWithArray:[UserHouseModel mj_objectArrayWithKeyValuesArray:arr]];
            NSMutableArray *mArr = [NSMutableArray array];
            for (UserHouseModel *model in self.houseArray) {
                [mArr addObject:[NSString stringWithFormat:@"%@%@", [ShareUserInfo sharedUserInfo].commuityInfo.name, model.address]];
            }
            self.popView.dataArray = [mArr copy];
            [self.popView showAccessRecordMemberPopView];
        });
    }];
}

// 加载来访事由数据
- (void)initReasonData {
    [VisitReasonListModel getVisitReasoneListWithBlock:^(NSArray * arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            self.reasonArray = [NSMutableArray arrayWithArray:[VisitReasonModel mj_objectArrayWithKeyValuesArray:arr]];
            NSMutableArray *mArr = [NSMutableArray array];
            for (VisitReasonModel *model in self.reasonArray) {
                [mArr addObject:model.name];
            }
            self.popView.dataArray = [mArr copy];
            [self.popView showAccessRecordMemberPopView];
        });
    }];
}

// 提交邀请访客数据
- (void)uploadVisitInviteData {
    NSDictionary *params = [self.uploadModel yy_modelToJSONObject];
    WEAKSELF
    [GuestInfoWillRegisterModel addGuestInfoRegistWithParm:params.mutableCopy withReturnResult:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        STRONGSELF
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"添加成功");
            //0630 成功后去二维码页面 返回时不到编辑页
            //刷新列表页
            Y_NSNotificationCenter_PostNotice_NilObject_Name(GuestOneInfoAddSuccessWillRefreshListVc_Notice_Name)
            //先跳转二维码页
            /**
             data =     {
                 id = 75345105560670208;
             };
             */
            if (isNil(dic)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self popVC];
                });
                return;
            }
            NSString *visitorIdStr = [[dic allKeys]containsObject:@"id"] ? [dic objectForKey:@"id"] : @"";
            [strongSelf goToQrVcWithIsNowSuccessType:YES andVisitorIdStr:visitorIdStr];
        }
    }];
}

- (void)goToQrVcWithIsNowSuccessType:(BOOL)nowSuccessType andVisitorIdStr:(NSString *)idStr{//Type_Show_GuestInfoRegistionEditVC 暂时3种添加编辑查看里面只有两种有使用
    dispatch_async(dispatch_get_main_queue(), ^{
        GuestInfoRegistionOkShowQrCardLateVC *qrCardVc = [[GuestInfoRegistionOkShowQrCardLateVC alloc]init];
        qrCardVc.isNowSuccessToShow = nowSuccessType;
        qrCardVc.visitorId = idStr;
        qrCardVc.houseNameShowStr = [NSString stringWithFormat:@"%@%@", [ShareUserInfo sharedUserInfo].commuityInfo.name, self.uploadModel.address];
        qrCardVc.personNameShowStr = [TextShowWithModelStr textShowWithModelStr:self.uploadModel.name];//名字
        if ( self.uploadModel.endTime.length <= 0) {//以天计算
            qrCardVc.timeDelineShowStr = self.uploadModel.startTime;
        }else{
            qrCardVc.timeDelineShowStr = self.uploadModel.endTime;
        }
        [self pushVc:qrCardVc];
    });
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYVisitorInviteEditCellID bundle:nil] forCellReuseIdentifier:ZYVisitorInviteEditCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYVisitorInviteEditCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYVisitorInviteEditCellID forIndexPath:indexPath];
    cell.nameTF.tag = 200;
    cell.nameTF.delegate = self;
    cell.telTF.tag = 300;
    cell.telTF.delegate = self;
    cell.delegate = self;
    if (self.type == ZYVisitorInvite_Type_Edit) {
        cell.nameTF.userInteractionEnabled = NO;
        cell.telTF.userInteractionEnabled = NO;
        cell.addressContentView.userInteractionEnabled = NO;
        cell.reasonContentView.userInteractionEnabled = NO;
    }
    cell.model = self.uploadModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYVisitorInviteEditCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.tag == 200) {
        self.uploadModel.name = textField.text;
    }else if (textField.tag == 300) {
        self.uploadModel.contact = textField.text;
    }
}

#pragma mark - ZYVisitorInviteEditCellDelegate
// 来访小区地址
- (void)addressViewEvent {
    NSLog(@"来访小区地址");
    [self.view endEditing:YES];
    self.currentSelectedIndex = 1;
    if (self.houseArray.count > 0) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (UserHouseModel *model in self.houseArray) {
            [mArr addObject:[NSString stringWithFormat:@"%@%@", [ShareUserInfo sharedUserInfo].commuityInfo.name, model.address]];
        }
        self.popView.dataArray = [mArr copy];
        [self.popView showAccessRecordMemberPopView];
    }else {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
        [self initHouseData];
    }
}

// 来访事由
- (void)reasonViewEvent {
    NSLog(@"来访事由");
    [self.view endEditing:YES];
    self.currentSelectedIndex = 2;
    if (self.reasonArray.count > 0) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (VisitReasonModel *model in self.reasonArray) {
            [mArr addObject:model.name];
        }
        self.popView.dataArray = [mArr copy];
        [self.popView showAccessRecordMemberPopView];
    }else {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
        [self initReasonData];
    }
}

// 有效日期
- (void)dateViewEvent {
    NSLog(@"有效日期");
    [self.view endEditing:YES];
    [self.timePopView showInView:self.view thePopViewSubViewHeight:0.0 WithArray:@[].mutableCopy];
}

#pragma mark - ZYVisitorInviteEditBottomViewDelegate
// 提交信息
- (void)okButtonEvent {
    NSLog(@"提交信息");
    if ([self judgeNoEmptyData]) {
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"提交中..."];
        [self uploadVisitInviteData];
    }
}

#pragma mark - ZYAccessRecordMemberPopViewDelegate
- (void)contentViewEventWithIndex:(NSInteger)index {
    NSLog(@"选择%ld", index);
    [self.popView hiddenAccessRecordMemberPopView];
    if (self.currentSelectedIndex == 1) {
        UserHouseModel *model = self.houseArray[index];
        self.uploadModel.address = model.address;
        self.uploadModel.houseId = model.houseId;
        self.uploadModel.unitId = model.pidStr;
    }else if (self.currentSelectedIndex == 2) {
        VisitReasonModel *model = self.reasonArray[index];
        self.uploadModel.reason = model.code;
        self.uploadModel.reasonStr = model.name;
    }
    [self.tableView reloadData];
}

#pragma mark ==  PopViewChoose VisitTime Delegate 时间
- (void)popViewChooseVisitTimeChooseDayArr:(NSMutableArray *)timeStrArr {
    DLog(@" PopViewChooseVisitTimeDelegate ====== %@",timeStrArr);
    self.uploadModel.startTime = [NSString stringWithFormat:@"%@ 00:00:00", timeStrArr.firstObject];
    NSString *endTime = timeStrArr.lastObject;
    if (endTime.length > 0) {
        self.uploadModel.endTime = [NSString stringWithFormat:@"%@ 23:59:59", endTime];
    }else {
        self.uploadModel.endTime = [NSString stringWithFormat:@"%@ 23:59:59", timeStrArr.firstObject];
    }
    [self.tableView reloadData];
}

#pragma mark - 数据不为空判断
- (BOOL)judgeNoEmptyData {
    if (self.uploadModel.name.length > 0) {
        if (self.uploadModel.contact.length > 0) {
            if (self.uploadModel.address.length > 0) {
                if (self.uploadModel.reasonStr.length > 0) {
                    if (self.uploadModel.startTime.length > 0) {
                        
                        return YES;
                    }else {
                        [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择有效日期" toView:self.view];
                    }
                }else {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择到访事由" toView:self.view];
                }
            }else {
                [ZYProgressHUDTool showCustomHUDTextMessage:@"请选择来访小区地址" toView:self.view];
            }
        }else {
            [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入来访人电话" toView:self.view];
        }
    }else {
        [ZYProgressHUDTool showCustomHUDTextMessage:@"请输入来访人姓名" toView:self.view];
    }
    
    return NO;
}

@end
