//
//  TopSearchView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/15.
//

#import "TopSearchView.h"

#define  this_GreenColor rgba(102, 208, 209,1)

@interface TopSearchView () <UITextFieldDelegate>

@end

@implementation TopSearchView
/**
 @property (nonatomic,strong) UIView *bkView;
 @property (nonatomic,strong) UIButton *okBtn;
 @property (nonatomic,strong) UITextField *textField;
 */
//- (instancetype)initWithFrame:(CGRect)frame{
//
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self addSubview:self.searchBar];
//        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(_searchBar.superview);
//        }];
//    }
//    return self;
//}
//
//- (UISearchBar *)searchBar{
//    if(!_searchBar){
//        _searchBar = [[UISearchBar alloc]init];
//        _searchBar.tintColor = [UIColor greenColor];//光标
//
//    }
//
//    return _searchBar;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bkView];
        [self.bkView addSubview:self.leftImgv];
        [self.bkView addSubview:self.textField];
        [self.bkView addSubview:self.okBtn];
        [self setSubvsWithFrame:frame];
        
    }
    return self;
}
-(void)setSubvsWithFrame:(CGRect)frame{
    CGFloat alll_w = frame.size.width;
    CGFloat textF_Bk_H = 34;
    CGFloat textF_Bk_w = alll_w-24;
    

    CGFloat lef_w = 40;
    CGFloat leftImgW = 15;
    CGFloat righ_w = 60;
    CGFloat rightBtnW = 50;
    CGFloat rightBtnH = 28;
    [_bkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_bkView.superview);
        make.width.equalTo(_bkView.superview).offset(-24);
        make.height.offset(textF_Bk_H);
    }];
    [_leftImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftImgv.superview);
        make.left.equalTo(_leftImgv.superview).offset(10);
        make.width.offset(leftImgW);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bkView).insets(UIEdgeInsetsMake(0, lef_w, 0, righ_w));
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_okBtn.superview);
        make.right.equalTo(_okBtn.superview).offset(-3);
        make.width.offset(rightBtnW);
        make.height.offset(rightBtnH);
        
    }];
    
}


- (UIView *)bkView{
    if(!_bkView){
        _bkView = [UIView new];
        _bkView.layer.cornerRadius = 16.0;
        _bkView.layer.borderWidth = 1.0;
        _bkView.layer.borderColor =  this_GreenColor.CGColor;
        _bkView.backgroundColor = [UIColor whiteColor];
    }
    return _bkView;
}
- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        _textField.placeholder = @"searching";
    }
    return _textField;
}
- (UIImageView *)leftImgv{
    if(!_leftImgv){
        _leftImgv = [[UIImageView alloc]init];
        _leftImgv.image = [UIImage imageNamed:@"icon_search"];
        _leftImgv.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImgv;
}
- (UIButton *)okBtn{
    if(!_okBtn){
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn newAnBtnWithBackColor:this_GreenColor];
        [_okBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_okBtn newAnBtnWithFont: [UIFont systemFontOfSize:13.0]];
        _okBtn.layer.cornerRadius = 15.0;
        [_okBtn newAnBtnWithTextStr:@"search"];
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

- (void)okBtnAction{
    if(_delegate && [_delegate respondsToSelector:@selector(touchOkBtn)]){
        [_delegate touchOkBtn];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(_delegate && [_delegate respondsToSelector:@selector(searchTextIsChanged)]){
        [_delegate searchTextIsChanged];
    }
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    
    if(_delegate && [_delegate respondsToSelector:@selector(searchTextIsChanged)]){
        [_delegate searchTextIsChanged];
    }
} 
@end
