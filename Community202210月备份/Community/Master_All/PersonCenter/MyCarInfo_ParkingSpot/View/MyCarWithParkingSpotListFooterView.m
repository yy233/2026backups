//
//  MyCarWithParkingSpotListFooterView.m
//  Community
//
//  Created by 余莹 on 2022/5/7.
//

#import "MyCarWithParkingSpotListFooterView.h"
static CGFloat kCellSubConentViewUseJianJu = 16.0;

//static NSString *kShowStr = @"\n*车位绑定的车辆为默认车辆，通过【我的车辆】进行绑定\n*未绑定【我的车辆】的次车以临时车收费模式收费\n*如需解除或换绑车辆，请到物业中心进行换绑";
//static NSString *kShowStrWithCantEditType = @"*若【我的车辆】有多辆车，首停车为业主车，非首停车为临时车";

static NSString *kShowStr = @"\n*车位绑定的车辆为默认车辆，通过【我的车辆】进行绑定\n*此页面未绑定的车辆将以临时车收费\n*如需解除或换绑车辆，请到物业中心进行换绑";
static NSString *kShowStrWithCantEditType = @"\n*我的车位仅限我添加的车辆进行停放\n*若我的车位无暂用，首辆入场为业主车。第二辆入场为临停车， 需按临停规则计费";

@interface MyCarWithParkingSpotListFooterView ()


 
 
@end


@implementation MyCarWithParkingSpotListFooterView
 
- (void)fillTypeWithWhetherMoreCarBool:(BOOL)whetherMoreCarBool{//0没有开启 1开启
    dispatch_async(dispatch_get_main_queue(), ^{
        if (whetherMoreCarBool) {
            self.showTextL.text = kShowStr;
        }else{
            self.showTextL.text = kShowStrWithCantEditType;
        }
    });
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    frame = CGRectMake(0, 0, Screen_W, 180);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.showTextL];
        [self addSubview:self.footerBtnV];
        [self.showTextL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_showTextL.superview).offset(kCellSubConentViewUseJianJu);
            make.right.equalTo(_showTextL.superview).offset(-kCellSubConentViewUseJianJu);
            make.top.equalTo(_showTextL).offset(10);
            make.height.offset(110);
        }];
        [self.footerBtnV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_footerBtnV.superview);
            make.bottom.equalTo(_footerBtnV.superview);
            make.height.offset(90);
        }];
        
        if ([ThemeManager shareManager].type == ThemeType_White) {
            _showTextL.textColor =  Y_ColorWith16FromRGB(0x6E727D);

        }else{
            _showTextL.textColor =  Y_ColorWith16FromRGB(0xC5C9D4);
        }
    }
    
    return self;
}

- (UILabel *)showTextL{
    if (!_showTextL) {
        _showTextL = [[UILabel alloc]init];
        //_showTextL.text = kShowStr;
        _showTextL.font = [UIFont systemFontOfSize:12.0];
        _showTextL.numberOfLines = 0;
    }
    return _showTextL;
}
- (BaseTableViewFooterView *)footerBtnV{
    if (!_footerBtnV) {
        _footerBtnV = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
        [_footerBtnV.footerBtn newAnBtnWithTextStr:@"确认"];
        _footerBtnV.footerBtn.layer.cornerRadius = 0.0f;
    }
    return _footerBtnV;
}
@end
