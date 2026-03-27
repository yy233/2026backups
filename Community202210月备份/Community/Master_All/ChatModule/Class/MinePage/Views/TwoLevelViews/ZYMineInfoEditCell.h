//
//  ZYMineInfoEditCell.h
//  Community
//
//  Created by ZY on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMineInfoEditCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;

@end

NS_ASSUME_NONNULL_END
