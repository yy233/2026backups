//
//  ZYContactPeopleTopCell.h
//  Community
//
//  Created by ZY on 2021/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYContactPeopleTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIView *friendsView;

@property (weak, nonatomic) IBOutlet UIView *contactView;

@property (weak, nonatomic) IBOutlet UIView *nfriendView;

@property (weak, nonatomic) IBOutlet UIView *groupManagerView;

@property (weak, nonatomic) IBOutlet UIView *labelView;

@end

NS_ASSUME_NONNULL_END
