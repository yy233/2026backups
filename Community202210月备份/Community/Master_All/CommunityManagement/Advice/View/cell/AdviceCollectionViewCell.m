//
//  AdviceCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import "AdviceCollectionViewCell.h"

@implementation AdviceCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imgView];
        [self setUI];
    }
    return self;
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _imgView.image = nil;
}

- (void)setUI{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imgView.superview);
    }];
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.layer.cornerRadius = 5;
        _imgView.layer.masksToBounds = YES;
        _imgView.userInteractionEnabled = NO;
    }
    return _imgView;
}
@end
