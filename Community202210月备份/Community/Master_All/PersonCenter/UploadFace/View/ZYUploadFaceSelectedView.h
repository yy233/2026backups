//
//  ZYUploadFaceSelectedView.h
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYUploadFaceSelectedView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *cameraView;

@property (weak, nonatomic) IBOutlet UIView *albumView;

@end

NS_ASSUME_NONNULL_END
