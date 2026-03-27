//
//  PopViewAccomPanyCar.m
//  Community
//
//  Created by 余莹 on 2020/12/9.
//

#import "PopViewAccomPanyCar.h"
#import "CarTypeChooseBtn.h"
 
#define W_CarSubBtn 80
#define H_CarSubBtn 30
#define Car_SubBtn_ViewMaxW (Screen_W-32)/4
#define Car_SubBtn_ViewMaxH (H_CarSubBtn + 10)
 
#define Car_SubBtn_Tag 260

@interface PopViewAccomPanyCar ()
//@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIView *oneBackV;
@property (nonatomic,strong) UIView *twoBackV;
@property (nonatomic,strong) UILabel *carNumberLabel;
@property (nonatomic,strong) UITextField *carNumberTextField;
@property (nonatomic,strong) UILabel *carTypeLabel;
@property (nonatomic,strong) UIButton *okBtn;
//@property (nonatomic,strong) UIView *cartypeItemBackView;
//@property (nonatomic,strong) NSMutableArray <CarTypeModel*> *cartypeModleArr;//车 类型 数组
//@property (nonatomic,strong) CarTypeModel *carTypeMode;//当前类型数据

@property (nonatomic,strong) CarInfoModel *oldModel;//新增一种show方式 对应的obj 在修改状态时所用
@end
@implementation PopViewAccomPanyCar
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
    _cartypeModleArr = [NSMutableArray arrayWithArray:[CarTypeModel mj_objectArrayWithKeyValuesArray:dataSourceArr]];
    [self setCarItem];
}

//添加/修改只用这一种
- (void)showInView:(UIView *)supview thePopViewSubViewHeight:(float)subViewHeight WithArray:(NSMutableArray *)array WithOldCarInfoModel:(CarInfoModel *)oldModel{
    [self showInView:supview thePopViewSubViewHeight:subViewHeight WithArray:array];
    self.oldModel = oldModel;
    if (self.oldModel!=nil) {
        [self editViewWithTextField:self.oldModel];
        [self editCatTypeModel:self.oldModel];
        [_okBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    }
}
- (void)editViewWithTextField:(CarInfoModel *)oldModel{
    _titleLabel.text = @"修改车辆信息";
    _carNumberTextField.text = oldModel.carPlate;//车牌号
    //cartypeItemBackView.subview当前空 so在btn 初始化的时候设置一点击状态
}
- (void)editCatTypeModel:(CarInfoModel *)oldModel{
    CarTypeModel *oldModelCarType = [[CarTypeModel alloc]init];
    oldModelCarType.code = oldModel.carType;
    oldModelCarType.name = oldModel.carTypeStr;
    self.carTypeMode = oldModelCarType;
}

#pragma mark == carbtn点击会在touchbegin响应 (父视图范围问题)
#pragma mark === carTypeBtnAction
- (void)subBtnAction:(CarTypeChooseBtn *)sender{
    NSLog(@"subBtnAction");
    if (sender.selected==YES) {
        return;
    }
    if (isNil(sender)) {
        return;
    }
    [self carTypeModeChoose:sender];
    [self changSubBtnUI:sender];
}
- (void)carTypeModeChoose:(CarTypeChooseBtn *)sender{
    self.carTypeMode = _cartypeModleArr[sender.tag-Car_SubBtn_Tag];
}
- (void)changSubBtnUI:(CarTypeChooseBtn *)sender{
    sender.selected = !sender.selected;
    for (int i = 0 ; i < self.cartypeItemBackView.subviews.count; i++) {
        if ([self.cartypeItemBackView.subviews[i] isKindOfClass:[CarTypeChooseBtn class]]) {
            CarTypeChooseBtn *btn = (CarTypeChooseBtn*)self.cartypeItemBackView.subviews[i];
            if (btn.selected==YES && btn.tag != sender.tag) {
                btn.selected = NO;
            }
        }
    }
}
#pragma mark === 车类型 btn 初始化
- (void)setCarItem{
     for (int i = 0; i<_cartypeModleArr.count; i++) {
        CarTypeModel *model = _cartypeModleArr[i];
    
        CGRect fram = CGRectMake(Car_SubBtn_ViewMaxW*((i)%4) +5 , Car_SubBtn_ViewMaxH*floor((i)/4.0), W_CarSubBtn, H_CarSubBtn);
        CarTypeChooseBtn *btn = [[CarTypeChooseBtn alloc]initWithFrame:fram];
        btn.tag = i+Car_SubBtn_Tag;
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
         //old edit状态时
         if (self.oldModel!=nil) {
             if ([model.name isEqualToString:self.oldModel.carTypeStr]) {//文本部分相同
                 btn.selected = YES;
             }else{
                 btn.selected = NO;
             }
         }else{
             btn.selected = NO;
         }
        [self.cartypeItemBackView addSubview:btn];
    }
}
#pragma mark ==
- (void)okBtnAction:(UIButton *)sender{
    if (_carNumberTextField.text.length==0 || _carTypeMode == nil) {
        Y_SVP_SHOW_ERR_MES(@"缺少数据");
        return;
    }
    CarInfoModel *newModel = [[CarInfoModel alloc]init];
    newModel.carPlate = self.carNumberTextField.text;
//    newModel.type = self.carTypeMode;
    newModel.carTypeStr = self.carTypeMode.name;
    newModel.carType = self.carTypeMode.code;
    if (_delegate && [_delegate respondsToSelector:@selector(carAddNewModel:removeOldCarInfoModel:)]) {
        [_delegate carAddNewModel:newModel removeOldCarInfoModel:self.oldModel];
    }
    [self dismissThePopView];
}

#pragma mark ==
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.titleLabel];
    [self.subMainBackView addSubview:self.oneBackV];
    [self.oneBackV addSubview:self.carNumberLabel];
    [self.oneBackV addSubview:self.carNumberTextField];
    
    [self.subMainBackView addSubview:self.twoBackV];
    [self.twoBackV addSubview:self.carTypeLabel];
    [self.subMainBackView addSubview:self.okBtn];
    
    [self.subMainBackView addSubview:self.cartypeItemBackView];//层级在twoBackV同级
    
  
    
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
    
    [_carNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_carNumberLabel.superview.mas_centerY);
        make.left.equalTo(_carNumberLabel.superview.mas_left);
        make.width.offset(80);
        make.height.offset(30);
    }];
    [_carTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_carTypeLabel.superview.mas_centerY);
        make.left.equalTo(_carTypeLabel.superview.mas_left);
        make.width.offset(80);
        make.height.offset(30);
    }];
    [_carNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_carNumberTextField.superview.mas_centerY);
        make.left.equalTo(_carNumberLabel.mas_right).offset(5);
        make.right.equalTo(_carNumberTextField.superview.mas_right);
        make.height.offset(30);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_okBtn.superview.mas_left).offset(16);
        make.right.equalTo(_okBtn.superview.mas_right).offset(-16);
        make.height.offset(44);
        make.bottom.equalTo(_okBtn.superview.mas_bottom).offset(-30);
    }];
    
    //
    [_cartypeItemBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_okBtn.superview.mas_left).offset(16);
        make.right.equalTo(_okBtn.superview.mas_right).offset(-16);
        make.top.equalTo(_carTypeLabel.mas_bottom).offset(5);
        make.bottom.equalTo(_okBtn.mas_top).offset(-10);
    }];
}

#pragma mark == get
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"新增随行车辆";
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

- (UILabel *)carNumberLabel{
    if (!_carNumberLabel) {
        _carNumberLabel = [[UILabel alloc]init];
        _carNumberLabel.text = @"车牌号";
        _carNumberLabel.textColor = [UIColor blackColor];
        _carNumberLabel.font = [UIFont systemFontOfSize:15];
    }
    return _carNumberLabel;
}
- (UILabel *)carTypeLabel{
    if (!_carTypeLabel) {
        _carTypeLabel = [[UILabel alloc]init];
        _carTypeLabel.text = @"车辆类型";
        _carTypeLabel.textColor = [UIColor blackColor];
        _carTypeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _carTypeLabel;
}

- (UITextField *)carNumberTextField{
    if (!_carNumberTextField) {
        _carNumberTextField = [[UITextField alloc]init];
        _carNumberTextField.placeholder = @"请输入车牌号";
        _carNumberTextField.font = [UIFont systemFontOfSize:15];
    }
    return _carNumberTextField;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.layer.cornerRadius = 22;//h44
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_okBtn setBackgroundColor:Y_RGBA(38, 114, 249, 1)];
        [_okBtn setTitle:@"确定新增车辆" forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _okBtn;
}
- (UIView *)cartypeItemBackView{
    if (!_cartypeItemBackView) {
        _cartypeItemBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 200)];
    }
    return _cartypeItemBackView;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = 450;
}

@end
