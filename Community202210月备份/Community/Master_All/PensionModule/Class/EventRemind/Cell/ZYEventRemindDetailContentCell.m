//
//  ZYEventRemindDetailContentCell.m
//  Community
//
//  Created by ZY on 2021/11/12.
//

#import "ZYEventRemindDetailContentCell.h"

@interface ZYEventRemindDetailContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property (weak, nonatomic) IBOutlet UILabel *membersLabel;

@end

@implementation ZYEventRemindDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 设置数据model
- (void)setModel:(ZYEventRemindModel *)model {
    _model = model;
    
    self.contentLabel.text = _model.content;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", _model.warnHour, _model.warnMinute];
    NSMutableArray *weekStrArray = [NSMutableArray array];
    for (NSString *week in _model.weeks) {
        NSString *weekStr = [ZYWeekStringTool weekdayStringWithNum:[week integerValue]];
        [weekStrArray addObject:weekStr];
    }
    self.weekLabel.text = [weekStrArray componentsJoinedByString:@" "];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (ZYEventRemindRecordsModel *tempModel in _model.records) {
        [nameArray addObject:tempModel.name];
    }
    self.membersLabel.text = [nameArray componentsJoinedByString:@", "];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
