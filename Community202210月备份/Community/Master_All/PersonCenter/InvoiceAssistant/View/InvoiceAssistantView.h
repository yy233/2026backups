//
//  InvoiceAssistantView.h
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InvoiceAssistantViewDelegate <NSObject>

@optional - (void)addBtnClicked;

@optional - (void)cellCliced;

@end

@interface InvoiceAssistantView : UIView



@property (nonatomic, weak) id<InvoiceAssistantViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
