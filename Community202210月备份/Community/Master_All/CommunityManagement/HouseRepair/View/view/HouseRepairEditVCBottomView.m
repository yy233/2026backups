//
//  HouseRepairEditVCBottomView.m
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import "HouseRepairEditVCBottomView.h"
#define Img_W  ((Screen_W-32-20-30)/4)   //10*3=30间隙
#define Img_Btn_Tag 200
@interface HouseRepairEditVCBottomView () <UITextViewDelegate>
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *textviewTopPlaceholdeLabel;
//@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIView *bottomImgBackView;
//@property (nonatomic,strong) UIButton *imgOneBtn;
//@property (nonatomic,strong) UIButton *imgTwoBtn;
//@property (nonatomic,strong) UIButton *imgThrBtn;
//@property (nonatomic,strong) UIButton *chooseImgBtn;
@end

@implementation HouseRepairEditVCBottomView

- (void)setModel:(HouseRepairEditModel *)model{
    _model = model;
    [self initData];
}
- (void)initData{
    
}
#pragma mark ==
- (void)imgBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag-Img_Btn_Tag;
    switch (index)  {
        case 3:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(chooseBtnIsTouchWitllToChoose)]) {
                [_delegate chooseBtnIsTouchWitllToChoose];
            }
        }
            break;
        default:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(changeImgWithTouchImgBtnWithNum:)]) {
                [_delegate changeImgWithTouchImgBtnWithNum:index];
            }
        }
            
            break;
    }
}
 
#pragma mark === textViewDidChange
- (void)textViewDidChange:(UITextView *)textView{
    if (self.textView.text.length<=0) {
        self.textviewTopPlaceholdeLabel.hidden = NO;
    }else{
        self.textviewTopPlaceholdeLabel.hidden = YES;
    }
}

#pragma mark == initWithFrame
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
        [self addSubview:self.titleLabel];
        [self addSubview:self.textView];
        [self.textView addSubview:self.textviewTopPlaceholdeLabel];
        [self addSubview:self.bottomImgBackView];
        [self setUI];
      
    }
    return self;
}
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(5);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(10);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.equalTo(_textView.superview.mas_left).offset(10);
        make.right.equalTo(_textView.superview.mas_right).offset(-10);
        make.height.equalTo(_textView.superview.mas_height).multipliedBy(0.33);//
    }];
    [_textviewTopPlaceholdeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textviewTopPlaceholdeLabel.superview.mas_top).offset(8);
        make.left.equalTo(_textviewTopPlaceholdeLabel.superview.mas_left).offset(10);
        make.right.equalTo(_textviewTopPlaceholdeLabel.superview.mas_right).offset(-10);
        make.height.offset(15);
    }];
    [_bottomImgBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(15);
        make.left.equalTo(_bottomImgBackView.superview.mas_left).offset(10);
        make.right.equalTo(_bottomImgBackView.superview.mas_right).offset(-10);
        make.bottom.equalTo(_bottomImgBackView.superview.mas_bottom).offset(-10);
    }];
    [self addImgSubAndSetHiden];
 
}

- (void)addImgSubAndSetHiden{
    [self addimgSubBtn];
    [self imgShowNum:0];//初始化是隐藏的
}
- (void)addimgSubBtn{
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [self imgBtn];
        btn.tag = (NSInteger)(Img_Btn_Tag+i);
        btn.frame = CGRectMake((Img_W+10)*i, 0, Img_W, Img_W);
        NSLog(@"addimgSubBtn---x--i--%f---%d",btn.frame.origin.x,i);
        switch (i) {
            case 0:
                self.imgOneBtn = btn;
                break;
            case 1:
                self.imgTwoBtn = btn;
                break;
            case 2:
                self.imgThrBtn = btn;
                break;
            case 3:
                self.chooseImgBtn = btn;
                self.chooseImgBtn.backgroundColor = [UIColor clearColor];
                break;
                
            default:
                break;
        }
    }
    [self.chooseImgBtn setImage:[UIImage imageNamed:@"Pictureselection_Icon"] forState:UIControlStateNormal];
    [self.bottomImgBackView addSubview:self.imgOneBtn];
    [self.bottomImgBackView addSubview:self.imgTwoBtn];
    [self.bottomImgBackView addSubview:self.imgThrBtn];
    [self.bottomImgBackView addSubview:self.chooseImgBtn];
}
- (UIButton *)imgBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [btn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)imgShowNum:(NSInteger)num{
    switch (num) {
        case 0:
        {
            self.imgOneBtn.hidden = YES;
            self.imgTwoBtn.hidden = YES;
            self.imgThrBtn.hidden = YES;
        }
            break;
        case 1:
        {
            self.imgOneBtn.hidden = NO;
            self.imgTwoBtn.hidden = YES;
            self.imgThrBtn.hidden = YES;
        }
            break;
        case 2:
        {
            self.imgOneBtn.hidden = NO;
            self.imgTwoBtn.hidden = NO;
            self.imgThrBtn.hidden = YES;
        }
            break;
        case 3:
        {
            self.imgOneBtn.hidden = NO;
            self.imgTwoBtn.hidden = NO;
            self.imgThrBtn.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ==
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
        _titleLabel.text = @"报修内容";
        _titleLabel.font  = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        _textView.textColor = [ThemeManager shareManager].mainTextColor;
        _textView.layer.cornerRadius = 5;
        _textView.delegate = self;
    }
    return _textView;
}
- (UILabel *)textviewTopPlaceholdeLabel {
    if (!_textviewTopPlaceholdeLabel) {
        _textviewTopPlaceholdeLabel = [[UILabel alloc]init];
        _textviewTopPlaceholdeLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _textviewTopPlaceholdeLabel.text = @"请简短描述问题";
        _textviewTopPlaceholdeLabel.font  = [UIFont systemFontOfSize:13];
    }
    return _textviewTopPlaceholdeLabel;
}

- (UIView *)bottomImgBackView{
    if (!_bottomImgBackView) {
        _bottomImgBackView = [[UIView alloc]init];
    }
    return _bottomImgBackView;
}

@end

