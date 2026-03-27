//
//  ZYQcodeView.h
//  Community
//
//  Created by ZY on 2021/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYQcodeView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *uidLabel;

@property (weak, nonatomic) IBOutlet UIImageView *qcodeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *qcodeBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *saveLabel;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@property (weak, nonatomic) IBOutlet UILabel *refreshLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (void)fillUserInfo:(NSMutableDictionary *)userInfoDic;

@end

NS_ASSUME_NONNULL_END
