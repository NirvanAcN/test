//
//  CutImageViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/9.
//

#import "CutImageViewController.h"
#import "MHMCutView.h"

@interface CutImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation CutImageViewController
{
    UIImageView * _imageView;
    MHMCutView * _cutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    NSLog(@"- %@ -", NSStringFromCGRect(self.view.frame));
    _cutView = [MHMCutView new];
    _cutView.backgroundColor = UIColor.grayColor;
    [self.view addSubview:_cutView];
    
    [_cutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    NSLog(@"- %@ -", NSStringFromCGRect(self.view.frame));
    _cutView.xImage = [UIImage imageNamed:@"niu.jpg"];
    
//    _imageView = [UIImageView new];
//    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:_imageView];
//
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.leading.trailing.equalTo(self.view);
//    }];
//
//    [self test];
    
    UIBarButtonItem * photosBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(onPhotoLibraryBarButtonClick:)];
    self.navigationItem.rightBarButtonItem = photosBarButtonItem;
    
    UIBarButtonItem * cropBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Crop" style:UIBarButtonItemStylePlain target:self action:@selector(onCropButtonClick:)];
    UIBarButtonItem * redoBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(onRedoButtonClick:)];

    self.navigationItem.leftBarButtonItems = @[cropBarButtonItem, redoBarButtonItem];
}

-(void)test {
    UIImage * orginImage = [UIImage imageNamed:@"niu.jpg"].mhm_squareImage;
    CGSize originSize = orginImage.size;
    CGFloat k_length = MAX(originSize.width, originSize.height);

    CGFloat k_default_length = k_length / 3;
    
    CGImageRef cgImage = orginImage.CGImage;
    NSMutableArray <UIImage *> * results = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 3; j ++) {
            @autoreleasepool {
                CGImageRef cutImage = CGImageCreateWithImageInRect(cgImage, CGRectMake(i * k_default_length, j * k_default_length, k_default_length, k_default_length));
                UIImage *resultImage = [UIImage imageWithCGImage:cutImage];
                CGImageRelease(cutImage);
                [results addObject:resultImage];
            }
        }
    }
        
    _imageView.image = results[0];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL * url = info[UIImagePickerControllerImageURL];
    UIImage * originImage = info[UIImagePickerControllerOriginalImage];
    _cutView.xImage = originImage;
//    UIImage * portraitImage = [self portraitEffectsMatteFilterCIImageAtURL:url andOriginImage:originImage];
//    imageView.image = [portraitImage mhm_generateBackgroundWithColor:UIColor.clearColor];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - crop action
-(void)onCropButtonClick:(id)sender {
    if (_cutView) {
        [_cutView testAction];
    }
}

-(void)onRedoButtonClick:(id)sender {
    _cutView.xImage = [UIImage imageNamed:@"niu.jpg"];
}

@end
