//
//  DapsView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import "DapsView.h"

@implementation DapsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.centerTopImgView];
        [self addSubview:self.centerBottomTitle];
        [self addSubview:self.dapAllCellBtn];
        [_centerBottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_centerBottomTitle.superview);
            make.width.equalTo(_centerBottomTitle.superview).offset(-10);
            make.height.offset(36);
            make.bottom.equalTo(_centerBottomTitle.superview);
        }];
        [_centerTopImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_centerBottomTitle.mas_top);
            make.width.centerX.equalTo(_centerBottomTitle);
            make.top.equalTo(_centerTopImgView.superview).offset(10);
        }];
        
        _dapAllCellBtn.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [_dapAllCellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_dapAllCellBtn.superview).insets(UIEdgeInsetsMake(2, 2, 2, 2));
        }];
    }
    return self;
}
- (UILabel *)centerBottomTitle{
    if(!_centerBottomTitle){
        _centerBottomTitle = [[UILabel alloc]init];
        _centerBottomTitle.textColor = rgba(51, 51, 51, 1);
        _centerBottomTitle.font = [UIFont systemFontOfSize:14.0];
        _centerBottomTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _centerBottomTitle;
}

- (UIImageView *)centerTopImgView{
    if(!_centerTopImgView){
        _centerTopImgView = [[UIImageView alloc]init];
        _centerTopImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerTopImgView;
}
- (UIButton *)dapAllCellBtn{
    if(!_dapAllCellBtn){
        _dapAllCellBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _dapAllCellBtn.userInteractionEnabled = YES;
        [_dapAllCellBtn addTarget:self action:@selector(dapBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _dapAllCellBtn;
}

 
- (void)dapBtnAction:(UIButton *)sender{
    if(_delegate && [_delegate respondsToSelector:@selector(touchDapsItem:)]){
        [_delegate touchDapsItem:sender];
    }
}
@end
