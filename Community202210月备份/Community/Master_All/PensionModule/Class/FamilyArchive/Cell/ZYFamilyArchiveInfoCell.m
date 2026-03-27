//
//  ZYFamilyArchiveInfoCell.m
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import "ZYFamilyArchiveInfoCell.h"

@interface ZYFamilyArchiveInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYFamilyArchiveInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.iconImageView zy_cornerRadiusRoundingRect];
}

// 设置数据model
- (void)setModel:(ZYFamilyArchiveInfoModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.title;
    if ([_model.type isEqual:@"image"]) {
        self.iconImageView.hidden = NO;
        self.contentTF.hidden = YES;
        self.contentLabel.hidden = YES;
        self.arrowImageView.hidden = NO;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.content] placeholderImage:[UIImage imageNamed:@"yl_mortx"]];
    }else if ([_model.type isEqual:@"TF"]) {
        self.iconImageView.hidden = YES;
        self.contentTF.hidden = NO;
        self.contentLabel.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.contentTF.text = _model.content;
        self.contentTF.placeholder = [NSString stringWithFormat:@"请输入%@", _model.title];
    }else {
        self.iconImageView.hidden = YES;
        self.contentTF.hidden = YES;
        self.contentLabel.hidden = NO;
        self.arrowImageView.hidden = NO;
        if (_model.content.length > 0) {
            self.contentLabel.text = _model.content;
            self.contentLabel.textColor = [UIColor zy_colorWithHexString:@"#2B2C2F"];
        }else {
            self.contentLabel.text = [NSString stringWithFormat:@"请选择%@", _model.title];
            self.contentLabel.textColor = [UIColor zy_colorWithHexString:@"#BEBEBE"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
