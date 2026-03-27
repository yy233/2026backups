//
//  ImMainConversationListVc_Minimalist.h
//  Socialize
//
//  Created by 余莹 on 2023/5/14.
// 主回话list



#import "TUIConversationListController_Minimalist.h" //会话列表  复制 TUIConversationListController_Minimalist
#import "ImMainListTableViewCell_Minimalist.h"   //cell
#import "ImMainSearchBar_Minialist.h"            //searchTopV



#import <UIKit/UIKit.h>
#import "TUIConversationListDataProvider_Minimalist.h"
#import "TUIConversationMultiChooseView_Minimalist.h"
#import "TUIConversationListControllerListener.h"
#import "TUIConversationCell.h"
#import "TUIDefine.h"

NS_ASSUME_NONNULL_BEGIN
@interface ImMainListTableViewCell_AddSystemGroup : UITableViewCell

@end
//
@interface ImMainListTableViewCell_GroupApplicationUseCell : ImMainListTableViewCell_AddSystemGroup

@end
//



@interface ImMainConversationListVc_Minimalist  : Y_BaseViewController

@property (nonatomic, strong) UIButton *searchTopBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TUIConversationMultiChooseView_Minimalist *multiChooseView;

@property (nonatomic, weak) id<TUIConversationListControllerListener> delegate;

@property (nonatomic, strong) TUIConversationListBaseDataProvider *dataProvider;

/**
 *  是否展示搜索框，如果集成了 TUICalling 组件，默认会展示
 *  An identifier that identifies whether to display the search box, If the TUICalling component is integrated, it will be displayed by default
 */
@property (nonatomic) BOOL isEnableSearch;

@property (nonatomic,copy) void(^dataSourceChanged)(NSInteger count);

- (void)openMultiChooseBoard:(BOOL)open;

- (void)enableMultiSelectedMode:(BOOL)enable;

- (NSArray<TUIConversationCellData *> *)getMultiSelectedResult;

- (void)startConversation:(V2TIMConversationType)type;


@end

NS_ASSUME_NONNULL_END
