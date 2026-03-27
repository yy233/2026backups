//
//  ContrectAllListBaseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "ContrectAllListBaseTableViewCell.h"

@implementation ContrectAllListBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYContrectAllListDataListModel *)model {
    _model = model;
    
    self.titleL.text = _model.conName;
    self.timeL.text = _model.createTime.xh_format_MM_dd;
    [self.faBtn  setTitle:_model.partAName forState:UIControlStateNormal];
    [self.souBtn setTitle:_model.partBName forState:UIControlStateNormal];
    
    if (_model.going == 0) {
        [self cellTypeIsWaitingFinish];
        self.finishLabel.text = @"已完成";
    }else if (_model.going == 1) {
        [self cellTypeIsWaitingTa];
    }else if (_model.going == 2) {
        [self cellTypeIsWaitingMe];
    }else if (_model.going == 3 || _model.going == 4) {
        [self cellTypeIsWaitingFinish];
        self.finishLabel.text = @"待作废";
        self.qianImgView.hidden = YES;
    }else if (_model.going == 5) {
        [self cellTypeIsWaitingFinish];
        self.finishLabel.text = @"已作废";
        self.qianImgView.hidden = YES;
    }else if (_model.going == 6) {
        [self cellTypeCancel];
        self.cancelLabel.text = @"已取消";
    }else {
        [self cellTypeCancel];
        self.cancelLabel.text = @"已逾期";
    }
}

- (void)cellDataIsDic:(NSDictionary *)dic{
    self.titleL.text = @"重庆纵横世纪科技合同签署协议协议协议协议协议协议协议";
    self.timeL.text = @"08-08";
    [self.faBtn  setTitle:@"重庆纵横世纪科技有限公司" forState:UIControlStateNormal];
    [self.souBtn setTitle:@"重庆今盛源区块链科技有限公司" forState:UIControlStateNormal];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.timeL];
        [self.backView addSubview:self.centerLabelsBackView];
        [self.centerLabelsBackView addSubview:self.wqLabel];
        [self.centerLabelsBackView addSubview:self.tqLabel];
        [self.centerLabelsBackView addSubview:self.finishLabel];
        [self.centerLabelsBackView addSubview:self.cancelLabel];
        [self.backView addSubview:self.faBtn];
        [self.backView addSubview:self.souBtn];
        [self.backView addSubview:self.qianImgView];
        [self setUI];
        self.faBtn.userInteractionEnabled = NO;
        self.souBtn.userInteractionEnabled = NO;
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
    //
    [self setTopUI];
    [self setCenterUI];
    [self setBottomAndImgUI];
    
}
- (void)setTopUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_backView);
        make.height.offset(20);
        make.right.equalTo(_backView.superview.mas_right).offset(-80);
    }];
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(_backView);
        make.height.offset(20);
        make.width.offset(70);
    }];
}
- (void)setCenterUI{
    [_centerLabelsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom);
        make.left.right.equalTo(_backView);
        make.height.offset(40);
    }];
    [_wqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerLabelsBackView);
        make.centerY.equalTo(_centerLabelsBackView.mas_centerY);
        make.width.offset(66);
        make.height.offset(22);
    }];
    [_tqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerLabelsBackView);
        make.centerY.equalTo(_centerLabelsBackView.mas_centerY);
        make.width.offset(66);
        make.height.offset(22);
    }];
    [_finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerLabelsBackView);
        make.centerY.equalTo(_centerLabelsBackView.mas_centerY);
        make.width.offset(66);
        make.height.offset(22);
    }];
    [_cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerLabelsBackView);
        make.centerY.equalTo(_centerLabelsBackView.mas_centerY);
        make.width.offset(66);
        make.height.offset(22);
    }];
}
- (void)setBottomAndImgUI{
   
    [_souBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_backView);
        make.height.offset(30);
    }];
    [_faBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backView);
        make.height.offset(30);
        make.bottom.equalTo(_souBtn.mas_top).offset(5);
    }];
    [_qianImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_backView);
        make.top.equalTo(_centerLabelsBackView.mas_centerY);
        make.width.equalTo(_qianImgView.mas_height);
    }];
}
- (void)cellTypeIsWaitingAll{
    _finishLabel.hidden = YES;
    _wqLabel.hidden = NO;
    _tqLabel.hidden = NO;
    _qianImgView.hidden = YES;
    [_tqLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_wqLabel.mas_right).offset(10);
        make.centerY.equalTo(_centerLabelsBackView.mas_centerY);
        make.width.offset(66);
        make.height.offset(22);
    }];
}
- (void)cellTypeIsWaitingMe{
    _finishLabel.hidden = YES;
    _wqLabel.hidden = NO;
    _tqLabel.hidden = YES;
    _cancelLabel.hidden = YES;
    _qianImgView.hidden = YES;
}
- (void)cellTypeIsWaitingTa{
    _finishLabel.hidden = YES;
    _wqLabel.hidden = YES;
    _tqLabel.hidden = NO;
    _cancelLabel.hidden = YES;
    _qianImgView.hidden = YES;
    
}
- (void)cellTypeIsWaitingFinish{
    _finishLabel.hidden = NO;
    _wqLabel.hidden = YES;
    _tqLabel.hidden = YES;
    _cancelLabel.hidden = YES;
    _qianImgView.hidden = NO;
}
- (void)cellTypeCancel{
    _finishLabel.hidden = YES;
    _wqLabel.hidden = YES;
    _tqLabel.hidden = YES;
    _cancelLabel.hidden = NO;
    _qianImgView.hidden = YES;
}

#pragma mark ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}
//
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleL.font = FontSize_ElectronicSignature_Bold(18);
    }
    return _titleL;
}
- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
        _timeL.font = FontSize_ElectronicSignature_Nomail(14);
        _timeL.textAlignment = NSTextAlignmentRight;
    }
    return _timeL;
}
//
- (UIView *)centerLabelsBackView{
    if (!_centerLabelsBackView) {
        _centerLabelsBackView = [[UIView alloc]init];
    }
    return _centerLabelsBackView;
}
//h_22
- (UILabel *)wqLabel{
    if (!_wqLabel) {
        _wqLabel = [[UILabel alloc]init];
        _wqLabel.text = @"待我签";
        _wqLabel.font = FontSize_ElectronicSignature_Nomail(13);
        _wqLabel.layer.cornerRadius = 11;
        _wqLabel.layer.masksToBounds = YES;
        _wqLabel.backgroundColor = Y_RGBA(112, 131, 169, 1);
        _wqLabel.textColor = [UIColor whiteColor];
        _wqLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _wqLabel;
}
- (UILabel *)tqLabel{
    if (!_tqLabel) {
        _tqLabel = [[UILabel alloc]init];
        _tqLabel.text = @"待他签";
        _tqLabel.font = FontSize_ElectronicSignature_Nomail(13);
        _tqLabel.layer.cornerRadius = 11;
        _tqLabel.layer.masksToBounds = YES;
        _tqLabel.backgroundColor =  Y_RGBA(96, 142, 226, 1);
        _tqLabel.textColor = [UIColor whiteColor];
        _tqLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tqLabel;
}
- (UILabel *)finishLabel{
    if (!_finishLabel) {
        _finishLabel = [[UILabel alloc]init];
        _finishLabel.text = @"已完成";
        _finishLabel.font = FontSize_ElectronicSignature_Nomail(13);
        _finishLabel.layer.cornerRadius = 11;
        _finishLabel.layer.masksToBounds = YES;
        _finishLabel.backgroundColor =  Y_RGBA(238, 238, 238, 1);
        _finishLabel.textColor = Y_RGBA(156, 156, 156, 1);
        _finishLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _finishLabel;
}
- (UILabel *)cancelLabel{
    if (!_cancelLabel) {
        _cancelLabel = [[UILabel alloc]init];
        _cancelLabel.text = @"已取消";
        _cancelLabel.font = FontSize_ElectronicSignature_Nomail(13);
        _cancelLabel.layer.cornerRadius = 11;
        _cancelLabel.layer.masksToBounds = YES;
        _cancelLabel.backgroundColor =  Y_RGBA(252, 111, 110, 1);
        _cancelLabel.textColor = [UIColor whiteColor];
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cancelLabel;
}
//
- (UIButton *)faBtn{
    if (!_faBtn) {
        _faBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _faBtn.titleLabel.font = FontSize_ElectronicSignature_Nomail(14);
        [_faBtn setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4  forState:UIControlStateNormal];
        [_faBtn setImage:[UIImage imageNamed:@"f"] forState:UIControlStateNormal];
        [_faBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:1];
        _faBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _faBtn;
}
- (UIButton *)souBtn{
    if (!_souBtn) {
        _souBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _souBtn.titleLabel.font = FontSize_ElectronicSignature_Nomail(14);
        [_souBtn setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4  forState:UIControlStateNormal];
        [_souBtn setImage:[UIImage imageNamed:@"s"] forState:UIControlStateNormal];
        [_souBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:1];
        _souBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _souBtn;
}
//
- (UIImageView *)qianImgView{
    if (!_qianImgView) {
        _qianImgView = [[UIImageView alloc]init];
        _qianImgView.image = [UIImage imageNamed:@"yiqianming"];
        _qianImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _qianImgView;
}
@end
