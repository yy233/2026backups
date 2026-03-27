//
//  MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCel.h"

@implementation MyRepariShwoDetailUserInfoWithPhoneCallInfoTableViewCel

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
       [self.backView addSubview:self.phoneCallImgV];
       [self setCellUI];
 
   }
   return  self;
}
- (void)setCellUI{
    WEAKSELF
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.titleL.superview);
        make.left.equalTo(weakSelf.titleL.superview.mas_left).offset(10);
        make.height.offset(20);
    }];
    [self.textL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.textL.superview);
        make.left.equalTo(weakSelf.titleL.mas_right).offset(5);
        make.height.offset(20);
    }];

    [self.phoneCallImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(18);
        make.centerY.equalTo(weakSelf.titleL);
        make.left.equalTo(weakSelf.textL.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(weakSelf.phoneCallImgV.superview).offset(-10);
    }];
}

- (void)fillDetailVcModel:(MyRepairShowDetailWorkOrderInfoModel *)model{
    DLog(@"");
}

#pragma mark ===
- (UIImageView *)phoneCallImgV{
    if (!_phoneCallImgV) {
        _phoneCallImgV = [[UIImageView alloc]init];
        _phoneCallImgV.contentMode = UIViewContentModeScaleAspectFit;
        _phoneCallImgV.image = [UIImage imageNamed:@"dianhua_icon"];

    }
    return _phoneCallImgV;
}
@end
