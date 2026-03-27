//
//  BasePopTableView.h
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BasePopTableViewChooseDelegate <NSObject>
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface BasePopTableView : UIView
@property (nonatomic,strong) UIView *backcontentView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,assign) float tableViewHeight;//
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) id<BasePopTableViewChooseDelegate>delegate;
- (void)showInView:(UIView *)supview thePopViewTableViewHeight:(float)tableViewHeight WithArray:(NSMutableArray *)array;
- (void)dismissThePopView;
@end

NS_ASSUME_NONNULL_END
