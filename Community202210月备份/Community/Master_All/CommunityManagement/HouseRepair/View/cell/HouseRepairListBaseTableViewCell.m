//
//  HouseRepairListTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import "HouseRepairListBaseTableViewCell.h"
#define Color_statusBtn_Not_End_Type     Y_RGBA(38, 114, 249, 1)
#define Color_statusBtn_Is_End_Type      Y_RGBA(170, 174, 185, 1)

#define statusBtn_W 40
#define bottomBtn_W 75
@interface HouseRepairListBaseTableViewCell ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *lineView;
//@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UILabel *timeLabel;
//@property (nonatomic,strong) UIButton *statusBtn;
//@property (nonatomic,strong) UIButton *removeThisRepairBtn;
//@property (nonatomic,strong) UIButton *evaluationBtn;
//@property (nonatomic,strong) UIImageView *imgV;
@end
@implementation HouseRepairListBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HouseRepairListModel *)model{
    _model = model;
    _titleLabel.text = [TextShowWithModelStr textShowWithModelStr:model.typeName];
    _timeLabel.text =  [TextShowWithModelStr textShowWithModelStr:model.createTime];
    if (model.repairImg.length != 0) {
        NSArray *imgStrArr = [NSArray arrayWithArray:[model.repairImg componentsSeparatedByString:@";"]];
        [_imgV sd_setImageWithURL:[UrlWithString getURLWithStr:imgStrArr.firstObject]];
    }
}

- (void)removeThisRepairBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(removeThisRepairWithModel:)]) {
        [_delegate removeThisRepairWithModel:_model];
    }
}
- (void)evaluationBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(evaluatThisRepairWithModel:)]) {
        [_delegate evaluatThisRepairWithModel:_model];
    }
}
- (void)showDismissBtnAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(showDismissReasonWithModel:)]) {
        [_delegate showDismissReasonWithModel:_model];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.lineView];
        [self.backView addSubview:self.statusBtn];
        [self.backView addSubview:self.lineView];
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.timeLabel];
        [self.backView addSubview:self.removeThisRepairBtn];
        [self.backView addSubview:self.evaluationBtn];
        [self.backView addSubview:self.showReasonBtn];
        [self setUI];
        [self setType];
    }
    return  self;
}
- (void)setType{//用于子类重写
    
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(15);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(10);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-10-statusBtn_W);
        make.height.offset(20);
    }];
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {//statusBtn_W
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.left.equalTo(_titleLabel.mas_right).offset(1);
        make.right.equalTo(_timeLabel.superview.mas_right).offset(-10);
        make.height.offset(30);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_lineView.superview.mas_left).offset(10);
        make.right.equalTo(_lineView.superview.mas_right).offset(-10);
        make.height.offset(1);
    }];
    //
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(10);
        make.left.equalTo(_imgV.superview.mas_left).offset(10);
        make.height.offset(55);
        make.width.offset(55);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV.mas_centerY);
        make.left.equalTo(_imgV.mas_right).offset(5);
        make.right.equalTo(_timeLabel.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_removeThisRepairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_removeThisRepairBtn.superview.mas_bottom).offset(-10);
        make.right.equalTo(_removeThisRepairBtn.superview.mas_right).offset(-10);
        make.width.offset(bottomBtn_W);
        make.height.offset(30);
    }];
    [_evaluationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_removeThisRepairBtn);
    }];

    [_showReasonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_evaluationBtn);
    }];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        _backView.layer.cornerRadius = 10;
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_statusBtn setTitleColor:Color_statusBtn_Not_End_Type forState:UIControlStateSelected];//蓝色
        [_statusBtn setTitleColor:Color_statusBtn_Is_End_Type forState:UIControlStateNormal];//灰色
    }
    return _statusBtn;
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
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
//        _imgV.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
//        _imgV.layer.cornerRadius = 3;
        [_imgV zy_cornerRadiusAdvance:3 rectCornerType:UIRectCornerAllCorners];
    }
    return _imgV;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}
- (UIButton *)removeThisRepairBtn{
    if (!_removeThisRepairBtn) {
        _removeThisRepairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _removeThisRepairBtn.layer.cornerRadius = 5;
        _removeThisRepairBtn.layer.borderWidth = 0.5;
        _removeThisRepairBtn.layer.borderColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7].CGColor;
        _removeThisRepairBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_removeThisRepairBtn setTitle:@"取消报修" forState:UIControlStateNormal];
        [_removeThisRepairBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_removeThisRepairBtn addTarget:self action:@selector(removeThisRepairBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _removeThisRepairBtn;
}
- (UIButton *)evaluationBtn{
    if (!_evaluationBtn) {
        _evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _evaluationBtn.layer.cornerRadius = 5;
        _evaluationBtn.layer.borderWidth = 0.5;
        _evaluationBtn.layer.borderColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7].CGColor;
        _evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_evaluationBtn setTitle:@"评价" forState:UIControlStateNormal];
        [_evaluationBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_evaluationBtn addTarget:self action:@selector(evaluationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evaluationBtn;
}

- (UIButton *)showReasonBtn{
    if (!_showReasonBtn) {
        _showReasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showReasonBtn.layer.cornerRadius = 5;
        _showReasonBtn.layer.borderWidth = 0.5;
        _showReasonBtn.layer.borderColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7].CGColor;
        _showReasonBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_showReasonBtn setTitle:@"查看理由" forState:UIControlStateNormal];
        [_showReasonBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [_showReasonBtn addTarget:self action:@selector(showDismissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showReasonBtn;
}
@end


@implementation  HouseRepairListWillDetailTableViewCell
- (void)setType{
    //type
    self.statusBtn.selected = YES;
    [self.statusBtn setTitle:@"待处理" forState:UIControlStateNormal];
    [self.statusBtn setTitle:@"待处理" forState:UIControlStateSelected];
    //bottom
    self.removeThisRepairBtn.hidden = NO;
    self.evaluationBtn.hidden = YES;
    self.showReasonBtn.hidden = YES;
}
@end

@implementation  HouseRepairListDetailingTableViewCell
- (void)setType{
    //type
    self.statusBtn.selected = YES;
    [self.statusBtn setTitle:@"处理中" forState:UIControlStateNormal];
    [self.statusBtn setTitle:@"处理中" forState:UIControlStateSelected];
    //bottom
    self.removeThisRepairBtn.hidden = YES;
    self.evaluationBtn.hidden = YES;
    self.showReasonBtn.hidden = YES;
    //back
    [self bottomViewReMas];
}
- (void)bottomViewReMas{
    //
}
@end

@implementation  HouseRepairListEndDetailTableViewCell
- (void)setType{
    //type
    self.statusBtn.selected = NO;
    [self.statusBtn setTitle:@"已完成" forState:UIControlStateNormal];
    [self.statusBtn setTitle:@"已完成" forState:UIControlStateSelected];
    //bottom
    self.removeThisRepairBtn.hidden = YES;
    self.evaluationBtn.hidden = NO;
    self.showReasonBtn.hidden = YES;
}
@end

@implementation HouseRepairListDismissDetailTableViewCell
 
- (void)setType{
    //type
    self.statusBtn.selected = NO;
    [self.statusBtn setTitle:@"已驳回" forState:UIControlStateNormal];
    [self.statusBtn setTitle:@"已驳回" forState:UIControlStateSelected];
    //bottom
    self.removeThisRepairBtn.hidden = YES;
    self.evaluationBtn.hidden = YES;
    self.showReasonBtn.hidden = NO;
}
 
@end
