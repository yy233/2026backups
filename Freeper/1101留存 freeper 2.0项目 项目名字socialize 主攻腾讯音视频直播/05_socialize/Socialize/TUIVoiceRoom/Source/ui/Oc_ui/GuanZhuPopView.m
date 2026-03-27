//
//  GuanZhuPopView.m
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/6/13.
//

#import "GuanZhuPopView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "VoiceOcTool.h"
@interface GuanZhuPopView ()
@property (nonatomic,strong) NSString *saveZhuBoIdStr;


@end

@implementation GuanZhuPopView
- (void)setGuanZhuUserInfoWithName:(NSString *)nameStr withHeadImg:(NSString *)headerImgStr  withUserID:(NSString *)userIdStr withIntordace:(NSString *)intordaceStr withTherInfos:(id)otherInfo{
    self.nickNameL.text = [NSString stringWithFormat:@"ID:%@",nameStr];
    //self.nickNameL.backgroundColor = [UIColor redColor];
    
    if (headerImgStr.length>0) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:headerImgStr] placeholderImage:[VoiceOcTool getHeaderGrayColorImg]];

    }else{
        self.imgV.image = [VoiceOcTool getHeaderGrayColorImg];
    }
    
    self.saveZhuBoIdStr = userIdStr;
    if(intordaceStr && intordaceStr.length >0){
        self.infoTextView.text = intordaceStr;
    }else{
        self.infoTextView.text = voiceRoomLocalize(@"暂无简介");
    }
    
    
}
#pragma mark == 重写
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    if(dataSourceArr.count <= 0){
        return;
    }
    
    NSString *nameStr = dataSourceArr.firstObject;
    NSString *headerImgUrl = dataSourceArr[1];
    NSString *introduceStr = dataSourceArr[2];
    _saveZhuBoIdStr = dataSourceArr[3];
    
    _nickNameL.text = nameStr;
    _infoTextView.text = introduceStr;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:headerImgUrl] placeholderImage:[VoiceOcTool getHeaderGrayColorImg]];
    
    //test
    //_infoTextView.text = @"简介位置简介位置简介位置简介位置简介位置简介位置简介位置";
  
}
- (void)changMainBackViewBackColor{
    self.subMainBackView.backgroundColor = [UIColor clearColor];// [UIColor whiteColor]; //Color_238GrayColor;//半截背景颜色配置
}
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.6;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
 
    }
    return self;
}

#pragma mark ==
- (void)addSubAllView{

    
        [self.subMainBackView addSubview:self.guanzhuAllSubViewMainBkView];
        [self.guanzhuAllSubViewMainBkView addSubview:self.bottomBkView];
        [self.guanzhuAllSubViewMainBkView addSubview:self.imgV];
        //头像地下
        [self.bottomBkView addSubview:self.idLable];
        [self.bottomBkView addSubview:self.rightTopJuBaoBtn];
        [self.bottomBkView addSubview:self.nickNameL];
        [self.bottomBkView addSubview:self.baseInfoBkView];
        [self.bottomBkView addSubview:self.infoTextView];
        
        //底部
        [self.guanzhuAllSubViewMainBkView addSubview:self.callATMeBtn];
        [self.guanzhuAllSubViewMainBkView addSubview:self.siXinBtn];
        [self.guanzhuAllSubViewMainBkView addSubview:self.guanZhuBtn];
        [self setsubViews];
 
}

#pragma mark ===  上部分
- (UIView *)guanzhuAllSubViewMainBkView{
    if(!_guanzhuAllSubViewMainBkView){
        _guanzhuAllSubViewMainBkView = [[UIView alloc]init];
        _guanzhuAllSubViewMainBkView.backgroundColor =  podUse_rgba(0, 0, 0, 1);
        _guanzhuAllSubViewMainBkView.layer.cornerRadius = 10;
//        _guanzhuAllSubViewMainBkView.layer.masksToBounds = YES;
    }
    return _guanzhuAllSubViewMainBkView;
}
 
- (UIImageView *)imgV{
    if(!_imgV){
        _imgV = [[UIImageView alloc]init];
        _imgV.backgroundColor = [UIColor cyanColor];
        _imgV.layer.cornerRadius = 50;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}
- (UIView *)bottomBkView{
    if(!_bottomBkView){
        _bottomBkView = [[UIView alloc]init];
    }
    return _bottomBkView;
}
- (UILabel *)idLable{
    if(!_idLable){
        _idLable = [[UILabel alloc]init];
        _idLable.textColor = [UIColor whiteColor];
        _idLable.text = @"";
        _idLable.font = [UIFont boldSystemFontOfSize:22];
        _idLable.textAlignment = NSTextAlignmentLeft;
    }
    return _idLable;
}
- (UIButton *)rightTopJuBaoBtn{
    if(!_rightTopJuBaoBtn){
        _rightTopJuBaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightTopJuBaoBtn.backgroundColor = podUse_rgba(102, 208, 209, 1);
        _rightTopJuBaoBtn.layer.cornerRadius = 16;
        _rightTopJuBaoBtn.layer.borderWidth = 0.0;
        _rightTopJuBaoBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_rightTopJuBaoBtn  setImage:[UIImage imageNamed:@"wColorShuDian"] forState:UIControlStateNormal];
        [_rightTopJuBaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightTopJuBaoBtn addTarget:self action:@selector(touchRightJuBaoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTopJuBaoBtn;
}

- (UILabel *)nickNameL{
    if(!_nickNameL){
        _nickNameL = [[UILabel alloc]init];
        _nickNameL.textColor = [UIColor whiteColor];
        _nickNameL.text = @"";
        _nickNameL.font = [UIFont boldSystemFontOfSize:22];
        _nickNameL.textAlignment = NSTextAlignmentCenter;
    }
    return _nickNameL;
}
- (UIView *)baseInfoBkView{//其他信息 小图
    if(!_baseInfoBkView){
        _baseInfoBkView = [[UIView alloc]init];
    }
    return _baseInfoBkView;
}


- (UITextView *)infoTextView{
    if(!_infoTextView){
        _infoTextView = [[UITextView alloc]init];
        _infoTextView.backgroundColor = [UIColor clearColor];
        _infoTextView.text = @"";//简介
        _infoTextView.textColor = podUse_rgba(193, 192, 201, 1);
        _infoTextView.font = [UIFont systemFontOfSize:15.0];
        _infoTextView.userInteractionEnabled = NO;
    }
    return _infoTextView;
}

#pragma mark ===  下部分


- (UIButton *)callATMeBtn{
    if(!_callATMeBtn){
        
        _callATMeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _callATMeBtn.backgroundColor = [UIColor clearColor];
        _callATMeBtn.layer.cornerRadius = 16;
        _callATMeBtn.layer.borderWidth = 1.0;
        _callATMeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_callATMeBtn setTitle:@"@me" forState:UIControlStateNormal];
        [_callATMeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_callATMeBtn addTarget:self action:@selector(callATMeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callATMeBtn;
}

- (UIButton *)siXinBtn{
    if(!_siXinBtn){
        _siXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _siXinBtn.backgroundColor = podUse_rgba(102, 208, 209, 1);
        _siXinBtn.layer.cornerRadius = 16;
        _siXinBtn.layer.borderWidth = 0.0;
        _siXinBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_siXinBtn setTitle:voiceRoomLocalize(@"私信") forState:UIControlStateNormal];
        [_siXinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_siXinBtn addTarget:self action:@selector(sixinBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _siXinBtn;
}
- (UIButton *)guanZhuBtn{
    if(!_guanZhuBtn){
        _guanZhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _guanZhuBtn.backgroundColor = podUse_rgba(102, 208, 209, 1);
        _guanZhuBtn.layer.cornerRadius = 16;
        _guanZhuBtn.layer.borderWidth = 0.0;
        _guanZhuBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_guanZhuBtn setTitle:voiceRoomLocalize(@"关注") forState:UIControlStateNormal];
        [_guanZhuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_guanZhuBtn addTarget:self action:@selector(guanZhuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _guanZhuBtn;
}


#pragma mark ===

- (void)layoutSubviews{
    [super layoutSubviews];

//    _bottomBkView.layer.mask = [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(0, 0, Screen_W, Screen_H/2-200) withCornerRadi:CGSizeMake(10, 10) withRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
}


#pragma mark ===
- (void)setsubViews{
 
    
    [_guanzhuAllSubViewMainBkView mas_makeConstraints:^(MASConstraintMaker *make) {//50的透明位置
        make.left.right.bottom.equalTo(_guanzhuAllSubViewMainBkView.superview);
        make.top.equalTo(_guanzhuAllSubViewMainBkView.superview).offset(50);
    }];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(100);
        make.centerX.equalTo(_imgV.superview);
        make.top.equalTo(_guanzhuAllSubViewMainBkView.mas_top).offset(-50);
    }];
    //
    [_bottomBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomBkView.superview);
        make.top.equalTo(_bottomBkView.superview);
    }];
    [_idLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgV.mas_left);
        make.left.equalTo(_idLable.superview).offset(16);
        make.height.offset(20);
        make.centerY.equalTo(_imgV).offset(40);
    }];
    [_rightTopJuBaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(30);
        make.centerY.equalTo(_imgV).offset(40);;
        make.right.equalTo(_rightTopJuBaoBtn.superview).offset(-30);
    }];
    
    //
    [_nickNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_nickNameL.superview).multipliedBy(0.8);
        make.centerX.equalTo(_nickNameL.superview);
        make.height.offset(30);
        make.top.equalTo(_imgV.mas_bottom).offset(16);
    }];
    [_baseInfoBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_baseInfoBkView.superview).multipliedBy(0.7);
        make.centerX.equalTo(_baseInfoBkView.superview);
        make.height.offset(60);
        make.top.equalTo(_nickNameL.mas_bottom).offset(10);
    }];
    [_infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_baseInfoBkView.superview).multipliedBy(0.9);
        make.centerX.equalTo(_baseInfoBkView.superview);
        make.top.equalTo(_baseInfoBkView.mas_bottom).offset(10);
        make.bottom.equalTo(_infoTextView.superview.mas_bottom).offset(-100);//60 36
    }];
    
    //
    [_callATMeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_callATMeBtn.superview).offset(16);
        make.height.offset(36);
        make.width.offset(76);
        //make.centerY.equalTo(_callATMeBtn.superview);
        make.bottom.equalTo(_callATMeBtn.superview).offset(-60);
    }];
    
    [_siXinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_callATMeBtn.mas_right).offset(10);
        make.height.offset(36);
        make.width.offset(76);
        //make.centerY.equalTo(_siXinBtn.superview);
        make.bottom.equalTo(_siXinBtn.superview).offset(-60);

    }];
    
    [_guanZhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_siXinBtn.mas_right).offset(10);
        make.right.equalTo(_guanZhuBtn.superview.mas_right).offset(-16);
        make.height.offset(36);
        //make.centerY.equalTo(_guanZhuBtn.superview);
        make.bottom.equalTo(_guanZhuBtn.superview).offset(-60);

    }];
}

- (void)touchRightJuBaoBtnAction{
    if(_guanZhuPopViewDelegate && [_guanZhuPopViewDelegate respondsToSelector:@selector(touchRightTopJuBaoBtnAction)]){
        [self dismissThePopView];
        [_guanZhuPopViewDelegate touchRightTopJuBaoBtnAction];
    }
}
#pragma mark===
- (void)callATMeBtnAction{
    if(_guanZhuPopViewDelegate && [_guanZhuPopViewDelegate respondsToSelector:@selector(touchAtMe)]){
        [self dismissThePopView];
        [_guanZhuPopViewDelegate touchAtMe];
    }
}
- (void)sixinBtnAction{
    if(_guanZhuPopViewDelegate && [_guanZhuPopViewDelegate respondsToSelector:@selector(touchSiXin)]){
        [self dismissThePopView];
        [_guanZhuPopViewDelegate touchSiXin];
    }
}
- (void)guanZhuBtnAction{
    if(_guanZhuPopViewDelegate && [_guanZhuPopViewDelegate respondsToSelector:@selector(touchGuanZhu)]){
        [self dismissThePopView];
        [_guanZhuPopViewDelegate touchGuanZhu];
    }
}


@end
