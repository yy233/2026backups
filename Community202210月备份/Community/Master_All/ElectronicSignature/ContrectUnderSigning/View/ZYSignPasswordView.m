//
//  ZYSignPasswordView.m
//  Community
//
//  Created by ZY on 2021/5/31.
//

#import "ZYSignPasswordView.h"

@interface ZYSignPasswordView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UIView *view5;

@property (weak, nonatomic) IBOutlet UIView *view6;

@property (weak, nonatomic) IBOutlet UIView *pw1View;

@property (weak, nonatomic) IBOutlet UIView *pw2View;

@property (weak, nonatomic) IBOutlet UIView *pw3View;

@property (weak, nonatomic) IBOutlet UIView *pw4View;

@property (weak, nonatomic) IBOutlet UIView *pw5View;

@property (weak, nonatomic) IBOutlet UIView *pw6View;

@property (nonatomic, strong) NSArray *viewArray;

@property (nonatomic, strong) NSString *pwStr;

@end

@implementation ZYSignPasswordView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.pwTF];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        self.view1.backgroundColor = Y_RGBA(238, 238, 238, 1);
        self.view2.backgroundColor = Y_RGBA(238, 238, 238, 1);
        self.view3.backgroundColor = Y_RGBA(238, 238, 238, 1);
        self.view4.backgroundColor = Y_RGBA(238, 238, 238, 1);
        self.view5.backgroundColor = Y_RGBA(238, 238, 238, 1);
        self.view6.backgroundColor = Y_RGBA(238, 238, 238, 1);
    }else {
        self.view1.backgroundColor = Y_RGBA(62, 81, 119, 1);
        self.view2.backgroundColor = Y_RGBA(62, 81, 119, 1);
        self.view3.backgroundColor = Y_RGBA(62, 81, 119, 1);
        self.view4.backgroundColor = Y_RGBA(62, 81, 119, 1);
        self.view5.backgroundColor = Y_RGBA(62, 81, 119, 1);
        self.view6.backgroundColor = Y_RGBA(62, 81, 119, 1);
    }
    self.pw1View.backgroundColor = [ZYThemeManager shareManager].titleThemeColor;
    self.pw2View.backgroundColor = [ZYThemeManager shareManager].titleThemeColor;
    self.pw3View.backgroundColor = [ZYThemeManager shareManager].titleThemeColor;
    self.pw4View.backgroundColor = [ZYThemeManager shareManager].titleThemeColor;
    self.pw5View.backgroundColor = [ZYThemeManager shareManager].titleThemeColor;
    self.pw6View.backgroundColor = [ZYThemeManager shareManager].titleThemeColor;
    CGSize size = CGSizeMake(kScreenW - 32, 44);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pwViewTap)]];
}

#pragma mark - 懒加载
- (ZYHideMenuTextField *)pwTF {
    if (!_pwTF) {
        _pwTF = [[ZYHideMenuTextField alloc] init];
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
            view.hidden = NO;
        }else{
            UIView *view = self.viewArray[index + 1];
            view.hidden = YES;
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
        view.hidden = YES;
    }
    self.pwTF.text = @"";
    self.pwStr = @"";
    [self reloadInputViews];
}

@end


@implementation ZYHideMenuTextField

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
