//
//  PostViewController.m
//  Blomaga
//
//  Created by mtgto on 1/26/13.
//  Copyright (c) 2013 mtgto. All rights reserved.
//

#import "PostViewController.h"
#import "NicoAPIClient.h"

@interface PostViewController ()

@property (nonatomic, strong) NSDictionary *parameters;

@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];

    NicoAPIClient *apiClient = [[NicoAPIClient alloc] init];
    [apiClient getNewArticleSuccess:^(NicoAPIClient *client, NSDictionary *parameters) {
        self.parameters = parameters;
        DDLogVerbose(@"success");
    } failure:^(NicoAPIClient *client) {
        DDLogVerbose(@"failure");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushPost:(id)sender {
    Article *article = [[Article alloc] initWithId:self.parameters[@"article_id"]
                                           subject:self.titleField.text
                                              body:self.textView.text
                                            blogId:self.parameters[@"blog_id"]
                                         channelId:self.parameters[@"channel_id"]
                                        screenName:self.parameters[@"screen_name"]
                                               key:self.parameters[@"key"]
                                          apiToken:self.parameters[@"scp_api_token"]
                                              time:self.parameters[@"time"]];
    NicoAPIClient *apiClient = [[NicoAPIClient alloc] init];
    [apiClient sendArticle:article
                   success:^(NicoAPIClient *client) {

                   } failure:^(NicoAPIClient *client) {

                   }];
}

- (void)imageTapped:(id)sender {
    DDLogVerbose(@"imageTapped");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:^{

    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DDLogVerbose(@"didFinishPickingMediaWithInfo");
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DDLogVerbose(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
