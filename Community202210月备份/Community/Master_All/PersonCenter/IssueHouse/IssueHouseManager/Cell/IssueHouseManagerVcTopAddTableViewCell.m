//
//  IssueHouseManagerVcHouseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import "IssueHouseManagerVcTopAddTableViewCell.h"
#define    Color_2Green    Y_RGBA(2, 195, 168, 1)
@implementation IssueHouseManagerVcTopAddTableViewCell

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
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 7.5;
        //
        [self.contentView addSubview:self.greenbackView];
        [self.backView addSubview:self.centerBtn];
        [self.backView addSubview:self.centerBottomL];
        //
        [self.contentView sendSubviewToBack:self.greenbackView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_greenbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_greenbackView.superview);
        make.height.equalTo(_greenbackView.superview).multipliedBy(0.3);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_centerBtn.superview).offset(-10);
    }];
    [_centerBottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerBtn);
        make.top.equalTo(_centerBtn.mas_bottom);
        make.height.offset(20);
    }];
    
}
- (UIView *)greenbackView{
    if (!_greenbackView) {
        _greenbackView = [[UIView alloc]init];
        _greenbackView.backgroundColor = Color_2Green;
    }
    return _greenbackView;
}
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn newAnBtnWithTextColor:[UIColor blackColor]];
//        [_centerBtn newAnBtnWithTextStrNomal:@"你还没有发布过房源" withTextStrSelected:@"发布新的房源"];
        [_centerBtn newAnBtnWithFont:[UIFont systemFontOfSize:14]];
        [_centerBtn newAnBtnWithImg:[UIImage imageNamed:@"Renting_release"]];
//        [_centerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
        [_centerBtn addTarget:self action:@selector(centerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}
- (UILabel *)centerBottomL{
    if (!_centerBottomL) {
        _centerBottomL = [[UILabel alloc]init];
        _centerBottomL.text = @"你还没有发布过房源";//
        _centerBottomL.textColor = [UIColor blackColor];
        _centerBottomL.font = [UIFont systemFontOfSize:14];
    }
    return _centerBottomL;
}
- (void)centerBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTouchBtnWithAddAction)]) {
        [_delegate cellTouchBtnWithAddAction];
    }
}
@end
