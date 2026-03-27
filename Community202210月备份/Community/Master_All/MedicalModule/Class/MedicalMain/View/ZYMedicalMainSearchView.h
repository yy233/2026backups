//
//  ZYMedicalMainSearchView.h
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMedicalMainSearchViewDelegate <NSObject>

- (void)backButtonEvent;

- (void)searchContentViewEvent;

@end

@interface ZYMedicalMainSearchView : UIView

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic, weak) id<ZYMedicalMainSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
