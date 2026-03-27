//
//  GuestInfoRegistionEditRightBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import "GuestInfoRegistionEditShowRightBtnTableViewCell.h"

@implementation GuestInfoRegistionEditShowRightBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textFieldRightBtn.hidden = NO;
        self.subShowChooseBtn.hidden = NO;
//        self.subShowChooseBtn.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:0.3];//测试textField的范围_____
        self.subShowChooseBtn.userInteractionEnabled = NO;//暂时不用这个的action 仅仅用做textfield的遮挡
        self.textField.userInteractionEnabled = NO;//不可输入状态 手势事件层级 在父视图响应 cell点击
    }
    return self;
    
}
 
#pragma mark === 重写
- (void)setTextLabelModuleUI{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView.superview);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL.superview.mas_centerY);
        make.left.equalTo(self.titleL.superview.mas_left).offset(16);
        make.height.offset(20);
//        make.width.offset(60);
//        make.width.offset(120);//不做宽度限制 则可有title为主textf为次优先级自动适配

    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textField.superview.mas_centerY);
        make.left.equalTo(self.titleL.mas_right).offset(1);
        make.right.equalTo(self.textField.superview.mas_right).offset(-28);//16+6+间隔
        make.height.offset(30);
    }];
    [self.textFieldRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textFieldRightBtn.superview.mas_centerY);
        make.left.equalTo(self.textField.mas_right).offset(5);
        make.right.equalTo(self.textFieldRightBtn.superview.mas_right).offset(-16);
        make.width.offset(5);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.superview.mas_bottom);
        make.left.equalTo(self.titleL.mas_left).offset(0);;
        make.right.equalTo(self.textFieldRightBtn.mas_right).offset(0);
        make.height.offset(1);
    }];
    [self.subShowChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textField);
    }];
}
@end
