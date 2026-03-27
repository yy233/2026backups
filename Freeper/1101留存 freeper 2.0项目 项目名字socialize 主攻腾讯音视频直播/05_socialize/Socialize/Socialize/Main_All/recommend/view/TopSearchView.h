//
//  TopSearchView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TopSearchViewDelegate <NSObject>

- (void)touchOkBtn;
- (void)searchTextIsChanged;

@end

@interface TopSearchView : UIView

//@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIView *bkView;
@property (nonatomic,strong) UIImageView *leftImgv;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,weak) id <TopSearchViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
