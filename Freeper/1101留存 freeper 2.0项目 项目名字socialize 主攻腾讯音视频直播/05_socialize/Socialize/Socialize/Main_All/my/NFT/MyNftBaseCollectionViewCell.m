//
//  MyNftBaseCollectionViewCell.m
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import "MyNftBaseCollectionViewCell.h"

@implementation MyNftBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.imgView];
        [self.backView addSubview:self.titL];
        [self.backView addSubview:self.typeBkView];
        [self setSubvs];
    }
    return self;
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _titL.text = nil;
}

- (void)setSubvs{
   
    _backView.layer.cornerRadius = 6;
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_typeBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_typeBkView.superview);
        make.height.offset(35);
     }];
    [_titL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titL.superview);
        make.bottom.equalTo(_typeBkView.mas_top);
        make.height.offset(20);
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_imgView.superview);
        make.height.equalTo(_imgView.superview).offset(-60);
    }];
 
}
#pragma mark ==

- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UIImageView *)imgView{
    if(!_imgView){
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    }
    return _imgView;
}
- (UILabel *)titL{
    if(!_titL){
        _titL = [[UILabel alloc]init];
        _titL.textAlignment = NSTextAlignmentCenter;
        _titL.font = [UIFont systemFontOfSize:14.0];
    }
    return _titL;
}
- (UIView *)typeBkView{
    if(!_typeBkView){
        _typeBkView = [[UIView alloc]init];
        _typeBkView.backgroundColor = [UIColor clearColor];
       
    }
    return _typeBkView;
}
@end
