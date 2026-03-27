//
//  HouseRentDetailHousesDetailListTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/6.
//房屋介绍

#import "HouseRentDetailHousesDetailListTableViewCell.h"
@interface HouseRentDetailHousesDetailListTableViewCell ()
@property (nonatomic,strong) UILabel *titleL;


@end
@implementation HouseRentDetailHousesDetailListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    _model = model;
    //文本部分
    _houseIntroduceLabel.text = [TextShowWithModelStr textShowWithModelStr:model.houseIntroduce];
    CGFloat houseIntroduceH = [model getHouseIntroduceHeight]; //高度在遇到分段时短了
    [_houseIntroduceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(houseIntroduceH);
    }];
    //
    if (_model.houseLeasemodeId == 2) {//整租
        [self detailListBackViewAddSubBtn];
    }else if((_model.houseLeasemodeId == 8)){//单间
        [self notZhengZuDetailListBackViewAddSubBtn];
    }else{//其他/合租旧数据
        [self detailListBackViewAddSubBtn];
    }
}
- (void)notZhengZuDetailListBackViewAddSubBtn{
    //用于子类重写
}
- (void)detailListBackViewAddSubBtn{
    CGFloat listViewH = [_model getHouseIntroduceListViewHeight];
    [_detailListBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(listViewH);
    }];
    float btn_W = (Screen_W-32)/4;
    float btn_h = 20;
    float btn_jiancha = 10;//高度
    [self.detailListBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 1; i < self.model.houseFurniture.count+1; i ++) {
        UIButton *btn = [self baseBtnWithText:[TextShowWithModelStr textShowWithModelStr:_model.houseFurniture[i-1]]];
        btn.frame = CGRectMake(((i-1)%4)*btn_W ,(i-1)/4*(btn_h+btn_jiancha), btn_W,btn_h);
        [self.detailListBackView addSubview:btn];
    }
}
- (UIButton *)baseBtnWithText:(NSString *)str{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    [btn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
//    btn.titleLabel.textAlignment = NSTextAlignmentCenter;//时间开销过多
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:str forState:UIControlStateNormal];
    if ([ThemeManager shareManager].type==ThemeType_White) {
        [btn setImage:[UIImage imageNamed:@"Rentaldetails_Housing_Check_heise"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"Rentaldetails_Housing_Check"] forState:UIControlStateNormal];
    }
    [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
   
    return btn;
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.houseIntroduceLabel];
        [self.contentView addSubview:self.detailListBackView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(10);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.right.equalTo(_titleL.superview.mas_right).offset(-16);
        make.height.offset(20);
    }];
    [_houseIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom);
        make.left.equalTo(_houseIntroduceLabel.superview.mas_left).offset(16);
        make.right.equalTo(_houseIntroduceLabel.superview.mas_right).offset(-16);
        make.height.offset(20);//初始
    }];
    [_detailListBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_houseIntroduceLabel.mas_bottom);
        make.left.equalTo(_detailListBackView.superview.mas_left).offset(16);
        make.right.equalTo(_detailListBackView.superview.mas_right).offset(-16);
        make.height.offset(20);//
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:17];
        _titleL.text = @"房屋介绍";
    }
    return _titleL;
}
- (UILabel *)houseIntroduceLabel{
    if (!_houseIntroduceLabel) {
        _houseIntroduceLabel = [[UILabel alloc]init];
        _houseIntroduceLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _houseIntroduceLabel.font = [UIFont systemFontOfSize:14];
        _houseIntroduceLabel.text = @"";
        _houseIntroduceLabel.numberOfLines = 0;
    }
    return _houseIntroduceLabel;
}
- (UIView *)detailListBackView{
    if (!_detailListBackView) {
        _detailListBackView = [[UIView alloc]init];
    }
    return _detailListBackView;
}
 

@end
