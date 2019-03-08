//
//  AppDelegate.m
//  Sample Mac
//
// Created by Paulo Andrade on 08/03/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

#import "AppDelegate.h"
#import <Sodium/Sodium.h>


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
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
}



@end
