//
//  VoiceTopViewSubCollectionViewCell.m
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/6/12.
//

#import "VoiceTopViewSubCollectionViewCell.h"
#import <Masonry/Masonry.h>
@implementation VoiceTopViewSubCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.onlyShowImgView];
        [_onlyShowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_onlyShowImgView.superview);
        }];
    }
    return self;
}
 

- (UIImageView *)onlyShowImgView{
    if(!_onlyShowImgView){
        _onlyShowImgView = [[UIImageView alloc]init];
        _onlyShowImgView.contentMode = UIViewContentModeScaleAspectFill;
        _onlyShowImgView.layer.cornerRadius = 16.0;
        _onlyShowImgView.layer.masksToBounds = YES;
        _onlyShowImgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    }
    return _onlyShowImgView;
}

@end
