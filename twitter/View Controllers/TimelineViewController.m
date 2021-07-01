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
#import "DateTools.h"
#import "DetailsViewController.h"

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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
        
    cell.name.text = tweet.user.name;
    cell.userName.text = tweet.user.screenName;
    cell.tweet = tweet;
    cell.userTweet.text = tweet.text;
    cell.tweetDate.text = tweet.createdAtString;
//    NSLog(@"%@", tweet.createdAtString);
//    cell.userTweet.text = tweet.text;
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.userProfileImage.layer.borderWidth = 1;
    cell.userProfileImage.layer.masksToBounds = false;
    cell.userProfileImage.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]);
    cell.userProfileImage.layer.cornerRadius = 24;
    cell.userProfileImage.clipsToBounds = true;
    NSString *likeCount = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    NSString *retweetCount = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    [cell.likeButton setTitle:likeCount forState:UIControlStateNormal];
    [cell.retweetButton setTitle:retweetCount forState:UIControlStateNormal];
    
    [cell.userProfileImage setImageWithURL:url];
    
    return cell;
}

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
}


@end
