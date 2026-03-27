//
//  ParkingPayMonthlyNumBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/27.
//

#import "ParkingPayMonthlyNumBtnTableViewCell.h"

@implementation ParkingPayMonthlyNumBtnTableViewCell

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
        self.monthlyN = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
//        self.backView.backgroundColor = Color_11BlueColor;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.textF];
        [self.backView addSubview:self.subtractBtn];
        [self.backView addSubview:self.addBtn];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview).offset(16);
        make.top.bottom.equalTo(_titleL.superview);
        make.width.offset(75);
    }];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addBtn.superview);
        make.height.offset(30);
        make.right.equalTo(_addBtn.superview).offset(-16);
    }];
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_textF.superview);
        make.right.equalTo(_addBtn.mas_left).offset(-10);
    }];
    [_subtractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addBtn.superview);
        make.height.offset(30);
        make.right.equalTo(_textF.mas_left).offset(-10);
    }];
  
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.font = [UIFont systemFontOfSize:15];
        _textF.textColor = [ThemeManager shareManager].mainTextColor;
        _textF.textAlignment = NSTextAlignmentRight;
        _textF.text = @"0";//文本状态的0
        _textF.userInteractionEnabled = NO;//不可输入
     
//        _textF.delegate = self;
    }
    return _textF;
}
//
- (UIButton *)subtractBtn{
    if (!_subtractBtn) {
        _subtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subtractBtn newAnBtnWithImg:[UIImage imageNamed:@"reduce_black"]];
        [_subtractBtn addTarget:self action:@selector(changeMonthlyNumAction:) forControlEvents:UIControlEventTouchUpInside];
        _subtractBtn.tag = 200;
    }
    return _subtractBtn;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([ThemeManager shareManager].type == ThemeType_Drak) {
            [_addBtn newAnBtnWithImg:[UIImage imageNamed:@"plus_black"]];//白色
        }else{
            [_addBtn newAnBtnWithImg:[UIImage imageNamed:@"addM_blue"]];//蓝色
        }
//        [_addBtn newAnBtnWithImg:[UIImage imageNamed:@"addM_blue"]];//addM_blue plus_black
        [_addBtn addTarget:self action:@selector(changeMonthlyNumAction:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = 201;
        //
        [_addBtn newAnBtnWithTextStr:@"月"];
        [_addBtn newAnBtnWithTextColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]];
        [_addBtn newAnBtnWithFont:[UIFont systemFontOfSize:14]];
        [_addBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return _addBtn;
}

- (void)changeMonthlyNumAction:(UIButton *)sender{
   NSInteger willChangeN = sender.tag-200;
   // NSLog(@"包月数量 cell 加减之前的 ==== 月份数 %ld", (long)self.monthlyN);
    if (willChangeN==0) {//减
        self.monthlyN -= 1;
    }else{//加
        self.monthlyN += 1;
    }
    //不可为负数
    if (self.monthlyN<0) {
        self.monthlyN = 0;//
    }
    //文本显示
    self.textF.text = [NSString stringWithFormat:@"%ld",self.monthlyN];
//    if (willChangeN == 0) {
//        NSLog(@"包月数量 （增加减少） 减减减减 ==== 月份数 %ld", (long)self.monthlyN);
//    }else{
//        NSLog(@"包月数量 （增加减少） ++++ ==== 月份数 %ld", (long)self.monthlyN);
//    }
    //传数据
    self.monthlyNumChangeBlock(self.monthlyN);
   
  

}
/***
 
 @property (nonatomic,strong) UILabel *titleL;
 @property (nonatomic,strong) UILabel *textF;
 @property (nonatomic,strong) UIButton *subtractBtn;
 @property (nonatomic,strong) UIButton *addBtn;
 
 */
@end
