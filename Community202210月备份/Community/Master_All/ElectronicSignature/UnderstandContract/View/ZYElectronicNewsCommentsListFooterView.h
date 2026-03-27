//
//  ZYElectronicNewsCommentsListFooterView.h
//  Community
//
//  Created by ZY on 2021/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYElectronicNewsCommentsListFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

NS_ASSUME_NONNULL_END
