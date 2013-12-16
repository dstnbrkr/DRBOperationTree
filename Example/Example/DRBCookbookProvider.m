//
//  DRBCookbookProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

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
                       success:(void (^)(id))success
                       failure:(void (^)())failure
{
    NSString *path = [NSString stringWithFormat:@"http://api.example.com/cookbooks/%@", cookbookID];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DRBCookbook *cookbook = [DRBCookbook cookbookWithJSON:responseObject context:_managedObjectContext];
        success(cookbook);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end
