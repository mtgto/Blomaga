//
//  ViewController.m
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "ViewController.h"
#import "PostViewController.h"
#import "LoginViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSURL *portalUrl;

@property (nonatomic, strong) NSRegularExpression *titleSuffixRegexp;

@property (nonatomic, weak) UIRefreshControl *refreshControl;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSError *error = nil;
    self.titleSuffixRegexp = [NSRegularExpression regularExpressionWithPattern:@" - (ニコニコチャンネル|ブロマガ)$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:&error];
    self.portalUrl = [NSURL URLWithString:@"http://sp.ch.nicovideo.jp/portal/blomaga"];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"引き下げて更新"];
    self.refreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];

    [self.webView.scrollView addSubview:self.refreshControl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.portalUrl]];
}

- (void)viewDidAppear:(BOOL)animated
{
    DDLogVerbose(@"viewDidAppear");
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    });
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
    } else if ([segue.identifier isEqualToString:@"LoginSegue"]) {
        LoginViewController *loginViewController = [segue destinationViewController];
        loginViewController.delegate = self;
    }
}

- (IBAction)pushHome:(id)sender {
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.portalUrl]];
}

- (void)pushPost:(id)sender {
    [self performSegueWithIdentifier:@"PostSegue" sender:self];
}

- (void)refreshAction:(id)sender {
    [self.refreshControl beginRefreshing];
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DDLogVerbose(@"webView shouldStartLoadWithRequest:%@ type:%d", request, navigationType);
    if ([request.URL.scheme isEqualToString:@"https"] &&
         [request.URL.host isEqualToString:@"secure.nicovideo.jp"] &&
        [request.URL.path hasPrefix:@"/secure/login_form"]) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        return NO;
    }
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
    [self.refreshControl endRefreshing];
    // hide register link
    [webView stringByEvaluatingJavaScriptFromString:@"$('a.siteHeaderBtn').hide()"];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    title = [self.titleSuffixRegexp stringByReplacingMatchesInString:title options:0 range:NSMakeRange(0, [title length]) withTemplate:@""];
    self.title = title;
}

#pragma mark - PostURLDelegate

- (void)goUrl:(NSURL *)url
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setPostButtonVisible:(BOOL)isVisible
{
    self.navigationItem.rightBarButtonItem = nil;
    if (isVisible) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(pushPost:)];
    }
}
@end
