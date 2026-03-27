//
//  PopViewBuniessShopQiZuMainZu.m
//  Community
//
//  Created by 余莹 on 2021/3/22.
//

#import "PopViewBuniessShopChooseQiZuMainZu.h"

#define Tag_TopBtn           300
#define Width_Top_OneItem   (Screen_W/2)

@interface PopViewBuniessShopChooseQiZuMainZu () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIView *topAllViewBackView;
@property (nonatomic,strong) UIView *centerLineV;
//
@property (nonatomic,strong) UILabel *topOneTitleL;
@property (nonatomic,strong) UILabel *topTwoTitleL;
//
@property (nonatomic,strong) UILabel *oneConcentL;
@property (nonatomic,strong) UILabel *twoConcentL;
//
@property (nonatomic,strong) UIButton *topOneBtn;
@property (nonatomic,strong) UIButton *topTwoBtn;
//
@property (nonatomic,strong) UILabel *centerTipLabel;
@property (nonatomic,strong) UIButton *finishBtn;
//
@property (nonatomic,strong) UIPickerView *pickView;
@property (nonatomic,strong) NSMutableArray *monthNumArr;


@end

@implementation PopViewBuniessShopChooseQiZuMainZu
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selfNowType = PopViewBuniessShopChooseQiZuMainZu_Type_QiZu;
        [self initData];
        [self addSubAllView];
        [self setUI];
        [self changeShowType:PopViewBuniessShopChooseQiZuMainZu_Type_QiZu];
        
    }
    return self;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.5;
}
#pragma mark == 边角 重写
- (void)changMainBackViewCornerRadius{
    self.subMainBackView.layer.cornerRadius = 0;
}
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    if (dataSourceArr.count==2) {
        //saveQiZuMainConcentArr
        self.saveQuZuMianZuArr = [NSMutableArray arrayWithArray:dataSourceArr];
        [self changeShowType:PopViewBuniessShopChooseQiZuMainZu_Type_QiZu];
    }
}
#pragma mark ===================
- (void)initData{
    self.monthNumArr = [[NSMutableArray alloc]init];
    for (int i = 0; i <=99; i++) {
        [self.monthNumArr addObject:@(i)];
    }
}
#pragma mark ==
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.topAllViewBackView];
    [self.topAllViewBackView addSubview:self.topOneTitleL];
    [self.topAllViewBackView addSubview:self.topTwoTitleL];
    [self.topAllViewBackView addSubview:self.oneConcentL];
    [self.topAllViewBackView addSubview:self.twoConcentL];
    [self.topAllViewBackView addSubview:self.topOneBtn];
    [self.topAllViewBackView addSubview:self.topTwoBtn];
    [self.topAllViewBackView addSubview:self.centerLineV];
    [self.subMainBackView addSubview:self.centerTipLabel];
    [self.subMainBackView addSubview:self.finishBtn];
    [self.subMainBackView addSubview:self.pickView];
}
- (void)setUI{
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(_pickView.superview);
        make.height.equalTo(_pickView.superview).multipliedBy(0.5);
    }];
    [_centerTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerTipLabel.superview);
        make.height.offset(40);
        make.bottom.equalTo(_pickView.mas_top);
    }];
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_centerTipLabel);
        make.width.offset(70);
    }];
    [_topAllViewBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_centerTipLabel.superview);
        make.bottom.equalTo(_centerTipLabel.mas_top);
    }];
    [self setTopUI];
    
}

- (void)setTopUI{
    [_oneConcentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(_topAllViewBackView);
        make.width.offset(Width_Top_OneItem);
        make.height.equalTo(_topAllViewBackView.mas_height).multipliedBy(0.6);
    }];
    [_twoConcentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_topAllViewBackView);
        make.width.offset(Width_Top_OneItem);
        make.height.equalTo(_topAllViewBackView.mas_height).multipliedBy(0.6);
    }];
    //--
    [_topOneTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_oneConcentL);
        make.height.equalTo(_topAllViewBackView.mas_height).multipliedBy(0.4);
        make.bottom.equalTo(_oneConcentL.mas_top);
    }];
    
    [_topTwoTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_twoConcentL);
        make.height.equalTo(_topAllViewBackView.mas_height).multipliedBy(0.4);
        make.bottom.equalTo(_twoConcentL.mas_top);
    }];
    //--
    [_topOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_topAllViewBackView);
        make.width.offset(Width_Top_OneItem);
    }];
    [_topTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_topAllViewBackView);
        make.width.offset(Width_Top_OneItem);
    }];
    //--
    [_centerLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topAllViewBackView.mas_centerY);
        make.height.right.equalTo(_oneConcentL);
        make.width.offset(1);
    }];
    
}
#pragma mark ==
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
#pragma mark ===
- (UIView *)topAllViewBackView{
    if (!_topAllViewBackView) {
        _topAllViewBackView = [[UIView alloc]init];
    }
    return _topAllViewBackView;
}
//
- (UIView *)centerLineV{
    if (!_centerLineV) {
        _centerLineV = [[UIView alloc]init];
        _centerLineV.backgroundColor = [Y_RGBA(110, 114, 125, 1) colorWithAlphaComponent:0.1];
    }
    return _centerLineV;
}
//
- (UILabel *)topOneTitleL{
    if (!_topOneTitleL) {
        _topOneTitleL = [[UILabel alloc]init];
        _topOneTitleL.textColor = Y_RGBA(110, 114, 125, 1);
        _topOneTitleL.font = [UIFont systemFontOfSize:12];
        _topOneTitleL.text = @"起租";
        _topOneTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _topOneTitleL;
}
- (UILabel *)topTwoTitleL{
    if (!_topTwoTitleL) {
        _topTwoTitleL = [[UILabel alloc]init];
        _topTwoTitleL.textColor = Y_RGBA(110, 114, 125, 1);
        _topTwoTitleL.font = [UIFont systemFontOfSize:12];
        _topTwoTitleL.text = @"免租";
        _topTwoTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _topTwoTitleL;
}

- (UILabel *)oneConcentL{
    if (!_oneConcentL) {
        _oneConcentL = [[UILabel alloc]init];
        _oneConcentL.textColor =  [UIColor blackColor];// Base_SubView_Use_BlueColor
        _oneConcentL.font = [UIFont systemFontOfSize:18];
        _oneConcentL.textAlignment = NSTextAlignmentCenter;
        _oneConcentL.text = @"0";
    }
    return _oneConcentL;
}
- (UILabel *)twoConcentL{
    if (!_twoConcentL) {
        _twoConcentL = [[UILabel alloc]init];
        _twoConcentL.textColor =  [UIColor blackColor];
        _twoConcentL.font = [UIFont systemFontOfSize:18];
        _twoConcentL.textAlignment = NSTextAlignmentCenter;
        _twoConcentL.text = @"0";
    }
    return _twoConcentL;
}

//
- (UIButton *)topOneBtn{
    if (!_topOneBtn) {
        _topOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topOneBtn.tag = Tag_TopBtn +0;
        [_topOneBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topOneBtn;
}
- (UIButton *)topTwoBtn{
    if (!_topTwoBtn) {
        _topTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topTwoBtn.tag = Tag_TopBtn +1;
        [_topTwoBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topTwoBtn;
}
//
- (UILabel *)centerTipLabel{
    if (!_centerTipLabel) {
        _centerTipLabel = [[UILabel alloc]init];
        _centerTipLabel.font = [UIFont systemFontOfSize:14];
        _centerTipLabel.textColor = Y_RGBA(110, 114, 125, 1);
        _centerTipLabel.backgroundColor = Y_RGBA(249, 249, 249, 1);
        _centerTipLabel.textAlignment = NSTextAlignmentCenter;
        _centerTipLabel.text = @"请选择";
    }
    return _centerTipLabel;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:Base_SubView_Use_BlueColor forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (void)topBtnAction:(UIButton *)sender{
    [self changeShowType:(sender.tag-Tag_TopBtn)];
}

#pragma mark ==
- (void)changeShowType:(PopViewBuniessShopChooseQiZuMainZu_Type)type{
    self.selfNowType = type;
    [self.pickView reloadAllComponents];//刷新 行列数据变化
    //UI
    switch (self.selfNowType) {
        case PopViewBuniessShopChooseQiZuMainZu_Type_QiZu://起租
            self.centerTipLabel.text = @"请选择起租月数";
            self.topOneBtn.selected = YES;
            self.topTwoBtn.selected = NO;
            self.topOneBtn.backgroundColor =  [Base_SubView_Use_BlueColor colorWithAlphaComponent:0.1];
            self.topTwoBtn.backgroundColor = [UIColor clearColor];
            self.oneConcentL.textColor = Base_SubView_Use_BlueColor;
            self.twoConcentL.textColor = [UIColor blackColor];
            [self.pickView selectRow:((NSInteger)[self.saveQuZuMianZuArr.firstObject integerValue]) inComponent:0 animated:NO];
            //
            self.oneConcentL.text = [NSString stringWithFormat:@"%ld个月起租",[self.saveQuZuMianZuArr.firstObject integerValue]];
            self.twoConcentL.text = [NSString stringWithFormat:@"免租%ld个月",[self.saveQuZuMianZuArr.lastObject integerValue]];
            
            break;
        case PopViewBuniessShopChooseQiZuMainZu_Type_MianZu://免租
            
            self.centerTipLabel.text = @"请选择免租月数";
            self.topOneBtn.selected = NO;
            self.topTwoBtn.selected = YES;
            self.topOneBtn.backgroundColor = [UIColor clearColor];
            self.topTwoBtn.backgroundColor = [Base_SubView_Use_BlueColor colorWithAlphaComponent:0.1];
            self.oneConcentL.textColor =[UIColor blackColor] ;
            self.twoConcentL.textColor = Base_SubView_Use_BlueColor;
            [self.pickView selectRow:((NSInteger)[self.saveQuZuMianZuArr.lastObject integerValue]) inComponent:0 animated:NO];
            //
            self.twoConcentL.text = [NSString stringWithFormat:@"免租%ld个月",[self.saveQuZuMianZuArr.lastObject integerValue]];
            self.oneConcentL.text = [NSString stringWithFormat:@"%ld个月起租",[self.saveQuZuMianZuArr.firstObject integerValue]];
            break;
        default:
            break;
    }
    
    //Data
}
#pragma mark ==
- (void)okBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(shopBuniessQiZuMainZuInfo:)]) {
        [_delegate shopBuniessQiZuMainZuInfo:self.saveQuZuMianZuArr];
    }
    [self dismissThePopView];
}

#pragma mark ==
//设置pickview一共有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// 设置pickview每列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  self.monthNumArr.count;
    
}

//设置pickview每一行的高度 component列 row行
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

//设置带有属性的每一行的文字内容(大小颜色阴影等)
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@""];
    NSString *monthStrOfRow = [NSString stringWithFormat:@"%ld个月",(long)[self.monthNumArr[row] integerValue]];
    attributedString = [[NSAttributedString alloc]initWithString:monthStrOfRow];
    return attributedString;
}


//返回当前选中的是哪一列的哪一行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DLog(@"返回当前选中的是哪一列的哪一行%ld %ld",(long)row,(long)component);
    //UI+saveData
    switch (self.selfNowType) {
        case PopViewBuniessShopChooseQiZuMainZu_Type_QiZu:
        {
            NSString *qiZuStr =  [NSString stringWithFormat:@"%ld个月",(long)[self.monthNumArr[row] integerValue]];
            self.oneConcentL.text = [NSString stringWithFormat:@"%@起租",qiZuStr];
            [self.saveQuZuMianZuArr replaceObjectAtIndex:0 withObject:self.monthNumArr[row]];
        }
            break;
        case PopViewBuniessShopChooseQiZuMainZu_Type_MianZu:
        {
            NSString *mainZuStr =  [NSString stringWithFormat:@"%ld个月",(long)[self.monthNumArr[row] integerValue]];
            self.twoConcentL.text = [NSString stringWithFormat:@"免租%@",mainZuStr];
            [self.saveQuZuMianZuArr replaceObjectAtIndex:1 withObject:self.monthNumArr[row]];
        }
            break;
            
    }
    
}

#pragma mark ========

- (NSMutableArray *)saveQuZuMianZuArr{
    if (!_saveQuZuMianZuArr) {
        _saveQuZuMianZuArr = [[NSMutableArray alloc]initWithObjects:@(0),@(0), nil];
    }
    return _saveQuZuMianZuArr;
}

@end
