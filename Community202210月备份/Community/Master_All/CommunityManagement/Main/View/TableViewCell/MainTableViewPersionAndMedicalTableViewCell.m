//
//  MainTableViewPersionAndMedicalTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "MainTableViewPersionAndMedicalTableViewCell.h"

@interface MainTableViewPersionAndMedicalTableViewCell ()
@property (nonatomic,strong) UIButton *persionBtn;
@property (nonatomic,strong) UIButton *medicalBtn;
//图中圆变形问题做imgv显示
@property (nonatomic,strong) UIImageView *persionBackImgView;
@property (nonatomic,strong) UIImageView *medicalBackImgView;
@end

@implementation MainTableViewPersionAndMedicalTableViewCell

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
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.persionBackImgView];
        [self.contentView addSubview:self.medicalBackImgView];
        [self.contentView addSubview:self.persionBtn];
        [self.contentView addSubview:self.medicalBtn];
        [self setUI];
        [self isMedicalViewShow];
    }
    return self;
}
- (void)setUI{
    [_persionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_persionBtn.superview.mas_left).offset(0);
        make.right.equalTo(_persionBtn.superview.mas_centerX).offset(-5);
        make.top.equalTo(_persionBtn.superview.mas_top).offset(10);
        make.bottom.equalTo(_persionBtn.superview.mas_bottom).offset(-10);
    }];
    [_medicalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_persionBtn);
        make.right.equalTo(_medicalBtn.superview.mas_right).offset(0);
        make.left.equalTo(_medicalBtn.superview.mas_centerX).offset(5);
    }];
    [_persionBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_persionBtn);
    }];
    [_medicalBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_medicalBtn);
    }];
}
- (UIButton *)persionBtn{
    if (!_persionBtn) {
        _persionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_persionBtn addTarget:self action:@selector(persionBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _persionBtn.layer.cornerRadius = 5;
        _persionBtn.layer.masksToBounds = YES;
        [_persionBtn setTitle:@"社区养老" forState:UIControlStateNormal];
        [_persionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_persionBtn setBackgroundImage:[UIImage imageNamed:@"Pension_bottom"] forState:UIControlStateNormal];
        [_persionBtn setHitTestEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        //调整文字距离边距的距离
        _persionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _persionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _persionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);//tlbr
    }
    return _persionBtn;
}
- (UIButton *)medicalBtn{
    if (!_medicalBtn) {
        _medicalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_medicalBtn addTarget:self action:@selector(medicalBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _medicalBtn.layer.cornerRadius = 5;
        _medicalBtn.layer.masksToBounds = YES;
        [_medicalBtn setTitle:@"社区医疗" forState:UIControlStateNormal];
        [_medicalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_medicalBtn setBackgroundImage:[UIImage imageNamed:@"Medicaltreatment_bottom"] forState:UIControlStateNormal];
        [_medicalBtn setHitTestEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        //调整文字距离边距的距离
        _medicalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _medicalBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//调整文字距离边距的距离
        _medicalBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);//tlbr
        _medicalBtn.hidden = YES;
    }
    return _medicalBtn;
}

- (UIImageView *)persionBackImgView{
    if (!_persionBackImgView ) {
        _persionBackImgView = [[UIImageView alloc]init];
        _persionBackImgView.image = [UIImage imageNamed:@"Pension_bottom"];
        _persionBackImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _persionBackImgView;
}
- (UIImageView *)medicalBackImgView{
    if (!_medicalBackImgView ) {
        _medicalBackImgView = [[UIImageView alloc]init];
        _medicalBackImgView.image = [UIImage imageNamed:@"Medicaltreatment_bottom"];
        _medicalBackImgView.contentMode = UIViewContentModeScaleAspectFit;
        _medicalBackImgView.hidden = YES;
    }
    return _medicalBackImgView;
}

#pragma mark - 是否显示医疗视图 初始版的主页cell 医疗养老 显示状态 ｜不会调用到 
- (void)isMedicalViewShow {
    
    WEAKSELF
    [VersionShowOrHiddenTool getVersionInfoBoolWithBool:^(BOOL succes, BOOL isShowBool) {
        if (succes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.medicalBackImgView.hidden = !isShowBool;
                weakSelf.medicalBtn.hidden = !isShowBool;
            });
        }
    }];
}

#pragma mark ==
- (void)persionBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(goPersionAction)]) {
        [_delegate goPersionAction];
    }
}
- (void)medicalBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(goMedicalAction)]) {
        [_delegate goMedicalAction];
    }
}
@end
