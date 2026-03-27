//
//  HouseRepairDetailShowTopHeaderTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import "HouseRepairDetailShowTopHeaderTableViewCell.h"

@implementation HouseRepairDetailShowTopHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setIDNum:(NSInteger)IDNum{
     
    self.model = [[HouseRepairListModel alloc]init];
    self.model.ID = IDNum;//赋予id  用于点击事件
}
- (void)setDetailModel:(HouseRepairDetailModel *)detailModel{
    _detailModel = detailModel;

    //
    self.titleLabel.text = @"房屋报修";
    if (detailModel.repairImg.length!=0) {
        NSArray *imgStrArr = [NSArray arrayWithArray:[detailModel.repairImg componentsSeparatedByString:@";"]];
        [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgStrArr.firstObject]];
    }
    self.timeLabel.text = [TextShowWithModelStr textShowWithModelStr:detailModel.typeName];
    [self setType];
    
}
- (void)setType{
    switch (_detailModel.status) {
        case 0:
        {
            //type
            self.statusBtn.selected = YES;
            [self.statusBtn setTitle:@"待处理" forState:UIControlStateNormal];
            [self.statusBtn setTitle:@"待处理" forState:UIControlStateSelected];
            //bottom
            self.removeThisRepairBtn.hidden = NO;
            self.evaluationBtn.hidden = YES;
            self.showReasonBtn.hidden = YES;
        }
            break;
        case 1:
        {
            //type
            self.statusBtn.selected = YES;
            [self.statusBtn setTitle:@"处理中" forState:UIControlStateNormal];
            [self.statusBtn setTitle:@"处理中" forState:UIControlStateSelected];
            //bottom
            self.removeThisRepairBtn.hidden = YES;
            self.evaluationBtn.hidden = YES;
            self.showReasonBtn.hidden = YES;
        }
            break;
        case 2:
        {
            //type
            self.statusBtn.selected = NO;
            [self.statusBtn setTitle:@"已完成" forState:UIControlStateNormal];
            [self.statusBtn setTitle:@"已完成" forState:UIControlStateSelected];
            //bottom
            self.removeThisRepairBtn.hidden = YES;
            self.evaluationBtn.hidden = NO;//评价按钮
            self.showReasonBtn.hidden = YES;
        }
            break;
        case 3:
        {
            //type
            self.statusBtn.selected = NO;
            [self.statusBtn setTitle:@"已驳回" forState:UIControlStateNormal];
            [self.statusBtn setTitle:@"已驳回" forState:UIControlStateSelected];
            //bottom
            self.removeThisRepairBtn.hidden = YES;
            self.evaluationBtn.hidden = YES;//评价按钮
            self.showReasonBtn.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
}
@end
