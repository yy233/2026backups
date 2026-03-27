//
//  BaseChoosePopView.m
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import "BaseChoosePopView.h"

@interface  BaseChoosePopView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BaseChoosePopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleBackView];
        [self addSubview:self.btnBackView];
        [self addSubview:self.tableViewOfChooseLanguage];
        [self.titleBackView addSubview:self.titleLabel];
        [self.btnBackView addSubview:self.yesBtn];
        [self.btnBackView addSubview:self.cancelBtn];
        [self setUI];
        [self setChangeUI];
        [self initViewColorOther];
        [self initViewColorOtherChange];
        [self initData];
    }
    return self;
}
#pragma mark ==
- (UIView *)titleBackView{
    if (!_titleBackView) {
        _titleBackView = [[UIView alloc]init];
        _titleBackView.backgroundColor = [UIColor whiteColor];
    }
    return _titleBackView;
}
- (UIView *)btnBackView{
    if (!_btnBackView) {
        _btnBackView = [[UIView alloc]init];
        _btnBackView.backgroundColor = [UIColor whiteColor];
    }
    return _btnBackView;
}
- (UITableView *)tableViewOfChooseLanguage{
    if (!_tableViewOfChooseLanguage) {
        _tableViewOfChooseLanguage = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableViewOfChooseLanguage.dataSource = self;
        _tableViewOfChooseLanguage.delegate = self;
        _tableViewOfChooseLanguage.tableFooterView = [UIView new];
    }
    return _tableViewOfChooseLanguage;
}
//
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
}
- (UIButton *)yesBtn{
    if (!_yesBtn) {
        _yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yesBtn addTarget:self action:@selector(yesBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yesBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (void)cancelAction{
    [self removeFromSuperview];
}
- (void)yesBtnAction{
    if (isNil(_arrOfTableViewDataNum)) {
        return;
    }
    self.yesBlock(_arrOfTableViewDataNum);
}
//
#pragma mark ==
- (void)setUI{
    [_titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.width.equalTo(_titleBackView.superview).multipliedBy(0.6);
        make.centerY.equalTo(_titleBackView.superview).multipliedBy(0.4);
        make.centerX.equalTo(_titleBackView.superview);
    }];
    [_tableViewOfChooseLanguage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleBackView.mas_bottom);
        make.left.right.equalTo(_titleBackView);
        make.height.equalTo(_tableViewOfChooseLanguage.superview).multipliedBy(0.35);
    }];
    [_btnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.top.equalTo(_tableViewOfChooseLanguage.mas_bottom);
        make.left.right.equalTo(_titleBackView);
    }];
    //
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(_titleLabel.superview);
        make.width.equalTo(_titleLabel.superview).offset(-20);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_cancelBtn.superview).multipliedBy(0.5);
        make.left.top.bottom.equalTo(_cancelBtn.superview);
    }];
    [_yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_cancelBtn.superview).multipliedBy(0.5);
        make.right.top.bottom.equalTo(_yesBtn.superview);
    }];
}
- (void)setChangeUI{
    
}
#pragma mark ==
-(void)awakeFromNib{
    [super awakeFromNib];
}
- (void)setDataWithTitleArr:(NSMutableArray *)arrOfPopTitle
                       numArr:(NSMutableArray *)arrOfPopTitleNum{
    
    _arrOfTableViewData = arrOfPopTitle;
    _arrOfTableViewDataNum = arrOfPopTitleNum;
   
    [self initData];
}
- (void)initViewColorOther{
    [_yesBtn setTitleColor:Color_38BlueColor forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:Color_38BlueColor forState:UIControlStateNormal];
    _titleBackView.layer.cornerRadius = 5;
    _btnBackView.layer.cornerRadius = 5;
    [_yesBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_yesBtn newAnBtnWithLayerCorNerNum:0.1 withLayerLineWidth:0.5 withLayerLineColor:Color_153GrayColor];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn newAnBtnWithLayerCorNerNum:0.1 withLayerLineWidth:0.5 withLayerLineColor:Color_153GrayColor];
}
- (void)initViewColorOtherChange{
    
}

- (void)initData{
    _tableViewOfChooseLanguage.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewOfChooseLanguage.tableFooterView = [UIView new];
    _tableViewOfChooseLanguage.dataSource = self;
    _tableViewOfChooseLanguage.delegate = self;
    if (_arrOfTableViewData.count>0) {
        _tableViewOfChooseLanguage.hidden = NO;
        [_tableViewOfChooseLanguage reloadData];
    }else{
        _tableViewOfChooseLanguage.hidden = YES;
    }
}
#pragma mark --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrOfTableViewData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = _arrOfTableViewData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (_arrOfTableViewDataNum.count>0) {//单选num组
        if ([_arrOfTableViewDataNum[indexPath.row] intValue]==0) {
            cell.imageView.image = [UIImage imageNamed:@"Selectgroup_Default_night"];
         }else{
            cell.imageView.image =  [UIImage imageNamed:@"Selectgroup_Select_night"];
        }
        //img大小
        CGSize itemSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        /***
         AppointmentWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentWeekTableViewCell"];
         if (!cell) {
         cell = [[AppointmentWeekTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentWeekTableViewCell"];
         }
         if (indexPath.row==7) {//第8行
         cell.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.selected = NO;
         }else if(indexPath.row == 8){
         cell.backgroundColor = [UIColor whiteColor];
         cell.selectionStyle = UITableViewCellSelectionStyleDefault;
         cell.textL.text = NSLocalizedString(_arrOfWeakTitlesource[indexPath.row-1], nil) ;
         cell.strOfSelected = _arrOfselected[indexPath.row-1];
         */
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_arrOfTableViewDataNum.count>0) {//单选num组数据不为空 有效
        
        if ([_arrOfTableViewDataNum[indexPath.row] intValue]==0) {//0->1 其余变0
            [self getNewArrDataNumWithIndex:indexPath.row strA:@"1" strB:@"0"];
//        }else{//不处理数据为1的 即点击已存在的不置为0  点击1 不做操作
//             [self getNewArrDataNumWithIndex:indexPath.row strA:@"0" strB:@"1"];
        }
    }
}

- (void)getNewArrDataNumWithIndex:(NSInteger)index
                             strA:(NSString *)strA
                             strB:(NSString *)strB{
    NSMutableArray *newArr = [NSMutableArray array];
    for (int i = 0 ; i<_arrOfTableViewDataNum.count; i++) {
        if (i == index) {//int
            [newArr addObject:strA];//a
        }else{
            [newArr addObject:strB];//b
        }
    }
    _arrOfTableViewDataNum = [NSMutableArray arrayWithArray:newArr];
    [_tableViewOfChooseLanguage reloadData];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
    
}
 

@end
