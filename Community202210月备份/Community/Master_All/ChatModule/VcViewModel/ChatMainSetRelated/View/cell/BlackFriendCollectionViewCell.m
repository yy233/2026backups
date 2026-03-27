//
//  BlackFriendCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "BlackFriendCollectionViewCell.h"

@implementation BlackFriendCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setNewUI];
    }
    return self;
}
- (void)setNewUI{
    self.backV.layer.cornerRadius = 5;
    self.backV.layer.masksToBounds = YES;
    self.backV.layer.borderColor = Y_ColorWith16FromRGB(0xEEEEEE).CGColor;
    self.backV.layer.borderWidth = 0.5;
//    self.imgV.layer.cornerRadius = 25;
    
   
    
    WEAKSELF
    [self.imgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backV);
        make.centerY.equalTo(weakSelf.backV).offset(-20);
        make.width.height.offset(50);
    }];
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backV);
        make.height.offset(20);
        make.top.equalTo(weakSelf.imgV.mas_bottom).offset(5);
        make.width.equalTo(weakSelf.backV);
    }];
    [self.imgV zy_cornerRadiusAdvance:25 rectCornerType:UIRectCornerAllCorners];
}
@end
