//
//  ShippingAddressTitleAndBtnsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "ShippingAddressTitleAndBtnsTableViewCell.h"


@interface ShippingAddressTitleAndBtnsTableViewCell ()
@property (nonatomic,assign) BOOL isBottomCell;
@end

@implementation ShippingAddressTitleAndBtnsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//显示的 已经选择的idx
- (void)showSelectedIndex:(NSInteger)indx{
    [self changeUIWithBtnTag:(indx+200)];
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textField.hidden = YES;
        [self.backView addSubview:self.subBtnsBackView];
        [_subBtnsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleL.mas_right).offset(10);
            make.centerY.right.equalTo(_subBtnsBackView.superview);
            make.height.equalTo(self.titleL.mas_height);//30
        }];
    }
    return self;
}
 
- (UIView *)subBtnsBackView{
    if (!_subBtnsBackView) {
        _subBtnsBackView = [[UIView alloc]init];
    }
    return _subBtnsBackView;
}
- (void)fillCellBtnsCellTypeIsBottomCellTipType:(BOOL)isBottomCell withTitleArr:(NSMutableArray *)btnsTitleArr{
    self.isBottomCell = isBottomCell;
    for ( int i = 0; i <btnsTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn newAnBtnWithTextStr:btnsTitleArr[i]];
        [btn newAnBtnWithFont:FontSize_Orders_Nomail(12)];
        [btn newAnBtnWithLayerCorNerNum:2.5 withLayerLineWidth:0.5 withLayerLineColor:Color_153GrayColor];;
        [btn newAnBtnWithTextColorNomal:Color_153GrayColor withTextColorSelected:COlor_Red255];
        btn.frame = CGRectMake(i*60, 0, 55, 30);//
        //
        btn.tag = i+200;
        [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.subBtnsBackView addSubview:btn];
        
    }
}

- (void)subBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(touchCellTypeIsBottomCellTipType:withSubBtnIndex:)]) {
        [_delegate touchCellTypeIsBottomCellTipType:self.isBottomCell withSubBtnIndex:(sender.tag-200)];
    }
    [self setSubBtnUIWithBtn:(UIButton *)sender];
}
- (void)setSubBtnUIWithBtn:(UIButton *)sender{
    if (sender.selected == YES) {
        return;
    }
    [self changeUIWithBtnTag:sender.tag];
}
- (void)changeUIWithBtnTag:(NSInteger)btnTag{
    for (UIButton *btn in self.subBtnsBackView.subviews) {
        if (btn.tag == btnTag) {
            btn.selected = YES;
            [btn newAnBtnWithLayerCorNerNum:2.5 withLayerLineWidth:0.5 withLayerLineColor:COlor_Red255];
        }else{
            btn.selected = NO;
            [btn newAnBtnWithLayerCorNerNum:2.5 withLayerLineWidth:0.5 withLayerLineColor:Color_153GrayColor];;
           
        }
    }
}

@end
