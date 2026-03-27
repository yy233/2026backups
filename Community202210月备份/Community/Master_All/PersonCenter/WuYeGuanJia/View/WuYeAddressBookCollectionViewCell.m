//
//  WuYeAddressBookCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/3.
//

#import "WuYeAddressBookCollectionViewCell.h"

@implementation WuYeAddressBookCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 2;
        self.contentView.layer.masksToBounds  = YES;
        self.phoneImgBtn.backgroundColor = [UIColor whiteColor];
        [self.phoneImgBtn newAnBtnWithImg:[UIImage imageNamed:@"phone_icon"]];
        self.backImgView.layer.cornerRadius = 2;
       
     
    }
    return self;
}
- (void)setTheme{
    self.titleLabel.textColor = Y_ColorWith16FromRGB(0x333333);
}
- (void)setHeaderImg{
    if ([self.model.department containsString:@"物业"]) {
//        self.backImgView.backgroundColor = Y_ColorWith16FromRGB(0xFCB4C1);
        self.backImgView.backgroundColor = Y_ColorWith16FromRGB(0xDEE8F6);

        self.headerImgView.image = [UIImage imageNamed:@"Property_icon"];
        return;
    }
    if ([self.model.department containsString:@"保卫"]) {
//        self.backImgView.backgroundColor = Y_ColorWith16FromRGB(0x578FE2);
        self.backImgView.backgroundColor = Y_ColorWith16FromRGB(0xDEE8F6);

        self.headerImgView.image = [UIImage imageNamed:@"protection_icon"];
        return;
    }
    if ([self.model.department containsString:@"后勤"]) {
//        self.backImgView.backgroundColor = Y_ColorWith16FromRGB(0x578FE2);
        self.backImgView.backgroundColor = Y_ColorWith16FromRGB(0xDEE8F6);

        self.headerImgView.image = [UIImage imageNamed:@"manager_icon"];
        return;
    }
    self.headerImgView.image = [UIImage imageNamed:@"manager_icon"];
//    self.backImgView.backgroundColor = Y_ColorWith16FromRGB(0x578FE2);
    self.backImgView.backgroundColor = Y_ColorWith16FromRGB(0xDEE8F6);


}

- (void)setUI{
    WEAKSELF
    [self.backImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.backImgView.superview).insets(UIEdgeInsetsMake(0, -3, 30, -3));
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.height.offset(60);
        make.centerX.equalTo(weakSelf.headerImgView.superview);
        make.centerY.equalTo(weakSelf.headerImgView.superview).offset(-15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.bottom.equalTo(weakSelf.titleLabel.superview);
        make.left.equalTo(weakSelf.titleLabel.superview).offset(16);

    }];
    [self.phoneImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(15);
        make.height.offset(30);
        make.bottom.equalTo(weakSelf.titleLabel.superview);
        make.right.equalTo(weakSelf.titleLabel.superview).offset(-16);
    }];
}
@end
