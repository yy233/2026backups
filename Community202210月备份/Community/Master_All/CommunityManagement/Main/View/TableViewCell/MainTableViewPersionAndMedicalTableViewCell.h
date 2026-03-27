//
//  MainTableViewPersionAndMedicalTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MainTableViewPersionAndMedicalTableViewCellDelegate <NSObject>
- (void)goPersionAction;
- (void)goMedicalAction;
@end
@interface MainTableViewPersionAndMedicalTableViewCell : UITableViewCell
@property (nonatomic,weak) id <MainTableViewPersionAndMedicalTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
