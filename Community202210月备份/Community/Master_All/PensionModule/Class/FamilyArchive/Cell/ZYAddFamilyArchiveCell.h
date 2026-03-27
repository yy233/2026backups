//
//  ZYAddFamilyArchiveCell.h
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYAddFamilyArchiveCellDelegate <NSObject>

- (void)codeButtonEvent;

- (void)addButtonEvent;

@end

@interface ZYAddFamilyArchiveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *telTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (nonatomic, weak) id<ZYAddFamilyArchiveCellDelegate> delegate;

// 验证码倒计时
- (void)countdown;

@end

NS_ASSUME_NONNULL_END
