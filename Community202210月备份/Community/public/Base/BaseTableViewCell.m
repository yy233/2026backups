//
//  BaseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/2.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

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
        self.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [self.contentView addSubview:self.backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
        }];
    }
    return self;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
} 
//
@end
