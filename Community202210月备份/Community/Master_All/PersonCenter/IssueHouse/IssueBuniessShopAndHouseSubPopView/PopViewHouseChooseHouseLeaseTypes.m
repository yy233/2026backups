//
//  PopViewHouseChooseHouseLeaseTypes.m
//  Community
//
//  Created by 余莹 on 2021/2/27.
//

#import "PopViewHouseChooseHouseLeaseTypes.h"
#import "IssueHouseConstModel.h"

@implementation PopViewHouseChooseHouseLeaseTypes

#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self reSetLabelText];//typenil无效
        [self reSetTypeBtnHidden];
        [self reSetPickView];
        [self reSetLabelText];
    }
    return self;
}
- (void)changePickVShowNumWithType{//重写防止父类行数据越界崩溃
}
#pragma mark == 数据 重写
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    self.typeDataSourceModelArr = [NSMutableArray arrayWithArray:[IssueHouseConstModel mj_objectArrayWithKeyValuesArray:dataSourceArr]];
    IssueHouseConstModel *model = self.typeDataSourceModelArr.firstObject;
    self.concentL.text = [TextShowWithModelStr textShowWithModelStr:model.houseConstName];
    [self.pickView reloadAllComponents];
}
#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.5;
}
#pragma mark === okBtn 重写
- (void)okBtnAction{
    if (_leaseTypesPopViewDelegate && [_leaseTypesPopViewDelegate respondsToSelector:@selector(popViewChooseHouseLeaseTypeWithModel:)]) {
        [_leaseTypesPopViewDelegate popViewChooseHouseLeaseTypeWithModel: self.typeDataSourceModelArr[self.nowChooseRowNum]];
    }
    [self dismissThePopView];
}
#pragma mark ==
- (void)reSetLabelText{
//    if (self.shopPublishType == BuniessShopPublish_Type_type) {
//        self.titleL.text = @"商铺类型";
//        self.centerTipLabel.text = @"请选择类型";
//        self.concentL.text = @"";
//    }else  if (self.shopPublishType == BuniessShopPublish_Type_business) {
//        self.titleL.text = @"商铺行业";
//        self.centerTipLabel.text = @"请选择行业";
//        self.concentL.text = @"";
//    }else{}
        self.titleL.text = @"房屋类型";
        self.centerTipLabel.text = @"请选择";
        self.concentL.text = @"";
  
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
    IssueHouseConstModel *model = self.typeDataSourceModelArr[row];
    attributedString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[TextShowWithModelStr textShowWithModelStr:model.houseConstName]]];
    return attributedString;
}

////设置每一行的view样式
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    return [UIButton buttonWithType:UIButtonTypeContactAdd];
//}

//返回当前选中的是哪一列的哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.nowChooseRowNum = row;
    IssueHouseConstModel *model = self.typeDataSourceModelArr[row];
    self.concentL.text =  [NSString stringWithFormat:@"%@",[TextShowWithModelStr textShowWithModelStr:model.houseConstName]];
}
@end
