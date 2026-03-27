//
//  ChatMainVcUseNoLoginShowView.m
//  Socialize
//
//  Created by 余莹 on 2023/7/28.
//

#import "ChatMainVcUseNoLoginShowView.h"

@implementation ChatMainVcUseNoLoginShowView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
        }else{
            self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
        }
        
        [self addSubview:self.showLoginBtn];
        [_showLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.width.equalTo(_showLoginBtn.superview).multipliedBy(0.7);
            make.top.equalTo(_showLoginBtn.superview).offset(150);
            make.centerX.equalTo(_showLoginBtn.superview);
        }];
        Y_NSNotificationCenter_Creat_NameAction(WebView_Theme_Change_NoticeName, changeZhuTi);//changeZhuTi 语言切换通知可用于黑白色主题切换

    }
    return self;
}

- (UIButton *)showLoginBtn{
    if(!_showLoginBtn){
        _showLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showLoginBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:18.0]];
        [_showLoginBtn newAnBtnWithLayerCorNerNum:15.0 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
        [_showLoginBtn newAnBtnWithTextColor:Color_51BlackColor];
        [_showLoginBtn newAnBtnWithBackColor:Color_Socialize_GreenColor];
    }
    [_showLoginBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"Login")];
    return _showLoginBtn;
}
- (void)changeZhuTi{
//    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
//        self.backgroundColor = [UIColor whiteColor];
//    }else{
//        self.backgroundColor = [UIColor blackColor];
//    }
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
    }else{
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
    }
    [_showLoginBtn newAnBtnWithTextStr:Y_LocaleTypeFile_NSLocalString(@"Login")];//更新
}

@end
