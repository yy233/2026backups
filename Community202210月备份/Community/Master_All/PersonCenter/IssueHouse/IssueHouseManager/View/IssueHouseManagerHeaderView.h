//
//  IssueHouseManagerHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol IssueHouseManagerHeaderViewDelegate <NSObject>
- (void)changeManagerVcMyType:(IssueHouseManagerVC_MyType)type;
@end

@interface IssueHouseManagerHeaderView : UIView
@property (nonatomic,strong) UIImageView *headerImgV;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *phoneL;
@property (nonatomic,strong) UIButton *changeBtn;
@property (nonatomic,weak) id <IssueHouseManagerHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
