//
//  IssueBaseTextViewTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol IssueBaseTextViewTableViewCellDelegate <NSObject>
- (void)cellTextViewTag:(NSInteger)tag withTextViewStr:(NSString *)textViewStr;
@end

@interface IssueBaseTextViewTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titelL;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UILabel *placeHolderLabel;

@property (nonatomic,weak) id <IssueBaseTextViewTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
