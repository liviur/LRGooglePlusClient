//
//  LRGooglePlusClient.m
//  LRGooglePlusClient
//
//  Created by Liviu Romascanu on 4/16/14.
//  Copyright (c) 2014 Liviu Romascanu. All rights reserved.
//


#import "LRGooglePlusClient.h"
#ifdef COCOAPODS
#import <google-plus-ios-sdk/GoogleOpenSource.h>
#else
#import <GoogleOpenSource/GoogleOpenSource.h>
#endif

NSString *const LRGooglePlusShareNotification = @"LRGooglePlusShareNotification";
NSString *const LRGooglePlusDidLoginNotification = @"LRGooglePlusDidLoginNotification";
NSString *const LRGooglePlusDidLogoutNotification = @"LRGooglePlusDidLogoutNotification";
NSString *const LRGooglePlusDidNotLoginNotification = @"LRGooglePlusDidNotLoginNotification";

@interface LRGooglePlusClient ()
@property (nonatomic, strong) NSDictionary *shareDictionary;

@end

@implementation LRGooglePlusClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [GPPDeepLink setDelegate:sharedInstance];
        [GPPDeepLink readDeepLinkAfterInstall];
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.shouldFetchGooglePlusUser = YES;
        signIn.scopes = @[ kGTLAuthScopePlusLogin ];
        signIn.delegate = sharedInstance;
        [[GPPShare sharedInstance] setDelegate:sharedInstance];

    });
    return sharedInstance;
}

- (void)setClientID:(NSString *)clientID
{
    _clientID = clientID;
    [GPPSignIn sharedInstance].clientID = clientID;
    self.isSignedIn = NO;
    [[GPPSignIn sharedInstance] trySilentAuthentication];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

- (void)signIn
{
    if (self.clientID == nil) {
        NSLog(@"No Client ID is set");
        return;
    }
    
    [[GPPSignIn sharedInstance] authenticate];
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink
{
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)disconnect
{
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)shareWithURL:(NSURL *)url andPrefillText:(NSString *)text
{
    if (self.clientID == nil) {
        NSLog(@"No Client ID is set");
        return;
    }
    
    if (self.isSignedIn) {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [shareBuilder setURLToShare:url];
        [shareBuilder setPrefillText:text];
        [shareBuilder open];
    } else {
        NSMutableDictionary *shareDictionary = [[NSMutableDictionary alloc] init];
        if (url) {
            [shareDictionary setObject:url forKey:@"url"];
        }
        if (text) {
            [shareDictionary setObject:text forKey:@"text"];
        }
        self.shareDictionary = shareDictionary;
        [self signIn];
    }
}

- (void)sharewithTitle:(NSString *)title andDescription:(NSString *)description andThumbnailURL:(NSURL *)thumbnailURL andURL:(NSURL *)url andPrefillText:(NSString *)text
{
    if (self.clientID == nil) {
        NSLog(@"No Client ID is set");
        return;
    }
    
    if (self.isSignedIn) {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [shareBuilder setURLToShare:url];
        [shareBuilder setTitle:title description:description thumbnailURL:thumbnailURL];
        [shareBuilder setPrefillText:text];
        [shareBuilder open];
    } else {
        NSMutableDictionary *shareDictionary = [[NSMutableDictionary alloc] init];
        if (title) {
            [shareDictionary setObject:title forKey:@"title"];
        }
        if (description) {
            [shareDictionary setObject:description forKey:@"description"];
        }
        if (thumbnailURL) {
            [shareDictionary setObject:thumbnailURL forKey:@"thumbnailURL"];
        }
        if (url) {
            [shareDictionary setObject:url forKey:@"url"];
        }
        if (text) {
            [shareDictionary setObject:text forKey:@"text"];
        }
        self.shareDictionary = shareDictionary;
        [self signIn];
    }
}

- (void)shareWithDictionary:(NSDictionary *)dictionary
{
    if (self.clientID == nil) {
        NSLog(@"No Client ID is set");
        return;
    }
    
    if (self.isSignedIn) {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [shareBuilder setURLToShare:[dictionary objectForKey:@"url"]];
        [shareBuilder setTitle:[dictionary objectForKey:@"title"]
                   description:[dictionary objectForKey:@"description"]
                  thumbnailURL:[dictionary objectForKey:@"thumbnailURL"]];
        [shareBuilder setPrefillText:[dictionary objectForKey:@"text"]];
        [shareBuilder open];
    } else {
        self.shareDictionary = dictionary;
        [self signIn];
    }
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    self.isSignedIn = ([GPPSignIn sharedInstance].authentication != nil);
    if (error) {
        NSLog(@"Login Error to Google Plus:\n%@", error);
    }
    
    if (self.isSignedIn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LRGooglePlusDidLoginNotification object:nil];
        if (self.shareDictionary) {
            [self shareWithDictionary:self.shareDictionary];
            self.shareDictionary = nil;
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:LRGooglePlusDidNotLoginNotification object:nil];
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    self.isSignedIn = ([GPPSignIn sharedInstance].authentication != nil);
    if (error) {
        NSLog(@"Logout Error to Google Plus:\n%@", error);
    }
    if (self.isSignedIn == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LRGooglePlusDidLogoutNotification object:nil];
    }
}

#pragma mark - GPPShareDelegate

- (void)finishedSharingWithError:(NSError *)error
{
    if (error) {
        NSLog(@"Error sharing on Google Plus:\n%@",error);
    } else {
        NSLog(@"Shared successfully on Google Plus");
        [[NSNotificationCenter defaultCenter] postNotificationName:LRGooglePlusShareNotification object:nil];
    }
}

@end