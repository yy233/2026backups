//
//  CreateLiveOrVoiceView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/23.
//

#import "CreateLiveOrVoiceView.h"

@implementation CreateLiveOrVoiceView


- (UIImageView *)fengMianImgV{
    if(!_fengMianImgV){
        _fengMianImgV  = [[UIImageView alloc]init];
        _fengMianImgV.backgroundColor = [UIColor lightGrayColor];
        _fengMianImgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _fengMianImgV;
}
- (UIButton *)fengMainBtn{
    if(!_fengMainBtn){
        _fengMainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fengMainBtn newAnBtnWithTextStr: Y_LocaleTypeFile_NSLocalString(@"封面图库 >")];
        _fengMainBtn.titleLabel.numberOfLines = 2;
        [_fengMainBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_fengMainBtn newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
        [_fengMainBtn addTarget:self action:@selector(fengMainBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fengMainBtn;
}

- (UITextField *)inputTitleTF{
    if(!_inputTitleTF){
        _inputTitleTF = [[UITextField alloc]init];
        _inputTitleTF.textColor = [UIColor whiteColor];
        _inputTitleTF.font = [UIFont systemFontOfSize:22.0];
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc]
                                                        initWithString:Y_LocaleTypeFile_NSLocalString(@"输入房间标题")
                                                        attributes:@{NSForegroundColorAttributeName:[[UIColor whiteColor] colorWithAlphaComponent:0.7],
                                                                     NSFontAttributeName:[UIFont systemFontOfSize:22.0]}];
        _inputTitleTF.attributedPlaceholder = placeholderString;
    }
    return _inputTitleTF;
}

- (UILabel *)btnOfPubOrPirTitle{
    if(!_btnOfPubOrPirTitle){
        _btnOfPubOrPirTitle = [[UILabel alloc]init];
        _btnOfPubOrPirTitle.textColor = [UIColor whiteColor];
        _btnOfPubOrPirTitle.text = Y_LocaleTypeFile_NSLocalString(@"私密");
        _btnOfPubOrPirTitle.numberOfLines = 2;
        _btnOfPubOrPirTitle.font = [UIFont systemFontOfSize:13.0];
    }
    return _btnOfPubOrPirTitle;
}

- (UIButton *)btnOfPubOrPir{
    if(!_btnOfPubOrPir){
        _btnOfPubOrPir = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnOfPubOrPir newAnBtnWithNomalImg:[UIImage imageNamed:@"私密"]  selectedImg:[UIImage imageNamed:@"公开"]];
        [_btnOfPubOrPir addTarget:self action:@selector(btnOfPubOrPirAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnOfPubOrPir;
}

- (UIView *)bottomChooseRoomTypeBkView{
    if(!_bottomChooseRoomTypeBkView){
        _bottomChooseRoomTypeBkView = [[UIView alloc]init];;
        _bottomChooseRoomTypeBkView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2];
        _bottomChooseRoomTypeBkView.layer.cornerRadius = 6;
    }
    return _bottomChooseRoomTypeBkView;
}
- (UILabel *)bottomTitleL{
    if(!_bottomTitleL){
        _bottomTitleL = [[UILabel alloc]init];
        _bottomTitleL.textColor = [UIColor whiteColor];
        _bottomTitleL.text = Y_LocaleTypeFile_NSLocalString(@"选择直播类型");
        _bottomTitleL.numberOfLines = 2;
        _bottomTitleL.font = [UIFont systemFontOfSize:13.0];

        
    }
    return _bottomTitleL;
}

- (UIButton *)typeOfLive{
    if(!_typeOfLive){
        _typeOfLive = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeOfLive newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"视频")];
        _typeOfLive.titleLabel.numberOfLines = 2;
        [_typeOfLive newAnBtnWithTextColor:[UIColor whiteColor]];
        [_typeOfLive newAnBtnWithFont: [UIFont systemFontOfSize:14.0]];
        [_typeOfLive newAnBtnWithNomalImg:[UIImage imageNamed:@"notSelected_y"] selectedImg:[UIImage imageNamed:@"green_Selected"]];
        [_typeOfLive addTarget:self action:@selector(typeOfLiveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeOfLive;
}

- (UIButton *)typeOfVoice{
    if(!_typeOfVoice){
        _typeOfVoice = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_typeOfVoice newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"音频")];
        [_typeOfVoice newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"语音")];
        _typeOfVoice.titleLabel.numberOfLines = 2;
        [_typeOfVoice newAnBtnWithTextColor:[UIColor whiteColor]];
        [_typeOfVoice newAnBtnWithFont: [UIFont systemFontOfSize:14.0]];
        [_typeOfVoice newAnBtnWithNomalImg:[UIImage imageNamed:@"notSelected_y"] selectedImg:[UIImage imageNamed:@"green_Selected"]];
        [_typeOfVoice addTarget:self action:@selector(typeOfVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeOfVoice;
}




#pragma mark== 0823增入
- (UIView *)kaiBoType_atOnceOrOnlyAddItemBkView{
    if(!_kaiBoType_atOnceOrOnlyAddItemBkView){
        _kaiBoType_atOnceOrOnlyAddItemBkView = [[UIView alloc]init];;
        _kaiBoType_atOnceOrOnlyAddItemBkView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2];
        _kaiBoType_atOnceOrOnlyAddItemBkView.layer.cornerRadius = 6;
    }
    return _kaiBoType_atOnceOrOnlyAddItemBkView;
}
- (UILabel *)kaiBoType_atOnceOrOnlyAddItem_title{
    if(!_kaiBoType_atOnceOrOnlyAddItem_title){
        _kaiBoType_atOnceOrOnlyAddItem_title = [[UILabel alloc]init];
        _kaiBoType_atOnceOrOnlyAddItem_title.textColor = [UIColor whiteColor];
        _kaiBoType_atOnceOrOnlyAddItem_title.text = Y_LocaleTypeFile_NSLocalString(@"选择开播类型");
        _kaiBoType_atOnceOrOnlyAddItem_title.numberOfLines = 2;
        _kaiBoType_atOnceOrOnlyAddItem_title.font = [UIFont systemFontOfSize:13.0];
    }
    return _kaiBoType_atOnceOrOnlyAddItem_title;
}

- (UIButton *)typeOfAtOnce{
    if(!_typeOfAtOnce){
        _typeOfAtOnce = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeOfAtOnce newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"立即开播")];
        _typeOfAtOnce.titleLabel.numberOfLines = 2;
        [_typeOfAtOnce newAnBtnWithTextColor:[UIColor whiteColor]];
        [_typeOfAtOnce newAnBtnWithFont: [UIFont systemFontOfSize:14.0]];
        [_typeOfAtOnce newAnBtnWithNomalImg:[UIImage imageNamed:@"notSelected_y"] selectedImg:[UIImage imageNamed:@"green_Selected"]];
        [_typeOfAtOnce addTarget:self action:@selector(typeOfAtOnceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeOfAtOnce;
}
- (UIButton *)typeOfAddItem{
    if(!_typeOfAddItem){
        _typeOfAddItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeOfAddItem newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"延时开播")];
        _typeOfAddItem.titleLabel.numberOfLines = 2;
        [_typeOfAddItem newAnBtnWithTextColor:[UIColor whiteColor]];
        [_typeOfAddItem newAnBtnWithFont: [UIFont systemFontOfSize:14.0]];
        [_typeOfAddItem newAnBtnWithNomalImg:[UIImage imageNamed:@"notSelected_y"] selectedImg:[UIImage imageNamed:@"green_Selected"]];
        [_typeOfAddItem addTarget:self action:@selector(typeOfAddItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeOfAddItem;
}



#pragma mark ==
 
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //self.backgroundColor = [UIColor blueColor];
        [self addSubview:self.fengMianImgV];
        [self addSubview:self.fengMainBtn];
        [self addSubview:self.inputTitleTF];
        [self addSubview:self.btnOfPubOrPirTitle];
        [self addSubview:self.btnOfPubOrPir];
        
        [self addSubview:self.bottomChooseRoomTypeBkView];
        [self addSubview:self.kaiBoType_atOnceOrOnlyAddItemBkView];
        [self addSubview:self.kaiBoBottomChooseTimeBkView];
        [self.bottomChooseRoomTypeBkView addSubview:self.bottomTitleL];
        [self.bottomChooseRoomTypeBkView addSubview:self.typeOfLive];
        [self.bottomChooseRoomTypeBkView addSubview:self.typeOfVoice];
        //开播时间区域
    
        [self.kaiBoType_atOnceOrOnlyAddItemBkView addSubview:self.kaiBoType_atOnceOrOnlyAddItem_title];
        [self.kaiBoType_atOnceOrOnlyAddItemBkView addSubview:self.typeOfAtOnce];
        [self.kaiBoType_atOnceOrOnlyAddItemBkView addSubview:self.typeOfAddItem];
        //时间年月日区域
        [self.kaiBoBottomChooseTimeBkView addSubview:self.kaiBoTitleL];
        [self.kaiBoBottomChooseTimeBkView addSubview:self.kaiBoRightImgv];
        [self.kaiBoBottomChooseTimeBkView addSubview:self.nowKaiBoBtn];
        [self.kaiBoBottomChooseTimeBkView addSubview:self.kaiBoTimeL];
        [self.kaiBoBottomChooseTimeBkView addSubview:self.kaiBoTimeChooseTopBtn];

        [self setsubViews];
        self.btnOfPubOrPir.selected = YES;
        self.btnOfPubOrPirTitle.text = Y_LocaleTypeFile_NSLocalString(@"公开");
        self.btnOfPubOrPirTitle.numberOfLines = 2;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.fengMianImgV.layer.mask =  [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(0, 0, 90, 90) withCornerRadi:CGSizeMake(6, 6) withRoundingCorners:UIRectCornerAllCorners];
    [self.fengMainBtn newAnBtnWithLayerCorNerNum:6 withLayerLineWidth:1.0 withLayerLineColor:[UIColor whiteColor]];
 
}


- (void)setsubViews{
    //顶
    [_fengMianImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_fengMianImgV.superview).offset(16);
        make.width.height.offset(90);
    }];
    [_fengMainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_fengMianImgV);
    }];
    [_inputTitleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fengMianImgV);
        make.left.equalTo(_fengMianImgV.mas_right).offset(20);
        make.height.offset(30);
        make.right.equalTo(_fengMianImgV.superview.mas_right).offset(-20);
    }];
    
    [_btnOfPubOrPirTitle  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_inputTitleTF);
        make.height.offset(36);
        make.bottom.equalTo(_fengMianImgV);
    }];
    [_btnOfPubOrPir mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_btnOfPubOrPirTitle.mas_right).offset(5);
        make.height.centerY.equalTo(_btnOfPubOrPirTitle);
        make.width.equalTo(_btnOfPubOrPir.mas_height).multipliedBy(1.6);//10:6 
    }];
    
    //背景
    [_bottomChooseRoomTypeBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fengMianImgV);
        make.top.equalTo(_fengMianImgV.mas_bottom).offset(50);
        make.height.offset(60);
        make.right.equalTo(_bottomChooseRoomTypeBkView.superview.mas_right).offset(-16);
    }];
    
    //一行
    [_bottomTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomTitleL.superview);
        make.left.equalTo(_bottomTitleL.superview.mas_left).offset(16);
        make.width.equalTo(_bottomTitleL.superview).multipliedBy(0.5);
//        make.height.offset(30);
        make.height.equalTo(_bottomTitleL.superview);

    }];
    [_typeOfLive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(55);
        make.centerY.equalTo(_typeOfLive.superview);
        make.right.equalTo(_typeOfLive.superview).offset(-16);
    }];
    [_typeOfVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(55);
        make.centerY.equalTo(_typeOfVoice.superview);
        make.right.equalTo(_typeOfLive.mas_left).offset(-20);
    }];
    
    //0823两行中间加一行 开播类型
    [_kaiBoType_atOnceOrOnlyAddItemBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomChooseRoomTypeBkView);
        make.top.equalTo(_bottomChooseRoomTypeBkView.mas_bottom).offset(20);
        make.height.offset(60);
        make.right.equalTo(_bottomChooseRoomTypeBkView);
    }];
    [_kaiBoType_atOnceOrOnlyAddItem_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_kaiBoType_atOnceOrOnlyAddItem_title.superview);
        make.left.equalTo(_kaiBoType_atOnceOrOnlyAddItem_title.superview.mas_left).offset(16);
        make.height.equalTo(_kaiBoType_atOnceOrOnlyAddItem_title.superview);
        make.width.offset(100);
    }];
    [_typeOfAddItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.centerY.equalTo(_typeOfAddItem.superview);
        make.right.equalTo(_typeOfAddItem.superview).offset(-16);
    }];
    [_typeOfAtOnce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(80);
        make.centerY.equalTo(_typeOfAtOnce.superview);
        make.right.equalTo(_typeOfAddItem.mas_left).offset(-20);
    }];

    //--0823增入行end
    
    
    [_kaiBoBottomChooseTimeBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomChooseRoomTypeBkView);
        make.top.equalTo(_kaiBoType_atOnceOrOnlyAddItemBkView.mas_bottom).offset(20);
        make.height.offset(60);
        make.right.equalTo(_bottomChooseRoomTypeBkView);
    }];
    //二行
    [_kaiBoTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_kaiBoTitleL.superview);
        make.left.equalTo(_kaiBoTitleL.superview.mas_left).offset(16);
//        make.height.offset(30);
        make.height.equalTo(_kaiBoTitleL.superview);
        make.width.offset(90);
    }];
    
    [_kaiBoRightImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(12);
        make.height.offset(10);
        make.centerY.equalTo(_kaiBoRightImgv.superview);
        make.right.equalTo(_kaiBoRightImgv.superview).offset(-20);
    }];
    [_nowKaiBoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_kaiBoRightImgv.mas_left).offset(-2);
        make.centerY.equalTo(_nowKaiBoBtn.superview);
//        make.height.offset(20);
        make.height.equalTo(_nowKaiBoBtn.superview);
//        make.width.offset(63);
        make.width.offset(1);//hiden
    }];
    
    [_kaiBoTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.centerY.equalTo(_kaiBoTimeL.superview);
        make.right.equalTo(_nowKaiBoBtn.mas_left).offset(0);
        make.left.equalTo(_kaiBoTitleL.mas_right);
    }];
    
    [_kaiBoTimeChooseTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_kaiBoTitleL.mas_left);
        make.top.bottom.equalTo(_kaiBoTitleL);
        make.right.equalTo(_kaiBoRightImgv.mas_left);
    }];
   //初始状态 语言类型
    _typeOfVoice.selected = YES;
    _typeOfLive.selected = NO;

    //初始开播类型 立即开播
    _typeOfAtOnce.selected = YES;
    _typeOfAddItem.selected = NO;
    //去掉旧版的立即开播按钮
    self.nowKaiBoBtn.hidden = YES;
    
    //初始状态 隐藏 时间选择区域
    self.kaiBoBottomChooseTimeBkView.hidden = YES;
}


#pragma mark ==

//公开私密类型
- (void)btnOfPubOrPirAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        _btnOfPubOrPirTitle.text = Y_LocaleTypeFile_NSLocalString(@"公开");
    }else{
        _btnOfPubOrPirTitle.text = Y_LocaleTypeFile_NSLocalString(@"私密");
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(touchChangePubOrPriType)]){
        [_delegate touchChangePubOrPriType];
    }
}

//切换
- (void)typeOfLiveAction:(UIButton *)sender{
    if(sender.selected == YES){
        return;
    }
    sender.selected = !sender.selected;
    _typeOfVoice.selected = !sender.selected;
    
    if(_delegate && [_delegate respondsToSelector:@selector(touchChooseLiveType)]){
        [_delegate touchChooseLiveType];
    }
}
- (void)typeOfVoiceAction:(UIButton *)sender{
    if(sender.selected == YES){
        return;
    }
    sender.selected = !sender.selected;
    _typeOfLive.selected = !sender.selected;

    if(_delegate && [_delegate respondsToSelector:@selector(touchChooseVoiceType)]){
        [_delegate touchChooseVoiceType];
    }
}

//开播类型切换
//
- (void)typeOfAtOnceAction:(UIButton *)sender{
    if(sender.selected == YES){
        return;
    }
    sender.selected = !sender.selected;
    _typeOfAddItem.selected = !sender.selected;
    //立即开播 隐藏选时间view
    self.kaiBoBottomChooseTimeBkView.hidden = YES;

}
- (void)typeOfAddItemAction:(UIButton *)sender{
    if(sender.selected == YES){
        return;
    }
    sender.selected = !sender.selected;
    _typeOfAtOnce.selected = !sender.selected;
    //延时开播 展示选时间view
    self.kaiBoBottomChooseTimeBkView.hidden = NO;
    
}

- (void)fengMainBtnAction{
    if(_delegate && [_delegate respondsToSelector:@selector(touchChooseFengMianPic)]){
        [_delegate touchChooseFengMianPic];
    }
}


- (void)kaiBoTopBtnAction{
    if(_delegate && [_delegate respondsToSelector:@selector(touchKaiBoTime)]){
        [_delegate touchKaiBoTime];
    }
}
- (void)nowkaiBoAction{
    if(_delegate && [_delegate respondsToSelector:@selector(nowGoTokaiBo)]){
        [_delegate nowGoTokaiBo];
    }
}



#pragma mark ===
- (UIView *)kaiBoBottomChooseTimeBkView{
    if(!_kaiBoBottomChooseTimeBkView){
        _kaiBoBottomChooseTimeBkView = [[UIView alloc]init];
        _kaiBoBottomChooseTimeBkView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.2];
        _kaiBoBottomChooseTimeBkView.layer.cornerRadius = 6;
    }
    return _kaiBoBottomChooseTimeBkView;
}


- (UILabel *)kaiBoTitleL{
    if(!_kaiBoTitleL){
        _kaiBoTitleL = [[UILabel alloc]init];
        _kaiBoTitleL.text = Y_LocaleTypeFile_NSLocalString(@"选择开播时间");
        _kaiBoTitleL.textColor = [UIColor whiteColor];
        _kaiBoTitleL.font = [UIFont systemFontOfSize:14.0];
        _kaiBoTitleL.numberOfLines = 2;
    }
    return _kaiBoTitleL;
}
- (UILabel *)kaiBoTimeL{
    if(!_kaiBoTimeL){
        _kaiBoTimeL = [[UILabel alloc]init];
        _kaiBoTimeL.text = @"";
        _kaiBoTimeL.textColor = [UIColor whiteColor];
        _kaiBoTimeL.font = [UIFont systemFontOfSize:14.0];
        _kaiBoTimeL.textAlignment = NSTextAlignmentCenter;
    }
    return _kaiBoTimeL;
}

- (UIImageView *)kaiBoRightImgv{
    if(!_kaiBoRightImgv){
        _kaiBoRightImgv = [[UIImageView alloc]init];
        _kaiBoRightImgv.contentMode = UIViewContentModeScaleAspectFit;
        _kaiBoRightImgv.image = [UIImage imageNamed:@"Fill_right_w"];
    }
    return _kaiBoRightImgv;
}
- (UIButton *)kaiBoTimeChooseTopBtn{
    if(!_kaiBoTimeChooseTopBtn){
        _kaiBoTimeChooseTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_kaiBoTimeChooseTopBtn addTarget:self action:@selector(kaiBoTopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kaiBoTimeChooseTopBtn;
}
- (UIButton *)nowKaiBoBtn{
    if(!_nowKaiBoBtn){
        _nowKaiBoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nowKaiBoBtn setTitle:Y_LocaleTypeFile_NSLocalString(@"立即开播") forState:UIControlStateNormal];
        _nowKaiBoBtn.titleLabel.numberOfLines = 2;
        _nowKaiBoBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_nowKaiBoBtn setTitleColor:Color_Socialize_GreenColor  forState:UIControlStateNormal];
        [_nowKaiBoBtn addTarget:self action:@selector(nowkaiBoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowKaiBoBtn;
}
@end
