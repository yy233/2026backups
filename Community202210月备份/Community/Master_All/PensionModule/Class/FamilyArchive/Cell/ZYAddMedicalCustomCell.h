//
//  ZYAddMedicalCustomCell.h
//  Community
//
//  Created by ZY on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYAddMedicalCustomCellDelegate <NSObject>

- (void)medicalViewEvent;

@end

@interface ZYAddMedicalCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *medicalTypeLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, weak) id<ZYAddMedicalCustomCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
