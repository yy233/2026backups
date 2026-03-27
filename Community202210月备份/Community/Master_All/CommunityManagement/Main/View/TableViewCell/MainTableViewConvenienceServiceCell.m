//
//  MainTableViewConvenienceServiceCell.m
//  Community
//
//  Created by 余莹 on 2020/11/24.
//
#define BTN_TAG_CONVENIENCESERVICE 330
#import "MainTableViewConvenienceServiceCell.h"
@interface MainTableViewConvenienceServiceCell ()

@property (nonatomic,strong) UIButton *applianceClearnBtn;
@property (nonatomic,strong) UIButton *clothesClearnBtn;
@property (nonatomic,strong) UIButton *applianceRepairBtn;
 
@end
@implementation MainTableViewConvenienceServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ===
- (void)btnTouchAction:(UIButton *)sender{
    if (_delegate &&[_delegate respondsToSelector:@selector(convenienceSeriveViewTouchIndex:)]) {
        [_delegate convenienceSeriveViewTouchIndex:(sender.tag-BTN_TAG_CONVENIENCESERVICE)];
    }
}
#pragma mark ===
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.applianceClearnBtn];
        [self.contentView addSubview:self.clothesClearnBtn];
        [self.contentView addSubview:self.applianceRepairBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_applianceClearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {//@"家电清理"
        make.centerY.equalTo(_applianceClearnBtn.superview.mas_centerY);
        make.height.equalTo(_applianceClearnBtn.superview.mas_height).offset(-10);
        make.width.equalTo(_applianceRepairBtn.superview.mas_width).multipliedBy(0.5).offset(-5);
        make.left.equalTo(_applianceClearnBtn.superview.mas_left);
    }];
    [_clothesClearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_applianceClearnBtn.mas_top);
//        make.height.equalTo(_applianceClearnBtn.mas_width).multipliedBy(0.42);
        make.bottom.equalTo(_applianceClearnBtn.mas_centerY).offset(-5);
        make.width.equalTo(_applianceClearnBtn.mas_width);
        make.right.equalTo(_clothesClearnBtn.superview.mas_right);
    }];
    [_applianceRepairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_applianceClearnBtn.mas_bottom);
//        make.height.equalTo(_applianceClearnBtn.mas_width).multipliedBy(0.42);
        make.top.equalTo(_applianceClearnBtn.mas_centerY).offset(5);
        make.width.equalTo(_clothesClearnBtn.mas_width);
        make.right.equalTo(_clothesClearnBtn.mas_right);
    }];
}

#pragma mark ===
- (UIButton *)applianceClearnBtn{
    if (!_applianceClearnBtn) {
        _applianceClearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applianceClearnBtn.layer.cornerRadius = 10;
        _applianceClearnBtn.layer.masksToBounds = YES;
        [_applianceClearnBtn setTitle:@"家电清理" forState:UIControlStateNormal];
        [_applianceClearnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applianceClearnBtn setBackgroundImage:[UIImage imageNamed:@"Recommendation_Householdappliancescleaning"] forState:UIControlStateNormal];
        [_applianceClearnBtn addTarget:self action:@selector(btnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _applianceClearnBtn.tag = BTN_TAG_CONVENIENCESERVICE+1;
        [_applianceClearnBtn setHitTestEdgeInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
        //调整文字距离边距的距离
        _applianceClearnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _applianceClearnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; //
        _applianceClearnBtn.titleEdgeInsets = UIEdgeInsetsMake(-90, 8, 0, 0);//tlbr
        
    }
    return _applianceClearnBtn;
}

- (UIButton *)clothesClearnBtn{
    if (!_clothesClearnBtn) {
        _clothesClearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clothesClearnBtn.layer.cornerRadius = 5;
        _clothesClearnBtn.layer.masksToBounds = YES;
        [_clothesClearnBtn setTitle:@"衣物清理" forState:UIControlStateNormal];
        [_clothesClearnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clothesClearnBtn setBackgroundImage:[UIImage imageNamed:@"Recommendation_repair"] forState:UIControlStateNormal];
        [_clothesClearnBtn addTarget:self action:@selector(btnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _clothesClearnBtn.tag = BTN_TAG_CONVENIENCESERVICE+2;
        [_clothesClearnBtn setHitTestEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        _clothesClearnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //调整文字距离边距的距离
        _clothesClearnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _clothesClearnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _clothesClearnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);//tlbr
    }
    return _clothesClearnBtn;
}

- (UIButton *)applianceRepairBtn{
    if (!_applianceRepairBtn) {
        _applianceRepairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applianceRepairBtn.layer.cornerRadius = 5;
        _applianceRepairBtn.layer.masksToBounds = YES;
        [_applianceRepairBtn setTitle:@"上门维修" forState:UIControlStateNormal];
        [_applianceRepairBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applianceRepairBtn setBackgroundImage:[UIImage imageNamed:@"Recommendation_Clothing"] forState:UIControlStateNormal];
        [_applianceRepairBtn addTarget:self action:@selector(btnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        _applianceRepairBtn.tag = BTN_TAG_CONVENIENCESERVICE+3;
        [_applianceRepairBtn setHitTestEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
        //调整文字距离边距的距离
        _applianceRepairBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _applianceRepairBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _applianceRepairBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);//tlbr
    }
    return _applianceRepairBtn;
}

@end
