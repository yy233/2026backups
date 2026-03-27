//
//  LifeCostPropertyFeeListVcNomalWuYeTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/7/7.
//

#import "LifeCostPropertyFeeListVcNomalWuYeTableViewCell.h"

@implementation LifeCostPropertyFeeListVcNomalWuYeTableViewCell

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
       self.selectionStyle = UITableViewCellSelectionStyleNone;
       self.contentView.backgroundColor = [UIColor clearColor];
       self.backgroundColor = [UIColor clearColor];
//       self.indentationLevel =  2;  //缩进层级
//       self.indentationWidth = 10;//每次缩进寛
       self.separatorInset = UIEdgeInsetsMake(0, 32, 0, 32);
       [self setUI];
   }
   return self;
}
- (void)setUI{
   self.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.8];
   self.detailTextLabel.textColor =  [ThemeManager shareManager].mainTextColor;
   self.textLabel.font = [UIFont systemFontOfSize:15];
   self.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
    [self fdata];
    //img
    CGSize itemSize = CGSizeMake(22+10, 22);//+
//    UIGraphicsBeginImageContext(itemSize);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, [UIScreen mainScreen].scale);//清晰度
    CGRect imageRect = CGRectMake(10, 0, itemSize.width-10, itemSize.height);
    [self.imageView.image drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    self.imageView.layer.shouldRasterize = YES;//栅栏
//    sell.imageView.layer.allowsEdgeAntialiasing = YES;//锯齿
 
}
- (void)fdata{
   self.textLabel.text = @"";//@"物业费";
   self.detailTextLabel.text = [NSString stringWithFormat:@"¥:%@ ",@""];
   self.imageView.image = [UIImage imageNamed:@"Property_fee"];
}
 //图片键值暂无 暂时用物业费用的图片

- (void)fillRiseName:(NSString *)riseNameStr andMoeny:(double)money{
    self.textLabel.text = riseNameStr;
    self.detailTextLabel.text = [NSString stringWithFormat:@"¥:%0.2f ",money];
}
@end
