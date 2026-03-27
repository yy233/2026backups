//
//  ZYVisitorInviteEditCell.h
//  Community
//
//  Created by ZY on 2022/5/20.
//

#import <UIKit/UIKit.h>
#import "ZYVisitorInviteUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYVisitorInviteEditCellDelegate <NSObject>

- (void)addressViewEvent;

- (void)reasonViewEvent;

- (void)dateViewEvent;

@end

@interface ZYVisitorInviteEditCell : UITableViewCell

@property (nonatomic, strong) ZYVisitorInviteUploadModel *model;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *telTF;

@property (weak, nonatomic) IBOutlet UIView *addressContentView;

@property (weak, nonatomic) IBOutlet UIView *reasonContentView;

@property (nonatomic, weak) id<ZYVisitorInviteEditCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
