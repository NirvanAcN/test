//
//  CoreGraphicsViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/8.
//

#import "CoreGraphicsViewController.h"
#import <IceRabbitKit/UIImage+mhmCommon.h>
#import "UIImage+coregraphics.h"
#import "UIImage+mhmFilter.h"
#import <IceRabbitKit/MHMAuthorizationManager.h>

@import AVFoundation;
@import Photos;

@interface CoreGraphicsViewController ()

@end

@implementation CoreGraphicsViewController
{
    UIImageView * _imageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self.view mas_makeConstraints:<#^(MASConstraintMaker *make)block#>]
        [self customUI];
    [self test];
}

-(void)test {
    //    方形源鹅.png
    UIImage * oringinImage = [UIImage imageNamed:@"方形源鹅.png"];
    NSLog(@"%lu", [self lOfImage:oringinImage]);
//    [self saveImage:oringinImage];
    
    UIImage * mhmUIKitImage = [oringinImage mhm_reDrawImageWithSize:oringinImage.size];
    NSLog(@"%lu", [self lOfImage:mhmUIKitImage]);
//    [self saveImage:mhmUIKitImage];
    
    UIImage * mhmCoreGraphicsImage = [oringinImage mhm_CGCompressImage:oringinImage.size];
    NSLog(@"%lu", [self lOfImage:mhmCoreGraphicsImage]);
//    [self saveImage:mhmCoreGraphicsImage];
    
    
    UIImage * filterImage = [oringinImage mhm_imageOfFilter:MHMImageFilterNameCISpotColor];
    _imageView.image = filterImage;
    UIImage * resultImage = [filterImage mhm_CGCompressImage:oringinImage.size];
    NSLog(@"%lu", [self lOfImage:filterImage]);
    [self saveImage:filterImage];
    

}

-(void)saveImage:(UIImage *)target {
    [MHMAuthorizationManager checkPhotoLibraryAuthorization:^(BOOL granted) {
        if (granted) {
            PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
            [library performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:target];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"保存%@", success ? @"成功" : @"失败");
                if (!success) {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        } else {
            
        }
    }];
}

-(NSUInteger)lOfImage:(UIImage *)im {
    NSUInteger s3 = CGImageGetHeight(im.CGImage) * CGImageGetBytesPerRow(im.CGImage);
    return s3;
}

-(void)customUI {
    _imageView = [UIImageView new];
    [self.view addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
