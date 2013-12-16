//
//  DRBCookbookProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
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

#import "DRBCookbookProvider.h"
#import "DRBCookbook.h"
#import "AFJSONRequestOperation.h"

@interface DRBCookbookProvider () {
    NSManagedObjectContext *_managedObjectContext;
}
@end

@implementation DRBCookbookProvider

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        _managedObjectContext = context;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(NSString *)cookbookID completion:(void (^)(NSArray *))completion
{
    completion(@[ cookbookID ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSString *)cookbookID
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSString *path = [NSString stringWithFormat:@"http://api.example.com/cookbooks/%@", cookbookID];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DRBCookbook *cookbook = [DRBCookbook cookbookWithJSON:responseObject context:_managedObjectContext];
        continuation(cookbook, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end
