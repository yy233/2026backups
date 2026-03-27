//
//  ZYContactPeopleTopCell.m
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import "ZYContactPeopleTopCell.h"

@implementation ZYContactPeopleTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
    self.friendsView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(200, 200) direction:IHGradientChangeDirectionDownDiagonalLine startColor:Y_RGBA(37, 88, 255, 1) endColor:Y_RGBA(61, 142, 252, 1)];
    self.contactView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(200, 200) direction:IHGradientChangeDirectionDownDiagonalLine startColor:Y_RGBA(252, 94, 40, 1) endColor:Y_RGBA(253, 169, 98, 1)];
    self.nfriendView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(200, 200) direction:IHGradientChangeDirectionDownDiagonalLine startColor:Y_RGBA(248, 130, 3, 1) endColor:Y_RGBA(253, 204, 98, 1)];
    self.groupManagerView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(200, 200) direction:IHGradientChangeDirectionDownDiagonalLine startColor:Y_RGBA(227, 128, 0, 1) endColor:Y_RGBA(253, 224, 52, 1)];
    self.labelView.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(200, 200) direction:IHGradientChangeDirectionDownDiagonalLine startColor:Y_RGBA(0, 146, 86, 1) endColor:Y_RGBA(0, 202, 119, 1)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
