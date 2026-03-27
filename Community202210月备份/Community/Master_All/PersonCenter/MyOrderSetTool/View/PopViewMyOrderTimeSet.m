//
//  PopViewMyOrderTimeSet.m
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import "PopViewMyOrderTimeSet.h"

@interface PopViewMyOrderTimeSet () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) NSMutableArray *arrOfH;
@property (nonatomic,strong) NSMutableArray *arrOfM;
@property (nonatomic,strong) NSMutableArray *arrDaysTitle;
//
@property (nonatomic,strong) NSString *strH;
@property (nonatomic,strong) NSString *strM;
@property (nonatomic,strong) NSString *strD;
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,assign) BOOL isEditing;
@end

@implementation PopViewMyOrderTimeSet
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.subMainBackView addSubview:self.saveBtnView];
        [self.subMainBackView addSubview:self.subBtnBackView];
        [self.subMainBackView addSubview:self.subBtnsTitleL];
        //
        [self.subMainBackView addSubview:self.titleL];
        //
        [self.subMainBackView addSubview:self.pickV];
        //
        [self setUI];
        [self initData];
        
    }
    return self;
}
//init
- (void)initData{
    self.isEditing = NO;
    self.strH = @"00";
    self.strM = @"00";
    self.strD = @"";
}
//edit
- (void)showInViewEditCellIndex:(NSInteger)index andWithArray:(NSMutableArray *)timeArr{
    [self showInView:self.superview thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
    self.strH = timeArr.firstObject;
    self.strM = timeArr[1];
    self.strD = timeArr.lastObject;
    self.isEditing = YES;
    self.cellIndex = index;
    //up ui
   [self.pickV selectRow:[self.strH integerValue] inComponent:0 animated:NO];
   [self.pickV selectRow:([self.strM integerValue]/10)  inComponent:1 animated:NO];
   //
    NSInteger dIndex =[self.arrDaysTitle indexOfObject:self.strD];
    if (dIndex == NSNotFound) {
        self.strD = @"";
        NSLog(@"不存在");
    }else{
        [self changeBtnsSeleldType:(dIndex+200)];
    }
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.6;
}
#pragma mark ==
- (void)setUI{
    [_saveBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_saveBtnView.superview);
        make.height.offset(90);
        make.bottom.equalTo(_saveBtnView.superview).offset(-20);
    }];
    [_subBtnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_subBtnBackView.superview);
        make.height.offset(70);
        make.bottom.equalTo(_saveBtnView.mas_top);
    }];
    [_subBtnsTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_subBtnBackView.mas_top);
        make.left.equalTo(_subBtnsTitleL.superview).offset(10);
        make.height.offset(20);
      
    }];
    //
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_titleL.superview);
        make.top.equalTo(_titleL.superview).offset(10);
        make.height.offset(20);
        make.width.equalTo(_titleL.superview);
    }];
    //
    [_pickV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_titleL);
        make.bottom.equalTo(_subBtnsTitleL.mas_top);
    }];
    [self addSubBtns];
}
- (void)addSubBtns{
    [self.subBtnBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //
    for (int i = 0; i <self.arrDaysTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn newAnBtnWithTextStr:self.arrDaysTitle[i]];
        [btn newAnBtnWithFont:FontSize_Orders_Nomail(14)];
        //
        [btn newAnBtnWithTextColor:Color_51BlackColor];
        [btn newAnBtnWithLayerCorNerNum:3 withLayerLineWidth:0.5 withLayerLineColor:Color_238GrayColor];
        if (i==0) {
            btn.frame = CGRectMake(10, 10, 100, 40);
        }else{
            btn.frame = CGRectMake(120+(i-1)*60, 10, 50, 40);
        }
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(subsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.subBtnBackView addSubview:btn];
    }
}
- (void)subsBtnAction:(UIButton *)sender{
    DLog(@"%@",self.arrDaysTitle[(sender.tag-200)]);
    self.strD = [NSString stringWithFormat:@"%@",self.arrDaysTitle[(sender.tag-200)]];//更新数据
    [self changeBtnsSeleldType:sender.tag];
}
- (void)changeBtnsSeleldType:(NSInteger)index{
    for (UIButton *btn in self.subBtnBackView.subviews) {
        if (btn.tag==index) {
            btn.selected = YES;
            [btn newAnBtnWithTextColor:Color_38BlueColor];
            [btn newAnBtnWithLayerCorNerNum:3 withLayerLineWidth:0.5 withLayerLineColor:Color_38BlueColor];
        }else{
            btn.selected = NO;
            [btn newAnBtnWithTextColor:Color_51BlackColor];
            [btn newAnBtnWithLayerCorNerNum:3 withLayerLineWidth:0.5 withLayerLineColor:Color_238GrayColor];
        }
    }
}
#pragma mark ===
- (UIPickerView *)pickV{
    if (!_pickV) {
        _pickV = [[UIPickerView alloc]init];
        _pickV.delegate = self;
        _pickV.dataSource = self;
    }
    return _pickV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"编辑提醒时间";
        _titleL.textColor = [UIColor blackColor];
        _titleL.font = FontSize_Orders_Nomail(18);
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
- (UILabel *)subBtnsTitleL{
    if (!_subBtnsTitleL) {
        _subBtnsTitleL = [[UILabel alloc]init];
        _subBtnsTitleL.text = @"重复周期";
        _subBtnsTitleL.textColor = [UIColor blackColor];
        _subBtnsTitleL.font = FontSize_Orders_Bold(16);
    }
    return _subBtnsTitleL;
}
- (UIView *)subBtnBackView{
    if (!_subBtnBackView) {
        _subBtnBackView = [[UIView alloc]init];
    }
    return _subBtnBackView;
}
- (BaseTableViewFooterView *)saveBtnView{
    if (!_saveBtnView) {
        _saveBtnView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_saveBtnView.footerBtn newAnBtnWithTextStr:@"保存"];
        [_saveBtnView.footerBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtnView;
}
- (void)saveAction{
    DLog(@"");
    if (self.strD.length>0) {
        if (self.isEditing) {
            //修改
            if (_delegate && [_delegate respondsToSelector:@selector(popViewTouchSaveEditCellIndex:withTimeHStr:withMStr:withDayStr:)]) {
                [_delegate popViewTouchSaveEditCellIndex:self.cellIndex withTimeHStr:self.strH withMStr:self.strM withDayStr:self.strD];
            }
        }else{
            //新增
            if (_delegate && [_delegate respondsToSelector:@selector(popViewTouchSaveWithTimeHStr:withMStr:withDayStr:)]) {
                [_delegate popViewTouchSaveWithTimeHStr:self.strH withMStr:self.strM withDayStr:self.strD];
            }
        }
      
        [self dismissThePopView];
    }else{
        Y_SVP_SHOW_INFO_MES(@"请选择重复周期");
    }
    
}
//
- (NSMutableArray *)arrOfH{
    if (!_arrOfH) {
        _arrOfH = [[NSMutableArray alloc]init];
        for (int i = 0; i <24; i ++) {
            [_arrOfH addObject:[NSString stringWithFormat:@"%0.2d",i]];
        }
    }
    return _arrOfH;
}
- (NSMutableArray *)arrOfM{
    if (!_arrOfM) {
        _arrOfM = [NSMutableArray arrayWithObjects:@"00",@"10",@"20",@"30",@"40",@"50",nil];
     }
    return _arrOfM;
}
- (NSMutableArray *)arrDaysTitle{
    if (!_arrDaysTitle) {
        _arrDaysTitle  = [NSMutableArray arrayWithObjects:@"周一至周五",@"周末",@"每天", nil];
    }
    return _arrDaysTitle;
}

#pragma mark ====
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return self.arrOfH.count;
    }else{
        return self.arrOfM.count;
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

 
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@""];
    if (component==0) {
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.arrOfH[row]]];
    }else{
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.arrOfM[row]]];
    }
    return attributedString;
}

////设置每一行的view样式
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    return [UIButton buttonWithType:UIButtonTypeContactAdd];
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        DLog(@"%@",self.arrOfH[row]);
        self.strH = [NSString stringWithFormat:@"%@",self.arrOfH[row]];
    }else{
        DLog(@"%@",self.arrOfM[row]);
        self.strM = [NSString stringWithFormat:@"%@",self.arrOfM[row]];
    }
}

@end
