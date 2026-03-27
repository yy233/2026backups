//
//  ZYAccessRecordMemberPopView.h
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYAccessRecordMemberPopViewDelegate <NSObject>

- (void)contentViewEventWithIndex:(NSInteger)index;

@end

@interface ZYAccessRecordMemberPopView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)showAccessRecordMemberPopView;

- (void)hiddenAccessRecordMemberPopView;

@property (nonatomic, weak) id<ZYAccessRecordMemberPopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
