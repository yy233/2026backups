//
//  ZYFillSignPasswordView.m
//  Community
//
//  Created by ZY on 2021/6/2.
//

#import "ZYFillSignPasswordView.h"

@interface ZYFillSignPasswordView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UIView *pw1View;

@property (weak, nonatomic) IBOutlet UIView *pw2View;

@property (weak, nonatomic) IBOutlet UIView *pw3View;

@property (weak, nonatomic) IBOutlet UIView *pw4View;

@property (weak, nonatomic) IBOutlet UIView *pw5View;

@property (weak, nonatomic) IBOutlet UIView *pw6View;

@property (nonatomic, strong) NSArray *viewArray;

@property (nonatomic, strong) NSString *pwStr;

@end

@implementation ZYFillSignPasswordView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.pwTF];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.placeholderLabel.textColor = [ZYThemeManager shareManager].threeLevelTitleThemeColor_Dc5c9d4;
    self.pw1View.backgroundColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.pw2View.backgroundColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.pw3View.backgroundColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.pw4View.backgroundColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.pw5View.backgroundColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.pw6View.backgroundColor = [ZYThemeManager shareManager].placeholderThemeColor;
    CGSize size = CGSizeMake(220, 50);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
    self.closeButton.hitTestEdgeInsets = UIEdgeInsetsMake(-16, -16, -16, -16);
}

#pragma mark - 懒加载
- (ZYHideMenuFillTextField *)pwTF {
    if (!_pwTF) {
        _pwTF = [[ZYHideMenuFillTextField alloc] init];
        _pwTF.hidden = NO;
        _pwTF.delegate = self;
        _pwTF.backgroundColor = [UIColor clearColor];
        _pwTF.keyboardType = UIKeyboardTypeNumberPad;
        _pwTF.secureTextEntry = YES;
        _pwTF.textColor = [UIColor clearColor];
        _pwTF.tintColor = [UIColor clearColor];
        [_pwTF addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _pwTF;
}

- (NSArray *)viewArray {
    if (!_viewArray) {
        _viewArray = @[self.pw1View, self.pw2View, self.pw3View, self.pw4View, self.pw5View, self.pw6View];
    }
    
    return _viewArray;
}

- (void)textDidChanged:(UITextField *)textField {
    
    if (textField.text.length <= 6){
        NSInteger index = textField.text.length - 1;
        if (self.pwStr.length < textField.text.length) {
            UIView *view = self.viewArray[index];
            view.backgroundColor = Y_RGBA(38, 114, 249, 1);
        }else{
            UIView *view = self.viewArray[index + 1];
            view.backgroundColor = [ZYThemeManager shareManager].placeholderThemeColor;
        }
        if (textField.text.length == 6) {
            if (self.block) {
                self.block(textField.text);
            }
        }
    }else{
        textField.text = [textField.text substringToIndex:6];
    }
    
    self.pwStr = textField.text;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - 处理点击事件
- (void)pwViewTap {
    [self.pwTF becomeFirstResponder];
}

#pragma mark - 清空内容
- (void)clearText {
    
    for (int i = 0; i < self.viewArray.count; i++) {
        UIView *view = self.viewArray[i];
        view.backgroundColor = Y_RGBA(200, 200, 200, 1);
    }
    self.pwTF.text = @"";
    self.pwStr = @"";
    [self reloadInputViews];
}

@end


@implementation ZYHideMenuFillTextField

#pragma mark - 设置TextField 不可复制 粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[UIMenuController sharedMenuController] hideMenu];
    if (action == @selector(copy:)) {
        return NO;
    } else if (action == @selector(selectAll:)) {
        return NO;
    }
    
    return NO;
}

@end

