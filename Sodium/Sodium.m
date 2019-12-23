//
//  Sodium.m
//  Sodium
//
// Created by Paulo Andrade on 08/03/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//

@import CSodium;

extern int sodium_init(void);

__attribute__((constructor))
static void SodiumInit()
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-result"
    sodium_init();
#pragma clang diagnostic pop
}
