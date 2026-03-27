//
//  ZYContrectAllDetailImgTableViewCell.m
//  Community
//
//  Created by ZY on 2021/5/27.
//

#import "ZYContrectAllDetailImgTableViewCell.h"

@implementation ZYContrectAllDetailImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
 

 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.detailTitleL.text = @"";
        self.detailTitleL.hidden = YES;
        [self.backView addSubview:self.rightImageView];
        [self.backView addSubview:self.signImageView];
        [self setImgUI];
    }

    return self;
}

- (void)setImgUI {
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightImageView.superview);
        make.right.equalTo(_rightImageView.superview).offset(-16);
        make.height.offset(12);
        make.width.offset(6);
    }];
    [_signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_signImageView.superview);
        make.right.equalTo(_rightImageView.mas_left).offset(-6);
        make.width.offset(130);
        make.height.offset(50);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)signImageView {
    if (!_signImageView) {
        _signImageView = [[UIImageView alloc] init];
        _signImageView.backgroundColor = [UIColor whiteColor];
        _signImageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _signImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"ic_back"];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _rightImageView;
}

@end
