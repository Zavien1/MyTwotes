//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DateTools.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"
#import "TTTAttributedLabel.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* arrayOfTweets;
@property (strong,nonatomic) NSArray* arrayOfUserInfo;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;



@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loadingIndicator startAnimating];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self loadTweets];
}

- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

//API Calls
- (void)loadTweets {
     [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
         if(tweets){
             self.arrayOfTweets = tweets;
             [self.tableView reloadData];
             
         }else{
             NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
         }
     }];
     [self.refreshControl endRefreshing];
     [self.loadingIndicator stopAnimating];
 }

- (IBAction)didTapLogout:(id)sender {
    [self userLogout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userLogout {
    
    // TimelineViewController.m
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    [cell generateCell:tweet];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row + 1 == [self.arrayOfTweets count]){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([self.arrayOfTweets count] <= 180) {
            [userDefaults setInteger:[self.arrayOfTweets count] + 20 forKey:@"numTweets"];
            [userDefaults synchronize];
        }
        
        // Reload data
        [self loadTweets];
    }
}

//Segue to DetailsView or ComposeView
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqual:@"ComposeView"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if([segue.identifier isEqual:@"DetailsView"]) {
        UITableViewCell *tappedTweet = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedTweet];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
         
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
    else if([segue.identifier isEqual:@"ProfileView"]) {
        UITableViewCell *tappedTweet = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedTweet];
        
        Tweet *user = self.arrayOfUserInfo[indexPath.row];
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = user;
    }
}


@end
