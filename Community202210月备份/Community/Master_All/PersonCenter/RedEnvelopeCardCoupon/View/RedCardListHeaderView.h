//
//  RedCardListHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    RedCardListHeaderView_subType_All,
    RedCardListHeaderView_subType_YouhuiQuan,
    RedCardListHeaderView_subType_KaQuan,
} RedCardListHeaderView_subType;

@protocol RedCardListHeaderViewDelegate <NSObject>
- (void)headerViewChangeTypeWith:(RedCardListHeaderView_subType)type;
@end

@interface RedCardListHeaderView : UIView

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel *leftNumL;
@property (nonatomic,strong) UILabel *centerNumL;
@property (nonatomic,strong) UILabel *rightsNumL;
//
- (void)fillData:(NSMutableArray *)dataSourceArr;
@property (nonatomic,weak) id <RedCardListHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
