//
//  PopViewBuniessShopChooseShopType.m
//  Community
//
//  Created by 余莹 on 2021/1/21.
//

#import "PopViewBuniessShopChooseShopPublishTypes.h"

@interface PopViewBuniessShopChooseShopPublishTypes ()
@property (nonatomic,assign) BuniessShopOrHousePublish_Type shopOrHousePublishType;
//@property (nonatomic,strong) NSMutableArray *typeDataSourceModelArr;
//@property (nonatomic,assign) NSInteger nowChooseRowNum;
@end

@implementation PopViewBuniessShopChooseShopPublishTypes

- (void)showInView:(UIView *)supview thePopViewBuniessShopPublishType:(BuniessShopOrHousePublish_Type)type WithArray:(NSMutableArray *)array{
    self.shopOrHousePublishType = type;
    [self reSetLabelText];//重置
    [self showInView:supview thePopViewSubViewHeight:0 WithArray:array];
}
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self reSetLabelText];//typenil无效
        [self reSetTypeBtnHidden];
        [self reSetPickView];
    }
    return self;
}
- (void)changePickVShowNumWithType{//重写防止父类行数据越界崩溃
}
#pragma mark == 数据 重写
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    if (self.shopOrHousePublishType == BuniessShopOrHousePublish_Type_BedroomType) {
        _typeDataSourceModelArr = [NSMutableArray arrayWithArray:dataSourceArr];
        self.concentL.text = _typeDataSourceModelArr.firstObject;
    }else{
        _typeDataSourceModelArr = [NSMutableArray arrayWithArray:[IssueBuniessShopPublishTypeModel mj_objectArrayWithKeyValuesArray:dataSourceArr]];
        IssueBuniessShopPublishTypeModel *model = _typeDataSourceModelArr.firstObject;
        self.concentL.text = [TextShowWithModelStr textShowWithModelStr:model.constName];
    }

    [self.pickView reloadAllComponents];
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    /**
     if (self.shopOrHousePublishType == BuniessShopOrHousePublish_Type_BedroomType) {
         self.subMainViewHeight  = Screen_H*0.35;//先被重写 后有类型数据 此处高度没改变 为type0时调用的Screen_H*0.5;
     }else{
         self.subMainViewHeight  = Screen_H*0.5;
     }
     */
    
    if ((kScreenH < 850)) {
        self.subMainViewHeight  = Screen_H*0.5;
    }else{
        self.subMainViewHeight  = Screen_H*0.45;
    }

}
#pragma mark === okBtn 重写
- (void)okBtnAction{
    if (self.shopOrHousePublishType == BuniessShopOrHousePublish_Type_BedroomType) {
//       卧室类型 只有文本数据 typeDataSourceModelArr装入
        if (_publishTypesDelegate && [_publishTypesDelegate respondsToSelector:@selector(popViewChooseBuniessShopPublishTypeWithBedRoomTypeWithTouchIndex:withShowStr:)]) {
            NSString *showRowStr = self.typeDataSourceModelArr[self.nowChooseRowNum];
            [_publishTypesDelegate popViewChooseBuniessShopPublishTypeWithBedRoomTypeWithTouchIndex:self.nowChooseRowNum withShowStr:showRowStr];
        }
     
    }else{
        if (_publishTypesDelegate && [_publishTypesDelegate respondsToSelector:@selector(popViewChooseBuniessShopFloorWithType:andFloorStr:)]) {
            [_publishTypesDelegate popViewChooseBuniessShopPublishTypeWithType:self.shopOrHousePublishType andModel:self.typeDataSourceModelArr[self.nowChooseRowNum]];
        }
     
    }
    [self dismissThePopView];
}
#pragma mark ==
- (void)reSetLabelText{
    if (self.shopOrHousePublishType == BuniessShopOrHousePublish_Type_type) {
        self.titleL.text = @"商铺类型";
        self.centerTipLabel.text = @"请选择类型";
        self.concentL.text = @"";
    }else  if (self.shopOrHousePublishType == BuniessShopOrHousePublish_Type_business) {
        self.titleL.text = @"商铺行业";
        self.centerTipLabel.text = @"请选择行业";
        self.concentL.text = @"";
    }else if (self.shopOrHousePublishType == BuniessShopOrHousePublish_Type_BedroomType){
        self.titleL.text = @"卧室类型";
        self.titleL.font = [UIFont systemFontOfSize:14];
        self.centerTipLabel.text = @"请选择";
        self.concentL.text = @"";
    }else{
        self.titleL.text = @"";
        self.centerTipLabel.text = @"请选择";
        self.concentL.text = @"";
    }
}
- (void)reSetTypeBtnHidden{
    [self.typeBtnBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
    }];
    self.typeBtnBackView.layer.masksToBounds = YES;//独栋等按钮隐藏
}
- (void)reSetPickView{
    self.nowChooseRowNum = 0;
    [self.pickView selectRow:0 inComponent:0 animated:NO];
}
#pragma mark ===
- (NSMutableArray *)typeDataSourceModelArr{
    if (!_typeDataSourceModelArr) {
        _typeDataSourceModelArr = [[NSMutableArray alloc]init];
    }
    return _typeDataSourceModelArr;
}

#pragma mark==
#pragma mark ==
//设置pickview一共有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// 设置pickview每列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.typeDataSourceModelArr.count;
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
    if (self.shopOrHousePublishType == BuniessShopOrHousePublish_Type_BedroomType){
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", self.typeDataSourceModelArr[row]]];
    }else{
        IssueBuniessShopPublishTypeModel *model = self.typeDataSourceModelArr[row];
        attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[TextShowWithModelStr textShowWithModelStr:model.constName]]];
    }
  
    return attributedString;
}

////设置每一行的view样式
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    return [UIButton buttonWithType:UIButtonTypeContactAdd];
//}

//返回当前选中的是哪一列的哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.nowChooseRowNum = row;
    if (self.shopOrHousePublishType == BuniessShopOrHousePublish_Type_BedroomType){
        self.concentL.text =  [NSString stringWithFormat:@"%@",self.typeDataSourceModelArr[row]];
    }else{
        IssueBuniessShopPublishTypeModel *model = self.typeDataSourceModelArr[row];
        self.concentL.text =  [NSString stringWithFormat:@"%@",[TextShowWithModelStr textShowWithModelStr:model.constName]];
    }
   
}

@end
