//
//  MainTableViewConvenienceServiceCell.h
//  Community
//
//  Created by 余莹 on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MainConvenienceSeriveViewDelegate <NSObject>
- (void)convenienceSeriveViewTouchIndex:(NSInteger)index;
@end

@interface MainTableViewConvenienceServiceCell : UITableViewCell
@property (nonatomic,weak) id <MainConvenienceSeriveViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
