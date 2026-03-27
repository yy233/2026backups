//
//  GroupOfQRvc.h
//  Socialize
//
//  Created by 余莹 on 2023/8/18.
//
//群二维码
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupOfQRvc : Y_BaseViewController
//
@property (nonatomic,strong) NSString *groupShowName;
@property (nonatomic,strong) NSString *groupID;
@property (nonatomic,strong) UIImage *groupimg;

//
@property (nonatomic,strong) UIImageView *bkImg;
@property (nonatomic,strong) UIView *centBkView;
@property (nonatomic,strong) UIImageView *centQrImgV;
@property (nonatomic,strong) UIImageView *groupFaceImgV;
@property (nonatomic,strong) UILabel *gorupLabel;
@property (nonatomic,strong) UIView *btnBkV;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIButton *shareBtn;

@end

NS_ASSUME_NONNULL_END
