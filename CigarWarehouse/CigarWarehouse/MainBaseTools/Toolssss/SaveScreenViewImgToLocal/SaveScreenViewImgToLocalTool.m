//
//  SaveScreenViewImgToLocalTool.m
//  Community
//
//  Created by 余莹 on 2021/10/27.
//

#import "SaveScreenViewImgToLocalTool.h"

@implementation SaveScreenViewImgToLocalTool

#pragma mark === //截图保存功能
+ (void)saveImgToPhonePhotoLocalWithImg:(UIImage *)img{
    DLog(@"view 保存到手机");
    
    UIImage *willSaveImg =  img;
    UIImageWriteToSavedPhotosAlbum(willSaveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}


+ (void)saveImgToPhonePhotoLocalWithView:(UIView *)view{
    DLog(@"view 保存到手机");
    
    UIImage *willSaveImg =  [self captureImageFromView:view];
    UIImageWriteToSavedPhotosAlbum(willSaveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}



//参数1:图片对象
//参数2:成功方法绑定的target
//参数3:成功后调用方法
//参数4:需要传递信息(成功后调用方法的参数)
//UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//#pragma mark -- <保存到相册>
+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = @"" ;
    if(error){
        msg = @"保存图片失败" ;
        Y_SVP_SHOW_ERR_MES(msg);
    }else{
        msg = @"保存图片成功" ;
        Y_SVP_SHOW_SUCCESS_MES(msg);
    }
    
}


#pragma mark===

//图片转img
+ (UIImage *)captureImageFromView:(UIView *)view

{
    
    CGRect screenRect = [view bounds];
    
    //UIGraphicsBeginImageContext(screenRect.size);//1029 清晰度不够 更换  默认当前设备的缩放因子==1.0
    UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, [UIScreen mainScreen].scale);//清晰度 /【UIScreen mainScreen].scale本参数==指定当前设备的缩放因子，而0.0的意思就是自动调整缩放因子以适配显示屏
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
     
    return image;
    
}
//图片img的清晰度适配当前显示屏（本方法內暂未使用）
+ (UIImage *)drawImgWithMaxShow:(UIImage *)img{
    
    //img
    CGSize itemSize = img.size;
//                UIGraphicsBeginImageContext(itemSize);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, [UIScreen mainScreen].scale);//清晰度
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [img drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//                cell.imageView.layer.shouldRasterize = YES;//栅栏
//                cell.imageView.layer.allowsEdgeAntialiasing = YES;//锯齿
    return img;
}
@end
