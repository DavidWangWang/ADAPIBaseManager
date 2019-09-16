//
//  ADServiceFactory.m
//  ADAPIBaseManager
//
//  Created by David on 2019/9/16.
//  Copyright © 2019年 ADIOS. All rights reserved.
//

#import "ADServiceFactory.h"
#import <CTMediator/CTMediator.h>

@interface ADServiceFactory()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation ADServiceFactory

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static ADServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ADServiceFactory alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (id<ADServiceProtocol>)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

- (id <ADServiceProtocol>)newServiceWithIdentifier:(NSString *)identifier
{
    return [[CTMediator sharedInstance] performTarget:identifier action:identifier params:nil shouldCacheTarget:NO];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}


@end
