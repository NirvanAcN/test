//
//  RFViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/3.
//

#import "RFViewController.h"
#import <Masonry/Masonry.h>

@interface RFViewController ()

@end

@implementation RFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView * v = [UIView new];
    v.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:v];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(100);
    }];
    
    UIView * c = [UIView new];
    c.backgroundColor = [UIColor redColor];
    [v addSubview:c];
    
    [c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@10);
        make.center.equalTo(v);
    }];
    
    NSLog(@"v.frame %@", NSStringFromCGRect(v.frame));
    NSLog(@"v.center %@", NSStringFromCGPoint(v.center));
    
    [self.view layoutIfNeeded];
    
//    NSLog(@"v.frame %@", NSStringFromCGRect(v.frame));
    
    NSLog(@"%f, %f",  self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    
    NSLog(@"view.center %@", NSStringFromCGPoint(self.view.center));
    NSLog(@"v.center %@", NSStringFromCGPoint(v.center));
    NSLog(@"c.center %@", NSStringFromCGPoint(c.center));
    
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
