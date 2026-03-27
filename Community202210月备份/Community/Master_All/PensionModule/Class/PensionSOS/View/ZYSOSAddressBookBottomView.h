//
//  ZYSOSAddressBookBottomView.h
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSOSAddressBookBottomViewDelegate <NSObject>

- (void)addContactButtonEvent;

@end

@interface ZYSOSAddressBookBottomView : UIView

@property (nonatomic, weak) id<ZYSOSAddressBookBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
