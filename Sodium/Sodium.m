//
//  Sodium.m
//  Sodium
//
// Created by Paulo Andrade on 08/03/2019.
// Copyright © 2019 Outer Corner. All rights reserved.
//


extern int sodium_init(void);

__attribute__((constructor))
static void SodiumInit()
{
    sodium_init();
}
