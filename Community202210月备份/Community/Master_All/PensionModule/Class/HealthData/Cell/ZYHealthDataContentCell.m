//
//  ZYHealthDataContentCell.m
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import "ZYHealthDataContentCell.h"
#import "HealthSleepTool.h"
@interface ZYHealthDataContentCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ZYHealthDataContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellShowNum:(NSNumber *)numb{
    if (numb.doubleValue > 0) {
       
        if ([self.titleLabel.text containsString: @"心率"]) {
            self.subTitleLabel.text = [NSString stringWithFormat:@"%ld次/分钟",[numb integerValue]];
        }else if ([self.titleLabel.text containsString: @"睡眠"]) {
            self.subTitleLabel.text =  [self showStrTimeMinNum:[numb integerValue]];//入睡睡眠时长 (healthDataOnlyMainNumArray 存的是前一天分钟数)
        }else if ([self.titleLabel.text containsString: @"体温"]) {
            self.subTitleLabel.text = [NSString stringWithFormat:@"%0.1f 摄氏度",[numb doubleValue]];
        }
        
    }else{
        //灰色状态背景的初始文本展示
        self.subTitleLabel.text = _model.subTitle;
    }
    
}
- (NSString *)showStrTimeMinNum:(NSInteger)minNum
{
    return  [HealthSleepTool showHMStrTimeWithMinIntValue:minNum];
}

- (void)changeCellHealthStatusWithType:(HealthShow_Type)type{
    switch (type) {
        case HealthShow_Type_NoStaus://无数据情况
        {
            self.contentV.backgroundColor = Color_HealthShow_Type_NoStaus;//灰色
        }
            break;
        case HealthShow_Type_Good:
        {
            self.contentV.backgroundColor = Color_HealthShow_Type_Good;
        }
            break;
        case HealthShow_Type_Warning:
        {
            self.contentV.backgroundColor = Color_HealthShow_Type_Warning;
        }
            break;
        case HealthShow_Type_Bad:
        {
            self.contentV.backgroundColor = Color_HealthShow_Type_Bad;
        }
            break;
            
        default:
        {
            self.contentV.backgroundColor = Color_HealthShow_Type_NoStaus;//灰色
        }
            break;
    }
}

// 设置数据model
- (void)setModel:(ZYHealthDataContentModel *)model {
    _model = model;
    
    self.iconImageView.image = [UIImage imageNamed:_model.iconImageName];
    self.titleLabel.text = _model.title;
    self.subTitleLabel.text = _model.subTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
