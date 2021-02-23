//
//  ViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/3.
//

#import "ViewController.h"
//#import "MHMOperationImageView.h"
#import <Masonry/Masonry.h>
#import <IceRabbitKit/MHMOperationImageView.h>
#import <IceRabbitKit/UIView+mhmImage.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation ViewController
{
    UIImageView * containImageView;
}
- (IBAction)onFinish:(UIButton *)sender {
//    UIImage * image = [self makeImageWithView:containImageView withSize:containImageView.bounds.size];
    _resultImageView.image = containImageView.mhm_image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.grayColor;
    
    containImageView = [UIImageView new];
    containImageView.userInteractionEnabled = YES;
    containImageView.contentMode = UIViewContentModeScaleAspectFit;
    containImageView.clipsToBounds = YES;
    [self.view addSubview:containImageView];
    
    [containImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    MHMOperationImageView * imageView = [MHMOperationImageView new];
    [containImageView addSubview:imageView];
    //    imageView.layer.borderColor = [UIColor redColor].CGColor;
    //    imageView.layer.borderWidth = 1;
    imageView.image = [UIImage imageNamed:@"5.png"];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    containImageView.image = [UIImage imageNamed:@"niu.jpg"];
}

- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size {
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
