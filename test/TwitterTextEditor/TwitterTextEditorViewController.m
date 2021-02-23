//
//  TwitterTextEditorViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/27.
//

#import "TwitterTextEditorViewController.h"
#import "test-Swift.h"
@import YYText;
#import "YYTextCommonParser.h"
#import "MHMParserModel.h"

@interface TwitterTextEditorViewController () <YYTextViewDelegate>

@end

@implementation TwitterTextEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    MHMParserModel * model = [[MHMParserModel alloc] initWithKey:@"{time}" andShowValue:@"{time}"];
    model.fontColor = UIColor.whiteColor;
    model.tagFillColor = UIColor.greenColor;
    [mapper addEntriesFromDictionary:model.mhmParserItem];
//    mapper[@"111"] = [[NSAttributedString alloc] initWithString:@"222"];
//    mapper[@"222"] = @"333";

    
//    [text appendAttributedString:tagText];
    
//    mapper[@"#red"] = tagText;
    YYTextCommonParser *parser = [YYTextCommonParser new];
    parser.commonMapper = mapper;
    
    YYTextView *textView = [YYTextView new];
//    textView.delegate = self;
    textView.textParser = parser;
    textView.textColor = UIColor.blackColor;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    ////    textView.frame = ...
    //    textView.attributedString = text;
    
}

@end
