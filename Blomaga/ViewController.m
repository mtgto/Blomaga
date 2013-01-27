//
//  ViewController.m
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSURL *portalUrl;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.portalUrl = [NSURL URLWithString:@"http://sp.ch.nicovideo.jp/portal/blomaga"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.portalUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PostSegue"]) {
        PostViewController *postViewController = [segue destinationViewController];
        postViewController.delegate = self;
    }
}

- (IBAction)pushHome:(id)sender {
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.portalUrl]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DDLogVerbose(@"webView shouldStartLoadWithRequest:%@ type:%d", request, navigationType);
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DDLogVerbose(@"webView didFailLoadWithError:%@", error);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DDLogVerbose(@"webView webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DDLogVerbose(@"webView webViewDidFinishLoad");
    NSString* title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

#pragma mark - PostURLDelegate

- (void)goUrl:(NSURL *)url
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
@end
