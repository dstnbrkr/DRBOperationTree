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

@implementation DRBCookbookProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    // noop
}

- (NSOperation *)operationTree:(DRBOperationTree *)node operationForObject:(NSString *)cookbookID success:(void (^)(id))success failure:(void (^)())failure
{
    NSString *path = [NSString stringWithFormat:@"http://api.example.com/api/cookbooks/%@", cookbookID];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DRBCookbook *cookbook = [DRBCookbook cookbookWithJSON:responseObject];
        success(cookbook);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end
