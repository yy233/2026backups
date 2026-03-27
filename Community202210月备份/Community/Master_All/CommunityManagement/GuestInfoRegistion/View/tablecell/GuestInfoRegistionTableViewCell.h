//
//  GuestInfoRegistionTableViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import <UIKit/UIKit.h>

#define BeginColor    Y_RGBA(26, 196, 165, 1)
#define EndColor      Y_RGBA(118, 234, 152, 1)
#define EditorBtnBackColor_Temp    Y_ColorWith16FromRGB(0x2672F9)


NS_ASSUME_NONNULL_BEGIN
@protocol GuestInfoRegistionTableViewCellDegelate <NSObject>

- (void)guestInfoListCellRightBtnTouch:(GuestInfoModel *)model;

@end
@interface GuestInfoRegistionTableViewCell : UITableViewCell

@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UIImageView *headImgV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailtitleLabel;
@property (nonatomic,strong) UILabel *titleContentLabel;
@property (nonatomic,strong) UILabel *detailContentLabel;
//@property (nonatomic,strong) UIButton *editorBtn;
@property (nonatomic,assign) CGSize detailTitleLabelSize;


@property (nonatomic,strong) UIButton *editorBtn;
@property (nonatomic,strong) GuestInfoModel *model;
@property (nonatomic,weak) id<GuestInfoRegistionTableViewCellDegelate>delegate;
@end

NS_ASSUME_NONNULL_END
