//
//  ZYLifeCostHelpCenterSearchView.h
//  Community
//
//  Created by ZY on 2022/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYLifeCostHelpCenterSearchViewDelegate <NSObject>

- (void)searchButtonEvent;

@end

@interface ZYLifeCostHelpCenterSearchView : UIView

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic, weak) id<ZYLifeCostHelpCenterSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
