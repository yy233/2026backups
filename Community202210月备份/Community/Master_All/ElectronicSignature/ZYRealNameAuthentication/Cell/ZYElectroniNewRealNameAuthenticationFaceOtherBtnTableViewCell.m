//
//  ElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/24.
//

#import "ZYElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell.h"

@implementation ZYElectroniNewRealNameAuthenticationFaceOtherBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.btnsBackView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_titleL.superview);
        make.height.offset(40);
    }];
    [_btnsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_btnsBackView.superview);
        make.top.equalTo(_titleL.mas_bottom);
    }];
    [self addSubBtns];
    
}
- (void)addSubBtns{
    [self.btnsBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *arrTitle = [[NSArray alloc]initWithObjects:@"正对手机",@"光线充足",@"放慢动作", nil];
    NSArray *arrImgName = [[NSArray alloc]initWithObjects:@"mobile-phone",@"light",@"Slow-down", nil];
    for (int i = 0;  i <arrTitle.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn newAnBtnWithTextStr:arrTitle[i]];
        [btn newAnBtnWithImg:[UIImage imageNamed:arrImgName[i]]];
        [btn newAnBtnWithTextColor:Color_51BlackColor];
        [btn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [btn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
        [self.btnsBackView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(65);
            make.height.offset(80);
            make.centerY.equalTo(_btnsBackView);
            if (i==0) {
                make.centerX.equalTo(_btnsBackView).multipliedBy(0.5);
            }else if (i==1){
                make.centerX.equalTo(_btnsBackView).multipliedBy(1);
            }else{
                make.centerX.equalTo(_btnsBackView).multipliedBy(1.5);
            }
        }];
    }
}
#pragma mark ==
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"请确认由本人亲自操作";
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = Color_138GrayColor;
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}

- (UIView *)btnsBackView{
    if (!_btnsBackView) {
        _btnsBackView = [[UIView alloc]init];
    }
    return _btnsBackView;
}
@end
