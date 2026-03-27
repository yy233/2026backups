//
//  BillingDetailVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BillingDetailVcTableViewCell.h"

@implementation BillingDetailVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//@property (nonatomic,strong) UILabel *titleL;
//
//@property (nonatomic,strong) UILabel *detailL;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAKSELF
        [weakSelf.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.detailL];
      
      
        [self setCellUI];
    }
    return self;
}
- (void)setCellUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.superview).offset(15);
        make.centerY.equalTo(_titleL.superview);
        make.height.offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_detailL.superview).offset(-15);
        make.centerY.equalTo(_detailL.superview);
        make.height.equalTo(_detailL.superview);
    }];
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].detailTextColor;
        _titleL.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textColor = [ThemeManager shareManager].mainTextColor;
        _detailL.font = [UIFont systemFontOfSize:14.0];
        _detailL.textAlignment = NSTextAlignmentRight;
        _detailL.numberOfLines = 2;
    }
    return _detailL;
}
@end
