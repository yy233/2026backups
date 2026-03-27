//
//  PopviewWithChoosePayTime.m
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import "PopviewWithChoosePayTime.h"

@interface PopviewWithChoosePayTime ()
//滚轮用的arr
@property (nonatomic,strong) NSMutableArray *yearDataSourceArr;
@property (nonatomic,strong) NSMutableArray *monthDataSourceArr;
//本年度的y+m
@property (nonatomic,assign) NSInteger saveThisYearNum;
@property (nonatomic,assign) NSInteger saveThisYearHaveMonthNum;
//ok后传出的
@property (nonatomic,strong) NSString  *yearS;
@property (nonatomic,strong) NSString  *monthS;
@end

@implementation PopviewWithChoosePayTime

#pragma mark ===
- (void)addSubPickV{
    [self.subMainBackView addSubview:self.timePickV];
}

- (void)setSubPickvUI{
    WEAKSELF
    [_timePickV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.left.right.bottom.equalTo(_timePickV.superview);
    }];
}

- (UIPickerView *)timePickV{
    if (!_timePickV) {
        _timePickV = [[UIPickerView alloc]init];
        _timePickV.delegate = self;
        _timePickV.dataSource = self;
        _timePickV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor;
    }
    return _timePickV;
}

#pragma mark === 重写数据

- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    self.yearDataSourceArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.monthDataSourceArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    
    self.saveThisYearNum = comp.year;
    int nowYesr = (int)comp.year;
    self.saveThisYearHaveMonthNum = comp.month;
    
    //y+m
    for (int i = nowYesr;i >= 2000; i--) {
        [self.yearDataSourceArr addObject:@(i)];
    }
    for (int j = 1;j <= 12; j++) {
        [self.monthDataSourceArr addObject:@(j)];
    }
    //当前年——01月为开始值
    [self.timePickV selectRow:0 inComponent:0  animated:NO];
    //初始为当前年月
    self.yearS = [NSString stringWithFormat:@"%@",self.yearDataSourceArr.firstObject];
    self.monthS = @"1";
    [self.timePickV reloadAllComponents];
}


#pragma mark === pickv

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{//0行做空时间数据？
    if (component==0) {//年
        return self.yearDataSourceArr.count;
    }else{//月
        NSInteger selectYearNum  = [self.yearS integerValue];
        if (  selectYearNum  == self.saveThisYearNum ) {
            return self.saveThisYearHaveMonthNum;
        }else{
            return self.monthDataSourceArr.count;
        }
    }
}

//设置pickview每一行的高度 component列 row行
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

//设置带有属性的每一行的文字内容(大小颜色阴影等)
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSDictionary *attributs = @{
        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
    };
    if (component==0) {
        return [[NSAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@年",self.yearDataSourceArr[row]] attributes:attributs];
        
    }else{
        return [[NSAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@月",self.monthDataSourceArr[row]] attributes:attributs];
    }
}


//返回当前选中的是哪一列的哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DLog(@"返回当前选中的是哪一列的哪一行%ld %ld",(long)row,(long)component);
    if (component==0) {
        self.yearS =  [NSString stringWithFormat:@"%@",self.yearDataSourceArr[row]];
        [pickerView reloadAllComponents];
    }else{
        self.monthS = [NSString stringWithFormat:@"%@",self.monthDataSourceArr[row]];
    }
    NSLog(@"得到数据 时间： %@ %@",self.yearS,self.monthS);
}

#pragma mark === 点击OK_Btn
- (void)touchOkAction{
    if (_delegagtePayTime && [_delegagtePayTime respondsToSelector:@selector(popViewChoosePayTimeWitYearAndMonthStr:)]) {
        if (self.monthS.length<2) {
            self.monthS = [@"0" stringByAppendingString:self.monthS];
        }
        [_delegagtePayTime popViewChoosePayTimeWitYearAndMonthStr:[NSString stringWithFormat:@"%@-%@",self.yearS,self.monthS]];
    }
}

@end
