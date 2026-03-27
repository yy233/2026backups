//
//  NftBaseCollectionViewCell.m
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import "NftBaseCollectionViewCell.h"

@implementation NftBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nftImgV];
        [self.contentView addSubview:self.nftLabel];
        [self setsubUI];
    }
    return self;
}

- (void)setsubUI{
    
    [_nftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(_nftImgV.superview);
        make.bottom.equalTo(_nftImgV.superview.mas_bottom).offset(-60);
    }];
    
    [_nftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nftImgV.mas_bottom);
        make.height.offset(30);
        make.width.equalTo(_nftLabel.superview).offset(-20);
        make.centerX.equalTo(_nftLabel.superview);
    }];
  
}


- (UIImageView *)nftImgV{
    if(!_nftImgV){
        _nftImgV = [[UIImageView alloc]init];
        _nftImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _nftImgV;
}
- (UILabel *)nftLabel{
    if(!_nftLabel){
        _nftLabel = [[UILabel alloc]init];
        _nftLabel.textColor = rgba(51, 51, 51, 1);
        _nftLabel.font = [UIFont systemFontOfSize:14.0];
        _nftLabel.textAlignment = NSTextAlignmentRight;
    }
    return _nftLabel;
}
@end

#pragma mark ===
@implementation NftBaseCollectionViewCell_ShowMoney

- (UILabel *)mongyL{
    if(!_mongyL){
        _mongyL = [[UILabel alloc]init];
        _mongyL.textColor = Color_Socialize_GreenColor;
        _mongyL.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _mongyL;
}

- (UIImageView *)moneyIcon{
    if(!_moneyIcon){
        _moneyIcon = [[UIImageView alloc]init];
        _moneyIcon.contentMode = UIViewContentModeCenter;
    }
    return _moneyIcon;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.moneyIcon];
        [self.contentView addSubview:self.mongyL];
        [self setSUbs];
    }
    return self;
}

- (void)setSUbs{

    WEAKSELF
    [_moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nftLabel.mas_bottom);
        make.left.equalTo(weakSelf.nftLabel);
        make.width.height.offset(20.0);
    }];
    [_mongyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyIcon.mas_right).offset(5);
        make.top.bottom.equalTo(_moneyIcon);
        make.right.equalTo(weakSelf.nftLabel);
    }];
}


@end
