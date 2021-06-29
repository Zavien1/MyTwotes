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
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 200;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self loadTweets];

    
}

 - (void)loadTweets {
     [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
         if (tweets) {
             self.arrayOfTweets = tweets;
             [self.tableView reloadData];
         } else {
             NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
         }
     }];
     [self.refreshControl endRefreshing];
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
//    NSLog(@"%@", tweet.user.screenName);
    
//    cell.name.text = tweet.user.name;
    cell.name.text = tweet.user.name;
    cell.tweet = tweet;
    cell.userTweet.text = tweet.text;
    cell.likeCount.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    cell.retweetCount.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
//    cell.userTweet.text = tweet.text;
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    [cell.userProfileImage setImageWithURL:url];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   UINavigationController *navigationController = [segue destinationViewController];
   ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
   composeController.delegate = self;
}


@end
