//
//  ZYMoulageHelperDetailSignatureChangedCell.m
//  Community
//
//  Created by ZY on 2021/5/8.
//

#import "ZYMoulageHelperDetailSignatureChangedCell.h"

@implementation ZYMoulageHelperDetailSignatureChangedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYZhangManagerDataModel *)model {
    _model = model;
    
    if (_model.sealUrl.length > 0) {
        self.promptLabel.hidden = YES;
        self.signatureImageView.hidden = NO;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, _model.sealUrl]];
        [self.signatureImageView sd_setImageWithURL:url];
    }else {
        self.promptLabel.hidden = NO;
        self.signatureImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
