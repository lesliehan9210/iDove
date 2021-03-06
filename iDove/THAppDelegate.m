//
//  THAppDelegate.m
//  iDove
//
//  Created by Taagoo'iMac on 14-7-23.
//  Copyright (c) 2014年 Taagoo. All rights reserved.
//

#import "THAppDelegate.h"

#import "WeiboSDK.h"

#import "LHWbAccount.h"

#import "THTabBarController.h"

#import "RequestData.h"

#import "LoginViewController.h"


@interface THAppDelegate () <WeiboSDKDelegate>


@end


@implementation THAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:kAppKey];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    

    LHWbAccount *account = [LHWbAccount readUserInfoFromDocuments];
    
    if (account.userId) {
        
        THTabBarController * tabbarViewController = [[THTabBarController alloc] initWithNibName:nil bundle:nil];
        
        self.window.rootViewController = tabbarViewController;
        
    }else {
        
        LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        
        self.window.rootViewController = loginVC;
        
    }
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}




-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{

    
    
}


-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        
        if (!response.userInfo) {
            
            
        }else{
        
            WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
            
            
            NSDictionary *parameters = @{@"uid": authResponse.userID,@"access_token":authResponse.accessToken};
            
            
            [RequestData getRequest:parameters WithRequestUrlString:url_user message:^(NSDictionary *dict, NSString *success, NSString *failure) {
                if (dict) {
                    LHWbAuthentication *authentication = [[LHWbAuthentication alloc]initWithAuthorizeID:authResponse.userID accessToken:authResponse.accessToken expirationDate:authResponse.expirationDate AppKey:kAppKey appSecret:kAppSecret];
                    
                    LHUser *user = [[LHUser alloc]initWithJsonDictionary:dict];
                    
                    LHWbAccount * wbAccount = [[LHWbAccount alloc]initWithAuthentication:authentication user:user];
                    
                    [wbAccount writeUserInfoToDocuments];
                    
                    
                    THTabBarController * tabbarViewController = [[THTabBarController alloc] initWithNibName:nil bundle:nil];
                    
                    self.window.rootViewController = tabbarViewController;
                    
                }
                else{
                    NSLog(@"%@",failure);
                }
                
            }];

            
        }
  
    }
    
    
}



@end
