//
//  JoinSystemGroupSubPopView.m
//  Socialize
//
//  Created by 余莹 on 2023/7/10.
//

#import "JoinSystemGroupSubPopView.h"

@interface JoinSystemGroupSubPopView ()
@property (nonatomic,assign) NSInteger oneNum;
@property (nonatomic,assign) NSInteger twoNum;

@end

@implementation JoinSystemGroupSubPopView
 
#pragma mark == 重写
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
}
- (void)changMainBackViewBackColor{
    self.subMainBackView.backgroundColor = [UIColor whiteColor]; //Color_238GrayColor;//半截背景颜色配置
}
- (void)initSubMainHeight{
   // self.subMainViewHeight  = Screen_H*0.9;//几乎全屏
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
        [self changeCodeTwoNub];
    }
    return self;
}

- (void)addSubAllView{
    [self.subMainBackView.superview addSubview:self.showUseBackView];
    self.subMainBackView.backgroundColor = [UIColor clearColor];//原本pop主承接页 不使用。
    
    [self.showUseBackView  addSubview:self.titleL];
    [self.showUseBackView  addSubview:self.textF];
    [self.showUseBackView  addSubview:self.showCodeInfoL];
    [self.showUseBackView  addSubview:self.changeCodeBtn];
    [self.showUseBackView  addSubview:self.cancelBtn];
    [self.showUseBackView  addSubview:self.okBtn];

}
- (void)setUI{

    
    [_showUseBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_showUseBackView.superview);
        make.centerY.equalTo(_showUseBackView.superview);
        make.width.equalTo(_showUseBackView.superview).multipliedBy(0.8);
        make.height.offset(180);
    }];
    
    //
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL.superview);
        make.top.equalTo(_titleL.superview).offset(15);
        make.height.offset(40);
    }];
    //
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textF.superview).offset(10);
        make.right.equalTo(_textF.superview).offset(-120);
        make.height.offset(35.0);
        make.top.equalTo(_titleL.mas_bottom).offset(10);
    }];
   
    [_changeCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_changeCodeBtn.superview).offset(-10);
        make.centerY.equalTo(_textF);
        make.height.equalTo(_textF);
        make.width.offset(35.0);
    }];
    
    [_showCodeInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_changeCodeBtn.mas_left);
        make.left.equalTo(_textF.mas_right);
        make.height.centerY.equalTo(_textF);
    }];
    
    //
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cancelBtn.superview).offset(10);
        make.bottom.equalTo(_cancelBtn.superview).offset(-10);
        make.height.offset(40);
        make.width.offset(80);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_okBtn.superview).offset(-10);
        make.bottom.equalTo(_okBtn.superview).offset(-10);
        make.height.offset(40);
        make.width.offset(80);
    }];
}

//
- (UIView *)showUseBackView{
    if(!_showUseBackView){
        _showUseBackView = [[UIView alloc]init];
        _showUseBackView.backgroundColor = [UIColor whiteColor];
        _showUseBackView.layer.cornerRadius = 10.0;
        _showUseBackView.layer.masksToBounds = YES;
    }
    return _showUseBackView;
}

- (UILabel *)titleL{
    if(!_titleL){
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [UIColor blackColor];
        _titleL.font = [UIFont systemFontOfSize:18.0];
        _titleL.text =  Y_LocaleTypeFile_NSLocalString( @"请完成验证" );
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}

- (UITextField *)textF{
    if(!_textF){
        _textF = [[UITextField alloc]init];
        _textF.placeholder =  Y_LocaleTypeFile_NSLocalString(@"请输入正确答案");
      
        _textF.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        _textF.layer.cornerRadius = 16;
        _textF.layer.masksToBounds = YES;
        _textF.textAlignment = NSTextAlignmentCenter;
        _textF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textF;
}
- (UILabel *)showCodeInfoL{
    if(!_showCodeInfoL){
        _showCodeInfoL = [[UILabel alloc]init];
        _showCodeInfoL.textColor = [UIColor blackColor];
        _showCodeInfoL.textAlignment = NSTextAlignmentCenter;
    }
    return _showCodeInfoL;
}

- (UIButton *)changeCodeBtn{
    if(!_changeCodeBtn){
        _changeCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeCodeBtn addTarget:self action:@selector(changeCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_changeCodeBtn setImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
    }
    return _changeCodeBtn;
}


- (UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn addTarget:self action:@selector(dismissThePopView) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:[Color_Socialize_GreenColor colorWithAlphaComponent:0.5]  withFont:[UIFont systemFontOfSize:16.0] withLayerCorNerNum:6.0 withLayerLineWidth:0.0 withLayerLineColor: [UIColor lightGrayColor]];
        [_cancelBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"取消")];
    }
    return _cancelBtn;
}

- (UIButton *)okBtn{
    if(!_okBtn){
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:Color_Socialize_GreenColor  withFont:[UIFont systemFontOfSize:16.0] withLayerCorNerNum:6.0 withLayerLineWidth:0.0 withLayerLineColor: [UIColor lightGrayColor]];
        [_okBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"确定")];
    }
    return _okBtn;
}


- (void)okBtnAction{
    
    if(_textF.text.length <= 0){
        
        NSString *str = Y_LocaleTypeFile_NSLocalString(@"请输入正确答案");
        Y_SVP_SHOW_INFO_MES(str);
        return;
    }
     
    NSInteger sunM = self.oneNum + self.twoNum;
    if([_textF.text integerValue]  == sunM){
        
        
        if(_joinGroupDelegate && [_joinGroupDelegate respondsToSelector:@selector(touchOkOfJoinSystem)]){
            [_joinGroupDelegate touchOkOfJoinSystem];
            [self dismissThePopView];//触发协议后再隐藏
        }
        
    }else{
        NSString *str = Y_LocaleTypeFile_NSLocalString(@"请输入正确答案");
        Y_SVP_SHOW_INFO_MES(str);
        [self changeCodeTwoNub];
    }

}

- (void)changeCodeBtnAction{
    [self changeCodeTwoNub];
}
//更新本地验证码
- (void)changeCodeTwoNub{
    self.oneNum = [Y_ToolOfOthers getRandomInt:1 to:10];
    self.twoNum = [Y_ToolOfOthers getRandomInt:1 to:10];
    self.showCodeInfoL.text = [NSString stringWithFormat:@"%ld+%ld=?",(long)self.oneNum,(long)self.twoNum];
    self.textF.text = @"";//清空
}
@end
