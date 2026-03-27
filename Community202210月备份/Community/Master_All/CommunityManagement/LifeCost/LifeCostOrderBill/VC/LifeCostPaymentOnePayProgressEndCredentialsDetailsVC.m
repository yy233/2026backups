//
//  LifeCostPaymentOnePayProgressEndCredentialsDetailsVC.m
//  Community
//
//  Created by 余莹 on 2021/1/11.
// 凭证

#import "LifeCostPaymentOnePayProgressEndCredentialsDetailsVC.h"
//
#define H_topBackView      90
#define H_centerBackView   60
#define H_bottomBackView   60
#define H_Cell_s 30
#define H_Cell_b 40
//
#import "LifeCostPaymentOnePayProgressEndCredentialsDetailModel.h"
//

@interface LifeCostPaymentOnePayProgressEndCredentialsDetailsVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *mainBackView;
@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UIView *centerBackView;
@property (nonatomic,strong) UIView *bottomBackView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *footerViewLabel;
//
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIButton *moneyBtn;
//
@property (nonatomic,strong) UILabel *typeTitleLabelOne;
@property (nonatomic,strong) UILabel *typeTitleLabelTwo;
@property (nonatomic,strong) UILabel *typeConcentLabelOne;
@property (nonatomic,strong) UILabel *typeConcentLabelTwo;
//
@property (nonatomic,strong) UIImageView *signatureImgView;//印章img
//
@property (nonatomic,strong) UIButton *downSignatureBtn;
@property (nonatomic,strong) UIButton *shareSignatureBtn;

//
@property (nonatomic,strong) NSMutableArray *dataSourceTitleArr;
@property (nonatomic,strong) NSMutableArray *dataSourceConcentArr;
@end

@implementation LifeCostPaymentOnePayProgressEndCredentialsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费凭证";
    [self initView];
    [self initData];
}
- (void)initData{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(self.orderId) forKey:@"orderId"];
    WEAKSELF
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:URL_Life_getOrderCredentials withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {

                LifeCostPaymentOnePayProgressEndCredentialsDetailModel *model = [LifeCostPaymentOnePayProgressEndCredentialsDetailModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                weakSelf.dataSourceConcentArr = [NSMutableArray arrayWithObjects:[TextShowWithModelStr textShowWithModelStr:model.payTypeName],\
                                                 [NSString stringWithFormat:@"%ld",model.familyId],\
                                                 [TextShowWithModelStr textShowWithModelStr:model.address],\
                                                 [TextShowWithModelStr textShowWithModelStr:model.companyName],\
                                                 [TextShowWithModelStr textShowWithModelStr:model.orderTime],\
                                                 [NSString stringWithFormat:@"%ld",model.orderNum], nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.moneyBtn setTitle:[NSString stringWithFormat:@"¥%0.2f",model.paymentBalance] forState:UIControlStateNormal];
                    weakSelf.typeConcentLabelOne.text = [TextShowWithModelStr textShowWithModelStr:model.typeName];
                    weakSelf.typeConcentLabelTwo.text = [weakSelf strOfTypeNum:model.status];
                    [weakSelf.tableView reloadData];
                    //印章图
                    //   _signatureImgView.image = [UIImage imageNamed:(nonnull NSString *)]
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
- (void)downSignatureBtnAction{
    NSLog(@"downSignatureBtnAction");
}
- (void)shareSignatureBtnAction{
    NSLog(@"shareSignatureBtnAction");
}



#pragma mark ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (Screen_H>700) {
        return H_Cell_b;
    }else{
        return H_Cell_s;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
    cell.textLabel.text = self.dataSourceTitleArr[indexPath.row];
    cell.detailTextLabel.text = self.dataSourceConcentArr[indexPath.row];
    cell.detailTextLabel.numberOfLines = 2;
    
    return cell;
}

-(void)tableView:(UITableView* )tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView setSeparatorColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.1]];
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //
    if (indexPath. section == 0 && indexPath. row != 3 ) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10000000)];
    }
}
#pragma mark===
- (void)initView{
    [self.view addSubview:self.mainBackView];
    [self.view addSubview:self.bottomBackView];
    [self.mainBackView addSubview:self.topBackView];
    [self.mainBackView addSubview:self.centerBackView];
    [self.mainBackView addSubview:self.tableView];
    [self.mainBackView addSubview:self.signatureImgView];
    [_mainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainBackView.superview.mas_top).offset(20);
        make.left.equalTo(_mainBackView.superview.mas_left).offset(16);
        make.right.equalTo(_mainBackView.superview.mas_right).offset(-16);
        make.height.equalTo(_mainBackView.superview.mas_height).multipliedBy(0.7);
    }];
    [_bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainBackView.mas_bottom).offset(20);
        make.left.equalTo(_bottomBackView.superview.mas_left).offset(16);
        make.right.equalTo(_bottomBackView.superview.mas_right).offset(-16);
        make.height.offset(H_bottomBackView);
    }];
    //
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainBackView.mas_top);
        make.left.equalTo(_mainBackView.mas_left).offset(10);
        make.right.equalTo(_mainBackView.mas_right).offset(-10);
        make.height.offset(H_topBackView);
    }];
    [_centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackView.mas_bottom).offset(10);
        make.left.equalTo(_topBackView.mas_left);
        make.right.equalTo(_topBackView.mas_right);
        make.height.offset(H_centerBackView);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerBackView.mas_bottom).offset(10);
        make.left.equalTo(_centerBackView.mas_left);
        make.right.equalTo(_centerBackView.mas_right);
        make.bottom.equalTo(_mainBackView.mas_bottom);
    }];
    //印章
    [_signatureImgView mas_makeConstraints:^(MASConstraintMaker *make) {//印章
        make.right.equalTo(_tableView.mas_right).offset(-10);
        make.bottom.equalTo(_tableView.mas_bottom).offset(-30);
        make.height.offset(100);
        make.width.offset(100);
    }];
    [self topUI];
    [self centerUI];
    [self bottomUI];
}
- (void)topUI{
    [_topBackView addSubview:self.titleL];
    [_topBackView addSubview:self.moneyBtn];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBackView.mas_top).offset(10);
        make.left.equalTo(_topBackView.mas_left);
        make.right.equalTo(_topBackView.mas_right);
        make.height.offset(20);
    }];
    [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(0);
        make.left.equalTo(_topBackView.mas_left);
        make.right.equalTo(_topBackView.mas_right);
        make.bottom.equalTo(_topBackView.mas_bottom);
    }];
}
- (void)centerUI{
    [_centerBackView addSubview:self.typeTitleLabelOne];
    [_centerBackView addSubview:self.typeTitleLabelTwo];
    [_centerBackView addSubview:self.typeConcentLabelOne];
    [_centerBackView addSubview:self.typeConcentLabelTwo];
    [_typeTitleLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerBackView.mas_top).offset(10);
        make.left.equalTo(_centerBackView.mas_left);
        make.right.equalTo(_centerBackView.mas_centerX).offset(-1);
        make.height.offset(15);
    }];
    [_typeConcentLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeTitleLabelOne.mas_bottom).offset(0);
        make.left.equalTo(_typeTitleLabelOne.mas_left);
        make.right.equalTo(_typeTitleLabelOne.mas_right);
        make.bottom.equalTo(_centerBackView.mas_bottom);
    }];
    [_typeTitleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerBackView.mas_top).offset(10);
        make.right.equalTo(_centerBackView.mas_right);
        make.left.equalTo(_centerBackView.mas_centerX).offset(1);
        make.height.offset(15);
    }];
    [_typeConcentLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeTitleLabelTwo.mas_bottom).offset(0);
        make.left.equalTo(_typeTitleLabelTwo.mas_left);
        make.right.equalTo(_typeTitleLabelTwo.mas_right);
        make.bottom.equalTo(_centerBackView.mas_bottom);
    }];
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.1];
    [_centerBackView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerBackView.mas_centerY);
        make.left.equalTo(_typeTitleLabelOne.mas_right);
        make.width.offset(1);
        make.height.equalTo(_centerBackView.mas_height).multipliedBy(0.5);
    }];
    
}
- (void)bottomUI{
    [_bottomBackView addSubview:self.downSignatureBtn];
    [_bottomBackView addSubview:self.shareSignatureBtn];
    [_downSignatureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomBackView.mas_top);
        make.left.equalTo(_bottomBackView.mas_left);
        make.right.equalTo(_bottomBackView.mas_centerX).offset(-1);
        make.bottom.equalTo(_bottomBackView.mas_bottom);
    }];
    [_shareSignatureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomBackView.mas_top);
        make.left.equalTo(_bottomBackView.mas_centerX).offset(1);
        make.right.equalTo(_bottomBackView.mas_right);
        make.bottom.equalTo(_bottomBackView.mas_bottom);
    }];
    UIView *lineV = [[UIView alloc]init];
    lineV.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.1];
    [_bottomBackView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomBackView.mas_centerY);
        make.left.equalTo(_downSignatureBtn.mas_right);
        make.width.offset(1);
        make.height.equalTo(_bottomBackView.mas_height).multipliedBy(0.5);
    }];
}

#pragma mark===
- (UIView *)mainBackView{
    if (!_mainBackView) {
        _mainBackView = [[UIView alloc]init];
        _mainBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _mainBackView.layer.cornerRadius = 10;
        _mainBackView.layer.masksToBounds = YES;
    }
    return _mainBackView;
}
- (UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc]init];
        _bottomBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _bottomBackView.layer.cornerRadius = 10;
        _bottomBackView.layer.masksToBounds = YES;
    }
    return _bottomBackView;
}
- (UIView *)topBackView{
    if (!_topBackView) {
        _topBackView = [[UIView alloc]init];
    }
    return _topBackView;
}
- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _centerBackView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.1];
        }else{
            _centerBackView.backgroundColor = Y_RGBA(46, 107, 255, 0.1);
        }
        _centerBackView.layer.cornerRadius = 5;
        _centerBackView.layer.masksToBounds = YES;
    }
    return _centerBackView;
}
//
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerViewLabel;
    }
    return _tableView;
}
- (UILabel *)footerViewLabel{
    if (!_footerViewLabel) {
        _footerViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, (Screen_W-32-20)*0.5, 60)];
        _footerViewLabel.font = [UIFont systemFontOfSize:12];
        _footerViewLabel.textColor = Y_RGBA(38, 114, 249, 1);
        _footerViewLabel.numberOfLines = 2;
        _footerViewLabel.textAlignment = NSTextAlignmentCenter;
        _footerViewLabel.text = @"该回单可以作为纵横世纪（中国）网络技术有限公司缴费凭证";
    }
    return _footerViewLabel;
}
//
- (UIImageView *)signatureImgView{
    if (!_signatureImgView) {
        _signatureImgView = [[UIImageView alloc]init];
        _signatureImgView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
//        _signatureImgView.layer.cornerRadius = 50;
    }
    return _signatureImgView;
}
//
#pragma mark ===
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font  = [UIFont boldSystemFontOfSize:18];
        _titleL.text = @"生活缴费凭证";
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (UIButton *)moneyBtn{
    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moneyBtn.titleLabel.font  = [UIFont boldSystemFontOfSize:30];
        _moneyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_moneyBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    }
    return _moneyBtn;
}
//
- (UILabel *)typeTitleLabelOne{
    if (!_typeTitleLabelOne) {
        _typeTitleLabelOne = [[UILabel alloc]init];
        _typeTitleLabelOne.text = @"缴费类型";
        _typeTitleLabelOne.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _typeTitleLabelOne.font = [UIFont systemFontOfSize:12];
        _typeTitleLabelOne.textAlignment = NSTextAlignmentCenter;
    }
    return _typeTitleLabelOne;
}
- (UILabel *)typeConcentLabelOne{
    if (!_typeConcentLabelOne) {
        _typeConcentLabelOne = [[UILabel alloc]init];
        _typeConcentLabelOne.text = @"类型";
        _typeConcentLabelOne.textColor = [ThemeManager shareManager].mainTextColor;
        _typeConcentLabelOne.font = [UIFont boldSystemFontOfSize:14];
        _typeConcentLabelOne.textAlignment = NSTextAlignmentCenter;
    }
    return _typeConcentLabelOne;
}
- (UILabel *)typeTitleLabelTwo{
    if (!_typeTitleLabelTwo) {
        _typeTitleLabelTwo = [[UILabel alloc]init];
        _typeTitleLabelTwo.text = @"缴费状态";
        _typeTitleLabelTwo.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _typeTitleLabelTwo.font = [UIFont systemFontOfSize:12];
        _typeTitleLabelTwo.textAlignment = NSTextAlignmentCenter;
    }
    return _typeTitleLabelTwo;
}
- (UILabel *)typeConcentLabelTwo{
    if (!_typeConcentLabelTwo) {
        _typeConcentLabelTwo = [[UILabel alloc]init];
        _typeConcentLabelTwo.text = @"状态";
        _typeConcentLabelTwo.textColor = [ThemeManager shareManager].mainTextColor;
        _typeConcentLabelTwo.font = [UIFont boldSystemFontOfSize:14];
        _typeConcentLabelTwo.textAlignment = NSTextAlignmentCenter;
    }
    return _typeConcentLabelTwo;
}
//
- (UIButton *)downSignatureBtn{
    if (!_downSignatureBtn) {
        _downSignatureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downSignatureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_downSignatureBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_downSignatureBtn setTitle:@"下载凭证" forState:UIControlStateNormal];
        [_downSignatureBtn addTarget:self action:@selector(downSignatureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downSignatureBtn;
}
- (UIButton *)shareSignatureBtn{
    if (!_shareSignatureBtn) {
        _shareSignatureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareSignatureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_shareSignatureBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_shareSignatureBtn setTitle:@"分享凭证" forState:UIControlStateNormal];
        [_shareSignatureBtn addTarget:self action:@selector(shareSignatureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareSignatureBtn;
}
#pragma mark ===
- (NSMutableArray *)dataSourceTitleArr{
    if (!_dataSourceTitleArr) {
        _dataSourceTitleArr = [NSMutableArray arrayWithObjects:@"支付账号",@"户号",@"住址信息",@"收费单位",@"付款时间",@"流水号", nil];
    }
    return _dataSourceTitleArr;
}
- (NSMutableArray *)dataSourceConcentArr{
    if (!_dataSourceConcentArr) {
        _dataSourceConcentArr = [NSMutableArray arrayWithObjects:@"支付账号",@"户号",@"住址信息",@"收费单位",@"付款时间",@"流水号", nil];
    }
    return _dataSourceConcentArr;
}

@end
