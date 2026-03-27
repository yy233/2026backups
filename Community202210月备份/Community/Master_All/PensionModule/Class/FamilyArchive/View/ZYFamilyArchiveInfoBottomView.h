//
//  ZYFamilyArchiveInfoBottomView.h
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYFamilyArchiveInfoBottomViewDelegate <NSObject>

- (void)saveButtonEvent;

- (void)deleteButtonEvent;

@end

@interface ZYFamilyArchiveInfoBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, weak) id<ZYFamilyArchiveInfoBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
