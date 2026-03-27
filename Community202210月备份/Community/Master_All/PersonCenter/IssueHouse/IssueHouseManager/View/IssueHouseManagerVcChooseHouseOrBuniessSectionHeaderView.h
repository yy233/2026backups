//
//  IssueHouseManagerVcChooseHouseOrBuniessSectionView.h
//  Community
//
//  Created by 余莹 on 2021/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderViewDelegate <NSObject>

- (void)chooseHouseOrBuniessSectionHeaderViewWithIsShowBuniessListBool:(BOOL)isShowBuniessListBool; 

@end

@interface IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView : UIView
@property (nonatomic,strong) UIButton *buniessBtn;
@property (nonatomic,strong) UIButton *houseBtn;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,weak) id <IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderViewDelegate>  delegate;
 
@end

NS_ASSUME_NONNULL_END
