//
//  HouseRentChooseHouseTypeView.m
//  Community
//
//  Created by 余莹 on 2021/1/15.
//

#import "HouseRentChooseHouseTypeView.h"
@interface HouseRentChooseHouseTypeView () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) UIButton *buXianBtn;
@property (nonatomic,strong) UIPickerView *pickView;
@property (nonatomic,strong) NSMutableArray *arrOfShi;
@property (nonatomic,strong) NSMutableArray *arrOfTing;
@property (nonatomic,strong) NSMutableArray *arrOfWei;

@property (nonatomic,assign) NSInteger s;
@property (nonatomic,assign) NSInteger t;
@property (nonatomic,assign) NSInteger w;
@end
@implementation HouseRentChooseHouseTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.pickView];
        [self.backView addSubview:self.cancelBtn];
        [self.backView addSubview:self.okBtn];
        [self.backView addSubview:self.buXianBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pickView.superview.mas_bottom);
        make.left.equalTo(_pickView.superview.mas_left);
        make.right.equalTo(_pickView.superview.mas_right);
        make.height.equalTo(_pickView.superview.mas_height).multipliedBy(0.3);
    }];
    //
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pickView.mas_top).offset(-1);
        make.width.equalTo(_pickView.mas_width).multipliedBy(0.33);
        make.left.equalTo(_pickView.mas_left);
        make.height.offset(50);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pickView.mas_top).offset(-1);
        make.width.equalTo(_pickView.mas_width).multipliedBy(0.33);
        make.right.equalTo(_pickView.mas_right);
        make.height.offset(50);
    }];
    [_buXianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pickView.mas_top).offset(-1);
        make.left.equalTo(_cancelBtn.mas_right).offset(1);
        make.right.equalTo(_okBtn.mas_left).offset(-1);
        make.height.offset(50);
    }];
    [self initPickViewZeroNumUI];
}
- (void)initPickViewZeroNumUI{
    self.s = 0;
    self.t = 0;
    self.w = 0;
    [self.pickView selectRow:0 inComponent:0 animated:YES];
    [self.pickView selectRow:0 inComponent:1 animated:YES];
    [self.pickView selectRow:0 inComponent:2 animated:YES];
}

#pragma mark ===
- (void)okBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(houseTypeIsChooseWithShiNum:withTingNum:withWeiNum:)]) {
//        NSInteger shi = [self.pickView numberOfRowsInComponent:0];
//        NSInteger ting = [self.pickView numberOfRowsInComponent:1];
//        NSInteger wei = [self.pickView numberOfRowsInComponent:2];
//        [_delegate houseTypeIsChooseWithShiNum:self.s withTingNum:self.t withWeiNum:self.t];
        NSInteger shi = [self.arrOfShi[self.s] integerValue];
        NSInteger ting = [self.arrOfTing[self.t] integerValue];
        NSInteger wei = [self.arrOfWei[self.w] integerValue];
        [_delegate houseTypeIsChooseWithShiNum:shi withTingNum:ting withWeiNum:wei];
//
    }
}
- (void)cancelBtnAction{
    self.hidden = YES;
}
//不限
- (void)buXianBtnAction{
    self.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(houseChooseBuXianBtnActionWithZeroNum)]) {
        //
        [self initPickViewZeroNumUI];
        
        [_delegate houseChooseBuXianBtnActionWithZeroNum];
    }
}

#pragma mark ==
//设置pickview一共有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// 设置pickview每列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.arrOfShi.count;
    }else if(component==1){
        return self.arrOfTing.count;
    }else{
        return self.arrOfWei.count;
    }
}

//设置pickview每一行的高度 component列 row行
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

//设置每一行展示的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"选择器选项";
}

//设置带有属性的每一行的文字内容(大小颜色阴影等)
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@""];
    if (component == 0) {
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@室",self.arrOfShi[row]]];
    }else if(component == 1){
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@厅",self.arrOfTing[row]]];
    }else{
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@卫",self.arrOfWei[row]]];
    }
    return attributedString;
}


//设置每一行的view样式
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    return [UIButton buttonWithType:UIButtonTypeCustom];
//}

//返回当前选中的是哪一列的哪一行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DLog(@"返回当前选中的是哪一列的哪一行%ld %ld",(long)row,(long)component);
    if (component==0) {
        self.s = row;
    }else if (component==1){
        self.t = row;
    }else{
        self.w = row;
    }
}

#pragma mark ===
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    }
    return _backView;
}

- (UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
    }
    return _pickView;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:Color_38BlueColor forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:Color_38BlueColor forState:UIControlStateNormal];
        _okBtn.backgroundColor = [UIColor whiteColor];
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}
- (UIButton *)buXianBtn{
    if (!_buXianBtn) {
        _buXianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buXianBtn setTitle:@"不限" forState:UIControlStateNormal];
        [_buXianBtn setTitleColor:Color_38BlueColor forState:UIControlStateNormal];
        _buXianBtn.backgroundColor = [UIColor whiteColor];
        [_buXianBtn addTarget:self action:@selector(buXianBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buXianBtn;
}
#pragma mark ==
- (NSMutableArray *)arrOfShi{
    if (!_arrOfShi) {
        _arrOfShi = [[NSMutableArray alloc]init];
        for (int i = 1; i < 100; i ++) {
            [_arrOfShi addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    return _arrOfShi;
}
- (NSMutableArray *)arrOfTing{
    if (!_arrOfTing) {
        _arrOfTing = [[NSMutableArray alloc]init];
        for (int i = 1; i < 100; i ++) {
            [_arrOfTing addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    return _arrOfTing;
}
- (NSMutableArray *)arrOfWei{
    if (!_arrOfWei) {
        _arrOfWei = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11", nil];
    }
    return _arrOfWei;
}
@end
