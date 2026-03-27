//
//  LifeCoseNewAddCoseVC.m
//  Community
//
//  Created by 余莹 on 2021/1/12.
// 新增缴费

#import "LifeCoseNewAddCoseVC.h"
#import "LifeCosePayCompanyListVc.h"
#import "LifeCostChooseGroupVC.h"
#import "LifeCoseNewPayInfoVc.h"

//
#import "LifeCostAddNewCostViewModel.h"

@interface LifeCoseNewAddCoseVC () <UITextFieldDelegate>
//
@property (nonatomic,strong) UIButton *topTypeTitleBtn;
@property (nonatomic,strong) UILabel *topTypeTitleLabel;
@property (nonatomic,strong) UIButton *topCityBtn;
//
@property (nonatomic,strong) UIView *mainBackView;
@property (nonatomic,strong) UIView *oneBackView;
@property (nonatomic,strong) UIView *twoBackView;
@property (nonatomic,strong) UIButton *blueTipBtn;//
@property (nonatomic,strong) UILabel *titleOneL;
@property (nonatomic,strong) UILabel *concentOneL;
@property (nonatomic,strong) UIView *lineOneV;
@property (nonatomic,strong) UIImageView *rightSkipImg;
@property (nonatomic,strong) UIButton *concentOneTopClearnBtn;//
@property (nonatomic,strong) UILabel *titleTwoL;
@property (nonatomic,strong) UITextField *concentTwoTextF;//
@property (nonatomic,strong) UIView *lineTwoV;

//
@property (nonatomic,strong) UIView *centerBackView;
@property (nonatomic,strong) UILabel *centerTitleL;
@property (nonatomic,strong) UIButton *centerBtn;
//
@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UILabel *agreeL;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong)  LifeCostAddNewCompanyModel *companyModel;
@end

@implementation LifeCoseNewAddCoseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增缴费";
    [self initView];
    [self initNotice];
    [self initData];
}
- (void)initNotice{
    Y_NSNotificationCenter_Creat_NameAction(LifeCostPayChooseCompany_Notice_Name, noticeGetChooseCompany:)
    Y_NSNotificationCenter_Creat_NameAction(LifeCose_Group_ChooseOneGroup_Notice_Name, chooseGooupGetGroupInfo:)
}
- (void)noticeGetChooseCompany:(NSNotification *)notice{
    NSDictionary *userinfo = notice.userInfo;
    DLog(@"%@",userinfo[Notice_UserInfo_Key]);
    //
    self.companyModel = userinfo[Notice_UserInfo_Key];
    _concentOneL.text = [TextShowWithModelStr textShowWithModelStr: self.companyModel.name];
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(LifeCostPayChooseCompany_Notice_Name);
    Y_NSNotificationCenter_RemoveNotice_Name(LifeCose_Group_ChooseOneGroup_Notice_Name);
}
#pragma mark ==

- (void)initData{
//    self.addNewCostModel
 
     UIImageView *imgv = [[UIImageView alloc]init];
 
    [imgv sd_setImageWithURL:[UrlWithString getURLWithStr:[TextShowWithModelStr textShowWithModelStr:self.addNewCostModel.icon]]];
    [_topTypeTitleBtn setImage:imgv.image forState:UIControlStateNormal];;
    _topTypeTitleBtn.imageView.frame = CGRectMake(0, 0, 20, 20);
    _topTypeTitleBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _topTypeTitleLabel.text = [TextShowWithModelStr textShowWithModelStr:self.addNewCostModel.name];
    [_topCityBtn setTitle:@"重庆" forState:UIControlStateNormal];
}
#pragma mark ==
- (void)topCityBtnAction{
    NSLog(@"topCityBtnAction");
//    EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:@"item1"];
//    EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"2" itemName:@"item2"];
//    EBDropdownListItem *item3 = [[EBDropdownListItem alloc] initWithItem:@"3" itemName:@"item3"];
//    EBDropdownListItem *item4 = [[EBDropdownListItem alloc] initWithItem:@"4" itemName:@"item4"];
//    // 弹出框向下
//    EBDropdownListView *dropdownListView1 = [EBDropdownListView new];
//    dropdownListView1.dataSource = @[item1, item2, item3, item4];
//    dropdownListView1.frame = self.topCityBtn.frame;
//    dropdownListView1.selectedIndex = 1;
//    [dropdownListView1 setViewBorder:0.5 borderColor:[UIColor grayColor] cornerRadius:2];
//    [self.view addSubview:dropdownListView1];
//
//
//    [dropdownListView1 setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
//        NSString *msgString = [NSString stringWithFormat:
//                               @"selected name:%@  id:%@  index:%ld"
//                               , dropdownListView.selectedItem.itemName
//                               , dropdownListView.selectedItem.itemId
//                               , dropdownListView.selectedIndex];
//
//        [self.topCityBtn setTitle:msgString forState:UIControlStateNormal];
//    }];
}
- (void)concentOneTopClearnBtnAction{
    NSLog(@"选择缴费单位");
    LifeCosePayCompanyListVc *vc = [[LifeCosePayCompanyListVc alloc]init];
    vc.typeId = self.addNewCostModel.id;
    vc.cityId = 500000;
    [self pushVc:vc];
}
- (void)blueTipBtnAction{
    NSLog(@"blueTipBtnAction");
}
 
- (void)agreeBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}
#pragma mark == 选择分组
- (void)centerBtnAction{
    NSLog(@"选择分组");

    LifeCostChooseGroupVC *vc = [[LifeCostChooseGroupVC alloc]init];
    [self pushVc:vc];
}
//组名
- (void)chooseGooupGetGroupInfo:(NSNotification *)notice{
//    notice.userInfo
    NSString *groupNameStr =   [notice.userInfo objectForKey:Notice_UserInfo_Key];
    [self.centerBtn setTitle:groupNameStr forState:UIControlStateNormal];
}

#pragma mark == footBtnAction
- (void)footBtnAction{
    NSLog(@"footBtnAction");
    if (!self.agreeBtn.selected) {
        Y_SVP_SHOW_ERR_MES(@"未同意服务协议!");
        return;
    }
    if (self.concentOneL.text.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"缺少缴费单位");
        return;
    }
    if (self.concentTwoTextF.text.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"缺少户号");
        return;
    }
    if (self.centerBtn.titleLabel.text.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"缺少分组");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue: @(self.companyModel.companyId) forKey:@"companyId"];
    [parms setValue:self.concentTwoTextF.text forKey:@"familyId"];
    WEAKSELF
    [LifeCostAddNewCostViewModel addNewLifeCostPayWithParms:parms withBlock:^(NSDictionary * dic, BOOL success) {
        /**
         url=http://192.168.12.60:9527/api/v1/proprietor/livingpaymentquery/getPayDetails____{
            code = 0;
            data =     {
                accountBalance = "-39.95";
                address = "天王星b座1810";
                companyId = 12;
                companyName = "重庆朝天门供水有限公司";
                familyId = 11111111;
                familyName = "纵横世纪";
                typeId = 1;
            };
            message = "<null>";
        }
        (lldb)
         */
        if (success) {
            LifeCostMyCostDetailModel *getPaymodel =  [LifeCostMyCostDetailModel mj_objectWithKeyValues:dic];
            LifeCostMyCostModel *oldModel = [[LifeCostMyCostModel alloc]init];
            oldModel.companyId  = weakSelf.companyModel.companyId;
         
            dispatch_async(dispatch_get_main_queue(), ^{
                oldModel.familyId = [weakSelf.concentTwoTextF.text intValue];
                oldModel.groupName = weakSelf.centerBtn.titleLabel.text;
                
                LifeCoseNewPayInfoVc *vc = [[LifeCoseNewPayInfoVc alloc]init];
                vc.thisCostDetailmodel = getPaymodel;
                vc.listOldModel = oldModel;
                [weakSelf pushVc:vc];
            });
        }
        
    }];
}
#pragma mark ===
- (void)initView{
    [self.view addSubview:self.topTypeTitleBtn];
    [self.view addSubview:self.topTypeTitleLabel];
    [self.view addSubview:self.topCityBtn];
    [self.view addSubview:self.mainBackView];
    [self.view addSubview:self.centerBackView];
    [self.view addSubview:self.agreeBtn];
    [self.view addSubview:self.agreeL];
    [self.view addSubview:self.footerView];
    [self setUI];
}
- (void)setUI{
    [self setTopUI];
    [self setMainUI];
    [self setCenterUI];
    [self setBottomUI];
    
}
- (void)setTopUI{
    [_topTypeTitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTypeTitleBtn.superview.mas_top).offset(20);
        make.left.equalTo(_topTypeTitleBtn.superview.mas_left).offset(16);
        make.height.offset(20);
        make.width.offset(20);
    }];
    [_topTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topTypeTitleBtn.mas_right).offset(5);
        make.centerY.equalTo(_topTypeTitleBtn);
        make.height.offset(20);
    }];
    [_topCityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topTypeTitleBtn.mas_centerY);
        make.right.equalTo(_topCityBtn.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_mainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topCityBtn.mas_bottom).offset(20);
        make.left.equalTo(_topTypeTitleBtn.mas_left);
        make.right.equalTo(_topCityBtn.mas_right);
        make.height.equalTo(_mainBackView.superview).multipliedBy(0.5);
    }];
    [_centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainBackView.mas_bottom).offset(20);
        make.left.equalTo(_mainBackView.mas_left);
        make.right.equalTo(_mainBackView.mas_right);
        make.height.equalTo(_centerBackView.superview).multipliedBy(0.1);
    }];
   
}
//中心主内容
- (void)setMainUI{
    [self.mainBackView addSubview:self.oneBackView];
    [self.mainBackView addSubview:self.twoBackView];
    [self.mainBackView addSubview:self.blueTipBtn];
    [_oneBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneBackView.superview.mas_top).offset(0);
        make.left.equalTo(_oneBackView.superview.mas_left).offset(20);
        make.right.equalTo(_oneBackView.superview.mas_right).offset(-20);
        make.height.equalTo(_oneBackView.superview.mas_height).multipliedBy(0.4);
    }];
    [_twoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneBackView.mas_bottom).offset(1);
        make.left.equalTo(_twoBackView.superview.mas_left).offset(20);
        make.right.equalTo(_twoBackView.superview.mas_right).offset(-20);
        make.height.equalTo(_oneBackView.superview.mas_height).multipliedBy(0.4);
    }];
    [_blueTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_twoBackView.mas_bottom);
        make.bottom.equalTo(_blueTipBtn.superview.mas_bottom);
        make.right.equalTo(_blueTipBtn.superview.mas_right).offset(-20);
    }];
    //
    [self.oneBackView addSubview:self.titleOneL];
    [self.oneBackView addSubview:self.concentOneL];
    [self.oneBackView addSubview:self.lineOneV];
    [self.oneBackView addSubview:self.rightSkipImg];
    [self.oneBackView addSubview:self.concentOneTopClearnBtn];
    [_titleOneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleOneL.superview.mas_top).offset(20);
        make.left.equalTo(_titleOneL.superview.mas_left);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_concentOneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleOneL.mas_bottom);
        make.left.equalTo(_concentOneL.superview.mas_left);
        make.right.equalTo(_concentOneL.superview.mas_right);
        make.bottom.equalTo(_concentOneL.superview.mas_bottom);
    }];
    [_lineOneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_concentOneL.mas_bottom);
        make.left.equalTo(_concentOneL.mas_left);
        make.right.equalTo(_concentOneL.mas_right);
        make.height.offset(1);
    }];
    [_rightSkipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_concentOneL.mas_centerY);
        make.right.equalTo(_concentOneL.mas_right);
        make.width.offset(5);
        make.height.equalTo(_concentOneL.mas_height);
    }];
    [_concentOneTopClearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_concentOneL.mas_top);
        make.bottom.equalTo(_concentOneL.mas_bottom);
        make.left.equalTo(_concentOneL.mas_left);
        make.right.equalTo(_concentOneTopClearnBtn.superview.mas_right);
    }];
    //
    [self.twoBackView addSubview:self.titleTwoL];
    [self.twoBackView addSubview:self.concentTwoTextF];
    [self.twoBackView addSubview:self.lineTwoV];
    [_titleTwoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleTwoL.superview.mas_top).offset(20);
        make.left.equalTo(_titleTwoL.superview.mas_left);
        make.height.offset(20);
        make.width.offset(70);
    }];
    [_concentTwoTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleTwoL.mas_bottom);
        make.left.equalTo(_concentTwoTextF.superview.mas_left);
        make.right.equalTo(_concentTwoTextF.superview.mas_right);
        make.bottom.equalTo(_concentTwoTextF.superview.mas_bottom);
    }];
    [_lineTwoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_concentTwoTextF.mas_bottom).offset(0);
        make.left.equalTo(_concentTwoTextF.mas_left);
        make.right.equalTo(_concentTwoTextF.mas_right);
        make.height.offset(1);
    }];
    
}
//分组
- (void)setCenterUI{
    [self.centerBackView addSubview:self.centerTitleL];
    [self.centerBackView addSubview:self.centerBtn];
    [_centerTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerBackView.mas_centerY);
        make.left.equalTo(_centerBackView.mas_left).offset(20);
        make.height.equalTo(_centerBackView.mas_height);
        make.width.offset(70);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerBackView.mas_centerY);
        make.right.equalTo(_centerBackView.mas_right).offset(-20);
        make.height.equalTo(_centerBackView.mas_height);
    }];
}
//agree+footer
- (void)setBottomUI{
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerBackView.mas_bottom).offset(20);
        make.left.equalTo(_centerBackView.mas_left);
        make.height.offset(25);
        make.width.offset(25);
    }];
    [_agreeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_agreeBtn.mas_centerY);
        make.left.equalTo(_agreeBtn.mas_right).offset(5);
        make.right.equalTo(_centerBackView.mas_right);
        make.height.offset(30);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_agreeL.mas_bottom);
        make.left.equalTo(_agreeBtn.mas_left);
        make.right.equalTo(_agreeL.mas_right);
        make.height.offset(90);
    }];
}
#pragma mark ===== top
- (UIButton *)topTypeTitleBtn{
    if (!_topTypeTitleBtn) {
        _topTypeTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topTypeTitleBtn  setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _topTypeTitleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _topTypeTitleBtn;
}
- (UILabel *)topTypeTitleLabel{
    if (!_topTypeTitleLabel) {
        _topTypeTitleLabel = [[UILabel alloc]init];
        _topTypeTitleLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _topTypeTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _topTypeTitleLabel;
}
- (UIButton *)topCityBtn{
    if (!_topCityBtn) {
        _topCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topCityBtn  setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        _topCityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_topCityBtn addTarget:self action:@selector(topCityBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topCityBtn;
}
#pragma mark ===== main
- (UIView *)mainBackView{
    if (!_mainBackView ) {
        _mainBackView  = [[UIView alloc]init];
        _mainBackView.layer.cornerRadius = 10;
        _mainBackView.layer.masksToBounds = YES;
        _mainBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    }
    return _mainBackView;
}
- (UIView *)oneBackView{
    if (!_oneBackView) {
        _oneBackView = [[UIView alloc]init];
    }
    return _oneBackView;
}
- (UIView *)twoBackView{
    if (!_twoBackView) {
        _twoBackView = [[UIView alloc]init];
    }
    return _twoBackView;
}
#pragma mark ===== center
- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        _centerBackView.layer.cornerRadius = 10;
        _centerBackView.layer.masksToBounds = YES;
        _centerBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    }
    return _centerBackView;
}
#pragma mark ===== agree
- (UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"agreeNo"] selectedImg:[UIImage imageNamed:@"agreeYes"]];
        [_agreeBtn addTarget:self action:@selector(agreeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}
- (UILabel *)agreeL{
    if (!_agreeL) {
        _agreeL = [[UILabel alloc]init];
        _agreeL.attributedText = [self agreeLabelStr];
        _agreeL.numberOfLines = 2;
    }
    return _agreeL;
}
- (NSMutableAttributedString *)agreeLabelStr{
    NSString *agreeStrOne = @"我已阅读并同意";
    NSString *agreeStrTwo = @"《纵横世纪生活缴费服务协议》";
    NSString *agreeStrAll = @"我已阅读并同意《纵横世纪生活缴费服务协议》";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:agreeStrAll];
    //左对齐
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, agreeStrAll.length)];
    //前部分
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:14] range:NSMakeRange(0, agreeStrOne.length)];
    [attributedStr addAttribute: NSForegroundColorAttributeName value:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] range:NSMakeRange(0, agreeStrOne.length)];
    //后部分
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:14] range:NSMakeRange(agreeStrOne.length, agreeStrTwo.length)];
    [attributedStr addAttribute: NSForegroundColorAttributeName value: Y_RGBA(38, 114, 249, 1) range:NSMakeRange(agreeStrOne.length, agreeStrTwo.length)];
    return attributedStr;

}
#pragma mark ===== footer
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerView.footerBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_footerView setBtnFram:CGRectMake(16, 0, Screen_W-32, 50)];
        [_footerView.footerBtn addTarget:self action:@selector(footBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
#pragma mark ===== main subview_one
- (UILabel *)titleOneL{
    if (!_titleOneL) {
        _titleOneL = [[UILabel alloc]init];
        _titleOneL.text = @"缴费单位";
        _titleOneL.font = [UIFont boldSystemFontOfSize:14];
        _titleOneL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleOneL;
}
- (UILabel *)concentOneL{
    if (!_concentOneL) {
        _concentOneL  = [[UILabel alloc]init];
        _concentOneL.text = @"";
        _concentOneL.textColor = [ThemeManager shareManager].mainTextColor;
        _concentOneL.font = [UIFont boldSystemFontOfSize:16];
    }
    return _concentOneL;
}
- (UIImageView *)rightSkipImg{
    if (!_rightSkipImg) {
        _rightSkipImg = [[UIImageView alloc]init];
        _rightSkipImg.image = [UIImage imageNamed:@"skip"];
        _rightSkipImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightSkipImg;
}
- (UIView *)lineOneV{
    if (!_lineOneV) {
        _lineOneV = [[UIView alloc]init];
        _lineOneV.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.1];
    }
    return _lineOneV;
}
- (UIButton *)concentOneTopClearnBtn{
    if (!_concentOneTopClearnBtn ) {
        _concentOneTopClearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_concentOneTopClearnBtn addTarget:self action:@selector(concentOneTopClearnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _concentOneTopClearnBtn;
}

#pragma mark ===== main subview_two
- (UILabel *)titleTwoL{
    if (!_titleTwoL) {
        _titleTwoL = [[UILabel alloc]init];
        _titleTwoL.text = @"缴费户号";
        _titleTwoL.font = [UIFont boldSystemFontOfSize:14];
        _titleTwoL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleTwoL;
}
- (UITextField *)concentTwoTextF{
    if (!_concentTwoTextF) {
        _concentTwoTextF = [[UITextField alloc]init];
        _concentTwoTextF.textColor = [ThemeManager shareManager].mainTextColor;
        _concentTwoTextF.font = [UIFont boldSystemFontOfSize:16];
         NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入缴费户号" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]}];
        _concentTwoTextF.attributedPlaceholder = placeholderString;
        _concentTwoTextF.delegate = self;
    }
    return _concentTwoTextF;
}
- (UIView *)lineTwoV{
    if (!_lineTwoV) {
        _lineTwoV = [[UIView alloc]init];
        _lineTwoV.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.1];
    }
    return _lineTwoV;
}
- (UIButton *)blueTipBtn{
    if (!_blueTipBtn) {
        _blueTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _blueTipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_blueTipBtn setTitleColor: Y_RGBA(13, 109, 252, 1) forState:UIControlStateNormal];
        [_blueTipBtn setTitle:@"如何查询户号?" forState:UIControlStateNormal];
        [_blueTipBtn addTarget:self action:@selector(blueTipBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blueTipBtn;
}
 
#pragma mark ===== center subview
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        [_centerBtn setTitle:@"选择和新增分组" forState:UIControlStateNormal];
        [_centerBtn setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(centerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _centerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_centerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
    }
    return _centerBtn;
}
- (UILabel *)centerTitleL{
    if (!_centerTitleL) {
        _centerTitleL = [[UILabel alloc]init];
        _centerTitleL.text = @"分组";
        _centerTitleL.font = [UIFont systemFontOfSize:14];
        _centerTitleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _centerTitleL;
}
 

@end

