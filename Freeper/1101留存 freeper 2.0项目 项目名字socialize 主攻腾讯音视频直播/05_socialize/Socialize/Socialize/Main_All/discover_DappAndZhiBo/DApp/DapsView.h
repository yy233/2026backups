//
//  DapsView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DapsViewDelegate <NSObject>

- (void)touchDapsItem:(UIButton *)sender;

@end

@interface DapsView : UIView
@property (nonatomic,strong) UIImageView * centerTopImgView;
@property (nonatomic,strong) UILabel * centerBottomTitle;
@property (nonatomic,strong) UIButton * dapAllCellBtn;

@property (nonatomic,weak) id <DapsViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
