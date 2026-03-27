//
//  IssueShopBuniessThreeGroupTextInfoShowTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import "IssueShopBuniessThreeGroupTextInfoShowTableViewCell.h"

@interface IssueShopBuniessThreeGroupTextInfoShowTableViewCell () <UITextFieldDelegate>
@property (nonatomic,strong) NSString *nowTextStr;
@end

@implementation IssueShopBuniessThreeGroupTextInfoShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUIOfNewTitles{
    self.oneTopLabel.text = @"面宽";
    self.twoTopLabel.text = @"进深";
    self.thrTopLabel.text = @"层高";
    self.oneBottomLabel.text = @"";
    self.twoBottomLabel.text = @"";
    self.thrBottomLabel.text = @"";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backV addSubview:self.oneTextF];
        [self.backV addSubview:self.twoTextF];
        [self.backV addSubview:self.thrTextF];
        [self setTextFieldUI];
    }
    return self;
}

- (void)setTextFieldUI{
    [_oneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.oneBottomLabel);
    }];
    [_twoTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.twoBottomLabel);
    }];
    [_thrTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.thrBottomLabel);
    }];
}
- (UITextField *)oneTextF{
    if (!_oneTextF) {
        _oneTextF = [[UITextField alloc]init];
        _oneTextF.font = [UIFont boldSystemFontOfSize:18];
        _oneTextF.textColor = [ThemeManager shareManager].mainTextColor;
        _oneTextF.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        _oneTextF.attributedPlaceholder = placeholderString;
        _oneTextF.tag = 301;
        _oneTextF.delegate = self;
    }
    return _oneTextF;
}
- (UITextField *)twoTextF{
    if (!_twoTextF) {
        _twoTextF = [[UITextField alloc]init];
        _twoTextF.font = [UIFont boldSystemFontOfSize:18];
        _twoTextF.textColor = [ThemeManager shareManager].mainTextColor;
        _twoTextF.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        _twoTextF.attributedPlaceholder = placeholderString;
        _twoTextF.tag = 302;
        _twoTextF.delegate = self;
    }
    return _twoTextF;
}
- (UITextField *)thrTextF{
    if (!_thrTextF) {
        _thrTextF = [[UITextField alloc]init];
        _thrTextF.font = [UIFont boldSystemFontOfSize:18];
        _thrTextF.textColor = [ThemeManager shareManager].mainTextColor;
        _thrTextF.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]}];
        _thrTextF.attributedPlaceholder = placeholderString;
        _thrTextF.tag = 303;
        _thrTextF.delegate = self;
    }
    return _thrTextF;
}

#pragma mark ==== textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    switch (textField.tag) {
        case 301:
        {
            self.nowTextStr =   self.oneTextF.text;
        }
            break;
        case 302:
        {
           self.nowTextStr =  self.twoTextF.text;
        }
            break;
        case 303:
        {
            self.nowTextStr = self.thrTextF.text;
        }
            break;
            
        default:
            break;
    }
    BOOL isHaveDian = YES;
    if ([self.nowTextStr rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([self.nowTextStr length]==0){
                if(single == '.'){
                   [self alertView:@"亲，第一个数字不能为小数点"];
                    [self.nowTextStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;

                }
                if (single == '0') {
                    [self alertView:@"亲，第一个数字不能为0"];
                    [self.nowTextStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;

                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [self alertView:@"亲，您已经输入过小数点了"];
                    [self.nowTextStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[self.nowTextStr rangeOfString:@"."];
                    NSUInteger tt=range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        [self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self alertView:@"亲，您输入的格式不正确"];
            [self.nowTextStr stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
    return YES;
}
- (void)alertView:(NSString *)str{
    Y_SVP_SHOW_INFO_MES(str);
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    self.nowTextStr = @"";//多个textf清空
    self.nowTextStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //
    switch (textField.tag) {
        case 301:
        {
            self.oneTextF.text = self.nowTextStr;
        }
            break;
        case 302:
        {
            self.twoTextF.text = self.nowTextStr;
        }
            break;
        case 303:
        {
            self.thrTextF.text = self.nowTextStr;
        }
            break;
            
        default:
            break;
    }
    [self sendInfoTextStr];
}
- (void)sendInfoTextStr{
    if (_delegate && [_delegate respondsToSelector:@selector(shopBuniessTextInfoWithWidth:withDepth:withHeight:)]) {
        [_delegate shopBuniessTextInfoWithWidth:self.oneTextF.text withDepth:self.twoTextF.text withHeight:self.thrTextF.text];
    }
}
@end
