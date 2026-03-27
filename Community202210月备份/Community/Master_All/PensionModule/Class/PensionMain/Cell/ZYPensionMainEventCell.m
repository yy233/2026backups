//
//  ZYPensionMainEventCell.m
//  Community
//
//  Created by ZY on 2021/11/5.
//

#import "ZYPensionMainEventCell.h"

@interface ZYPensionMainEventCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ZYPensionMainEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYEventRemindModel *)model {
    _model = model;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", _model.warnHour, _model.warnMinute];
    NSMutableArray *weekStrArray = [NSMutableArray array];
    for (NSString *week in _model.weeks) {
        NSString *weekStr = [ZYWeekStringTool weekdayStringWithNum:[week integerValue]];
        [weekStrArray addObject:weekStr];
    }
    self.weekLabel.text = [weekStrArray componentsJoinedByString:@" "];
    self.contentLabel.text = _model.content;
    if (_model.status == 1) {
        self.alarmSwitch.on = YES;
    }else {
        self.alarmSwitch.on = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
