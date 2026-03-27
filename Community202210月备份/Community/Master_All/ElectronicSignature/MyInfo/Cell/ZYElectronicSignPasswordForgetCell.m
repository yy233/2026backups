//
//  ZYElectronicSignPasswordForgetCell.m
//  Community
//
//  Created by ZY on 2021/7/7.
//

#import "ZYElectronicSignPasswordForgetCell.h"

@interface ZYElectronicSignPasswordForgetCell ()

@property (weak, nonatomic) IBOutlet UIView *line1View;

@property (weak, nonatomic) IBOutlet UIView *line2View;

@property (weak, nonatomic) IBOutlet UIView *line3View;

@end

@implementation ZYElectronicSignPasswordForgetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.pwTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarP = class_getInstanceVariable([self.pwTF class], "_placeholderLabel");
    id placeholderLabelP = object_getIvar(self.pwTF, ivarP);
    [placeholderLabelP performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    UIButton *pwTFClearButton = [self.pwTF valueForKey:@"_clearButton"];
    [pwTFClearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    
    self.verifyPWTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarV = class_getInstanceVariable([self.verifyPWTF class], "_placeholderLabel");
    id placeholderLabelV = object_getIvar(self.verifyPWTF, ivarV);
    [placeholderLabelV performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    UIButton *verifyPWTFClearButton = [self.verifyPWTF valueForKey:@"_clearButton"];
    [verifyPWTFClearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    
    self.codeTF.textColor = [ZYThemeManager shareManager].titleThemeColor;
    Ivar ivarC = class_getInstanceVariable([self.codeTF class], "_placeholderLabel");
    id placeholderLabelC = object_getIvar(self.codeTF, ivarC);
    [placeholderLabelC performSelector:@selector(setTextColor:) withObject:[ZYThemeManager shareManager].placeholderThemeColor];
    UIButton *codeTFClearButton = [self.codeTF valueForKey:@"_clearButton"];
    [codeTFClearButton setImage:[UIImage imageNamed:@"ic_clear"] forState:UIControlStateNormal];
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.line1View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line2View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.line3View.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    CGSize size = CGSizeMake(kScreenW - 60, 50);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 验证码倒计时
- (void)countdown {
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeButton setTitleColor:Y_RGBA(38, 130, 255, 1) forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.codeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
