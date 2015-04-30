//
//  RulesViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "RulesViewController.h"


@interface RulesViewController ()   <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;


@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.table-soccer.org/rules/documents/ITSFRulesEnglish.pdf"]]];
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = CGPointMake(160, 240);
    self.activityView.color = [UIColor darkColor];
    self.activityView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityView];
    
    [self.activityView startAnimating];

    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=20)-[_activityView]-(>=20)-|" options:0 metrics:nil views:viewsDictionary]];
    
    [NSLayoutConstraint constraintWithItem:self.activityView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.f constant:0.f];
    
    [NSLayoutConstraint constraintWithItem:self.activityView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.f constant:0.f];

   
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityView stopAnimating];
    
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
