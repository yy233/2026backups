//
//  ZYMedicalCustomCell.m
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import "ZYMedicalCustomCell.h"

@interface ZYMedicalCustomCell ()

@property (weak, nonatomic) IBOutlet UILabel *medicalTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYMedicalCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteButton.hitTestEdgeInsets = UIEdgeInsetsMake(-8, -8, -8, -8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
