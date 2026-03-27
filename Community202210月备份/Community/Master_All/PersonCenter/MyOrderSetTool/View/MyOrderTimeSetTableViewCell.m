//
//  MyOrderTimeSetTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import "MyOrderTimeSetTableViewCell.h"

@implementation MyOrderTimeSetTableViewCell

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
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
        }];
        self.backView.layer.cornerRadius = 7.5;
        //
        [self.backView addSubview: self.timeL];
        [self.backView addSubview: self.detailTextL];
        [self.backView addSubview: self.editBtn];
        [self.backView addSubview: self.openSwith];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeL.superview).offset(20);
        make.top.equalTo(_timeL.superview).offset(10);
        make.height.offset(30);
    }];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeL.mas_right).offset(5);
        make.top.bottom.equalTo(_timeL);
        make.width.offset(20);
    }];
    [_detailTextL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeL);
        make.top.equalTo(_timeL.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    [_openSwith mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_openSwith.superview).offset(-20);
        make.width.offset(60);
        make.height.offset(35);
        make.centerY.equalTo(_openSwith.superview);
    }];
}
//
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = [UIColor blackColor];
        _timeL.font = FontSize_Orders_Nomail(30);
    }
    return _timeL;
}
- (UILabel *)detailTextL{
    if (!_detailTextL) {
        _detailTextL = [[UILabel alloc]init];
        _detailTextL.textColor = [UIColor blackColor];
        _detailTextL.font = FontSize_Orders_Nomail(14);
    }
    return _detailTextL;
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn newAnBtnWithImg:[UIImage imageNamed:@"Orderreminder_edit"]];
    }
    return _editBtn;
}
- (UISwitch *)openSwith{
    if (!_openSwith) {
        _openSwith = [[UISwitch alloc]init];
    }
    return _openSwith;
}
@end
