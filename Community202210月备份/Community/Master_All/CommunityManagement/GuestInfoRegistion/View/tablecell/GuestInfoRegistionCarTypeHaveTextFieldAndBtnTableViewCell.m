//
//  GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/10/27.
//

#import "GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell.h"

@interface GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell ()

@end

@implementation GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell

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
        self.textFieldRightBtn.hidden = YES;
        self.subShowChooseBtn.hidden = NO;
        [self.subShowChooseBtn addTarget:self action:@selector(tfTopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backView addSubview:self.chooseWithCarListShowOrHidenBtn];
        [self chooseBtnUI];
    }
    return self;
}

#pragma mark === 重写 mas_make
- (void)setTextLabelModuleUI{
   [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.backView.superview);
   }];
   
   [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.titleL.superview.mas_centerY);
       make.left.equalTo(self.titleL.superview.mas_left).offset(16);
       make.height.offset(20);
   }];
   [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.textField.superview.mas_centerY);
       make.left.equalTo(self.titleL.mas_right).offset(1);
       make.right.equalTo(self.textField.superview.mas_right).offset(-30);// 4-20-16
       make.height.offset(30);
   }];
    //
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
    //
   [self.subShowChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.textField);
   }];
}
- (void)chooseBtnUI{
    [_chooseWithCarListShowOrHidenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_chooseWithCarListShowOrHidenBtn.superview.mas_centerY);
        make.left.equalTo(self.textField.mas_right).offset(4);
        make.right.equalTo(_chooseWithCarListShowOrHidenBtn.superview.mas_right).offset(-16);
        make.height.offset(30);
    }];
}
#pragma mark ==
- (UIButton *)chooseWithCarListShowOrHidenBtn{
    if (!_chooseWithCarListShowOrHidenBtn) {
        _chooseWithCarListShowOrHidenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseWithCarListShowOrHidenBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"zhankai"] selectedImg:[UIImage imageNamed:@"shoqi"] ];//平时收起。点击状态即用时状态做展开 (对应的图标为即将成为状态的图标名字)
    }
    return _chooseWithCarListShowOrHidenBtn;
}

- (void)tfTopBtnAction{
    DLog(@"点击车牌号tF的顶部btn");
    if (isNotNil(self.touchTextFiledTopBtnActionBlock)) {
        self.touchTextFiledTopBtnActionBlock();
    }
    
}
@end
