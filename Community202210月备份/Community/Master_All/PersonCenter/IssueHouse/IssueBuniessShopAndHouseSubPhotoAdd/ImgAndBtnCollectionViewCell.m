//
//  ImgAndBtnCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/20.
//

#import "ImgAndBtnCollectionViewCell.h"

@implementation ImgAndBtnCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.objBackView];
        [self.objBackView addSubview:self.imgView];
        [self.objBackView addSubview:self.deletBtn];
        [self.objBackView addSubview:self.editBtn];
        [self.contentView addSubview:self.centerBtn];
        [self setUI];
    }
    return self;
}

#pragma mark ==
- (void)showCenterAddBtnWithBool:(BOOL)isShow{
    if (isShow) {
        self.objBackView.hidden = YES;
        self.centerBtn.hidden = NO;
    }else{
        self.objBackView.hidden = NO;
        self.centerBtn.hidden = YES;
    }
}
- (void)hiddenAllSubViewWithBool:(BOOL)showAllOrHiddenAll{
    self.objBackView.hidden = YES;
    self.centerBtn.hidden = YES;
}
#pragma mark ==

- (void)setUI{
    [_objBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_objBackView.superview);
    }];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imgView.superview);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_centerBtn.superview);
    }];
    //
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_deletBtn.superview.mas_top);
        make.right.equalTo(_deletBtn.superview.mas_right);
        make.height.offset(20);
        make.width.offset(20);
    }];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_editBtn.superview.mas_bottom);
        make.right.equalTo(_editBtn.superview.mas_right);
        make.left.equalTo(_editBtn.superview.mas_left);
        make.height.offset(20);
    }];
}

#pragma mark ==
- (UIView *)objBackView{
    if (!_objBackView) {
        _objBackView = [[UIView alloc]init];
        _objBackView.layer.masksToBounds = YES;
    }
    return _objBackView;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent: 0.3];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}
- (UIButton *)centerBtn{//addbtn
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn setTitle:@"添加图片" forState:UIControlStateNormal];
        _centerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_centerBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        [_centerBtn setImage:[UIImage imageNamed:@"Uploadpictures_addto"] forState:UIControlStateNormal];
        [_centerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        _centerBtn.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent: 0.3];
    }
    return _centerBtn;
}
//
- (UIButton *)deletBtn{
    if (!_deletBtn) {
        _deletBtn =[UIButton buttonWithType:UIButtonTypeCustom];
         [_deletBtn setImage:[UIImage imageNamed:@"Upload_Picture_delete"] forState:UIControlStateNormal];
    }
    return _deletBtn;
 }
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
     }
    return _editBtn;
}
@end
