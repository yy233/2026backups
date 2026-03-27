//
//  IssuLastAddressCellSubBasePopViewSubTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/26.
//

#import "IssuLastAddressCellSubBasePopViewSubTableViewCell.h"

@implementation IssuLastAddressCellSubBasePopViewSubTableViewCell

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
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.chooseBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview).offset(10);
        make.right.equalTo(_titleL.superview.mas_right).offset(-50);
        make.centerY.equalTo(_titleL.superview);
    }];
    [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_chooseBtn.superview.mas_right).offset(-10);
        make.height.width.offset(25);
        make.centerY.equalTo(_chooseBtn.superview);
    }];
}
//
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:15];
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL ;
}
- (UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Chooseahouse_normal"] selectedImg:[UIImage imageNamed:@"Chooseahouse_Select"]];
        _chooseBtn.userInteractionEnabled = NO;//使用tableview的点击事件
//        [_chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _chooseBtn;
}
//
//- (void)chooseBtnAction:(UIButton *)sender{
//    sender.selected = !sender.selected;
//}
@end
