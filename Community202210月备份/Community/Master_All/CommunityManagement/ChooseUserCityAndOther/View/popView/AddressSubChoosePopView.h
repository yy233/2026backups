//
//  AddressSubBounceView.h
//  Community
//
//  Created by 余莹 on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AddressChooseVcSubPopViewDelegate <NSObject>
- (void)popViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface AddressSubChoosePopView : UIView
@property (nonatomic,strong) UILabel *tableViewbackViewTopLabel;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) id<AddressChooseVcSubPopViewDelegate>delegate;
- (void)showInView:(UIView *)supview thePopViewWithArray:(NSMutableArray *)array;
- (void)dismissThePopView;
@end

NS_ASSUME_NONNULL_END
