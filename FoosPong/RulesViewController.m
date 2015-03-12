//
//  RulesViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "RulesViewController.h"

@interface RulesViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.table-soccer.org/rules/documents/ITSFRulesEnglish.pdf"]]];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
