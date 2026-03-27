//
//  ZYEditEventDateCell.m
//  Community
//
//  Created by ZY on 2021/11/11.
//

#import "ZYEditEventDateCell.h"

@interface ZYEditEventDateCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (nonatomic, assign) BOOL isMark;

@end

@implementation ZYEditEventDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.layer.borderWidth = 0.5;
    self.contentV.layer.borderColor = Y_RGBA(221, 221, 221, 1).CGColor;
    self.contentV.layer.cornerRadius = 5;
    self.contentV.layer.masksToBounds = YES;
}

// 设置数据model
- (void)setModel:(ZYEventRemindModel *)model {
    _model = model;
    
    if (!self.isMark) {
        self.isMark = YES;
        NSString *dateStr = [NSString stringWithFormat:@"%@ %02ld:%02ld", [NSDate br_stringFromDate:[NSDate date] dateFormat:@"yyyy-MM-dd"], _model.warnHour, _model.warnMinute];
        self.datePicker.date = [NSDate xh_dateWithFormat_yyyy_MM_dd_HH_mm_string:dateStr];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
