# LRGooglePlusClient

## Intro
LRGoogle Plus Client was created to simplify the integration of Google Plus framework into an iOS App.

Since the Google documentation is pretty extensive, but not always that clear - I went onwards to creating a simpler solution - a singleton class that does anything from loging in , one line sharing and properly notifying you on various events.

I find this solution much easier to implement and maintain as it also removes a lot of the overhead when copying this solution from project to project.

The less code you duplicate and write - the less bugs you will have.

### Google Plus SDK version:
This version has currently been tested against Google Plus SDK 1.5.1

## Integration
1. Copy LRGooglePlusClient into your project
2. Either download (https://developers.google.com/+/mobile/ios/) drag the Google plus libray into your project or - in case of using CocoaPods (http://www.cocoapods.org) add the following line into your PodFile:
	```
		pod 'google-plus-ios-sdk', '~> 1.5'
	```
3. Follow the instructions to create a Google Plus App (Steps 1-3):
	https://developers.google.com/+/mobile/ios/getting-started
4. Write down the Client ID of your specific app from:
	https://code.google.com/apis/console
    Go to the old version -> API Access
5. In the App Delegate add the following:
	- Import LRGooglePlusClient Header:
		```objective-c
			#import "LRGooglePlusClient.h"
		```
    - Start up shared instance with the client ID:
    	```objective-c
        	[[LRGooglePlusClient sharedInstance] setClientID:<client id>];
        ```
    - Add the following method to handle URL scheme and SSO:
    	```objective-c
        	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
			{
			    return [[LRGooglePlusClient sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
			}
        ```
    - If you have more then one URL scheme handling component you can instead use the following snipet to ease integration:
    	```objective-c
            - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
            {
                if ([[LRGooglePlusClient sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation] == NO) {
                    // Add you URL handling code
                } else {
                    return YES;
                }
            }
        ```
And ... That's it - you finished your integration and are ready to start sharing.

## Usage guide
Before going into the sharing methods - you might note there are sign in , sign out and disconnect methods.
While those methods exist to simplify the usage and give you the opertunity to present relevant UI - if you try to share without loging in - it will simply save the share data until a succesful login has happened.

### signIn
Sign in with Google plus method.

### signOut
Sign out current user from Google Plus.

### disconnect
Differes from sign out by also removing the application authorization and completly diconnecting the user from the Google App.

### shareWithURL:andPrefillText:
Share a URL and text.
Note - the description , Title and thumbnail URL are taken from the URL tags themselves.

### sharewithTitle:andDescription:andThumbnailURL:andURL:andPrefillText:
Share with Title , Description , Thumbnail URL , URL and Prefill text.
Do note - the URL information overrides the rest of the fields.

### shareWithDictionary:
This share method is basically here mainly to be used after a sign in.
In case a user tried sharing and was not signed in - The LLGooglePlusClient serializes the sharing info into a dictionary and uses it after a succesfull sign in in order to restore the sharing request.

## Notifications
To simplify understanding the current state of actions and to ease adding various analytics around actions - I created a few notifications to better understand the flow and lifecycle of the Google Plus Client:

### LRGooglePlusShareNotification
This notification is called when the Google Plus share is successfully sent.

### LRGooglePlusDidLoginNotification
This notification is sent when Google Plus did Login.

### LRGooglePlusDidLogoutNotification
This notification is sent when Google Plus did Logout.

### LRGooglePlusDidNotLoginNotification
This notification is sent when Google Plus didn't manage to Login.