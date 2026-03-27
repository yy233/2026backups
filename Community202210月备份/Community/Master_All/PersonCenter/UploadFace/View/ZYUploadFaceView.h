//
//  ZYUploadFaceView.h
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYUploadFaceViewDelegate <NSObject>

@optional

- (void)addPhotos;

- (void)imageViewTapWithIndex:(NSInteger)index;

- (void)deletePhotoWithIndex:(NSInteger)index;

@end

@interface ZYUploadFaceView : UIView

@property (nonatomic, copy) NSString *typeStr;

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, weak) id<ZYUploadFaceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
