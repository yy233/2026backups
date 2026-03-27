//
//  LiveUseCarmeraView.m
//  Socialize
//
//  Created by 余莹 on 2023/8/4.
//
//实时摄像头获取
#import "LiveUseCarmeraView.h"

#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface LiveUseCarmeraView ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession; // 管理输入输出音视频流
@property (nonatomic, strong) UIImageView *imageView; // 输出图像
// @property (nonatomic, strong) CALayer *customLayer; // 输出图像
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer; // 相机预览

@end

@implementation LiveUseCarmeraView

 
#pragma mark - setup
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
 

- (void)setupCameraWithPosition:(AVCaptureDevicePosition)devicePosition onVideoOrientation:(AVCaptureVideoOrientation)viedoOrientation
{
  
    AVCaptureDevice * testDevice;
    // 创建Camera镜头组，实现镜头自动变焦
    NSArray<AVCaptureDeviceType> * deviceTypeArr = @[AVCaptureDeviceTypeBuiltInWideAngleCamera,AVCaptureDeviceTypeBuiltInTripleCamera,AVCaptureDeviceTypeBuiltInDualWideCamera,AVCaptureDeviceTypeBuiltInTrueDepthCamera,AVCaptureDeviceTypeBuiltInUltraWideCamera,AVCaptureDeviceTypeBuiltInTelephotoCamera,AVCaptureDeviceTypeBuiltInDualCamera,AVCaptureDeviceTypeBuiltInMicrophone];
    AVCaptureDeviceDiscoverySession * myDiscoverySesion = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypeArr mediaType:AVMediaTypeVideo position:devicePosition];
    
    for (AVCaptureDevice *item in myDiscoverySesion.devices) {
        // 找到对应的摄像头
        if ([item position] == devicePosition) {
            testDevice = item;
            break;
        }
    }
    // 如果没有找到镜头，就不做操作，防止崩溃
    if (testDevice != nil) {

        AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                              deviceInputWithDevice:testDevice  error:nil];
        
        AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        captureOutput.alwaysDiscardsLateVideoFrames = YES;
        dispatch_queue_t queue;
        queue = dispatch_queue_create("cameraQueue", NULL);
        [captureOutput setSampleBufferDelegate:self queue:queue];
        
        NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [captureOutput setVideoSettings:videoSettings];
        
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession addInput:captureInput];
        [self.captureSession addOutput:captureOutput];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.captureSession startRunning];
        });
    
        // FIXME：用CALayer.contents显示有可能会导致内存溢出，程序崩溃。
//        self.customLayer = [CALayer layer];
//        self.customLayer.frame = self.bounds;
//        self.customLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI/1.0f, 0, 0, 1);
//        self.customLayer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
//        self.customLayer.contentsGravity = kCAGravityResizeAspect;
//        [self.layer addSublayer:self.customLayer];
        
        // 解决录屏图像问题
        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = self.bounds;
        [self addSubview:self.imageView];
        
        // 相机预览
        self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.prevLayer.frame = self.bounds;
        // 指定屏幕方向
        self.prevLayer.connection.videoOrientation = viedoOrientation;
        self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:self.prevLayer];
    }
    
}

#pragma mark - AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    // 执行此方法有可能会导致内存飙升，程序崩溃。
//    [self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: (__bridge id) newImage waitUntilDone:YES];
    // 新图层的输出图像方向
    UIImage * image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationDown];
    CGImageRelease(newImage);
    // 解决录屏图像
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    
    /**
     其中引用RealTimeCameraView并且录屏时，使用CALayer的(setContents:)方法会导致内存一直飙升，导致程序崩溃，因此改用动态执行setImage:方法来输出图像。
     */
}

@end
