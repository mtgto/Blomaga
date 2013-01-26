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

@property (nonatomic, copy) NSString *imageUrl;

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
    UITapGestureRecognizer *bgTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:bgTapGestureRecognizer];

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
    NSString *body = self.textView.text;
    if (self.imageUrl) {
        body = [body stringByAppendingFormat:@"<br><br><img src=\"%@\" height=\"400px\" style=\"\">", self.imageUrl];
    }
    Article *article = [[Article alloc] initWithId:self.parameters[@"article_id"]
                                           subject:self.titleField.text
                                              body:body
                                            blogId:self.parameters[@"blog_id"]
                                         channelId:self.parameters[@"channel_id"]
                                        screenName:self.parameters[@"screen_name"]
                                               key:self.parameters[@"key"]
                                          apiToken:self.parameters[@"scp_api_token"]
                                              time:self.parameters[@"time"]];
    NicoAPIClient *apiClient = [[NicoAPIClient alloc] init];
    [apiClient sendArticle:article
                   success:^(NicoAPIClient *client) {
                       [self.navigationController dismissViewControllerAnimated:YES completion:^{

                       }];
                   } failure:^(NicoAPIClient *client) {

                   }];
}

- (IBAction)doneTextEditing:(id)sender {
    [sender resignFirstResponder];
}

- (void)backgroundTapped:(id)sender
{
    [self.textView resignFirstResponder];
    [self.titleField resignFirstResponder];
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
        NSData *data = UIImageJPEGRepresentation(originalImage, 0.5f);
        NicoAPIClient *apiClient = [[NicoAPIClient alloc] init];
        [apiClient sendImageData:data
                       channelId:self.parameters[@"channel_id"]
                       articleId:self.parameters[@"article_id"]
                           token:self.parameters[@"key"]
                            time:self.parameters[@"time"]
                         success:^(NicoAPIClient *client, NSString *imageUrl) {
                             self.imageUrl = imageUrl;
        }
                         failure:^(NicoAPIClient *client) {
            
        }];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DDLogVerbose(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

@end
