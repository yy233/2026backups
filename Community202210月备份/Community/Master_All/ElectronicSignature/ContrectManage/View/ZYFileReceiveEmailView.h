//
//  ZYFileReceiveEmailView.h
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYFileReceiveEmailView : UIView

@property (weak, nonatomic) IBOutlet UIView *TFView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

NS_ASSUME_NONNULL_END
