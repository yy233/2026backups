//
//  ElectronicSignatureCenterAdTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "ElectronicSignatureCenterAdTableViewCell.h"
@interface ElectronicSignatureCenterAdTableViewCell ()
@property (nonatomic,strong) UIImageView *imgV;
@end

@implementation ElectronicSignatureCenterAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.imgV];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imgV.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
}
//
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
        _imgV.layer.cornerRadius = (74*0.5);
        _imgV.layer.masksToBounds = YES;
        _imgV.image = [UIImage imageNamed:@"ad"];
    }
    return _imgV;
}
@end
