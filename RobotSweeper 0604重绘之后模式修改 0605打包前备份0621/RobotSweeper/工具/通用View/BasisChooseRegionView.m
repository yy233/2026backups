//
//  BasisChooseRegionView.m
//  OA
//
//  Created by yy on 17/6/26.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "BasisChooseRegionView.h"

@implementation BasisChooseRegionView
-(void)awakeFromNib{
    [super awakeFromNib];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
   
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)setArrOfData:(NSArray *)arrOfData{
    _arrOfData = arrOfData;
    if (_arrOfData.count>0) {
        _strOfNewSelect = _arrOfData[0];
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arrOfData.count;
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _arrOfData[row];
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    //设置分割线的颜色
//    for(UIView *singleLine in pickerView.subviews)
//    {
//        if (singleLine.frame.size.height < 1)
//        {
//            singleLine.backgroundColor = BlueColor;
//        }
//    }
//    return view;
//}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     NSLog(@"didSelectRow=%@",_arrOfData[row]);
    _strOfNewSelect = [NSString stringWithFormat:@"%@",_arrOfData[row]];
}
- (IBAction)btnOfOkAction:(UIButton *)sender {
    if (_delegateOfRegion && [_delegateOfRegion respondsToSelector:@selector(regionOfdidSelect:)]) {
        [_delegateOfRegion regionOfdidSelect:_strOfNewSelect];
    }
}
- (IBAction)btnOfRemoveRegionView:(UIButton *)sender {
    if (_delegateOfRegion && [_delegateOfRegion respondsToSelector:@selector(removeRegionView)]) {
        [_delegateOfRegion removeRegionView];
    }
    
}
@end
