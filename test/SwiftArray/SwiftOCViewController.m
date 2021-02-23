//
//  SwiftOCViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/31.
//

#import "SwiftOCViewController.h"
#import "test-Swift.h"

@interface SwiftOCViewController ()

@end

@implementation SwiftOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray * array = @[@"1", @"2", @"4", @"5"];
    NSLog(@"%@", [array mhm_map:^id _Nonnull(NSString * _Nonnull obj) {
        return [NSString stringWithFormat:@"xxxxxx%@", obj];
    }]);
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
