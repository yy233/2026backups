//
//  PopViewAddressBookDetaillPhoneList.h
//  Community
//
//  Created by 余莹 on 2020/12/19.
// 部门的通讯录列表

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopViewAddressBookDetaillPhoneList : BasePopTableView
@property (nonatomic,strong) NSString *headertitleStr;
- (void)showInView:(UIView *)supview thePopViewTableViewHeight:(float)tableViewHeight WithArray:(NSMutableArray *)array withHeaderViewTitle:(NSString *)titleStr;

@end

NS_ASSUME_NONNULL_END
