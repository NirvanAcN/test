//
//  PortraitEffectsMatteViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/17.
//

#import "PortraitEffectsMatteViewController.h"

@import Photos;

@interface PortraitEffectsMatteViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PortraitEffectsMatteViewController
{
    UIImageView * imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIImageView * bgView = [UIImageView new];
//    bgView.image = [UIImage imageNamed:@"niu.jpg"];
    
    bgView.backgroundColor = [UIColor redColor];
//    [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"niu.jpg"]];
//    UIColor.init(patternImage:UIImage(named:"blockcheck")!)

//    bgView.backgroundColor = [UIColor whiteColor];
    bgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    
    imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"相册" forState:UIControlStateNormal];
    button.accessibilityLabel = @"这是测试哦";
    [button addTarget:self action:@selector(onPhotoLibraryBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
    }];
}

-(void)onPhotoLibraryBarButtonClick:(id)sender {
    [MHMAuthorizationManager checkPhotoLibraryAuthorization:^(BOOL granted) {
        if (granted) {
            UIImagePickerController * imagePickerController = [UIImagePickerController new];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            [self showViewController:imagePickerController sender:nil];
        }
    }];
}

-(CIImage *)portraitEffectsMatteCIImageAtURL:(NSURL *)imageURL {
    CFURLRef urlRef = CFBridgingRetain(imageURL);
    // Get reference to the image data:
    CGImageSourceRef source = CGImageSourceCreateWithURL(urlRef, nil);
    CFBridgingRelease(urlRef);
    
    // Query for auxiliary data of specific type:
    CFDictionaryRef auxiliaryInfoDict = CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0, kCGImageAuxiliaryDataTypePortraitEffectsMatte);
    
    NSDictionary * auxDataDictionary = (__bridge NSDictionary *)auxiliaryInfoDict;
    CIImage * matteCIImage;
    if (auxDataDictionary) {
        AVPortraitEffectsMatte * matteData = [AVPortraitEffectsMatte portraitEffectsMatteFromDictionaryRepresentation:auxDataDictionary error:nil];
        // Load matte data into Core Image for conversion to UIImage:
        matteCIImage = [CIImage imageWithPortaitEffectsMatte:matteData];
    }
    return matteCIImage;
}

-(UIImage *)originImageAtURL:(NSURL *)imageURL {
    CFURLRef urlRef = CFBridgingRetain(imageURL);
    // Get reference to the image data:
    CGImageSourceRef source = CGImageSourceCreateWithURL(urlRef, nil);
    CFBridgingRelease(urlRef);
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    UIImage * sourceImage = [UIImage imageWithCGImage:imageRef];
    
    return sourceImage;
}

-(UIImage *)portraitEffectsMatteImageAtURL: (NSURL *)imageURL {
    CIImage * matteCIImage = [self portraitEffectsMatteCIImageAtURL:imageURL];
    return [UIImage imageWithCIImage:matteCIImage];
}

-(UIImage *)portraitEffectsMatteFilterCIImageAtURL:(NSURL *)imageURL andOriginImage:(UIImage *)originImage {
    CIImage * matteCIImage = [self portraitEffectsMatteCIImageAtURL:imageURL];
    if (!matteCIImage) return nil;
    static NSString * const filterName = @"CIBlendWithMask";
    CGImageRef selectedCGImage = originImage.CGImage;
    CIImage * selectedCIImage = [CIImage imageWithCGImage:selectedCGImage];
    CGAffineTransform transform = CGAffineTransformMakeScale(selectedCIImage.extent.size.width / matteCIImage.extent.size.width, selectedCIImage.extent.size.height / matteCIImage.extent.size.height);
    matteCIImage = [matteCIImage imageByApplyingTransform:transform];
    CIFilter * filter = [CIFilter filterWithName:filterName withInputParameters:@{
        kCIInputImageKey: selectedCIImage,
        kCIInputMaskImageKey: matteCIImage
    }];
    CIImage * maskedCIImage = filter.outputImage;
    UIImage * maskedImage = [UIImage imageWithCIImage:maskedCIImage];
    return maskedImage;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL * url = info[UIImagePickerControllerImageURL];
    UIImage * originImage = info[UIImagePickerControllerOriginalImage];
    
    UIImage * portraitImage = [self portraitEffectsMatteFilterCIImageAtURL:url andOriginImage:originImage];
    imageView.image = [portraitImage mhm_generateBackgroundWithColor:UIColor.clearColor];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
