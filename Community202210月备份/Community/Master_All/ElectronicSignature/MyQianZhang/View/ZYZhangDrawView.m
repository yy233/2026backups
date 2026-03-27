//
//  ZYZhangDrawView.m
//  Community
//
//  Created by ZY on 2021/5/11.
//

#import "ZYZhangDrawView.h"

@implementation ZYZhangDrawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.blackButton.backgroundColor = [UIColor blackColor];
    self.blackButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.blackButton.layer.cornerRadius = 12.5;
    self.blackButton.layer.borderWidth = 1;
    self.blackButton.layer.masksToBounds = YES;
    self.blackButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    
    self.redButton.backgroundColor = [UIColor whiteColor];
    self.redButton.layer.borderColor = Y_RGBA(230, 230, 230, 1).CGColor;
    self.redButton.layer.cornerRadius = 12.5;
    self.redButton.layer.borderWidth = 1;
    self.redButton.layer.masksToBounds = YES;
    self.redButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    
    self.greenButton.backgroundColor = [UIColor whiteColor];
    self.greenButton.layer.borderColor = Y_RGBA(230, 230, 230, 1).CGColor;
    self.greenButton.layer.cornerRadius = 12.5;
    self.greenButton.layer.borderWidth = 1;
    self.greenButton.layer.masksToBounds = YES;
    self.greenButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    
    self.thickThinButton.hitTestEdgeInsets = UIEdgeInsetsMake(-6, -6, -6, -6);
    
    self.saveButton.backgroundColor = [UIColor y_colorGradientChangeWithSize: CGSizeMake(80, 36) direction:IHGradientChangeDirectionVertical startColor:Y_RGBA(116, 143, 181, 1) endColor:Y_RGBA(57, 69, 107, 1)];
    
    self.clearButton.layer.borderWidth = 1;
    self.clearButton.layer.borderColor = Y_RGBA(49, 116, 254, 1).CGColor;
}

@end
