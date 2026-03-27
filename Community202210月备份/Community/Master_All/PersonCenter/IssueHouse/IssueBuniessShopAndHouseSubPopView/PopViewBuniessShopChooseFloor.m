//
//  PopViewBuniessShopChooseFloor.m
//  Community
//
//  Created by 余莹 on 2021/1/20.
//

#import "PopViewBuniessShopChooseFloor.h"
#define  PopView_subBlueColor            Y_RGBA(38, 114, 249, 1)
#define  H_SubBtn                        28
#define  W_subBtn                        55
#define  Tag_SubBtn                      200
@interface PopViewBuniessShopChooseFloor () <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIButton *finishBtn;
@property (nonatomic,strong) UIView *rollBackView;
@property (nonatomic,strong) NSMutableArray *cengNumArr;//-99 到 99 层
@property (nonatomic,strong) NSMutableArray *allCengTotalNumArr;//总共多少层
@property (nonatomic,assign) PopView_Floor_Type floorType;
//记录滚轮部分
@property (nonatomic,assign) NSInteger oneComponentNum;
@property (nonatomic,assign) NSInteger twoComponentNum;
@property (nonatomic,assign) NSInteger thrComponentNum;
@property (nonatomic,assign) NSInteger fourComponentNum;
@end

@implementation PopViewBuniessShopChooseFloor
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.floorType = PopView_Floor_Type_OnlyOneFloor;
        [self addSubAllView];
        [self setUI];
        [self initData];
        [self changePickVShowNumWithType];
    }
    return self;
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.6;
}
#pragma mark == 边角 重写
- (void)changMainBackViewCornerRadius{
    self.subMainBackView.layer.cornerRadius = 0;
}
#pragma mark ===================
- (void)initData{
    self.cengNumArr = [[NSMutableArray alloc]init];
    self.allCengTotalNumArr = [[NSMutableArray alloc]init];
    for (int i = -99; i<100; i++) {
        if (i !=0) {
            [self.cengNumArr  addObject:@(i)];
        }
        if (i>0) {
            [self.allCengTotalNumArr addObject:@(i)];
        }
    }
}
#pragma mark ===================
- (void)changePickVShowNumWithType{
    [self.pickView reloadAllComponents];//刷新 行列数据变化
    switch (self.floorType) {
        case PopView_Floor_Type_OnlyOneFloor:
            [self.pickView selectRow:(self.cengNumArr.count/2) inComponent:0 animated:NO];
            [self.pickView selectRow:0 inComponent:1 animated:NO];
            self.concentL.text = @"1层/共1层";
            self.oneComponentNum = (self.cengNumArr.count/2);
            self.twoComponentNum = 0;
            break;
        case PopView_Floor_Type_MoreFloor:
            [self.pickView selectRow:(self.cengNumArr.count/2) inComponent:0 animated:NO];
            [self.pickView selectRow:0 inComponent:1 animated:NO];
            [self.pickView selectRow:(self.cengNumArr.count/2) inComponent:2 animated:NO];//
            [self.pickView selectRow:0 inComponent:3 animated:NO];
            self.concentL.text = @"1层 至 1层/共1层";
            self.oneComponentNum = (self.cengNumArr.count/2);
            self.thrComponentNum = (self.cengNumArr.count/2);
            self.fourComponentNum = 0;
            break;
        case PopView_Floor_Type_DuLiFloor:
            [self.pickView selectRow:0 inComponent:0 animated:NO];
            self.concentL.text = @"1层";
            self.oneComponentNum = 0;
            break;
    }
   
}
#pragma mark ===
- (void)okBtnAction{
    switch (self.floorType) {
        case PopView_Floor_Type_OnlyOneFloor:
            break;
        case PopView_Floor_Type_MoreFloor:
            break;
        case PopView_Floor_Type_DuLiFloor:
        default:
            break;
    }
    if (_floorDelegate && [_floorDelegate respondsToSelector:@selector(popViewChooseBuniessShopFloorWithType:andFloorStr:)]) {
        [_floorDelegate popViewChooseBuniessShopFloorWithType:self.floorType andFloorStr:self.concentL.text];
    }
    [self dismissThePopView];
}
 
#pragma mark ==
//设置pickview一共有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (self.floorType) {
        case PopView_Floor_Type_OnlyOneFloor:
            return 2;
            break;
        case PopView_Floor_Type_MoreFloor:
            return 4;
            break;
        case PopView_Floor_Type_DuLiFloor:
            return 1;
            break;
    }
}

// 设置pickview每列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.floorType) {
        case PopView_Floor_Type_OnlyOneFloor:
            if (component==0) {
                return self.cengNumArr.count;
            }else{
                return self.allCengTotalNumArr.count;
            }
            break;
        case PopView_Floor_Type_MoreFloor:
            if (component==0||component==2) {
                return self.cengNumArr.count;
            }else if(component==1){
                return 1;//至
            }else{
                return self.allCengTotalNumArr.count;
            }
            break;
        case PopView_Floor_Type_DuLiFloor:
            return self.allCengTotalNumArr.count;
            break;
    }
   
    return 0;
}

//设置pickview每一行的高度 component列 row行
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

//设置带有属性的每一行的文字内容(大小颜色阴影等)
-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@""];
    switch (self.floorType) {
        case PopView_Floor_Type_OnlyOneFloor:
            if (component == 0) {
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld层",(long)[self.cengNumArr[row] integerValue]]];
            }else{
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%ld层",(long)[self.allCengTotalNumArr[row] integerValue]]];
            }
            break;
        case PopView_Floor_Type_MoreFloor:
            if (component == 0 || component == 2) {
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld层",(long)[self.cengNumArr[row] integerValue]]];
            }else if(component == 1){
                attributedString = [[NSAttributedString alloc]initWithString:@"至"];
            }else{
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%ld层",(long)[self.allCengTotalNumArr[row] integerValue]]];
            }
            break;
        case PopView_Floor_Type_DuLiFloor:
            attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%ld层",(long)[self.allCengTotalNumArr[row] integerValue]]];
            break;
    }
    return attributedString;
}
////设置每一行展示的内容
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    NSString *viewString = @"";
//    switch (self.floorType) {
//        case PopView_Floor_Type_OnlyOneFloor:
//            if (component == 0) {
//                viewString = [NSString stringWithFormat:@"%ld层",(long)[self.cengNumArr[row] integerValue]];
//            }else{
//                viewString = [NSString stringWithFormat:@"共%ld层",(long)[self.allCengTotalNumArr[row] integerValue]];
//            }
//            break;
//        case PopView_Floor_Type_MoreFloor:
//            if (component == 0 || component == 2) {
//                viewString = [NSString stringWithFormat:@"%ld层",(long)[self.cengNumArr[row] integerValue]];
//            }else if(component == 1){
//                viewString = @"至";
//            }else{
//                viewString = [NSString stringWithFormat:@"共%ld层",(long)[self.allCengTotalNumArr[row] integerValue]];
//            }
//            break;
//        case PopView_Floor_Type_DuLiFloor:
//            viewString = [NSString stringWithFormat:@"共%ld层",(long)[self.allCengTotalNumArr[row] integerValue]];
//            break;
//    }
//    return viewString;
//}


//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//
//
//
//    /// 未选中颜色
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        pickerLabel.textAlignment = NSTextAlignmentCenter;
//        pickerLabel.font = [UIFont systemFontOfSize:17];//[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
//        pickerLabel.textColor = [UIColor colorWithRed:12.f/255.f green:14.f/255.f blue:14.f/255.f alpha:1];
//
//    }
//
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//
//    return pickerLabel;
//}

//返回当前选中的是哪一列的哪一行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DLog(@"返回当前选中的是哪一列的哪一行%ld %ld",(long)row,(long)component);
    //Data
    if (component==0) {
        self.oneComponentNum = row;
    }else if (component==1){
        self.twoComponentNum = row;
    }else if (component==2){
        self.thrComponentNum = row;
    }else{
        self.fourComponentNum = row;
    }
    //UI
    switch (self.floorType) {
        case PopView_Floor_Type_OnlyOneFloor:
            self.concentL.text = [NSString stringWithFormat:@"%d层/共%d层",[self.cengNumArr[self.oneComponentNum] intValue],[self.allCengTotalNumArr[self.twoComponentNum] intValue]];
            break;
        case PopView_Floor_Type_MoreFloor:
            self.concentL.text = [NSString stringWithFormat:@"%d层 至 %d层/共%d层",[self.cengNumArr[self.oneComponentNum] intValue],[self.cengNumArr[self.thrComponentNum] intValue],[self.allCengTotalNumArr[self.fourComponentNum] intValue]];
            break;
        case PopView_Floor_Type_DuLiFloor:
            self.concentL.text = [NSString stringWithFormat:@"共%d层",[self.allCengTotalNumArr[self.oneComponentNum] intValue]];
    }
}



#pragma mark =================== view
#pragma mark ===
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.rollBackView];
    [self.rollBackView addSubview:self.pickView];
    [self.subMainBackView addSubview:self.typeBtnBackView];
    [self.subMainBackView addSubview:self.centerTipLabel];
    [self.subMainBackView addSubview:self.finishBtn];
    [self.subMainBackView addSubview:self.titleL];
    [self.subMainBackView addSubview:self.concentL];
    [self typeBtnBackViewAddSubBtns];
}
- (void)typeBtnBackViewAddSubBtns{
    [self.typeBtnBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//旧数据去掉
    NSArray *titleArr = [NSArray arrayWithObjects:@"单层",@"多层",@"独栋", nil];
    NSInteger count = titleArr.count;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = [self baseBtn];
        if (i==0) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
        [btn setTitle:[NSString stringWithFormat:@"%@",titleArr[i]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i*(W_subBtn+10), 5, W_subBtn, H_SubBtn);//5_top
        btn.tag = Tag_SubBtn +i;
        [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeBtnBackView addSubview:btn];
    }
}
- (UIButton *)baseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:Y_RGBA(245, 245, 245, 1)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:PopView_subBlueColor] forState:UIControlStateSelected];
    btn.layer.cornerRadius = H_SubBtn*0.5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)subBtnAction:(UIButton *)sender{
    if (sender.selected==YES) {
        return;
    }
    NSInteger index = sender.tag-Tag_SubBtn;
    //Btn Ui
    [self reNewUI:sender];
    //滚轮
    switch (index) {
        case 0:
            self.floorType = PopView_Floor_Type_OnlyOneFloor;
            break;
        case 1:
            self.floorType = PopView_Floor_Type_MoreFloor;
            break;
        case 2:
            self.floorType = PopView_Floor_Type_DuLiFloor;
            break;
    }
    [self changePickVShowNumWithType];
    
}
#pragma mark=== 单选
- (void)reNewUI:(UIButton *)sender{

    for (UIButton *subB in    sender.superview.subviews) {
        if (subB.tag == sender.tag) {
            subB.selected = YES;
        }else{
            subB.selected = NO;
        }
    }
}

#pragma mark ==
- (void)setUI{
    //滚轮
    [_rollBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_rollBackView.superview.mas_bottom);
        make.left.equalTo(_rollBackView.superview.mas_left);
        make.right.equalTo(_rollBackView.superview.mas_right);
        make.height.offset(Screen_H*0.3);
    }];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_pickView.superview);
    }];
    //类型切换btn
    [_typeBtnBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_rollBackView.mas_top);
        make.left.equalTo(_typeBtnBackView.superview.mas_left).offset(10);
        make.right.equalTo(_typeBtnBackView.superview.mas_right).offset(-10);
        make.height.offset(40);
    }];
    [_centerTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_typeBtnBackView.mas_top);
        make.left.equalTo(_centerTipLabel.superview.mas_left);
        make.right.equalTo(_centerTipLabel.superview.mas_right);
        make.height.offset(40);
    }];
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerTipLabel.mas_top);
        make.right.equalTo(_centerTipLabel.mas_right);
        make.height.offset(40);
        make.width.offset(70);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(10);
        make.height.offset(20);
        make.centerX.equalTo(_titleL.superview.mas_centerX);
        make.width.offset(70);
    }];
    [_concentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom);
        make.bottom.equalTo(_centerTipLabel.mas_top);
        make.centerX.equalTo(_titleL.mas_centerX);
        make.width.offset(Screen_W);
    }];
    
}
#pragma mark ==
- (UIView *)rollBackView{
    if (!_rollBackView) {
        _rollBackView = [[UIView alloc]init];
        _rollBackView.backgroundColor =[UIColor whiteColor];
    }
    return _rollBackView;
}
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
//
- (UIView *)typeBtnBackView{
    if (!_typeBtnBackView) {
        _typeBtnBackView = [[UIView alloc]init];
    }
    return _typeBtnBackView;
}
//
- (UILabel *)centerTipLabel{
    if (!_centerTipLabel) {
        _centerTipLabel = [[UILabel alloc]init];
        _centerTipLabel.font = [UIFont systemFontOfSize:14];
        _centerTipLabel.textColor = Y_RGBA(110, 114, 125, 1);
        _centerTipLabel.backgroundColor = Y_RGBA(249, 249, 249, 1);
        _centerTipLabel.textAlignment = NSTextAlignmentCenter;
        _centerTipLabel.text = @"请选择楼层";
    }
    return _centerTipLabel;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:PopView_subBlueColor forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}
//
- (UILabel *)concentL{
    if (!_concentL) {
        _concentL = [[UILabel alloc]init];
        _concentL.textColor = PopView_subBlueColor;
        _concentL.font = [UIFont systemFontOfSize:18];
        _concentL.textAlignment = NSTextAlignmentCenter;
    }
    return _concentL;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = Y_RGBA(110, 114, 125, 1);
        _titleL.font = [UIFont systemFontOfSize:12];
        _titleL.text = @"楼层";
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}
@end
