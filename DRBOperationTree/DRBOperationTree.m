//
//  DRBOperationTree.m
//
//  Created by Dustin Barker on 12/5/13.
//  Copyright (c) 2013 Dustin Barker (http://github.com/dstnbrkr), Artsy (http://artsy.net). All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "DRBOperationTree.h"

@interface DRBOperationTree ()
@property (nonatomic, strong) NSMutableSet *children;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSCountedSet *retries;
@end

static const NSUInteger kARSyncNodeMaxRetries = 3;

@implementation DRBOperationTree

+ (NSOperationQueue *)defaultOperationQueue
{
    static NSOperationQueue *operationQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue = [[NSOperationQueue alloc] init];
    });
    return operationQueue;
}

+ (DRBOperationTree *)tree
{
    NSOperationQueue *operationQueue = [self defaultOperationQueue];
    return [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
}

- (id)initWithOperationQueue:(NSOperationQueue *)operationQueue
{
    if ((self = [super init])) {
        _operationQueue = operationQueue;
        _children = [NSMutableSet set];
        _retries = [NSCountedSet set];
    }
    return self;
}

- (void)addChild:(DRBOperationTree *)node
{
    [self.children addObject:node];
}

- (void)sendObject:(id)object completion:(void(^)())completion
{
    if(_children.count == 0 && completion){
        dispatch_sync(dispatch_get_main_queue(), completion);
        return;
    }

    dispatch_group_t group = dispatch_group_create();
    for (DRBOperationTree *child in _children) {
        dispatch_group_enter(group);
        [child enqueueOperationsForObject:object completion:^{
            dispatch_group_leave(group);
        }];
    }
    
    // the completion block will be called after all child nodes have called their completion block
    dispatch_group_notify(group, dispatch_get_main_queue(), completion);
}

- (void)enqueueOperationForObject:(id)object dispatchGroup:(dispatch_group_t)group
{
    dispatch_group_enter(group);
    NSOperation *operation = [self.provider operationTree:self
                                       operationForObject:object
                                             continuation:^(id result, void(^completion)()) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [self sendObject:result completion:^{
                                                         
                                                         // call the completion block associated with this node
                                                         if (completion) completion();
                                                         
                                                         dispatch_group_leave(group);
                                                     }];
                                                 });
                                             }
                                                  failure:^{
                                                      [_retries addObject:object];
                                                      
                                                      // retry failed operations
                                                      if ([_retries countForObject:object] < kARSyncNodeMaxRetries) {
                                                          [self enqueueOperationForObject:object dispatchGroup:group];
                                                      }
                                                      
                                                      dispatch_group_leave(group);
                                                  }];
    [self.operationQueue addOperation:operation];
}

- (void)enqueueOperationsForObject:(id)object completion:(void(^)())completion
{
    [self.provider operationTree:self objectsForObject:object completion:^(NSArray *objects) {
        dispatch_group_t group = dispatch_group_create();
        
        for (id object in objects) {
            [self enqueueOperationForObject:object dispatchGroup:group];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), completion);
    }];
}

@end
