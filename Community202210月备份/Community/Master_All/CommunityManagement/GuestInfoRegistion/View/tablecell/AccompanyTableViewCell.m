//
//  AccompanyTableViewCell.m
//  Community
//  访客随行的车辆cell和人员cell
//  Created by 余莹 on 2020/12/8.
//

#import "AccompanyTableViewCell.h"
#define Tag_EdiBtn_Person 500
#define Tag_EdiBtn_Car 600
#define Tag_SelectedType_Person 700
#define Tag_SelectedType_Car 800
@interface AccompanyTableViewCell ()
//@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UIImageView *headImgV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *titleContentLabel;
@property (nonatomic,strong) UILabel *detailContentLabel;
//@property (nonatomic,strong) UIButton *editorBtn;
//@property (nonatomic,strong) UIButton *isSelectedTypeBtn;
 
@end

@implementation AccompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}
#pragma mark == type change
- (void)isSelectedType{
    _isSelectedTypeBtn.hidden = NO;
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top);
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.height.offset(20);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-135);//（50+15）btn +5间隔 -----60+5的isSelectedTypeBtn——w
    }];
    [_detailContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_detailContentLabel.superview.mas_right).offset(-135);//（50+15）btn +5间隔
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.offset(20);
    }];
}
- (void)isNomailType{
    _isSelectedTypeBtn.hidden = YES;
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top);
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.height.offset(20);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-70);//（50+15）btn +5间隔
    }];
    [_detailContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_detailContentLabel.superview.mas_right).offset(-70);//（50+15）btn +5间隔
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.offset(20);
    }];
}

#pragma mark == data
-(void)prepareForReuse{
    [super prepareForReuse];
    _titleLabel.text = @"";
    _detailContentLabel.text = @"";
    _headImgV.image = nil;
}
- (void)setPersonModel:(GuestInfoModel *)personModel{
    _personModel = personModel;
    _titleLabel.text = _personModel.name;
    _detailContentLabel.text = _personModel.mobile;
    _headImgV.image = [UIImage imageNamed:@"person"];
    _editorBtn.tag = Tag_EdiBtn_Person;
    _isSelectedTypeBtn.tag  = Tag_SelectedType_Person;
}
- (void)setCarModel:(CarInfoModel *)carModel{//待改model 类型
    _carModel = carModel;
    _titleLabel.text = _carModel.carPlate;
//    _detailContentLabel.text = _carModel.type.name;
    _detailContentLabel.text = _carModel.carTypeStr;
    _headImgV.image = [UIImage imageNamed:@"car"];
    _editorBtn.tag = Tag_EdiBtn_Car;
    _isSelectedTypeBtn.tag  = Tag_SelectedType_Car;
}
#pragma mark == delegate
- (void)editorBtnAction:(UIButton *)sender{//修改按钮
    if (sender.tag==Tag_EdiBtn_Person) {
        if (_delegate && [_delegate respondsToSelector:@selector(cellRightBtnTouchGuest:)]){
            if (isNotNil(_personModel)) {
                [_delegate cellRightBtnTouchGuest:_personModel];
            }
        }
    }
    if (sender.tag==Tag_EdiBtn_Car) {
        if (_delegate && [_delegate respondsToSelector:@selector(cellRightBtnTouchCar:)]) {
            if (isNotNil(_carModel)) {
                [_delegate cellRightBtnTouchCar:_carModel];
            }
        }
    }
   
}
#pragma mark == delegate
- (void)selectedTypeBtnAction:(UIButton *)sender{
    if (sender.tag==Tag_SelectedType_Person) {
        if (_delegate && [_delegate respondsToSelector:@selector(cellSelectedTypeBtnTouchGuest:)]){
            if (isNotNil(_personModel)) {
                [_delegate cellSelectedTypeBtnTouchGuest:_personModel];
            }
        }
    }
    if (sender.tag==Tag_SelectedType_Car) {
        if (_delegate && [_delegate respondsToSelector:@selector(cellSelectedTypeBtnTouchCar:)]) {
            if (isNotNil(_carModel)) {
                [_delegate cellSelectedTypeBtnTouchCar:_carModel];
            }
        }
    }
}
- (void)cellSelectedTypeBtnTouchCar:(CarInfoModel *)model{
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor  = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.headImgV];
        [self.backGroundV addSubview:self.titleLabel];
        [self.backGroundV addSubview:self.detailContentLabel];
        [self.backGroundV addSubview:self.editorBtn];
        [self.backGroundV addSubview:self.isSelectedTypeBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    _titleLabel.text = @"姓名姓名";
    _detailContentLabel.text = @"电话";
  
    //cell70 self80
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.superview.mas_centerY);
        make.centerX.equalTo(_backGroundV.superview.mas_centerX);
        make.width.equalTo(_backGroundV.superview.mas_width).offset(-32);
        make.height.offset(70.0);
    }];
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.superview.mas_centerY);
        make.left.equalTo(_headImgV.superview.mas_left).offset(15);
        make.width.offset(36);
        make.height.equalTo(_headImgV.mas_width);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top);
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.height.offset(20);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-70);//（50+15）btn +5间隔
    }];
 
    [_detailContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_detailContentLabel.superview.mas_right).offset(-70);//（50+15）btn +5间隔
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.offset(20);
    }];
    
    [_editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImgV.mas_centerY).offset(0);
        make.right.equalTo(_editorBtn.superview.mas_right).offset(-15);
        make.width.offset(50);
        make.height.offset(30);
    }];
    //
    [_isSelectedTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_editorBtn.mas_left).offset(-65);//
        make.centerY.equalTo(_editorBtn.mas_centerY);
        make.height.offset(20);
        make.width.offset(60);
    }];
}
#pragma mark ===
- (UIView *)backGroundV{
    if (!_backGroundV) {
        _backGroundV = [[UIView alloc]init];
        _backGroundV.layer.cornerRadius = 5;
        _backGroundV.backgroundColor = [UIColor clearColor];
    }
    return _backGroundV;
}
- (UIImageView *)headImgV{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc]init];
        _headImgV.contentMode = UIViewContentModeScaleAspectFit;
//        _headImgV.layer.borderWidth = 1;
//        _headImgV.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _headImgV.layer.cornerRadius = 18;//35h-36
//        _headImgV.layer.masksToBounds = YES;
        [_headImgV zy_cornerRadiusAdvance:18 rectCornerType:UIRectCornerAllCorners];
        [_headImgV zy_attachBorderWidth:1.0 color:[UIColor lightGrayColor]];


    }
    return _headImgV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}

- (UILabel *)detailContentLabel{
    if (!_detailContentLabel) {
        _detailContentLabel = [[UILabel alloc]init];
        _detailContentLabel.font = [UIFont systemFontOfSize:12];
        _detailContentLabel.textColor = [ThemeManager shareManager].mainTexDetailLightBluetColor;
    }
    return _detailContentLabel;
}

- (UIButton *)editorBtn{
    if (!_editorBtn) {
        _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editorBtn.layer.cornerRadius = 15;//50h 30w
        _editorBtn.layer.masksToBounds = YES;
         _editorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editorBtn addTarget:self action:@selector(editorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editorBtn;
}
- (UIButton *)isSelectedTypeBtn{
    if(!_isSelectedTypeBtn){
        _isSelectedTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _isSelectedTypeBtn.layer.cornerRadius = 10;//60h 20w
        _isSelectedTypeBtn.layer.borderWidth = 0.5;
        _isSelectedTypeBtn.layer.borderColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5].CGColor;
        _isSelectedTypeBtn.layer.masksToBounds = YES;
        _isSelectedTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_isSelectedTypeBtn setTitle:@"取消随行" forState:UIControlStateNormal];
        [_isSelectedTypeBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_isSelectedTypeBtn addTarget:self action:@selector(selectedTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _isSelectedTypeBtn.hidden = YES;
    }
    return _isSelectedTypeBtn;
}
@end
