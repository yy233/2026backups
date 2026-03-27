//
//  HealthTempAbnormalTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import "HealthTempOrHeartAbnormalTableViewCell.h"

@implementation HealthTempOrHeartAbnormalTableViewCell 

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
//        self.backgroundColor = [UIColor whiteColor];
//        self.contentView.backgroundColor = [UIColor whiteColor]; 
        self.textLabel.textColor = Y_ColorWith16FromRGB(0x6E727D);
        self.textLabel.font = [PensionThemeManager shareManager].Pension_TextFont_14;
        self.detailTextLabel.textColor = Y_ColorWith16FromRGB(0xFF0033);
        self.detailTextLabel.font = [PensionThemeManager shareManager].Pension_TextFont_14;
    }
    return self;
}
 
- (void)fillDataWithTempAbnormalModel:(HealthGetOneAbnormalModel *)model{
    self.textLabel.text = [TextShowWithModelStr textShowWithModelStr:model.time];
    self.detailTextLabel.text = [[TextShowWithModelStr textShowWithModelStr:model.decimalData] stringByAppendingString:@"℃"];
}
- (void)fillDataWithHeartAbnormalModel:(HealthGetOneAbnormalModel *)model{
    self.textLabel.text = [TextShowWithModelStr textShowWithModelStr:model.time];
    self.detailTextLabel.text = [[TextShowWithModelStr textShowWithModelStr:model.data] stringByAppendingString:@"次/分钟"];
}
 
@end
