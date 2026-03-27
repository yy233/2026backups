//
//  PopviewWIthChoosePayType.m
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import "PopviewWithChoosePayType.h"

@interface PopviewWithChoosePayType ()
@property (nonatomic,assign) NSInteger saveChooseRowNum;
@property (nonatomic,strong) NSMutableArray *savePayTypeModelArr;
@end

@implementation PopviewWithChoosePayType

- (NSMutableArray *)savePayTypeModelArr{
    if (!_savePayTypeModelArr) {
        _savePayTypeModelArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _savePayTypeModelArr;
}
#pragma mark ===
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    self.savePayTypeModelArr = [NSMutableArray arrayWithArray:dataSourceArr];
    [self.typePickV reloadAllComponents];
}

- (void)addSubPickV{
    [self.subMainBackView addSubview:self.typePickV];
}
 
- (void)setSubPickvUI{
    WEAKSELF
    [_typePickV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.left.right.bottom.equalTo(_typePickV.superview);
    }];
}

- (UIPickerView *)typePickV{
    if (!_typePickV) {
        _typePickV = [[UIPickerView alloc]init];
        _typePickV.delegate = self;
        _typePickV.dataSource = self;
        _typePickV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor;
    }
    return _typePickV;
}
#pragma mark ===

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.savePayTypeModelArr.count+1;
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
    if (row==0) {
        return [[NSAttributedString alloc]initWithString:@"全部费种" attributes:attributs];
    }else{
        LifeCostPayTypeModel *model = self.savePayTypeModelArr[row-1];
        NSString *monthStrOfRow = [TextShowWithModelStr textShowWithModelStr:model.typeName];
        return [[NSAttributedString alloc]initWithString:monthStrOfRow attributes:attributs];
    }
}


//返回当前选中的是哪一列的哪一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    DLog(@"返回当前选中的是哪一列的哪一行%ld %ld",(long)row,(long)component);
    self.saveChooseRowNum = row;
}

#pragma mark ===
- (void)touchOkAction{
    DLog(@"");
    if (_delegagtePayType) {
        
        if (self.saveChooseRowNum == 0) {
            if ([_delegagtePayType respondsToSelector:@selector(popViewChooseALlPayType)]) {
                [_delegagtePayType popViewChooseALlPayType];
            }
        }else{
            LifeCostPayTypeModel *model = self.savePayTypeModelArr[self.saveChooseRowNum-1];
            if ([_delegagtePayType respondsToSelector:@selector(popViewChoosePayTypeWithModel:)]) {
                [_delegagtePayType popViewChoosePayTypeWithModel:model];
            }
        }
        
    }
    
}
 
@end
