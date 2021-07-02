//
//  TweetCell.m
//  twitter
//
//  Created by Zavien Sibilia on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userTweet.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    self.userTweet.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//tap like action
- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited){
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                [self refreshData];
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
                [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateSelected];
                [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateHighlighted];
                [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
            }
        }];
    } else {
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                [self refreshData];
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
                [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateSelected];
                [self.likeButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateHighlighted];
                [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
            }
        }];
    }
    [sender setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount]];
}

//Tap Retweet action
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted){
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                [self refreshData];
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
                [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateSelected];
                [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateHighlighted];
                [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
            }
        }];
    } else {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                [self refreshData];
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
                [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateSelected];
                [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateHighlighted];
                [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)refreshData {
    // Refreshes tweet cell
    self.userName.text = self.tweet.user.name;
    self.userTweet.text = self.tweet.text;

    
    // Retrieve image and set image
    NSString *URLString = self.tweet.user.profilePicture;
    [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
}

- (void)generateCell:(Tweet *) tweet{
        
    self.name.text = tweet.user.name;
    self.userName.text = tweet.user.screenName;
    self.tweet = tweet;
    self.userTweet.text = tweet.text;
    self.tweetDate.text = tweet.createdAtString;
    
    //Profile image url formatting
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    // Profile image styling
    self.userProfileImage.layer.borderWidth = 1;
    self.userProfileImage.layer.masksToBounds = false;
    self.userProfileImage.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]);
    self.userProfileImage.layer.cornerRadius = 24;
    self.userProfileImage.clipsToBounds = true;
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", tweet.favoriteCount] forState:UIControlStateNormal];

    [self.retweetButton setTitle:[NSString stringWithFormat:@"%d", tweet.retweetCount] forState:UIControlStateNormal];
    
    [self.userProfileImage setImageWithURL:url];
}

@end
