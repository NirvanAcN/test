//
//  PDFKitViewController.m
//  test
//
//  Created by 马浩萌 on 2021/2/3.
//

#import "PDFKitViewController.h"
@import PDFKit;

@interface PDFKitViewController ()

@end

@implementation PDFKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray <NSString *> * imagesArray = @[@"方形源鹅.png", @"imagefilter.jpg", @"niu.jpg"];
    PDFDocument * pdf = [[PDFDocument alloc] init];

    [imagesArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PDFPage * page = [[PDFPage alloc] initWithImage:[UIImage imageNamed:obj]];
        [pdf insertPage:page atIndex:0];
    }];

//    NSLog(@"%@", pdf.dataRepresentation);
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[@"", pdf.dataRepresentation] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
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
