//
//  DetailsViewController.m
//  twitter
//
//  Created by Zavien Sibilia on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userName.text = self.tweet.user.name;
    self.userScreenName.text = self.tweet.user.screenName;
    self.tweetText.text = self.tweet.text;
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.userProfileImage setImageWithURL:url];
    self.totalRetweets.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.totalLikes.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    self.userProfileImage.layer.borderWidth = 1;
    self.userProfileImage.layer.masksToBounds = false;
    self.userProfileImage.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]);
    self.userProfileImage.layer.cornerRadius = 24;
    self.userProfileImage.clipsToBounds = true;

}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted){
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
            }
        }];
    } else {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
            }
        }];
    }
    
}

- (IBAction)didTapLike:(id)sender {
    if(self.tweet.favorited){
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self.likeButton setBackgroundImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
            }
        }];
    } else {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                [self.likeButton setBackgroundImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
            }
        }];
    }
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
