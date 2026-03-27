//
//  FeedBackCellSubCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "FeedBackCellSubCollectionViewCell.h"

@implementation FeedBackCellSubCollectionViewCell
#pragma mark == 父类重写清空
- (void)showCenterAddBtnWithBool:(BOOL)isShow{
}
- (void)hiddenAllSubViewWithBool:(BOOL)showAllOrHiddenAll{
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editBtn.hidden = YES;
        //
        self.centerBtn.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
        self.centerBtn.layer.cornerRadius = 5;
        self.centerBtn.layer.masksToBounds = YES;
        self.centerBtn.hidden = NO;
        [self.centerBtn setTitle:@"上传图片" forState:UIControlStateNormal];
        [self.centerBtn setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
        [self.centerBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self.centerBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:8];
    }
    return self;
}
#pragma mark ==
- (void)isAddUIShow{
    self.objBackView.hidden = YES;
    self.centerBtn.hidden = NO;
}
- (void)isObjImgUIShow{
    self.objBackView.hidden = NO;
    self.centerBtn.hidden = YES;
}
- (void)isMaxNumWillHiddendAllSubV{
    self.objBackView.hidden = YES;
    self.centerBtn.hidden = YES;
}
@end
