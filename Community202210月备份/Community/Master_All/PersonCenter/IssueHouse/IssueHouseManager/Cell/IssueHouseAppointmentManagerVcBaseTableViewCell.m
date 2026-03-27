//
//  IssueHouseAppointmentManagerVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import "IssueHouseAppointmentManagerVcBaseTableViewCell.h"

#define Type_Color [Tool getColorWithHexString:@"#2672F9"]

@interface IssueHouseAppointmentManagerVcBaseTableViewCell ()
@property (nonatomic,strong) IssueHouseAppointmentManagerVcModel *model;//selfmodel
@property (nonatomic,strong) HouseRentListVcHouseCellModel *subViewInfoModel;
@end

@implementation IssueHouseAppointmentManagerVcBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}
#pragma mark ===

- (void)fillDataWithModle:(IssueHouseAppointmentManagerVcModel *)model{
    self.titleL.text = model.houseLeaseMode;//  model.houseTitle;
    self.model = model;
    [self centerModeDeal];
}
- (void)centerModeDeal{
    NSDictionary *modeDic = [self.model mj_keyValues];
    self.subViewInfoModel = [HouseRentListVcHouseCellModel mj_objectWithKeyValues:modeDic];
    //改字段数据
    self.subViewInfoModel.houseImage = self.model.houseImageUrl;          //图片arr字段不一样
    NSString *squareMeterNumStr =  [[TextShowWithModelStr textShowWithModelStr:self.model.houseSquareMeter] stringByReplacingOccurrencesOfString:@"m²" withString:@""];
    self.subViewInfoModel.houseSquareMeter = [squareMeterNumStr doubleValue];//面积
    self.subViewInfoModel.houseAddress = self.model.houseCommunityName;   //地址
    //赋
    self.centerInfoV.houseCellmodel = self.subViewInfoModel;
}
- (HouseRentListVcHouseCellModel *)subViewInfoModel{
    if (!_subViewInfoModel) {
        _subViewInfoModel = [[HouseRentListVcHouseCellModel alloc]init];
    }
    return _subViewInfoModel;
}
#pragma mark ===
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        //
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.typeL];
        [self.backView addSubview:self.lineV];
        //
        [self.backView addSubview:self.centerInfoBackView];
        [self.centerInfoBackView addSubview:self.centerInfoV];
        //
        [self.backView addSubview:self.bottomBackView];
        [self.bottomBackView addSubview:self.acceptBtn];
        [self.bottomBackView addSubview:self.cancelBtn];
        [self.bottomBackView addSubview:self.finishBtn];
        [self setUI];
        
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview).offset(10);
        make.top.equalTo(_titleL.superview).offset(0);
        make.height.offset(40);
        make.right.equalTo(_titleL.superview).offset(-65);
    }];
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_titleL);
        make.right.equalTo(_typeL.superview.mas_right).offset(-10);
        make.width.offset(50);
    }];
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL);
        make.right.equalTo(_typeL);
        make.height.offset(1);
        make.top.equalTo(_titleL.mas_bottom);
    }];
    //
    [_centerInfoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineV.mas_bottom).offset(5);
        make.left.right.equalTo(_centerInfoBackView.superview);
        make.height.offset(90);
    }];
    [_centerInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_centerInfoV.superview);
    }];
    //
    [_bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerInfoV.mas_bottom);
        make.bottom.equalTo(_bottomBackView.superview.mas_bottom);
        make.left.right.equalTo(_lineV);
    }];
    [_acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_acceptBtn.superview).offset(-10);
        make.width.offset(80);
        make.height.offset(30);
        make.centerY.equalTo(_cancelBtn.superview);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_acceptBtn);
    }];
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_acceptBtn);
    }];
}
#pragma mark ==

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font =[UIFont systemFontOfSize:15];
        _titleL.textColor = Color_51BlackColor;
    }
    return _titleL;
}
- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.font =[UIFont systemFontOfSize:13];
        _typeL.textColor = Type_Color;
        _typeL.textAlignment = NSTextAlignmentRight;
    }
    return _typeL;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = Color_238GrayColor;
    }
    return _lineV;
}
//
- (UIView *)centerInfoBackView{
    if (!_centerInfoBackView) {
        _centerInfoBackView = [[UIView alloc]init];
    }
    return _centerInfoBackView;
}
- (HouseRentHouseTableViewCell *)centerInfoV{
    if (!_centerInfoV) {
        _centerInfoV = [[HouseRentHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyle"];
        _centerInfoV.titleLabel.textColor = Color_51BlackColor;
    }
    return _centerInfoV;
}
//
- (UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc]init];
    }
    return _bottomBackView;
}
- (UIButton *)acceptBtn{
    if (!_acceptBtn) {
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_acceptBtn  newAnBtnWithTextStr:@"接受预约"];
        [_acceptBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
        [_acceptBtn newAnBtnWithTextColor:Color_38BlueColor];
        [_acceptBtn newAnBtnWithLayerCorNerNum:15 withLayerLineWidth:0.5 withLayerLineColor:Color_38BlueColor];
        [_acceptBtn addTarget:self action:@selector(acceptBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn  newAnBtnWithTextStr:@"取消预约"];
        [_cancelBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
        [_cancelBtn newAnBtnWithTextColor:Color_138GrayColor];
        [_cancelBtn newAnBtnWithLayerCorNerNum:15 withLayerLineWidth:0.5 withLayerLineColor:Color_138GrayColor];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn  newAnBtnWithTextStr:@"完成看房"];
        [_finishBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
        [_finishBtn newAnBtnWithTextColor:Color_38BlueColor];
        [_finishBtn newAnBtnWithLayerCorNerNum:15 withLayerLineWidth:0.5 withLayerLineColor:Color_38BlueColor];
        [_finishBtn addTarget:self action:@selector(finishLookHouseBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _finishBtn;
}
//房主接受预约
- (void)acceptBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTouchAcceptBtnWithModel:)]) {
        [_delegate cellTouchAcceptBtnWithModel:self.model];
    }
}
//房主取消预约 +//租客取消预约
- (void)cancelBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTouchCancelBtnWithModle:)]) {
        [_delegate cellTouchCancelBtnWithModle:self.model];
    }
}
//租客完成看房
- (void)finishLookHouseBtnBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTouchFinishLookHouseBtnWithModle:)]) {
        [_delegate cellTouchFinishLookHouseBtnWithModle:self.model];
    }
}

@end

#pragma mark == 待处理
@implementation IssueHouseAppointmentManagerVcWillDealTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeL.text = @"待处理";
        self.typeL.textColor = Color_38BlueColor;
        self.finishBtn.hidden = YES;
    }
    return self;
}
- (void)zuKeIsShowCancelBtn{
    self.cancelBtn.hidden = NO;
    self.acceptBtn.hidden = YES;
}
- (void)fangDngIsShowAcceptBtn{
    self.cancelBtn.hidden = YES;
    self.acceptBtn.hidden = NO;
}
@end

#pragma mark == 待看房
@implementation IssueHouseAppointmentManagerVcWillLookHouseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeL.text = @"待看房";
        self.typeL.textColor = Color_38BlueColor;
        self.acceptBtn.hidden = YES;
     
    }
    return self;
}
- (void)zuKeIsShowFinishLookHouseOkBtn{
    self.finishBtn.hidden = NO;
    self.cancelBtn.hidden = YES;
}
- (void)fangDngIsShowCancelBtn{
    self.finishBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
}
@end

#pragma mark == 已取消
@implementation IssueHouseAppointmentManagerVcIsCancelledTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeL.text = @"已取消";
        self.typeL.textColor = Color_138GrayColor;
        self.cancelBtn.hidden = YES;
        self.finishBtn.hidden = YES;
        self.acceptBtn.hidden = YES;
    }
    return self;
}
@end

#pragma mark == 已完成
@implementation IssueHouseAppointmentManagerVcEndTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeL.text = @"已完成";
        self.typeL.textColor = Color_138GrayColor;
        self.cancelBtn.hidden = YES;
        self.finishBtn.hidden = YES;
        self.acceptBtn.hidden = YES;
    }
    return self;
}
@end
