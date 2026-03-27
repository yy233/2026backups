//
//  LGifImageView.swift
//  RobotLeo
//
//  Created by lmc on 16/1/7.
//  Copyright © 2016年 eric. All rights reserved.
//

import UIKit
import ImageIO

//typealias myClosure = (pra : Bool)->Void

class LGifImageFrame: NSObject {
    
    var duration : Double? = 0
    var image : UIImage?
}


typealias myClosure = (_ pra : Bool)->Void


class LGifImageView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var gifFinishCompletionBlock : myClosure?
    
    var currentImageIndex : NSInteger!
    var imageFrameArray : NSArray?
    var timer : Timer?
    
    var ani : Bool!
    
    var isOnce = false
    
    func resetTimer(){
        
        if timer != nil {
            if timer!.isValid{
               timer?.invalidate()
            }
        }
        timer = nil
    }
    
    func setData(_ imageData:Data?,pre:@escaping (_ finish:Bool)->Void){
        if imageData == nil{
            return
        }
        resetTimer()
        
        gifFinishCompletionBlock = pre
//        CFData
        let source : CGImageSource? = CGImageSourceCreateWithData(imageData! as CFData, nil)
        let count : size_t = CGImageSourceGetCount(source!)
        let  tmpArr = NSMutableArray()
        
        
    
        
        for i : size_t in  0 ..< count {
            let gifImage = SCGIFImageFrame()
            
            let image : CGImage = CGImageSourceCreateImageAtIndex(source!, i, nil)!
            gifImage.image = UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: UIImageOrientation.up)
            let frameProperties : NSDictionary = CGImageSourceCopyPropertiesAtIndex(source!, i, nil)!
            
            let tmp = (frameProperties.object(forKey: kCGImagePropertyGIFDictionary) as AnyObject).object(forKey: kCGImagePropertyGIFDelayTime)
            
            if tmp != nil{
                gifImage.duration = (tmp! as AnyObject).doubleValue
            }
//            gifImage.duration = max(gifImage.duration, 0.01)
            gifImage.duration = 0.05
            
            tmpArr.add(gifImage)
        
        }
        imageFrameArray = nil
        if tmpArr.count > 1 {
            imageFrameArray = tmpArr
            currentImageIndex = -1
            ani = true
            showNextImage()
        }else{
            image = UIImage(data: imageData!)
            resetTimer()
            imageFrameArray = nil
            ani = false
        }
        
    }
    

    
    func showNextImage(){
        if !ani{
            return
        }

        currentImageIndex = currentImageIndex + 1
        
        
        currentImageIndex = (currentImageIndex) % imageFrameArray!.count
        let gifImage : SCGIFImageFrame = imageFrameArray!.object(at: currentImageIndex) as! SCGIFImageFrame
        super.image = gifImage.image
        //结束
        if (currentImageIndex+1) == imageFrameArray!.count{
            
            
            if isOnce{
                gifFinishCompletionBlock?(true)
                return
            }
            
        }
        timer = Timer.scheduledTimer(timeInterval: gifImage.duration, target: self, selector: #selector(LGifImageView.showNextImage), userInfo: nil, repeats: false)
    }
    
    func setAnimation(_ animating1:Bool){
        if imageFrameArray!.count < 2{
            ani = animating1
            return
        }
        if !ani! && animating1 {
            ani = animating1
            if (timer == nil) {
               showNextImage()
            }
        }else if (animating1 == false && ani == true){
            ani = animating1
            resetTimer()
        }
    }
    

}
