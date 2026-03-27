//
//  ZYContrectUnderSigningDetailEditBottomView.h
//  Community
//
//  Created by ZY on 2021/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYContrectUnderSigningDetailEditBottomView : UIView

@property (weak, nonatomic) IBOutlet UIView *dropDownView;

@property (weak, nonatomic) IBOutlet UIImageView *dropDownImageView;

@property (weak, nonatomic) IBOutlet UIView *contractTopView;

@property (weak, nonatomic) IBOutlet UIView *contractContentView;

@property (weak, nonatomic) IBOutlet UILabel *contractContentLabel;

@property (weak, nonatomic) IBOutlet UIView *contractContentLineView;

@property (weak, nonatomic) IBOutlet UIView *signatureSettingView;

@property (weak, nonatomic) IBOutlet UILabel *signatureSettingLabel;

@property (weak, nonatomic) IBOutlet UIView *signatureSettingLineView;

@property (weak, nonatomic) IBOutlet UILabel *attachmentUploadLabel;

@property (weak, nonatomic) IBOutlet UIView *attachmentUploadView;

@property (weak, nonatomic) IBOutlet UIView *attachmentUploadLineView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

NS_ASSUME_NONNULL_END
