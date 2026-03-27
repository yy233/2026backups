//
//  ContrectAllDetailPdfDownTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "ContrectAllDetailPdfDownTableViewCell.h"

@interface ContrectAllDetailPdfDownTableViewCell ()

@property (nonatomic,strong) UIImageView *pdfImgView;

@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation ContrectAllDetailPdfDownTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.detailTitleL.text = @"";
        self.detailTitleL.hidden = YES;
        [self.backView addSubview:self.pdfImgView];
        [self.backView addSubview:self.companyLabel];
        [self.backView addSubview:self.rightImageView];
        [self setPdfUI];
        
    }
    return self;
}
- (void)setPdfUI{
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightImageView.superview);
        make.right.equalTo(_rightImageView.superview).offset(-16);
        make.height.offset(12);
        make.width.offset(6);
    }];
    [_pdfImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.left.equalTo(self.titleL.mas_right).offset(1);
        make.width.offset(20);
        make.height.offset(25);
    }];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.left.equalTo(_pdfImgView.mas_right).offset(10);
        make.right.equalTo(_rightImageView.mas_right).offset(-6);
    }];
}

#pragma mark - 懒加载
- (UIImageView *)pdfImgView{
    if (!_pdfImgView) {
        _pdfImgView = [[UIImageView alloc]init];
        _pdfImgView.image = [UIImage imageNamed:@"pdf"];
        _pdfImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _pdfImgView;
}

- (UILabel *)companyLabel{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc]init];
        _companyLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _companyLabel.numberOfLines = 2;
        _companyLabel.font = FontSize_ElectronicSignature_Bold(15);
    }
    return _companyLabel;
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
