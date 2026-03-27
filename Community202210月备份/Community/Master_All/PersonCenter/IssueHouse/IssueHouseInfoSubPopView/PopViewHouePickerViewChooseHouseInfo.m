//
//  PopViewHouePickerViewChooseHouseInfo.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import "PopViewHouePickerViewChooseHouseInfo.h"
#define Tag_TopBtn           300
#define Width_Top_OneItem   (Screen_W/3)

@interface PopViewHouePickerViewChooseHouseInfo ()  <UIPickerViewDelegate,UIPickerViewDataSource>
//
@property (nonatomic,strong) UIView *topAllViewBackView;
@property (nonatomic,strong) UIView *leftLineV;
@property (nonatomic,strong) UIView *rightLineV;
//
@property (nonatomic,strong) UILabel *topOneTitleL;
@property (nonatomic,strong) UILabel *topTwoTitleL;
@property (nonatomic,strong) UILabel *topThrTitleL;
@property (nonatomic,strong) UILabel *oneConcentL;
@property (nonatomic,strong) UILabel *twoConcentL;
@property (nonatomic,strong) UILabel *thrConcentL;
@property (nonatomic,strong) UIButton *topOneBtn;
@property (nonatomic,strong) UIButton *topTwoBtn;
@property (nonatomic,strong) UIButton *topThrBtn;
//
@property (nonatomic,strong) UILabel *centerTipLabel;
@property (nonatomic,strong) UIButton *finishBtn;
@property (nonatomic,strong) UIPickerView *pickView;
//__________________________
//
@property (nonatomic,strong) NSMutableArray *saveDoorModelRowNumArr;
@property (nonatomic,strong) NSMutableArray *saveTowardRowNumArr;
@property (nonatomic,strong) NSMutableArray *saveFloorRowNumArr;
//
@property (nonatomic,strong) NSMutableArray *doormodelOneArr;
@property (nonatomic,strong) NSMutableArray *doormodelTwoAndThrArr;
@property (nonatomic,strong) NSMutableArray *towardArr;
@property (nonatomic,strong) NSMutableArray *floorOneArr;
@property (nonatomic,strong) NSMutableArray *floorTwoArr;
//
@property (nonatomic,strong) NSMutableArray *codeSaveArr;//code 房屋类型 朝向 楼层 （用于发布的数据处理 楼层暂时0不使用）
@end

@implementation PopViewHouePickerViewChooseHouseInfo

#pragma mark ===
- (void)showInView:(UIView *)supview withHouseInfoStrArr:(NSMutableArray*)showStrArr andSaveAllRowNumArr:(NSMutableArray *)allRowNumArr{
    self.chooseType = PopviewChooseHouseInfo_ChooseType_doorModel;
    [self showInView:supview thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
    //
    if (allRowNumArr.count == 3) {
        self.saveDoorModelRowNumArr = allRowNumArr.firstObject;
        self.saveTowardRowNumArr = allRowNumArr[1];
        self.saveFloorRowNumArr = allRowNumArr.lastObject;
    }
    if (showStrArr.count == 3) {
        self.oneConcentL.text = showStrArr.firstObject;
        self.twoConcentL.text = showStrArr[1];
        self.thrConcentL.text = showStrArr.lastObject;
    }
    [self changeShowType:self.chooseType];
}

#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame{
    [self initData];
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
    }
    return self;
}
#pragma mark ==
- (void)topBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag - Tag_TopBtn;
    switch (index) {
        case 0:
            [self changeShowType:PopviewChooseHouseInfo_ChooseType_doorModel];
            break;
        case 1:
            [self changeShowType:PopviewChooseHouseInfo_ChooseType_toward];
            break;
        case 2:
            [self changeShowType:PopviewChooseHouseInfo_ChooseType_floor];
            break;
        default:
            break;
    }
}
- (void)changeShowType:(PopviewChooseHouseInfo_ChooseType)type{
    self.chooseType = type;
    [self.pickView reloadAllComponents];//刷新 行列数据变化
    //UI
    switch (self.chooseType) {
        case PopviewChooseHouseInfo_ChooseType_doorModel:
            self.oneConcentL.textColor = Base_SubView_Use_BlueColor;
            self.twoConcentL.textColor = [UIColor blackColor];
            self.thrConcentL.textColor = [UIColor blackColor];
            [self.pickView selectRow:((NSInteger)[self.saveDoorModelRowNumArr.firstObject integerValue]) inComponent:0 animated:NO];
            [self.pickView selectRow:((NSInteger)[self.saveDoorModelRowNumArr[1] integerValue]) inComponent:1 animated:NO];
            [self.pickView selectRow:((NSInteger)[self.saveDoorModelRowNumArr.lastObject integerValue]) inComponent:2 animated:NO];
            self.centerTipLabel.text = @"请选择厅室数量";
            self.topOneBtn.selected = YES;
            self.topTwoBtn.selected = NO;
            self.topThrBtn.selected = NO;
            self.topOneBtn.backgroundColor =  [Base_SubView_Use_BlueColor colorWithAlphaComponent:0.1];
            self.topTwoBtn.backgroundColor = [UIColor clearColor];
            self.topThrBtn.backgroundColor = [UIColor clearColor];
            break;
        case PopviewChooseHouseInfo_ChooseType_toward:
            self.oneConcentL.textColor =[UIColor blackColor] ;
            self.twoConcentL.textColor = Base_SubView_Use_BlueColor;
            self.thrConcentL.textColor = [UIColor blackColor];
            [self.pickView selectRow:((NSInteger)[self.saveTowardRowNumArr.firstObject integerValue]) inComponent:0 animated:NO];
            self.centerTipLabel.text = @"请选择朝向";
            self.topOneBtn.selected = NO;
            self.topTwoBtn.selected = YES;
            self.topThrBtn.selected = NO;
            self.topOneBtn.backgroundColor = [UIColor clearColor];
            self.topTwoBtn.backgroundColor = [Base_SubView_Use_BlueColor colorWithAlphaComponent:0.1];
            self.topThrBtn.backgroundColor = [UIColor clearColor];
            break;
        case PopviewChooseHouseInfo_ChooseType_floor:
            self.oneConcentL.textColor = [UIColor blackColor];
            self.twoConcentL.textColor = [UIColor blackColor];
            self.thrConcentL.textColor = Base_SubView_Use_BlueColor;
            [self.pickView selectRow:((NSInteger)[self.saveFloorRowNumArr.firstObject integerValue]) inComponent:0 animated:NO];//楼层-层
            NSInteger index = (NSInteger)[self.saveFloorRowNumArr.lastObject integerValue];
            [self.pickView selectRow:(index) inComponent:1 animated:NO];//
            self.centerTipLabel.text = @"请选择楼层";
            self.topOneBtn.selected = NO;
            self.topTwoBtn.selected = NO;
            self.topThrBtn.selected = YES;
            self.topOneBtn.backgroundColor = [UIColor clearColor];
            self.topTwoBtn.backgroundColor = [UIColor clearColor];
            self.topThrBtn.backgroundColor = [Base_SubView_Use_BlueColor colorWithAlphaComponent:0.1];
            break;
        default:
            break;
    }
    
    //Data
}
#pragma mark ==
//设置pickview一共有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (self.chooseType) {
        case PopviewChooseHouseInfo_ChooseType_doorModel:
            return 3;
            break;
        case PopviewChooseHouseInfo_ChooseType_toward:
            return 1;
            break;
        case PopviewChooseHouseInfo_ChooseType_floor:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}
 
// 设置pickview每列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.chooseType) {
        case PopviewChooseHouseInfo_ChooseType_doorModel:
            if (component==1||component==2) {
                return self.doormodelTwoAndThrArr.count;
            }else{
                return self.doormodelOneArr.count;
            }
            break;
        case PopviewChooseHouseInfo_ChooseType_toward:
            return self.towardArr.count;
            break;
        case PopviewChooseHouseInfo_ChooseType_floor:
            if (component==0) {
                return self.floorOneArr.count;
            }else{
                return self.floorTwoArr.count;
            }
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
    switch (self.chooseType) {
        case PopviewChooseHouseInfo_ChooseType_doorModel:
            if (component == 0) {
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld室",(long)[self.doormodelOneArr[row] integerValue]]];
            }else if (component == 1) {
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld厅",(long)[self.doormodelTwoAndThrArr[row] integerValue]]];
            }else{
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld卫",(long)[self.doormodelTwoAndThrArr[row] integerValue]]];
            }
            break;
        case PopviewChooseHouseInfo_ChooseType_toward:
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.towardArr[row]]];
            break;
        case PopviewChooseHouseInfo_ChooseType_floor:
            if (component == 0) {
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld层",(long)[self.floorOneArr[row] integerValue]]];
            }else{
                attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"共%ld层",(long)[self.floorTwoArr[row] integerValue]]];
            }

            break;
    }
    return attributedString;
}
 
 
//返回当前选中的是哪一列的哪一行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DLog(@"返回当前选中的是哪一列的哪一行%ld %ld",(long)row,(long)component);
    NSInteger oneComponentNum = 0;
    NSInteger twoComponentNum = 0;
    NSInteger thrComponentNum = 0;
    //Data
    if (component==0) {
        oneComponentNum = row;
    }else if (component==1){
        twoComponentNum= row;
    }else if (component==2){
        thrComponentNum= row;
    }else{
    }
    //UI+saveData
    switch (self.chooseType) {
        case PopviewChooseHouseInfo_ChooseType_doorModel:
        {
            [self.saveDoorModelRowNumArr replaceObjectAtIndex:component withObject:@(row)];
            self.oneConcentL.text = [NSString stringWithFormat:@"%@室%@厅%@卫",self.doormodelOneArr[(NSInteger)[self.saveDoorModelRowNumArr.firstObject intValue]],self.doormodelTwoAndThrArr[(NSInteger)[self.saveDoorModelRowNumArr[1] intValue]],self.doormodelTwoAndThrArr[(NSInteger)[self.saveDoorModelRowNumArr.lastObject intValue]]];
        }
            break;
        case PopviewChooseHouseInfo_ChooseType_toward:
            [self.saveTowardRowNumArr replaceObjectAtIndex:0 withObject:@(row)];
            self.twoConcentL.text = [NSString stringWithFormat:@"%@",self.towardArr[oneComponentNum]];
            break;
        case PopviewChooseHouseInfo_ChooseType_floor:
            [self.saveFloorRowNumArr replaceObjectAtIndex:component withObject:@(row)];
          //self.thrConcentL.text = [NSString stringWithFormat:@"%@/%@",self.floorOneArr[(NSInteger)[self.saveFloorRowNumArr.firstObject intValue]],self.floorTwoArr[(NSInteger)[self.saveFloorRowNumArr[1] intValue]]];
            self.thrConcentL.text = [NSString stringWithFormat:@"%@层共%@层",self.floorOneArr[(NSInteger)[self.saveFloorRowNumArr.firstObject intValue]],self.floorTwoArr[(NSInteger)[self.saveFloorRowNumArr[1] intValue]]];
    }
    
}

#pragma mark ========
#pragma mark == initData
- (void)initData{
    self.towardArr = [NSMutableArray arrayWithObjects:@"东",@"南",@"西",@"北", nil];
    self.doormodelOneArr = [[NSMutableArray alloc]init];
    self.doormodelTwoAndThrArr = [[NSMutableArray alloc]init];
    self.floorOneArr = [[NSMutableArray alloc]init];
    self.floorTwoArr = [[NSMutableArray alloc]init];
    for (int i = -99; i < 100; i++) {
        if (i<0) {
            [self.floorOneArr addObject:@(i)];;//第几层
        }else if(i==0){
            [self.doormodelTwoAndThrArr addObject:@(i)];//厅卫
        }else{
            [self.doormodelOneArr addObject:@(i)];//室
            [self.doormodelTwoAndThrArr addObject:@(i)];//厅卫
            [self.floorOneArr addObject:@(i)];//第几层
            [self.floorTwoArr addObject:@(i)];//共x层
        }
    }
    //
    self.saveDoorModelRowNumArr = [NSMutableArray arrayWithObjects:@(0),@(0),@(0), nil];
    self.saveTowardRowNumArr = [NSMutableArray arrayWithObjects:@(0), nil];
    NSInteger idex = self.floorOneArr.count/2;
    self.saveFloorRowNumArr = [NSMutableArray arrayWithObjects:@(idex),@(0), nil];
    DLog(@"")
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.5;
}
#pragma mark == 边角 重写
- (void)changMainBackViewCornerRadius{
    self.subMainBackView.layer.cornerRadius = 0;
}
 
- (void)okBtnAction{
    
    DLog(@"");
    NSMutableArray *codeArr = [[NSMutableArray alloc]init];
    //
    NSNumber *houseTypeCode = [self getHousCodeWithSelfInfo];
    [codeArr addObject:houseTypeCode];//房屋户型code 6位数 num型会出现5位 在vc处理%0.6@
    //
    NSNumber *directionCodeNum = [self getDirectionCodeWithTowardStr:self.twoConcentL.text];
    [codeArr addObject:directionCodeNum];//朝向 houseDirection
    [codeArr addObject:@(0)];//楼层不使用该值 置0
    self.codeSaveArr = [NSMutableArray arrayWithArray:codeArr];//
    //
    if (_houseInfoDelegate && [_houseInfoDelegate respondsToSelector:@selector(okActionWithHouseInfoGetStrArr:withInfoGetCodeArr:withGetSaveRowNumArr:)]) {
        NSMutableArray *strArr = [NSMutableArray arrayWithObjects:self.oneConcentL.text,self.twoConcentL.text,self.thrConcentL.text,nil];
        NSMutableArray *saveRowNumArr = [NSMutableArray arrayWithObjects:self.saveDoorModelRowNumArr,self.saveTowardRowNumArr,self.saveFloorRowNumArr, nil];//房屋类型 朝向 楼层
        [_houseInfoDelegate okActionWithHouseInfoGetStrArr:strArr withInfoGetCodeArr:codeArr withGetSaveRowNumArr:saveRowNumArr];
    }
    [self dismissThePopView];
}
//
- (NSNumber *)getHousCodeWithSelfInfo{// house type  code6位5位
    NSInteger shi = [self.doormodelOneArr[(NSInteger)[self.saveDoorModelRowNumArr.firstObject intValue]] integerValue];
    NSInteger ting = [self.doormodelTwoAndThrArr[(NSInteger)[self.saveDoorModelRowNumArr[1] intValue]]  integerValue];
    NSInteger wei = [self.doormodelTwoAndThrArr[(NSInteger)[self.saveDoorModelRowNumArr.lastObject intValue]]  integerValue];
    //
    NSString *strOfTypeCodeStr = [NSString stringWithFormat:@"%0.2ld%0.2ld%0.2ld",shi,ting,wei];
    NSNumber *typeCodeNum = [[NSNumber alloc]initWithInteger:[strOfTypeCodeStr integerValue]];
    DLog(@"------------PopviewChooseHouseInfo_ChooseType_doorModel  %@",typeCodeNum);
    return typeCodeNum;
}
- (NSNumber *)getDirectionCodeWithTowardStr:(NSString *)towardStr{
    //房屋朝向     code对应值---- 1.东.2.西 3.南 4.北. 5.东南 6.东北 7.西北 8.西南
    NSNumber *inexNum = @(0);
    for (int i = 0;  i < self.towardArr.count; i++) {
        if ([towardStr isEqualToString:[NSString stringWithFormat:@"%@",self.towardArr[i]]]) {
            inexNum = @(i+1);
        }
    }
    return inexNum;
}


#pragma mark == UI
#pragma mark ==
- (void)addSubAllView{
    [self.subMainBackView addSubview:self.topAllViewBackView];
    [self.topAllViewBackView addSubview:self.topOneTitleL];
    [self.topAllViewBackView addSubview:self.topTwoTitleL];
    [self.topAllViewBackView addSubview:self.topThrTitleL];
    [self.topAllViewBackView addSubview:self.oneConcentL];
    [self.topAllViewBackView addSubview:self.twoConcentL];
    [self.topAllViewBackView addSubview:self.thrConcentL];
    [self.topAllViewBackView addSubview:self.topOneBtn];
    [self.topAllViewBackView addSubview:self.topTwoBtn];
    [self.topAllViewBackView addSubview:self.topThrBtn];
    [self.topAllViewBackView addSubview:self.leftLineV];
    [self.topAllViewBackView addSubview:self.rightLineV];
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
        make.bottom.centerX.equalTo(_topAllViewBackView);
        make.width.offset(Width_Top_OneItem);
        make.height.equalTo(_topAllViewBackView.mas_height).multipliedBy(0.6);
    }];
    [_thrConcentL mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [_topThrTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_thrConcentL);
        make.height.equalTo(_topAllViewBackView.mas_height).multipliedBy(0.4);
        make.bottom.equalTo(_thrConcentL.mas_top);
    }];
    //--
    [_topOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_topAllViewBackView);
        make.width.offset(Width_Top_OneItem);
    }];
    [_topTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(_topAllViewBackView);
        make.width.offset(Width_Top_OneItem);
    }];
    [_topThrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(_topAllViewBackView);
        make.width.offset(Width_Top_OneItem);
    }];
    //--
    [_leftLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topAllViewBackView.mas_centerY);
        make.height.right.equalTo(_oneConcentL);
        make.width.offset(1);
    }];
    [_rightLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topAllViewBackView.mas_centerY);
        make.height.left.equalTo(_thrConcentL);
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
- (UIView *)rightLineV{
    if (!_rightLineV) {
        _rightLineV = [[UIView alloc]init];
        _rightLineV.backgroundColor = [Y_RGBA(110, 114, 125, 1) colorWithAlphaComponent:0.1];
    }
    return _rightLineV;
}
- (UIView *)leftLineV{
    if (!_leftLineV) {
        _leftLineV = [[UIView alloc]init];
        _leftLineV.backgroundColor = [Y_RGBA(110, 114, 125, 1) colorWithAlphaComponent:0.1];
    }
    return _leftLineV;
}
//
- (UILabel *)topOneTitleL{
    if (!_topOneTitleL) {
        _topOneTitleL = [[UILabel alloc]init];
        _topOneTitleL.textColor = Y_RGBA(110, 114, 125, 1);
        _topOneTitleL.font = [UIFont systemFontOfSize:12];
        _topOneTitleL.text = @"房屋户型";
        _topOneTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _topOneTitleL;
}
- (UILabel *)topTwoTitleL{
    if (!_topTwoTitleL) {
        _topTwoTitleL = [[UILabel alloc]init];
        _topTwoTitleL.textColor = Y_RGBA(110, 114, 125, 1);
        _topTwoTitleL.font = [UIFont systemFontOfSize:12];
        _topTwoTitleL.text = @"朝向";
        _topTwoTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _topTwoTitleL;
}
- (UILabel *)topThrTitleL{
    if (!_topThrTitleL) {
        _topThrTitleL = [[UILabel alloc]init];
        _topThrTitleL.textColor = Y_RGBA(110, 114, 125, 1);
        _topThrTitleL.font = [UIFont systemFontOfSize:12];
        _topThrTitleL.text = @"楼层";
        _topThrTitleL.textAlignment = NSTextAlignmentCenter;
    }
    return _topThrTitleL;
}
- (UILabel *)oneConcentL{
    if (!_oneConcentL) {
        _oneConcentL = [[UILabel alloc]init];
        _oneConcentL.textColor =  [UIColor blackColor];// Base_SubView_Use_BlueColor
        _oneConcentL.font = [UIFont systemFontOfSize:18];
        _oneConcentL.textAlignment = NSTextAlignmentCenter;
        _oneConcentL.text = @"1室0厅0卫";
    }
    return _oneConcentL;
}
- (UILabel *)twoConcentL{
    if (!_twoConcentL) {
        _twoConcentL = [[UILabel alloc]init];
        _twoConcentL.textColor =  [UIColor blackColor];
        _twoConcentL.font = [UIFont systemFontOfSize:18];
        _twoConcentL.textAlignment = NSTextAlignmentCenter;
        _twoConcentL.text = @"东";
    }
    return _twoConcentL;
}
- (UILabel *)thrConcentL{
    if (!_thrConcentL) {
        _thrConcentL = [[UILabel alloc]init];
        _thrConcentL.textColor =  [UIColor blackColor];
        _thrConcentL.font = [UIFont systemFontOfSize:18];
        _thrConcentL.textAlignment = NSTextAlignmentCenter;
//        _thrConcentL.text = @"1/1";
        _thrConcentL.text = @"1层共1层";
    }
    return _thrConcentL;
}
//
- (UIButton *)topOneBtn{
    if (!_topOneBtn) {
        _topOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topOneBtn.tag = Tag_TopBtn +0;
        [_topOneBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_topOneBtn setImage:[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1]] forState:UIControlStateNormal];
//        [_topOneBtn setImage:[UIImage imageWithColor:[Base_SubView_Use_BlueColor colorWithAlphaComponent:0.2]] forState:UIControlStateSelected];
    }
    return _topOneBtn;
}
- (UIButton *)topTwoBtn{
    if (!_topTwoBtn) {
        _topTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topTwoBtn.tag = Tag_TopBtn +1;
        [_topTwoBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_topTwoBtn setImage:[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1]] forState:UIControlStateNormal];
//        [_topTwoBtn setImage:[UIImage imageWithColor:[Base_SubView_Use_BlueColor colorWithAlphaComponent:0.2]] forState:UIControlStateSelected];
    }
    return _topTwoBtn;
}
- (UIButton *)topThrBtn{
    if (!_topThrBtn) {
        _topThrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topThrBtn.tag = Tag_TopBtn +2;
        [_topThrBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_topThrBtn setImage:[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1]] forState:UIControlStateNormal];
//        [_topThrBtn setImage:[UIImage imageWithColor:[Base_SubView_Use_BlueColor colorWithAlphaComponent:0.2]] forState:UIControlStateSelected];
    }
    return _topThrBtn;
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
//
- (NSMutableArray *)codeSaveArr{
    if ( !_codeSaveArr ) {
        _codeSaveArr = [[NSMutableArray alloc]init];
    }
    return _codeSaveArr;
}
@end
