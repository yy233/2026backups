//
//  HouseRentOfAppointmentTimesPopView.m
//  Community
//
//  Created by 余莹 on 2021/3/31.
//  预约时间

#import "HouseRentOfAppointmentTimesPopView.h"

@interface HouseRentOfAppointmentTimesPopView () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *okBtn;
//
@property (nonatomic,strong) NSMutableArray *daysArr;
@property (nonatomic,strong) NSMutableArray *timesArr;
//
@property (nonatomic,strong) NSString *chooseDayStr;
@property (nonatomic,strong) NSString *chooseTimeStr;
@end


@implementation HouseRentOfAppointmentTimesPopView

#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.chooseDayStr = @"";
        self.chooseTimeStr = @"";
        [self.subMainBackView addSubview:self.titleLabel];
        [self.subMainBackView addSubview:self.okBtn];
        [self.subMainBackView addSubview:self.pickView];
        [self setUI];
    }
    return self;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.4;
}
//用于子类重写
- (void)changMainBackViewCornerRadius{
   self.subMainBackView.layer.cornerRadius = 0;
}
#pragma mark ====== show
#pragma mark ==
- (void)showViewfillDataWithTimeArr:(NSMutableArray *)dayArr withTimeArr:(NSMutableArray *)timeArr{
    self.daysArr = dayArr;
    self.timesArr = timeArr;
    if (self.daysArr.count>0) {
        self.chooseDayStr = [NSString stringWithString:self.daysArr.firstObject];
    }
    if (self.timesArr.count>0) {
        self.chooseTimeStr = [NSString stringWithString:self.timesArr.firstObject];
    }
    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
}
#pragma mark == view UI
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(_titleLabel.superview);
        make.height.offset(45);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.centerY.equalTo(_titleLabel);
        make.width.offset(50);
    }];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.bottom.equalTo(_pickView.superview);
    }];
}
#pragma mark ===
- (UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.showsSelectionIndicator = NO;
    }
    return _pickView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc]init];
        _titleLabel.text = @"请选择看房时间";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn newAnBtnWithTextColor:Color_38BlueColor];
        [_okBtn newAnBtnWithTextStr:@"确认"];
        [_okBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}


#pragma mark ==
- (NSMutableArray *)daysArr{
    if (!_daysArr ) {
        _daysArr = [[NSMutableArray alloc]init];
    }
    return _daysArr;
}
- (NSMutableArray *)timesArr{
    if (!_timesArr) {
        _timesArr = [[NSMutableArray alloc]init];
    }
    return _timesArr;
}
#pragma mark == pickview delegate
    
#pragma mark ==设置pickview一共有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// 设置pickview每列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.daysArr.count;
    }else if(component==1){
        return self.timesArr.count;
    }else{
        return 0;
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
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.daysArr[row]]];
    }else if(component == 1){
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.timesArr[row]]];
    }else{
        attributedString = [[NSAttributedString alloc]initWithString:@""];
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
        self.chooseDayStr = [NSString stringWithString:self.daysArr[row]];
    }else if (component==1){
        self.chooseTimeStr = [NSString stringWithString:self.timesArr[row]];
    }else{
    }
}
#pragma mark ==
- (void)okBtnAction{
    //判断是否空数据
    if (self.chooseDayStr.length==0 || self.chooseTimeStr.length==0) {
        Y_SVP_SHOW_ERR_MES(@"请选择");
        return;
    }
    //判断是否为过去时
    NSString *yuyueTimeShowStr = [NSString stringWithFormat:@"%@ %@",self.chooseDayStr,self.chooseTimeStr];
    NSString *chooseOkTimeStr = [ToolOfTimeChangeFormat getTimeStrWithShortYearMonthDayHouseMinString:yuyueTimeShowStr];
    if ( [[ToolOfTimeChangeFormat currentTimeStr] integerValue] > [chooseOkTimeStr integerValue]) {
        Y_SVP_SHOW_ERR_MES(@"时间已过,不可选");
        return;
    }
    //返回时间相关数据
    if (_delegate && [_delegate respondsToSelector:@selector(chooseYuyueTimeStrWithReserveDate:withReserveTime:)]) {
        [_delegate chooseYuyueTimeStrWithReserveDate:self.chooseDayStr withReserveTime:self.chooseTimeStr];
    }
    [self dismissThePopView];
     
}
@end
