//
//  UIImage+coregraphics.m
//  test
//
//  Created by 马浩萌 on 2021/1/8.
//

#import "UIImage+coregraphics.h"

@implementation UIImage (coregraphics)

//YYImage和SDWebImage都是使用这种方法，解压缩的原理就是CGBitmapContextCreate方法重新生产一张位图然后把图片绘制当这个位图上，最后拿到的图片就是解压缩之后的图片。
- (UIImage *)mhm_CGCompressImage:(CGSize)size {
    CGImageRef imageRef = self.CGImage;
    //读取image通道数据，一般是RGB格式（也有YUV），大端存储下，包含alpha就是RGBA或者ARGB（），不包含alpha就是RGB，值为8或者6
    size_t bytePerComponent = CGImageGetBitsPerComponent(imageRef);
    
    //数据有多少行
    size_t bytePerRow = CGImageGetBytesPerRow(imageRef);
    
    //颜色空间
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    //位图信息，就是RGB的存储格式，RGBA或者ARGB（大端模式），也还要小端模式，可以自己网上看
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 size.width,
                                                 size.height,
                                                 bytePerComponent,
                                                 bytePerRow,
                                                 colorSpace,
                                                 bitmapInfo);
    if (!context) {
        return nil;
    }
    
    //设置插值质量
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    //绘图
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageRef);
    //生成imageRef
    CGImageRef bitmapImageRef = CGBitmapContextCreateImage(context);
    if (!bitmapImageRef) {
        return nil;
    }
    UIImage *image = [UIImage imageWithCGImage:bitmapImageRef scale:self.scale orientation:self.imageOrientation];
    
    CGContextRelease(context);
    return image;
    
}

@end
