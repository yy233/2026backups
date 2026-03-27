//
//  ZYComplaintsOpinionCell.h
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYComplaintsOpinionCell : UITableViewCell

@property (nonatomic, strong) UITextView *textView;

@property (weak, nonatomic) IBOutlet UITextField *telTF;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

NS_ASSUME_NONNULL_END
