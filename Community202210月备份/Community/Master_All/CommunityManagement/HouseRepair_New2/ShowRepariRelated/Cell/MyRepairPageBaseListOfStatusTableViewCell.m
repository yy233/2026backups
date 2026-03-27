//
//  MyRepairPageBaseListOfStatusTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepairPageBaseListOfStatusTableViewCell.h"

@interface MyRepairPageBaseListOfStatusTableViewCell ()

@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UIButton *statusBtn;
@property (nonatomic,strong) UIView *lineView;


@end

@implementation MyRepairPageBaseListOfStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithModel:(MyRepairPageListUseModel *)model{
    [self.statusBtn newAnBtnWithTextStr:[TextShowWithModelStr textShowWithNotNullStr:model.statusStr]];
    self.typeLabel.text = [TextShowWithModelStr textShowWithNotNullStr:model.workOrderTypeName]; 
 
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        //self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        WEAKSELF
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        
        [self.backView addSubview:self.typeLabel];
        [self.backView addSubview:self.statusBtn];
        [self.backView addSubview:self.lineView];
        [self setUI];
  
    }
    return  self;
}
 
- (void)setUI{
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_typeLabel.superview);
        make.left.equalTo(_typeLabel.superview).offset(10);
        make.right.lessThanOrEqualTo(_typeLabel.superview).offset(-60);
    }];
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {//statusBtn_W
        make.centerY.equalTo(_typeLabel);
        make.right.equalTo(_statusBtn.superview.mas_right).offset(-10);
        make.height.offset(30);
        make.width.offset(40);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lineView.superview).offset(-1);
        make.left.equalTo(_lineView.superview.mas_left).offset(10);
        make.right.equalTo(_lineView.superview.mas_right).offset(-10);
        make.height.offset(1.0);
    }];
}


#pragma mark ===

- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_statusBtn setTitleColor:Color_Blue forState:UIControlStateNormal];//蓝色
    }
    return _statusBtn;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont boldSystemFontOfSize:14];
        _typeLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _typeLabel.numberOfLines = 1;
    }
    return _typeLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _lineView.backgroundColor = Y_RGBA(240, 241, 246, 1);
        }else{
            _lineView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        }
    }
    return _lineView;
}
 
@end
