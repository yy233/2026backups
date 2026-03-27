//
//  CarTypeChooseBtn.m
//  Community
//
//  Created by 余莹 on 2020/12/1.
//

#import "CarTypeChooseBtn.h"

@implementation CarTypeChooseBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width==0) {
        self.bounds = CGRectMake(0, 0, 70, 30);
    }else{
        self = [super initWithFrame:frame];
    }
    if (self) {
       
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:Y_RGBA(211, 224, 252, 1)] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:Y_RGBA(14, 99, 252, 1) forState:UIControlStateSelected];
        self.layer.borderColor = Y_RGBA(170, 174, 185, 1).CGColor;// [UIColor grayColor].CGColor;//rgba(170, 174, 185, 1)
        if (self.isSelected) {
            self.layer.borderColor = Y_RGBA(15, 100, 253, 1).CGColor; //无效果果 这是init里的
        }else{
            self.layer.borderColor = Y_RGBA(170, 174, 185, 1).CGColor;//[UIColor grayColor].CGColor;//Selected rgba(15, 100, 253, 1)
        }
    }
    return self;
}
 
@end
