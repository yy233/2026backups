//
//  ZYVisitorInviteInfoVc.m
//  Community
//
//  Created by ZY on 2022/5/20.
//

#import "ZYVisitorInviteInfoVc.h"
#import "ZYVisitorInviteEditVc.h"
#import "GuestInfoRegistionOkShowQrCardLateVC.h"
#import "ZYVisitorInviteEditBottomView.h"
#import "ZYVisitorInviteInfoCell.h"
#import "GuestInfoWillRegisterModel.h"

static NSString * const ZYVisitorInviteInfoCellID = @"ZYVisitorInviteInfoCell";
#define kZYVisitorInviteEditBottomViewHeight 84+button_bottom_height
#define kZYVisitorInviteInfoCellHeight 280

@interface ZYVisitorInviteInfoVc () <UITableViewDataSource, UITableViewDelegate, ZYVisitorInviteEditBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYVisitorInviteEditBottomView *bottomView;

@property (nonatomic, strong) GuestInfoWillRegisterModel *model;

@end

@implementation ZYVisitorInviteInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邀请访客信息";
    [self setUI];
    [self customTableView];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    [self initVisitorInviteData];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (ZYVisitorInviteEditBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYVisitorInviteEditBottomView" owner:nil options:nil].lastObject;
        _bottomView.hidden = YES;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

#pragma mark - 加载数据
// 加载访客邀请详情数据
- (void)initVisitorInviteData {
    self.tableView.hidden = YES;
    [GuestInfoWillRegisterModel showDetailGuestInfoRegistWithParm:@{@"id" : self.ID}.mutableCopy withReturnResult:^(BOOL resultBool, GuestInfoWillRegisterModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (resultBool) {
                self.model = model;
                self.bottomView.hidden = NO;
                if (self.model.expireStatus == 0) {
                    [self.bottomView.okButton setTitle:@"查看访客二维码" forState:UIControlStateNormal];
                }else {
                    [self.bottomView.okButton setTitle:@"重新生成访客码" forState:UIControlStateNormal];
                }
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
        });
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYVisitorInviteInfoCellID bundle:nil] forCellReuseIdentifier:ZYVisitorInviteInfoCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYVisitorInviteInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYVisitorInviteInfoCellID forIndexPath:indexPath];
    cell.model = self.model;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYVisitorInviteInfoCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.model.expireStatus == 1) {
        
        return 35;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.model.expireStatus == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
        view.backgroundColor = [UIColor zy_colorWithHexString:@"#FF0033" andAlpha:0.2];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenW - 32, 35)];
        label.text = @"温馨提示：当前访客码已失效，请点击下方重新生成访客码";
        label.textColor = [UIColor zy_colorWithHexString:@"#FF0033"];
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        
        return view;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - ZYVisitorInviteEditBottomViewDelegate
- (void)okButtonEvent {
    if (self.model.expireStatus == 0) {
        NSLog(@"查看访客二维码");
        GuestInfoRegistionOkShowQrCardLateVC *qrCardVc = [[GuestInfoRegistionOkShowQrCardLateVC alloc]init];
        qrCardVc.isNowSuccessToShow = NO;
        qrCardVc.visitorId = self.model.idStr;
        qrCardVc.houseNameShowStr = [NSString stringWithFormat:@"%@%@", [ShareUserInfo sharedUserInfo].commuityInfo.name, _model.address];
        qrCardVc.personNameShowStr = [TextShowWithModelStr textShowWithModelStr:self.model.name];//名字
        if ( self.model.endTime.length <= 0) {//以天计算
            qrCardVc.timeDelineShowStr = self.model.startTime;
        }else{
            qrCardVc.timeDelineShowStr = self.model.endTime;
        }
        [self pushVc:qrCardVc];
    }else {
        NSLog(@"重新生成访客码");
        ZYVisitorInviteEditVc *vc = [[ZYVisitorInviteEditVc alloc] init];
        vc.type = ZYVisitorInvite_Type_Edit;
        ZYVisitorInviteUploadModel *model = [[ZYVisitorInviteUploadModel alloc] init];
        model.communityId = [NSString stringWithFormat:@"%ld", [ShareUserInfo sharedUserInfo].commuityInfo.ID];
        model.name = self.model.name;
        model.contact = self.model.contact;
        model.address = self.model.address;
        model.houseId = self.model.houseId;
        model.unitId = self.model.unitId;
        model.reason = self.model.reason;
        model.reasonStr = self.model.reasonStr;
        vc.uploadModel = model;
        [self pushVc:vc];
    }
}

@end
