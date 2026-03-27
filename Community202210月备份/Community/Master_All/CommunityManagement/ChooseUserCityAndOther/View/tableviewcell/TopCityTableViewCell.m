//
//  TopCityTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import "TopCityTableViewCell.h"
//#define cityItem_W (Screen_W/4-20)-20
//#define cityItem_H 40
//#define cityItem_Max_H 50
//#define cityItem_OneLine_MaxNum 3

//#define cityItem_W ((Screen_W-20)/4-20)-10
#define cityItem_W ((Screen_W-20)/4)-10
#define cityItem_Max_W ((Screen_W-20)/4)
#define cityItem_H 30
#define cityItem_Max_H 40
#define cityItem_OneLine_MaxNum 4

@implementation TopCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)setDataSourceArr:(NSMutableArray<CityChooseModel *> *)dataSourceArr{
    _dataSourceArr = dataSourceArr;
    [self setUI];
}
- (void)setUI{
    for (int i = 0; i < _dataSourceArr.count ; i++) {
        CityChooseModel *model = _dataSourceArr[i];
        UIButton *cityItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [cityItem setTitle:model.name forState:UIControlStateNormal];
        cityItem.titleLabel.font = [UIFont systemFontOfSize:14];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [cityItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cityItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [cityItem setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]forState:UIControlStateNormal];
            [cityItem setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateSelected];
        }else{
            [cityItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
            [cityItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateSelected];
            [cityItem setBackgroundColor:[UIColor clearColor]];
        }
        cityItem.layer.cornerRadius = 2.5;
        cityItem.layer.masksToBounds = YES;
        cityItem.layer.borderWidth = 1;
        cityItem.layer.borderColor = [UIColor grayColor].CGColor;
        cityItem.tag = Main_SUB_CityChoose_TopCityItem_TAG+i;
        [cityItem addTarget:self action:@selector(hotCityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat x = (i%cityItem_OneLine_MaxNum)*cityItem_Max_W +20;
        CGFloat y = (i/cityItem_OneLine_MaxNum)*cityItem_Max_H +10;
        //        cityItem.frame = CGRectMake(x, y, cityItem_W, cityItem_H);
        cityItem.frame = CGRectMake(x, y, cityItem_W, cityItem_H);
        
        [self.contentView addSubview:cityItem];
    }
}


- (void)hotCityBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    for (int i = 0; i<self.contentView.subviews.count; i++) {
        UIButton *btn = (UIButton *)self.contentView.subviews[i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(topCityTableViewCellBtnAction:)]) {
        [_delegate topCityTableViewCellBtnAction:sender];
    }
}




@end
