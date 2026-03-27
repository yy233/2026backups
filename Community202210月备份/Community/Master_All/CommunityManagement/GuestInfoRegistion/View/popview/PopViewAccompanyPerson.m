//
//  PopViewAccompanyPerson.m
//  Community
//
//  Created by 余莹 on 2020/12/8.
//

#import "PopViewAccompanyPerson.h"
@interface PopViewAccompanyPerson ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *oneBackV;
@property (nonatomic,strong) UIView *twoBackV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) GuestInfoModel *dataSourceOfPersonIsSaveToEditModle;//不能变地址strong //存旧model 修改时用
@property (nonatomic,strong) GuestInfoModel *addModle;//添加时用的

@end
@implementation PopViewAccompanyPerson
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
    }
    return self;
}
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
  
    if (dataSourceArr.count==1) {//修改按钮 有元素的情况 model
        _dataSourceOfPersonIsSaveToEditModle = dataSourceArr.firstObject;
        _nameTextField.text = _dataSourceOfPersonIsSaveToEditModle.name;
        _phoneField.text = _dataSourceOfPersonIsSaveToEditModle.mobile;
        _titleLabel.text = @"修改人员信息";
        [_okBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    }else{//添加 的 情况
        _titleLabel.text = @"新增随行人员";
        [_okBtn setTitle:@"确定新增人员" forState:UIControlStateNormal];
    }
}

- (void)okBtnAction:(UIButton *)sender{
    if (_nameTextField.text.length==0 || _phoneField.text.length==0) {
        Y_SVP_SHOW_ERR_MES(@"缺少数据");
        return;
    }
    _addModle = [[GuestInfoModel alloc]init];
    _addModle.name = _nameTextField.text;
    _addModle.mobile = _phoneField.text;
    if (_dataSourceOfPersonIsSaveToEditModle != nil) {//修改按钮 有元素的情况 model
        
        if (_delegate && [_delegate respondsToSelector:@selector(personRemoveOldGuestInfoModel:addNewInfoModel:)]) {
            [_delegate personRemoveOldGuestInfoModel:_dataSourceOfPersonIsSaveToEditModle addNewInfoModel:_addModle];
        }
    }else{//添加情况
        if (_delegate && [_delegate respondsToSelector:@selector(personAddNewInfoWithGuestInfoModel:)]) {
            [_delegate personAddNewInfoWithGuestInfoModel:_addModle];
        }
    }
    [self dismissThePopView];
}

#pragma mark ==
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.titleLabel];
    
    [self.subMainBackView addSubview:self.oneBackV];
    [self.oneBackV addSubview:self.nameLabel];
    [self.oneBackV addSubview:self.nameTextField];
    
    [self.subMainBackView addSubview:self.twoBackV];
    [self.twoBackV addSubview:self.phoneLabel];
    [self.twoBackV addSubview:self.phoneField];
    
    [self.subMainBackView addSubview:self.okBtn];
}

- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(15);
        make.height.offset(20);
        make.left.equalTo(_titleLabel.superview.mas_left);
        make.right.equalTo(_titleLabel.superview.mas_right);
    }];
    [_oneBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(15);
        make.left.equalTo(_titleLabel.mas_left).offset(16);
        make.right.equalTo(_titleLabel.mas_right).offset(-16);
        make.height.offset(50);
    }];
    [_twoBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneBackV.mas_bottom).offset(5);
        make.left.equalTo(_titleLabel.mas_left).offset(16);
        make.right.equalTo(_titleLabel.mas_right).offset(-16);
        make.height.offset(50);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel.superview.mas_centerY);
        make.left.equalTo(_nameLabel.superview.mas_left);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_phoneLabel.superview.mas_centerY);
        make.left.equalTo(_phoneLabel.superview.mas_left);
        make.width.offset(50);
        make.height.offset(30);
    }];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameTextField.superview.mas_centerY);
        make.left.equalTo(_nameLabel.mas_right).offset(5);
        make.right.equalTo(_nameTextField.superview.mas_right);
        make.height.offset(30);
    }];
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_phoneField.superview.mas_centerY);
        make.left.equalTo(_phoneLabel.mas_right).offset(5);
        make.right.equalTo(_phoneField.superview.mas_right);
        make.height.offset(30);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_okBtn.superview.mas_left).offset(16);
        make.right.equalTo(_okBtn.superview.mas_right).offset(-16);
        make.height.offset(44);
        make.bottom.equalTo(_okBtn.superview.mas_bottom).offset(-30);
    }];
}

#pragma mark == get
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"新增随行人员";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIView *)oneBackV{
    if (!_oneBackV) {
        _oneBackV = [[UIView alloc]init];
    }
    return _oneBackV;
}
- (UIView *)twoBackV{
    if (!_twoBackV) {
        _twoBackV = [[UIView alloc]init];
    }
    return _twoBackV;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"姓名";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = @"电话";
        _phoneLabel.textColor = [UIColor blackColor];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
    }
    return _phoneLabel;
}

- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.placeholder = @"输入姓名";
        _nameTextField.font = [UIFont systemFontOfSize:15];
    }
    return _nameTextField;
}

- (UITextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[UITextField alloc]init];
        _phoneField.placeholder = @"输入电话";
        _phoneField.font = [UIFont systemFontOfSize:15];
    }
    return _phoneField;
}

- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.layer.cornerRadius = 22;//h44
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_okBtn setBackgroundColor:Y_RGBA(38, 114, 249, 1)];
        [_okBtn setTitle:@"确定新增人员" forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _okBtn;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = 250;
}

@end
