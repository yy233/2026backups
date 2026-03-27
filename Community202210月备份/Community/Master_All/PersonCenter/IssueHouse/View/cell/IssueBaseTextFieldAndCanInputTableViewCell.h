//
//  IssueBaseTextFieldAndCanInputTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IssueBaseTextFieldAndCanInputTableViewCellDelegate <NSObject>
- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)str;
@end

@interface IssueBaseTextFieldAndCanInputTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITextField *textField;
//
@property (nonatomic,weak) id <IssueBaseTextFieldAndCanInputTableViewCellDelegate> delegale;
@end

NS_ASSUME_NONNULL_END
