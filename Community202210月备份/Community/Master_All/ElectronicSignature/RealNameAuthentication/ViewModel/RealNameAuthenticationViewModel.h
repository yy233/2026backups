//
//  RealNameAutgebtucationViewModel.h
//  Community
//
//  Created by 余莹 on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import <EsandZim/EsandZim.h>
NS_ASSUME_NONNULL_BEGIN

 
@interface RealNameAuthenticationViewModel : NSObject
 
singleton_interface(realNameAuthenticationViewModelShare)


- (void)sendCerNo:(NSString *)cerNo andCerName:(NSString *)cerName andCerDetailAddress:(NSString *)cerAddress withUiVc:(UIViewController *)vc withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
- (void)willFaceCerWithResultDicJsonData:(NSString *)strOfInitRes andCerDetailAddress:(NSString *)cerAddress withUIVc:(UIViewController *)vc withDicBlock:(BaseDicAndSuccessBoolBlock)dicBlock;
@end

NS_ASSUME_NONNULL_END
