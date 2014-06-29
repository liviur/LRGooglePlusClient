//
//  LRGooglePlusClient.h
//  LRGooglePlusClient
//
//  Created by Liviu Romascanu on 4/16/14.
//  Copyright (c) 2014 Liviu Romascanu. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef COCOAPODS
#import <google-plus-ios-sdk/GooglePlus.h>
#else
#import <GooglePlus/GooglePlus.h>
#endif

/** This notification is called when the Google Plus share is successfully sent. */
extern NSString * const LRGooglePlusShareNotification;
/** This notification is sent when Google Plus did Login */
extern NSString * const LRGooglePlusDidLoginNotification;
/** This notification is sent when Google Plus did Logout */
extern NSString * const LRGooglePlusDidLogoutNotification;
/** This notification is sent when Google Plus didn't manage to Login */
extern NSString * const LRGooglePlusDidNotLoginNotification;

@interface LRGooglePlusClient : NSObject <GPPDeepLinkDelegate,GPPSignInDelegate, GPPShareDelegate>

/**
 Google Plus Application identifier.
 Can be found at https://code.google.com/apis/console - API Access
 Once you set it - isSignedIn turns into NO and Google Plus Client will try to sliently log in.
 */
@property (nonatomic, copy) NSString *clientID;

/**
 Boolean property - indicates if signed in to Google Plus
 */
@property (nonatomic, assign) BOOL isSignedIn;

/**
 Singleton shared Instance that creates and sets the shared instance as the Google Plus delegate for deep linking , share and signing in.
 */
+ (instancetype)sharedInstance;

/**
 Application url opening for SSO use
 @property application - source application
 @property url - URL used to open the app
 @property sourceApplication - source application
 @property annotation - plist object sent from the opening application
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/**
 Sign in to Google Plus
 */
- (void)signIn;

/**
 Sign out of Google Plus
 */
- (void)signOut;

/**
 Disconnect from Google Plus
 This will also remove the app from your authorize apps lists
 */
- (void)disconnect;

/**
 Share with URL
 If not signed in - a sign in attempt will be tried - and upon success - sharing will occur
 @param url used for sharing - Image , text and description are taken from the link
 @param text to be filled in the user share portion
 */
- (void)shareWithURL:(NSURL *)url andPrefillText:(NSString *)text;

/**
 Share with multiple fields
 Note - Fields will NOT override share data from URL. This is GooglePlus behaviour that cannot be changed
 If not signed in - a sign in attempt will be tried - and upon success - sharing will occur
 @param title - title of the GP share
 @param description - Description of the GPShare
 @param thumbnailURL - Thumbnail to be added
 @param url - URL to be shared
 @param text - to be filled in the user share portion
 */
- (void)sharewithTitle:(NSString *)title
        andDescription:(NSString *)description
       andThumbnailURL:(NSURL *)thumbnailURL
                andURL:(NSURL *)url
        andPrefillText:(NSString *)text;

/**
 Share with Dictionary
 If not signed in - a sign in attempt will be tried - and upon success - sharing will occur
 @param dictionary used for sharing
 @discussion
 This dictionary can use the following keys:
 url - URL to share
 title - URL Title
 description - URL Description
 thumbnailURL - URL Thumbnail
 text - Prefill Text
 */
- (void)shareWithDictionary:(NSDictionary *)dictionary;

@end
