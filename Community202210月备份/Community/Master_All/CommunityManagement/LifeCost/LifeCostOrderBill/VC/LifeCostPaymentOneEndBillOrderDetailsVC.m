//
//  LifeCostPaymentOnePayProgressEndBillDetailsVC.m
//  Community
//
//  Created by 余莹 on 2021/1/11.
//  账单详情

#import "LifeCostPaymentOneEndBillOrderDetailsVC.h"
#import "LifeCostProgressEndBillAddMarkVC.h"//标签
#import "LifeCostProgressEndBillAddNoteVC.h"//备注
//
#import "LifeCostPaymentOneEndBillOrderDetailModel.h"
//
@interface LifeCostPaymentOneEndBillOrderDetailsVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton *commpnyShowBtn;
@property (nonatomic,strong) UIImageView *compnyImgV;
@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UIView *mainBackView;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *sectionOneTitle;
@property (nonatomic,strong) NSMutableArray *sectionTwoTitle;
@property (nonatomic,strong) NSMutableArray *sectionOneConent;
@property (nonatomic,strong) NSMutableArray *sectionTwoConent;

@end

@implementation LifeCostPaymentOneEndBillOrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单详情";//账单 详情
    [self initView];
    [self initNotice];
    [self initData];
}
- (void)initNotice{
    Y_NSNotificationCenter_Creat_NameAction(LifeCost_BillMark_Save_Notice_Name, noticeWithBillMarkSave:)
    Y_NSNotificationCenter_Creat_NameAction(LifeCost_BillNote_Save_Notice_Name, noticeWithBillNoteSave:)
}
- (void)noticeWithBillMarkSave:(NSNotification *)notice{//标签
    NSDictionary *userinfo = notice.userInfo;
    NSLog(@"%@",userinfo[Notice_UserInfo_Key]);
    self.sectionTwoConent[3] = userinfo[Notice_UserInfo_Key];
    [self.tableView reloadData];
}
- (void)noticeWithBillNoteSave:(NSNotification *)notice{//备注
    NSDictionary *userinfo = notice.userInfo;
    NSLog(@"%@",userinfo[Notice_UserInfo_Key]);
    self.sectionTwoConent[4] = userinfo[Notice_UserInfo_Key];
    [self.tableView reloadData];
}
#pragma mark===
- (void)initData{
   
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(self.orderId) forKey:@"orderId"];
    WEAKSELF
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_Life_DetaiHistorytlList_OneOrderDetails withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                LifeCostPaymentOneEndBillOrderDetailModel *model = [LifeCostPaymentOneEndBillOrderDetailModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                //
                weakSelf.sectionOneConent = [NSMutableArray arrayWithObjects:[TextShowWithModelStr textShowWithModelStr:model.payTypeName],\
                                             [TextShowWithModelStr textShowWithModelStr:model.typeName],\
                                             [NSString stringWithFormat:@"%ld",model.familyId],\
                                             [TextShowWithModelStr textShowWithModelStr:model.companyName],\
                                             [NSString stringWithFormat:@"%ld",model.orderId],nil];
                 [weakSelf.sectionTwoConent replaceObjectAtIndex:0 withObject:[TextShowWithModelStr textShowWithModelStr:model.billClassificationName]];
                 [weakSelf.sectionTwoConent replaceObjectAtIndex:3 withObject:[TextShowWithModelStr textShowWithModelStr:model.tally]];
                 [weakSelf.sectionTwoConent replaceObjectAtIndex:4 withObject:[TextShowWithModelStr textShowWithModelStr:model.remark]];
                //
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.commpnyShowBtn setTitle:[TextShowWithModelStr textShowWithModelStr:model.companyName] forState:UIControlStateNormal];
                    [weakSelf.compnyImgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.icon]];
                    weakSelf.moneyL.text = [NSString stringWithFormat:@"¥%0.2f",model.paymentBalance];
                    weakSelf.typeL.text = [weakSelf strOfTypeNum:model.status];
                    //
                    [weakSelf.tableView reloadData];
                 });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

- (NSString *)strOfTypeNum:(NSInteger)status{
    switch (status) {
        case 1:
        {
            return @"已支付";
        }
            break;
        case 2:
        {
            return @"正在处理";
        }
            break;
        case 3:
        {
            return @"交易成功";
        }
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark ===
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row == 2) {//缴费详情
            //缴费详情
            LifeCostPaymentOnePayProgressDetailsVC *vc = [[LifeCostPaymentOnePayProgressDetailsVC alloc]init];
            vc.orderId = self.orderId;
            [self pushVc:vc];
        }
        if (indexPath.row == 3) {//标签
            LifeCostProgressEndBillAddMarkVC *vc = [[LifeCostProgressEndBillAddMarkVC alloc]init];
            vc.orderId = self.orderId;
            [self pushVc:vc];
        }
        if (indexPath.row == 4) {//备注
            LifeCostProgressEndBillAddNoteVC *vc = [[LifeCostProgressEndBillAddNoteVC alloc]init];
            vc.orderId = self.orderId;
            [self pushVc:vc];
        }
    }
 
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }else{
        return 6;
    }
  
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryNone;//cell没有任何的样式
        cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.textLabel.text = self.sectionOneTitle[indexPath.row];
        cell.detailTextLabel.text = self.sectionOneConent[indexPath.row];
        cell.detailTextLabel.numberOfLines = 2;
    }else{
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightSkip"]];
        cell.accessoryView = accessoryImgView;
        cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.detailTextLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        cell.textLabel.text = self.sectionTwoTitle[indexPath.row];
        cell.detailTextLabel.text = self.sectionTwoConent[indexPath.row];
    }
    return cell;
}


#pragma mark ==
- (void)initView{
    [self.view addSubview:self.topBackView];
    [self.view addSubview:self.mainBackView];
    [self.topBackView addSubview:self.compnyImgV];
    [self.topBackView addSubview:self.commpnyShowBtn];
    [self.topBackView addSubview:self.moneyL];
    [self.topBackView addSubview:self.typeL];
    [self.mainBackView addSubview:self.tableView];
    [self setUI];
}
- (void)setUI{
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackView.superview.mas_top).offset(10);
        make.left.equalTo(_topBackView.superview.mas_left).offset(16);
        make.right.equalTo(_topBackView.superview.mas_right).offset(-16);
        make.height.offset(60);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyL.superview.mas_top);
        make.right.equalTo(_moneyL.superview.mas_right);
        make.height.offset(30);
    }];
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyL.mas_bottom);
        make.right.equalTo(_moneyL.mas_right);
        make.bottom.equalTo(_typeL.superview.mas_bottom);
        make.width.offset(80);
    }];
    [_compnyImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_compnyImgV.superview.mas_left);
        make.centerY.equalTo(_compnyImgV.superview.mas_centerY);
        make.height.equalTo(_compnyImgV.superview.mas_height);
        make.width.offset(20);
    }];
    [_commpnyShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_compnyImgV.mas_right);
        make.centerY.equalTo(_commpnyShowBtn.superview.mas_centerY);
        make.height.equalTo(_commpnyShowBtn.superview.mas_height);
        make.right.equalTo(_moneyL.mas_left);
    }];
    //
    [_mainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackView.mas_bottom);
        make.left.equalTo(_topBackView.mas_left);
        make.right.equalTo(_topBackView.mas_right);
        make.bottom.equalTo(_mainBackView.superview.mas_bottom).offset(-40);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
}


#pragma mark ==
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]init];
    }
    return _topBackView;
}
 
- (UIView *)mainBackView{
    if (!_mainBackView) {
        _mainBackView = [[UIView alloc]init];
    }
    return _mainBackView;
}

#pragma mark===
- (UIImageView *)compnyImgV{
    if (!_compnyImgV) {
        _compnyImgV = [[UIImageView alloc]init];
        _compnyImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _compnyImgV;
}
- (UIButton *)commpnyShowBtn{
    if (!_commpnyShowBtn) {
        _commpnyShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commpnyShowBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_commpnyShowBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _commpnyShowBtn.titleLabel.numberOfLines = 0;
//        _commpnyShowBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _commpnyShowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//居左显示

    }
    return _commpnyShowBtn;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.font = [UIFont boldSystemFontOfSize:30];
        _moneyL.textAlignment = NSTextAlignmentRight;
    }
    return _moneyL;
}
- (UILabel *)typeL{
    if (!_typeL) {
        _typeL  = [[UILabel alloc]init];
        _typeL.textColor = [ThemeManager shareManager].mainTextColor;
        _typeL.font = [UIFont systemFontOfSize:12];
        _typeL.textAlignment = NSTextAlignmentRight;
    }
    return _typeL;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        _tableView.scrollEnabled = NO;//
        _tableView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    }
    return _tableView;
}
#pragma mark ==
- (NSMutableArray *)sectionOneTitle{
    if (!_sectionOneTitle) {
        _sectionOneTitle = [NSMutableArray arrayWithObjects:@"付款方式",@"缴费说明",@"户号",@"收费单位",@"订单号",nil];
    }
    return _sectionOneTitle;
}
- (NSMutableArray *)sectionTwoTitle{
    if (!_sectionTwoTitle) {
        _sectionTwoTitle = [NSMutableArray arrayWithObjects:@"账单分类",@"对此订单有疑问",@"查看缴费详情",@"标签",@"备注",@"投诉",nil];
    }
    return _sectionTwoTitle;
}
- (NSMutableArray *)sectionOneConent{
    if (!_sectionOneConent) {
        _sectionOneConent = [NSMutableArray arrayWithObjects:@"付款方式",@"缴费说明",@"户号",@"收费单位",@"订单号",nil];
    }
    return _sectionOneConent;
}
- (NSMutableArray *)sectionTwoConent{
    if (!_sectionTwoConent) {
        _sectionTwoConent = [NSMutableArray arrayWithObjects:@"充值缴费",@"",@"",@"添加",@"添加",@"",nil];
    }
    return _sectionTwoConent;
}
@end
