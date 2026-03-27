//
//  ZYOwnersVotePlanCell.m
//  Community
//
//  Created by ZY on 2021/8/4.
//

#import "ZYOwnersVotePlanCell.h"

@interface ZYOwnersVotePlanCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *pieChartView;

@property (nonatomic, strong) PNPieChart *pieChart;

@property (weak, nonatomic) IBOutlet UIView *subView;

@end

@implementation ZYOwnersVotePlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.contentLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.subView.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    }else {
        self.subView.backgroundColor = [UIColor zy_colorWithHexString:@"#000F26"];
    }
}

// 设置数据model
- (void)setModel:(ZYOwnersVotePlanDataModel *)model {
    _model = model;
    
    self.contentLabel.text = [NSString stringWithFormat:@"%ld人参与了投票/共%ld人名额", _model.haveTotal, _model.total];
    
    if (self.pieChart) {
        [self.pieChart removeFromSuperview];
    }
    // 画圆环图
    NSMutableArray *itemsArray = [NSMutableArray array];
    NSArray *colorsArray = @[Y_RGBA(38, 114, 249, 1), Y_RGBA(62, 138, 255, 1), Y_RGBA(65, 188, 210, 1), Y_RGBA(22, 214, 183, 1), Y_RGBA(255, 168, 43, 1), Y_RGBA(38, 114, 249, 1), Y_RGBA(62, 138, 255, 1), Y_RGBA(65, 188, 210, 1), Y_RGBA(22, 214, 183, 1), Y_RGBA(255, 168, 43, 1)];
    for (ZYOwnersVotePlanDataListModel *tempModel in _model.list) {
        if (tempModel.number > 0) {
            PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:tempModel.number color:colorsArray[tempModel.code - 1] description:[NSString stringWithFormat:@"%ld选项", tempModel.code]];
            [itemsArray addObject:item];
        }
    }
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 160, kScreenW - 160) items:itemsArray];
    self.pieChart.userInteractionEnabled = NO;
    self.pieChart.displayAnimated = NO;
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont = [UIFont systemFontOfSize:13];
    self.pieChart.legendFontColor = [UIColor whiteColor];
    self.pieChart.legendFont = [UIFont systemFontOfSize:13];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    self.pieChart.legendStyle = PNLegendItemStyleSerial;
    [self.pieChart strokeChart];
    [self.pieChartView addSubview:self.pieChart];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
