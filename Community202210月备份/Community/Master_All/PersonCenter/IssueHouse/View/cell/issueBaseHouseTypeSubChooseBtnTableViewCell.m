//
//  issueBaseHouseZhengZuSubChooseBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "issueBaseHouseTypeSubChooseBtnTableViewCell.h"
@interface issueBaseHouseTypeSubChooseBtnTableViewCell ()
@property (nonatomic,strong) UIView *backView;
@end
@implementation issueBaseHouseTypeSubChooseBtnTableViewCell

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
        [self.contentView addSubview:self.backView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}
@end
