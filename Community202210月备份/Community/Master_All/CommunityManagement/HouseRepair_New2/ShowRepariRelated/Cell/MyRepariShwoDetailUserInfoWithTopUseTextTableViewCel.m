//
//  MyRepariShwoDetailUserInfoWithNearTopTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel.h"

@implementation MyRepariShwoDetailUserInfoWithTopUseTextTableViewCel

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
       [self setThisCellUI];
 
   }
   return  self;
}
- (void)setThisCellUI{
    WEAKSELF
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.titleL.superview);
        make.left.equalTo(weakSelf.titleL.superview.mas_left).offset(10);
        make.height.offset(20);
    }];
    [self.textL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.textL.superview);
        make.left.equalTo(weakSelf.titleL.mas_right).offset(5);
        make.height.offset(20);
    }];
    
}
@end
