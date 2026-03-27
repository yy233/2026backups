//
//  LoginAndRegiestViewSubTopView.h
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegiestViewUseTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginAndRegiestViewSubTopView : UIView

@property (nonatomic,strong) UILabel *maxFontLabel;
@property (nonatomic,strong) UILabel *minFontLabel;
- (void)setThisViewShowType:(LoginAndRegiestVC_Show_Type)type;
@end

NS_ASSUME_NONNULL_END
