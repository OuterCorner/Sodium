//
//  AppDelegate.m
//  Sample iOS
//
// Created by Paulo Andrade on 09/03/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "AppDelegate.h"
#import <Sodium/Sodium.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    int ret = sodium_init();
    if (ret == 1) {
        NSLog(@"Note sodium_init() returns 1 when the library is already initialized. This happens because the Sodium.framework already initiliazes sodium on load");
    }
    
    NSString *message = @"test";
    NSUInteger mlen = [message length] + 1 /*to account for \0*/;
    NSUInteger clen = mlen + crypto_secretbox_MACBYTES;
    unsigned char key[crypto_secretbox_KEYBYTES];
    unsigned char nonce[crypto_secretbox_NONCEBYTES];
    unsigned char ciphertext[clen];
    
    crypto_secretbox_keygen(key);
    randombytes_buf(nonce, sizeof(nonce));
    crypto_secretbox_easy(ciphertext, (const unsigned char *)[message cStringUsingEncoding:NSASCIIStringEncoding], mlen, nonce, key);
    
    unsigned char decrypted[mlen];
    if (crypto_secretbox_open_easy(decrypted, ciphertext, clen, nonce, key) != 0) {
        /* message forged! */
        exit(1);
    }
    
    NSLog(@"%s", decrypted);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
