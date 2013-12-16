//
//  DRBOperationTree.h
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

#import <Foundation/Foundation.h>

@class DRBOperationTree;

/**
 `DRBOperationProvider` is the interface `DRBOperationTree` interacts with to determine what work needs to be performed in a node.
 
 An object that implements `DRBOperationProvider` is responsible for:
 - mapping an input object to one or more output objects
 - mapping each output object to an NSOperation
 */
@protocol DRBOperationProvider <NSObject>

/**
 Maps an input object to one or more output objects.
 */
- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void(^)(NSArray *objects))completion;

/**
 Maps an output object to an operation.
 
 The operation is responsible for calling `continuation`, which will allow tree proccessing to continue.
 */
- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(id)object
                  continuation:(void(^)(id object, void(^completion)()))continuation
                       failure:(void(^)())failure;

@end

/**
 `DRBOperationTree` is an iOS and OSX API to organize NSOperations into a tree.
 
 Each node's output becomes the input for its child nodes.
 */
@interface DRBOperationTree : NSObject

/**
 Convenience constructor to return a `DRBOperationTree` initialized with the default NSOperationQueue.
 */
+ (DRBOperationTree *)tree;

/**
 Initializes a `DRBOperationTree` with a specific NSOperationQueue
 */
- (id)initWithOperationQueue:(NSOperationQueue *)operationQueue;

/**
 Passes an object to it's child nodes. Completion is called when the level order traversal of all child nodes is complete.
 */
- (void)sendObject:(id)object completion:(void(^)())completion;

/**
 Adds a child node to the node.
 */
- (void)addChild:(DRBOperationTree *)node;

/**
 Maps an input object to output objects and enqueue the corresponding NSOperations for each.
 */
- (void)enqueueOperationsForObject:(id)object completion:(void(^)())completion;

/**
 The `DRBOperationProvider` responsible for mapping input objects to output objects and object to operations.
 */
@property (nonatomic, strong) id<DRBOperationProvider> provider;

/**
 The NSOperationQueue associated with this node
 */
@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;

@end
