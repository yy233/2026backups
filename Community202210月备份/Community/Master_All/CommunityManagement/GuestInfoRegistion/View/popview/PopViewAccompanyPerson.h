//
//  PopViewAccompanyPerson.h
//  Community
//  随行人员
//  Created by 余莹 on 2020/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PopViewAccompanyPersonDelegate <NSObject>
- (void)personAddNewInfoWithGuestInfoModel:(GuestInfoModel *)model;
- (void)personRemoveOldGuestInfoModel:(GuestInfoModel *)model addNewInfoModel:(GuestInfoModel *)newModel;
@end
@interface PopViewAccompanyPerson : BasePopView
@property (nonatomic,weak) id <PopViewAccompanyPersonDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
