//
//  ZYEventRemindTopCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/11/10.
//

#import "ZYEventRemindTopCollectionViewCell.h"

@interface ZYEventRemindTopCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@end

@implementation ZYEventRemindTopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYEventRemindTopModel *)model {
    _model = model;
    
    if (_model.isPast) {
        self.contentV.backgroundColor = Y_RGBA(182, 186, 196, 1);
        self.dayLabel.textColor = [UIColor whiteColor];
        self.weekLabel.textColor = [UIColor whiteColor];
    }else {
        if (_model.isSelected) {
            self.contentV.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(45, 65) direction:IHGradientChangeDirectionVertical startColor:Y_RGBA(74, 238, 201, 1) endColor:Y_RGBA(16, 199, 159, 1)];
            self.dayLabel.textColor = [UIColor whiteColor];
            self.weekLabel.textColor = [UIColor whiteColor];
        }else {
            self.contentV.backgroundColor = Y_RGBA(240, 241, 246, 1);
            self.dayLabel.textColor = Y_RGBA(43, 44, 47, 1);
            self.weekLabel.textColor = Y_RGBA(110, 114, 125, 1);
        }
    }
    self.dayLabel.text = _model.day;
    self.weekLabel.text = _model.week;
}

@end
