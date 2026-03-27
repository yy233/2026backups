//
//  UITextField+CleanBtnImg.m
//  Community
//
//  Created by 余莹 on 2020/11/30.
//

#import "UITextField+CleanBtnImg.h"

@implementation UITextField (CleanBtnImg)

//
- (void)cleanBtnImgNameStr:(NSString *)nameStr{
    UIButton *clearBtn = [self valueForKey:@"_clearButton"];
    [clearBtn setImage:[UIImage imageNamed:nameStr] forState:UIControlStateNormal];
}
- (void)loginModuleTextFieldCleanBtnImgChange{
    UIButton *clearBtn = [self valueForKey:@"_clearButton"];
//    [clearBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"textFieldClean"] forState:UIControlStateNormal];
//    [clearBtn setImage:[UIImage imageNamed:@"待定"] forState:UIControlStateNormal];
}
//
- (void)cleanBtnImgNameStr:(NSString *)nameStr textField:(UITextField *)textField {
    UIButton *clearBtn = [textField valueForKey:@"_clearButton"];
    [clearBtn setImage:[UIImage imageNamed:nameStr] forState:UIControlStateNormal];
}

- (void)loginModuleTextFieldCleanBtnImgChange:(UITextField *)textField {
    UIButton *clearBtn = [textField valueForKey:@"_clearButton"];
//    [clearBtn setImage:[ThemeImg loginModuleThemeImageWithBaseName:@"textFieldClean"] forState:UIControlStateNormal];
//    [clearBtn setImage:[UIImage imageNamed:@"待定"] forState:UIControlStateNormal];
}
@end
