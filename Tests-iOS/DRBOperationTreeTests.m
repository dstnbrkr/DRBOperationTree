//
//  DRBOperationTreeTests.m
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

#import <XCTest/XCTest.h>
#import "XCTestCase+SRTAdditions.h"
#import "DRBOperationTree.h"

@interface DRBOperationTestProvider : NSObject<DRBOperationProvider>
@property (nonatomic, readonly) id object;
@end

@interface DRBOperationFailingProvider : NSObject<DRBOperationProvider>
@property (nonatomic, readonly) NSUInteger retryCount;
@end

@interface DRBOperationTreeTests : XCTestCase
@end

@implementation DRBOperationTreeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testEnqueueOperationWithSingleNode
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    DRBOperationTree *node = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    DRBOperationTestProvider *delegate = [[DRBOperationTestProvider alloc] init];
    node.provider = delegate;
    
    id object = @"foo";
    
    __block BOOL completed = NO;
    [node enqueueOperationsForObject:object completion:^{ completed = YES; }];
    
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return completed == YES;
    } timeout:1];
    
    XCTAssert([delegate.object isEqual:object], @"Expected delegate to be completed");
}

- (void)testSendObjectWithSingleNode
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    DRBOperationTree *node = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    DRBOperationTestProvider *delegate = [[DRBOperationTestProvider alloc] init];
    node.provider = delegate;
    
    __block BOOL completed = NO;
    [node sendObject:nil completion:^{ completed = YES; }];
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return completed == YES;
    } timeout:1];
}

- (void)testSendObjectWithChildren
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];

    DRBOperationTree *root = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    DRBOperationTree *child1 = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    DRBOperationTree *child2 = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    
    DRBOperationTestProvider *child1Delegate = [[DRBOperationTestProvider alloc] init];
    DRBOperationTestProvider *child2Delegate = [[DRBOperationTestProvider alloc] init];
    
    child1.provider = child1Delegate;
    child2.provider = child2Delegate;
    
    [root addChild:child1];
    [root addChild:child2];

    __block BOOL completed = NO;
    [root sendObject:@"foo" completion:^{
        XCTAssert(child1Delegate.object, @"Expected child 1 to be completed");
        XCTAssert(child2Delegate.object, @"Expected child 2 to be completed");
        completed = YES;
    }];
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return completed;
    } timeout:1];
}

- (void)testCompletionWithGrandchildren
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];

    DRBOperationTree *root = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    DRBOperationTree *child1 = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    DRBOperationTree *child2 = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    DRBOperationTree *grandchild1 = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    DRBOperationTree *grandchild2 = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    
    DRBOperationTestProvider *grandchild1Delegate = [[DRBOperationTestProvider alloc] init];
    DRBOperationTestProvider *grandchild2Delegate = [[DRBOperationTestProvider alloc] init];
    
    child1.provider = [[DRBOperationTestProvider alloc] init];
    child2.provider = [[DRBOperationTestProvider alloc] init];
    grandchild1.provider = grandchild1Delegate;
    grandchild2.provider = grandchild2Delegate;
    
    [root addChild:child1];
    [root addChild:child2];
    [child1 addChild:grandchild1];
    [child2 addChild:grandchild2];
    
    __block BOOL completed = NO;
    [root sendObject:@"foo" completion:^{
        XCTAssert(grandchild1Delegate.object, @"Expected grandchild 1 to be completed");
        XCTAssert(grandchild2Delegate.object, @"Expected grandchild 2 to be completed");
        completed = YES;
    }];
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return completed == YES;
    } timeout:1];
}

- (void)testRetry
{
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];

    DRBOperationFailingProvider *provider = [[DRBOperationFailingProvider alloc] init];
    DRBOperationTree *tree = [[DRBOperationTree alloc] initWithOperationQueue:operationQueue];
    tree.provider = provider;
    
    __block BOOL completed = NO;
    [tree enqueueOperationsForObject:@"foo" completion:^{
        completed = YES;
    }];
    
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return completed == YES;
    } timeout:10];
    
    XCTAssertEqual(provider.retryCount, 3U, @"Expected 3 retries");
}

@end

@implementation DRBOperationTestProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    completion(@[ object ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node operationForObject:(id)object success:(void (^)(id result))success failure:(void (^)())failure
{
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        _object = object;
    }];
    operation.completionBlock = ^{ success(object); };
    return operation;
}

@end

@implementation DRBOperationFailingProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    completion(@[ object ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node operationForObject:(id)object success:(void (^)(id result))success failure:(void (^)())failure
{
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        _retryCount++;
    }];
    operation.completionBlock = failure;
    return operation;
}

@end

