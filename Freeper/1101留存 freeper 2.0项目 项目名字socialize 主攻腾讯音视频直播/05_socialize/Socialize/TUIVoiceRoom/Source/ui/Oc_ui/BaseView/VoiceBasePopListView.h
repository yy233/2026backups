//
//  VoiceListPopView.h
//  AFNetworking
//
//  Created by 余莹 on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VoiceListPopViewDelegate <NSObject>
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath;
@end


@interface VoiceBasePopListView : UIView
@property (nonatomic,strong) UIView *backcontentView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,assign) float tableViewHeight;//
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) id<VoiceListPopViewDelegate>delegate;
- (void)showInView:(UIView *)supview thePopViewTableViewHeight:(float)tableViewHeight WithArray:(NSMutableArray *)array;
- (void)dismissThePopView;
@end
NS_ASSUME_NONNULL_END
