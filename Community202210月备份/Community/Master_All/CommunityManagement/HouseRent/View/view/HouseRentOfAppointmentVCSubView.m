//
//  HouseRentOfAppointmentVCSubView.m
//  Community
//
//  Created by 余莹 on 2021/3/30.
//

#import "HouseRentOfAppointmentVCSubView.h"
#import "HouseRentHouseTableViewCell.h"
#define  TimesBtn_Tag      200
#define  TimesBtn_W      ((Screen_W-32-20)/4)-10
#define  TimesBtn_H      (30)
@interface HouseRentOfAppointmentVCSubView ()
@property (nonatomic,strong) UILabel *topTipLabel;
@property (nonatomic,strong) UIView *topBackView;
@property (nonatomic,strong) UIView *centerBackView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
//
@property (nonatomic,strong) HouseRentHouseTableViewCell *topInfoView;
//
@property (nonatomic,strong) UILabel *centerOneTitleL;
@property (nonatomic,strong) UIButton *centerOneBtn;
@property (nonatomic,strong) UILabel *centerOneContentL;
@property (nonatomic,strong) UIView *centerLineView;
//
@property (nonatomic,strong) UILabel *centerTwoTitleL;
@property (nonatomic,strong) UIView *stayInTimeBtnsBackView;
@property (nonatomic,strong) NSArray *stayInTimesTitleArr;

@end


@implementation HouseRentOfAppointmentVCSubView
//初info data
- (void)fillDataWithIsHouseModel:(HouseRentListVcHouseCellModel *)model{
    _topInfoView.houseCellmodel  = model;
}
//选后的预约str
- (void)changYuyueTimeWithStr:(NSString *)showYuyueTimeStr{
    self.centerOneContentL.text = showYuyueTimeStr;
    if (showYuyueTimeStr.length>0) {
        [self.centerOneBtn newAnBtnWithTextColor:[UIColor clearColor]];//透明色
    }
}

#pragma mark == action
- (void)okAction{
    if (_delegate && [_delegate respondsToSelector:@selector(footerViewOkAction)]) {
        [_delegate footerViewOkAction];
    }
}
- (void)chooseTimesBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchTimesChooseBtnAction)]) {
        [_delegate touchTimesChooseBtnAction];
    }
}
#pragma mark ==
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Screen_H-KNavBarHeight);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topTipLabel];
        [self addSubview:self.topBackView];
        [self addSubview:self.centerBackView];
        [self addSubview:self.footerView];
        //
        [self.topBackView addSubview:self.topInfoView];
        //
        [self.centerBackView addSubview:self.centerOneTitleL];//看房时间
        [self.centerBackView addSubview:self.centerOneBtn];
        [self.centerBackView addSubview:self.centerOneContentL];
        [self.centerBackView addSubview:self.centerLineView];
        //
        [self.centerBackView addSubview:self.centerTwoTitleL];
        [self.centerBackView addSubview:self.stayInTimeBtnsBackView];//入住时间
        //
        [self setUI];
        
    }
    return self;
}

- (void)setUI{
    [_topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_topTipLabel.superview);
        make.height.offset(35);
    }];
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBackView.superview).offset(16);
        make.right.equalTo(_topBackView.superview).offset(-16);
        make.top.equalTo(_topTipLabel.mas_bottom).offset(15);
        make.height.offset(100);
    }];
    [_centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBackView);
        make.right.equalTo(_topBackView);
        make.top.equalTo(_topBackView.mas_bottom).offset(10);
        make.height.offset(150);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.bottom.equalTo(_footerView.superview);
        make.height.offset(90);
    }];
    //
    [_topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topInfoView.superview);
    }];
    [self setCenterOneUI];
    [self setCenterTwoUI];
    [self addStayInTimeBtnsUI];
}
- (void)setCenterOneUI{
    [_centerOneTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerOneTitleL.superview).offset(10);
        make.top.equalTo(_centerOneTitleL.superview).offset(10);
        make.width.offset(70);
        make.height.offset(20);
    }];
    [_centerOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_centerOneTitleL.superview).offset(-10);
        make.top.equalTo(_centerOneTitleL.superview).offset(10);
        make.width.offset(85);
        make.height.offset(20);
    }];
    [_centerOneContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_centerOneTitleL.superview).offset(-20);
        make.top.equalTo(_centerOneTitleL.superview).offset(10);
        make.left.equalTo(_centerOneTitleL.mas_right).offset(10);
        make.height.offset(20);
    }];
    [_centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerOneTitleL);
        make.right.equalTo(_centerOneBtn);
        make.height.offset(1);
        make.top.equalTo(_centerOneTitleL.mas_bottom).offset(10);
    }];
}
- (void)setCenterTwoUI{
    [_centerTwoTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerLineView);
        make.top.equalTo(_centerLineView.mas_bottom);
        make.height.offset(30);
    }];
    [_stayInTimeBtnsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerTwoTitleL);
        make.top.equalTo(_centerTwoTitleL.mas_bottom);
        make.bottom.equalTo(_stayInTimeBtnsBackView.superview);
    }];
}
//入住时间
- (void)addStayInTimeBtnsUI{
    [self.stayInTimeBtnsBackView.subviews respondsToSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.stayInTimesTitleArr.count; i++ ) {
        UIButton *timesBtn = [self timeBaseBtn];
        [timesBtn newAnBtnWithTextStr:self.stayInTimesTitleArr[i]];
        timesBtn.tag = TimesBtn_Tag +i;
        timesBtn.frame = CGRectMake(i*(10+TimesBtn_W), 10, TimesBtn_W, TimesBtn_H);
        [self.stayInTimeBtnsBackView addSubview:timesBtn];
    }
}

- (UIButton *)timeBaseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn newAnBtnWithTextColor:[UIColor whiteColor]];
    [btn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
    //
    [btn newAnBtnWithBackColor: [Tool getColorWithHexString:@"#153877"]];
    [btn addTarget:self action:@selector(subTimesBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
#pragma mark ==
- (void)subTimesBtnAction:(UIButton *)sender{
    DLog(@"");
    if (sender.selected==YES) {
        return;
    }
    for (UIButton *subBtn in self.stayInTimeBtnsBackView.subviews) {
        if (subBtn.tag == sender.tag) {//选的
            [subBtn newAnBtnWithBackColor:Color_38BlueColor];
            [subBtn newAnBtnWithLayerCorNerNum:1 withLayerLineWidth:1 withLayerLineColor:[UIColor whiteColor]];
        }else{//置成非选
            [subBtn newAnBtnWithBackColor: [Tool getColorWithHexString:@"#153877"]];
            [subBtn newAnBtnWithLayerCorNerNum:1 withLayerLineWidth:1 withLayerLineColor:[UIColor clearColor]];
        }
    }
    NSInteger index = sender.tag-TimesBtn_Tag;
    if (_delegate && [_delegate respondsToSelector:@selector(chooseStayInTimeIndex:)]) {
        [_delegate chooseStayInTimeIndex:(index+1)];//传参数为1234
    }
}
#pragma mark ==

- (UILabel *)topTipLabel{
    if (!_topTipLabel) {
        _topTipLabel = [[UILabel alloc]init];
        _topTipLabel.backgroundColor = [[Tool getColorWithHexString:@"#2672F9"] colorWithAlphaComponent:0.15];
        _topTipLabel.textColor = [Tool getColorWithHexString:@"#86B2FF"];
        _topTipLabel.font = [UIFont systemFontOfSize:13];
        _topTipLabel.text = @"     提交预约后房东会电话联系你，请保持手机通畅";
    }
    return _topTipLabel;
}
- (UIView *)topBackView{//HouseRentHouseTableViewCell
    if (!_topBackView) {
        _topBackView  = [[UIView alloc]init];
        _topBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;//带不同主题色
        _topBackView.layer.cornerRadius = 5;
        _topBackView.layer.masksToBounds = YES;
    }
    return _topBackView;
}
- (UIView *)centerBackView{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        _centerBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;//带不同主题色
        _centerBackView.layer.cornerRadius = 5;
        _centerBackView.layer.masksToBounds = YES;
    }
    return _centerBackView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(16, 0, Screen_W-32, 90)];
        [_footerView.footerBtn setTitle:@"提交预约" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

#pragma mark = sub view
- (HouseRentHouseTableViewCell *)topInfoView{
    if (!_topInfoView) {
        _topInfoView = [[HouseRentHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HouseRentHouseTableViewCell"];
    }
    return _topInfoView;
}
- (UILabel *)centerOneTitleL{
    if (!_centerOneTitleL) {
        _centerOneTitleL = [[UILabel alloc]init];
        _centerOneTitleL.text = @"看房时间";
        _centerOneTitleL.textColor = [ThemeManager shareManager].mainTextColor;
        _centerOneTitleL.font = [UIFont systemFontOfSize:15];
   
    }
    return _centerOneTitleL;
}

- (UILabel *)centerOneContentL{
    if (!_centerOneContentL) {
        _centerOneContentL = [[UILabel alloc]init];
        _centerOneContentL.font  = [UIFont systemFontOfSize:15];
        _centerOneContentL.textColor  = [ThemeManager shareManager].mainTextColor;
        _centerOneContentL.textAlignment = NSTextAlignmentRight;
    }
    return _centerOneContentL;
}

- (UIButton *)centerOneBtn{
    if (!_centerOneBtn) {
        _centerOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerOneBtn newAnBtnWithTextStr:@"请选择时间"];
        [_centerOneBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_centerOneBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_centerOneBtn newAnBtnWithImg:[UIImage imageNamed:@"skip"]];
        [_centerOneBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [_centerOneBtn addTarget:self action:@selector(chooseTimesBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerOneBtn;
}
- (UIView *)centerLineView{
    if (!_centerLineView) {
        _centerLineView = [[UIView alloc]init];
        _centerLineView.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.3];
    }
    return _centerLineView;
}
- (UILabel *)centerTwoTitleL{
    if (!_centerTwoTitleL) {
        _centerTwoTitleL = [[UILabel alloc]init];
        _centerTwoTitleL.text = @"入住时间";
        _centerTwoTitleL.textColor = [ThemeManager shareManager].mainTextColor;
        _centerTwoTitleL.font = [UIFont systemFontOfSize:15];
    }
    return _centerTwoTitleL;
}
- (UIView *)stayInTimeBtnsBackView{
    if (!_stayInTimeBtnsBackView) {
        _stayInTimeBtnsBackView = [[UIView alloc]init];
    }
    return _stayInTimeBtnsBackView;
}
- (NSArray *)stayInTimesTitleArr{
    if (!_stayInTimesTitleArr) {
        _stayInTimesTitleArr = [[NSArray alloc]initWithObjects:@"1周内",@"1-2周内",@"2-4周内",@"1个月之后", nil];//传参数为1234
    }
    return _stayInTimesTitleArr;
}
@end
