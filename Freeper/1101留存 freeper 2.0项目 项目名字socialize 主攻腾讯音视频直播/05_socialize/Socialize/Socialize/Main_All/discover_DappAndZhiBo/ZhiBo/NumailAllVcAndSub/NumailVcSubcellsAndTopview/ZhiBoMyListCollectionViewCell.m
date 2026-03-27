//
//  ZhiBoMyListCollectionViewCell.m
//  Socialize
//
//  Created by 余莹 on 2023/7/3.
//

#import "ZhiBoMyListCollectionViewCell.h"

#define  greenColor_Main     Y_RGBA(143.0, 239.0, 240.0,1.0)


@interface ZhiBoMyListCollectionViewCell ()
@end

@implementation ZhiBoMyListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backViewMain];
        [self.backViewMain addSubview:self.backViewTop];
        [self.backViewMain addSubview:self.backViewBottom];
        [self.backViewTop addSubview:self.bkimgView];
        [self.backViewTop addSubview:self.zhuBoUserNameLabel];
        [self.backViewTop addSubview:self.titleBkV];
        [self.backViewTop addSubview:self.titleLabel];
        [self.backViewBottom addSubview:self.pubOrPivTypeBtn];
        [self.backViewBottom addSubview:self.zhiBoTypeBtn];
        [self.backViewBottom addSubview:self.statueTypeBtn];
        [self.backViewBottom addSubview:self.kaiBoJuLiTimeTitleLabel];
        [self.backViewBottom addSubview:self.kaiBoJuLiTimeLabel];
        [self setAllUI];
 
    }
    return self;
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _bkimgView.image = nil;
    _titleLabel.text = @"";
    _zhuBoUserNameLabel.text = @"";
    _kaiBoJuLiTimeLabel.text = @"";
    
}


- (void)setAllUI{
    [_backViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backViewMain.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_backViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(_backViewTop.superview);
        make.height.equalTo(_backViewMain.superview).multipliedBy(0.5).offset(60);
    }];
    [_backViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(_backViewTop.superview);
        make.bottom.equalTo(_backViewBottom.superview.mas_bottom);
        make.top.equalTo(_backViewTop.mas_bottom).offset(-10);
    }];
    
    [self topUI];
    [self bottomUI];
    self.backViewMain.layer.cornerRadius = 10;
    self.backViewMain.layer.masksToBounds = YES;
    self.backViewMain.layer.borderWidth = 1.0;
    self.backViewMain.layer.borderColor = Color_238GrayColor.CGColor;
    self.backViewBottom.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)topUI{
    [_bkimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bkimgView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_titleLabel.superview).offset(-20);
        make.centerX.equalTo(_zhuBoUserNameLabel);
        make.bottom.equalTo(_titleLabel.superview).offset(-10);
    }];
    [_titleBkV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_titleLabel.superview).offset(0);
        make.centerX.equalTo(_zhuBoUserNameLabel);
        make.bottom.equalTo(_titleLabel.superview).offset(0);
        make.top.equalTo(_titleLabel).offset(-5);
    }];
    [_zhuBoUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_zhuBoUserNameLabel.superview).offset(-20);
        make.centerX.equalTo(_zhuBoUserNameLabel.superview);
        make.bottom.equalTo(_titleLabel.mas_top);
        make.height.offset(20.0);
    }];
    
    
}
- (void)bottomUI{
    
    [_pubOrPivTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pubOrPivTypeBtn.superview).offset(15);
        make.left.equalTo(_pubOrPivTypeBtn.superview).offset(10);
        make.width.equalTo(_pubOrPivTypeBtn.superview).multipliedBy(0.25);
        make.height.offset(20.0);
    }];
    
    [_zhiBoTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_zhiBoTypeBtn.superview).offset(15);
        make.width.equalTo(_zhiBoTypeBtn.superview).multipliedBy(0.25);
        make.centerX.equalTo(_zhiBoTypeBtn.superview);
        make.height.offset(20.0);
    }];
    
    [_statueTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statueTypeBtn.superview).offset(15);
        make.width.equalTo(_statueTypeBtn.superview).multipliedBy(0.25);
        make.right.equalTo(_statueTypeBtn.superview).offset(-10);
        make.height.offset(20.0);
    }];
    
    //
    [_kaiBoJuLiTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pubOrPivTypeBtn);
        make.width.offset(55);
        make.top.equalTo(_statueTypeBtn.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    [_kaiBoJuLiTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(_kaiBoJuLiTimeTitleLabel);
        make.left.equalTo(_kaiBoJuLiTimeTitleLabel.mas_right);
        make.right.equalTo(_kaiBoJuLiTimeLabel.superview);

    }];
    
    if(Screen_H < 812.0){
        _kaiBoJuLiTimeLabel.font = [UIFont systemFontOfSize:12.0];
    }
    
}


#pragma mark ===
- (UIView *)backViewMain{
    if(!_backViewMain){
        _backViewMain = [[UIView alloc]init];
    }
    return _backViewMain;
}
- (UIView *)backViewTop{
    if(!_backViewTop){
        _backViewTop = [[UIView alloc]init];
    }
    return _backViewTop;
}

- (UIView *)backViewBottom{
    if(!_backViewBottom){
        _backViewBottom = [[UIView alloc]init];
    }
    return _backViewBottom;
}
#pragma mark ===

- (UIImageView *)bkimgView{
    if(!_bkimgView){
        _bkimgView  = [[UIImageView alloc]init];
        _bkimgView.contentMode =  UIViewContentModeScaleAspectFill;
    }
    return _bkimgView;
}
- (UILabel *)zhuBoUserNameLabel{
    if (!_zhuBoUserNameLabel) {
        _zhuBoUserNameLabel = [[UILabel alloc]init];
        _zhuBoUserNameLabel.numberOfLines = 1;
        _zhuBoUserNameLabel.font = [UIFont systemFontOfSize:12];
        _zhuBoUserNameLabel.textAlignment = NSTextAlignmentLeft;
        _zhuBoUserNameLabel.textColor = [UIColor whiteColor];
//        _zhuBoUserNameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _zhuBoUserNameLabel;
}
- (UIView *)titleBkV{
    if(!_titleBkV){
        _titleBkV = [[UIView alloc] init];
        _titleBkV.backgroundColor = [Color_153GrayColor colorWithAlphaComponent:0.5];
        _titleBkV.layer.masksToBounds = YES;
    }
    return _titleBkV;
}
- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _titleLabel;
    
}

#pragma mark ===

- (UILabel *)kaiBoJuLiTimeLabel{
    if(!_kaiBoJuLiTimeLabel){
        _kaiBoJuLiTimeLabel = [[UILabel alloc]init];
        _kaiBoJuLiTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _kaiBoJuLiTimeLabel.textColor = Color_51BlackColor;
    }
    return _kaiBoJuLiTimeLabel;
}


- (UILabel *)kaiBoJuLiTimeTitleLabel{
    if(!_kaiBoJuLiTimeTitleLabel){
        _kaiBoJuLiTimeTitleLabel = [[UILabel alloc]init];
        _kaiBoJuLiTimeTitleLabel.font = [UIFont systemFontOfSize:12.0];
        _kaiBoJuLiTimeTitleLabel.textColor = Color_153GrayColor;
        _kaiBoJuLiTimeTitleLabel.text =  Y_LocaleTypeFile_NSLocalString(@"开始时间");
        _kaiBoJuLiTimeTitleLabel.numberOfLines = 2;
    }
    return _kaiBoJuLiTimeTitleLabel;
}
- (UIButton *)statueTypeBtn{
    if(!_statueTypeBtn){
        _statueTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statueTypeBtn newAnBtnWithFont:[UIFont systemFontOfSize:11.0]];
        [_statueTypeBtn newAnBtnWithTextColor:Color_153GrayColor];
        [_statueTypeBtn newAnBtnWithBackColor:[Color_153GrayColor colorWithAlphaComponent:0.2]];
        [_statueTypeBtn newAnBtnWithLayerCorNerNum:10.0 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
        
    }
    return _statueTypeBtn;
}

- (UIButton *)zhiBoTypeBtn{
    if(!_zhiBoTypeBtn){
        _zhiBoTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhiBoTypeBtn newAnBtnWithFont:[UIFont systemFontOfSize:11.0]];
        [_zhiBoTypeBtn newAnBtnWithTextColor:greenColor_Main];
        [_zhiBoTypeBtn newAnBtnWithLayerCorNerNum:10.0 withLayerLineWidth:1.0 withLayerLineColor:greenColor_Main];
        _zhiBoTypeBtn.titleLabel.numberOfLines = 2;
    }
    return _zhiBoTypeBtn;
}

- (UIButton *)pubOrPivTypeBtn{
    if(!_pubOrPivTypeBtn){
        _pubOrPivTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pubOrPivTypeBtn newAnBtnWithFont:[UIFont systemFontOfSize:11.0]];
        [_pubOrPivTypeBtn newAnBtnWithTextColor:greenColor_Main];
        [_pubOrPivTypeBtn newAnBtnWithLayerCorNerNum:10.0 withLayerLineWidth:1.0 withLayerLineColor:greenColor_Main];
    }
    return _pubOrPivTypeBtn;
}

#pragma mark === 倒计时
- (void)upDataTimeInfoWithNowUseDaoJiShiHMSTimeIv:(NSString *)cellUseTimeIv{
    WEAKSELF
    if(cellUseTimeIv.length <= 0){
        //已经先于当前时间 或者不符合要求 总之 不做变化
        weakSelf.kaiBoJuLiTimeTitleLabel.text =  Y_LocaleTypeFile_NSLocalString(@"开始时间");
        return;
    }else{
        //有数据 ---- 处理倒计时文本
        NSString *showStr = [YTimeStamp getDHMSTimeStrUseDaoJiShiTimeIv:[cellUseTimeIv integerValue]];//getHMSTimeStrUseDaoJiShiTimeIv
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.kaiBoJuLiTimeTitleLabel.text = Y_LocaleTypeFile_NSLocalString(@"距离开播");
            weakSelf.kaiBoJuLiTimeLabel.text = showStr;
        });
    }
    
}
#pragma mark === 倒计时  

@end
