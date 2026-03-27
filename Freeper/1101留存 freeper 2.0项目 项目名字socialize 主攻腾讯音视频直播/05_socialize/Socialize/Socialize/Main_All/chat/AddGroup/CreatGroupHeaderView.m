//
//  CreatGroupHeaderView.m
//  Socialize
//
//  Created by 余莹 on 2023/8/18.
//

#import "CreatGroupHeaderView.h"
#define  base_H  (60)
@implementation CreatGroupHeaderView

 
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, base_H*4);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleBk];
        [self addSubview:self.titleBottomL];
        [self addSubview:self.chooseVerifTypeBk];
        [self addSubview:self.verifBottomL];
        [self.titleBk addSubview:self.textFied];
        [self.chooseVerifTypeBk addSubview:self.verifmainL];
        [self.chooseVerifTypeBk addSubview:self.verSwitch];
        [self setUIs];
    }
    return self;
}
- (void)setUIs{
    [_titleBk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_titleBk.superview);
        make.height.offset(base_H);
    }];
    [_titleBottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleBk.mas_bottom);
        make.left.equalTo(_titleBottomL.superview).offset(10);
        make.right.equalTo(_titleBottomL.superview);
        make.height.offset(base_H);
    }];
    [_chooseVerifTypeBk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleBottomL.mas_bottom);
        make.left.right.equalTo(_chooseVerifTypeBk.superview);
        make.height.offset(base_H);
    }];
    [_verifBottomL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chooseVerifTypeBk.mas_bottom);
        make.left.equalTo(_verifBottomL.superview).offset(10);
        make.right.equalTo(_verifBottomL.superview);
        make.height.offset(base_H);
    }];
    //
    [_textFied mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.height.equalTo(_textFied.superview);
        make.width.equalTo(_textFied.superview).offset(-40);
    }];
    [_verSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_verSwitch.superview);
        make.right.equalTo(_verSwitch.superview.mas_right).offset(-20);
    }];
    [_verifmainL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_verifmainL.superview);
        make.left.equalTo(_verifmainL.superview).offset(20);
        make.right.equalTo(_verSwitch.mas_left).offset(-10);
    }];
    self.verSwitch.on = YES;
    [self initcolors];
    [self initTitles];
}

#define  kTheme_Type_Key   @"Theme_Type"
- (void)initcolors{
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type
    if([nowThemeStr isEqualToString: @"light"]){
        self.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
        _titleBottomL.backgroundColor = self.backgroundColor;
        _verifBottomL.backgroundColor = self.backgroundColor;
        //
        _titleBk.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#f9f9f9"];
        _chooseVerifTypeBk.backgroundColor = _titleBk.backgroundColor;
        //
        _textFied.textColor = [Y_ToolOfOthers getColorWithHexString:@"#515151"];
        _textFied.tintColor = _textFied.textColor;
        _titleBottomL.textColor =  [_textFied.textColor colorWithAlphaComponent:0.7];
        //
        _verifmainL.textColor = _textFied.textColor;
        _verifBottomL.textColor =   _titleBottomL.textColor;
        
    }else{
        self.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#000000"];
        _titleBottomL.backgroundColor = self.backgroundColor;
        _verifBottomL.backgroundColor = self.backgroundColor;
        //
        _titleBk.backgroundColor = [Y_ToolOfOthers getColorWithHexString:@"#333333"];
        _chooseVerifTypeBk.backgroundColor = _titleBk.backgroundColor;
        //
        _textFied.textColor = [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"];
        _textFied.tintColor = _textFied.textColor;
        _titleBottomL.textColor =  [_textFied.textColor colorWithAlphaComponent:0.7];
        //
        _verifmainL.textColor = _textFied.textColor;
        _verifBottomL.textColor =   _titleBottomL.textColor;
        
    }
    _verSwitch.onTintColor = Color_Socialize_GreenColor;
}

- (void)initTitles{
    NSString*titlePS = Y_LocaleTypeFile_NSLocalString(@"请输入群名称");
    NSString*titleBottomS = Y_LocaleTypeFile_NSLocalString(@"请输入群名称(1-12字符)");
    NSString*vMS = Y_LocaleTypeFile_NSLocalString(@"进群验证");
    NSString *vBottomS = Y_LocaleTypeFile_NSLocalString(@"开启后，需要群主审核进群");
    
    //
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:titlePS attributes:@{NSForegroundColorAttributeName: [_textFied.textColor colorWithAlphaComponent:0.7]}];
    _textFied.attributedPlaceholder = placeholderString;
    //
    self.titleBottomL.text = titleBottomS;
    self.verifmainL.text = vMS;
    self.verifBottomL.text = vBottomS;
    
}

#pragma mark ==
- (UIView *)titleBk{
    if(!_titleBk){
        _titleBk = [[UIView alloc]init];
    }
    return _titleBk;
}
- (UIView *)chooseVerifTypeBk{
    if(!_chooseVerifTypeBk){
        _chooseVerifTypeBk = [[UIView alloc]init];
    }
    return _chooseVerifTypeBk;
}
- (UILabel *)titleBottomL{
    if(!_titleBottomL){
        _titleBottomL = [[UILabel alloc]init];
        _titleBottomL.font = [UIFont systemFontOfSize:14.0];
        _titleBottomL.numberOfLines = 2;
    }
    return _titleBottomL;
}
- (UILabel *)verifBottomL{
    if(!_verifBottomL){
        _verifBottomL = [[UILabel alloc]init];
        _verifBottomL.font = [UIFont systemFontOfSize:14.0];
        _verifBottomL.numberOfLines = 2;
    }
    return _verifBottomL;
}
//

- (UITextField *)textFied{
    if(!_textFied){
        _textFied = [[UITextField alloc]init];
    }
    return _textFied;
}
- (UISwitch *)verSwitch{
    if(!_verSwitch){
        _verSwitch = [[UISwitch alloc]init];
    }
    return _verSwitch;
}
- (UILabel *)verifmainL{
    if(!_verifmainL){
        _verifmainL = [[UILabel alloc]init];
        _verifmainL.font = [UIFont systemFontOfSize:15.0];
        _verifmainL.numberOfLines = 2;
    }
    return _verifmainL;
}

@end
