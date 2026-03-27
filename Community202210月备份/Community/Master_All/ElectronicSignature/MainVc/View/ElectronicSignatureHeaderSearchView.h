//
//  ElectronicSignatureHeaderSearchView.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  ElectronicSignatureHeaderSearchViewDelegate <NSObject>
- (void)touchSacnBtnAction;
- (void)touchUpItemWithIndex:(NSInteger)index;
@end

@interface ElectronicSignatureHeaderSearchView : UIView
- (void)showViewWithDataTitleArr:(NSMutableArray *)titleArr
              withDetailTitleArr:(NSMutableArray *)detailTitleArr
                      withImgArr:(NSMutableArray *)imgNameArr;
@property (nonatomic,weak) id <ElectronicSignatureHeaderSearchViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
