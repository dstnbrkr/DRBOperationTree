//
//  DRBRecipeProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBRecipeProvider.h"
#import "DRBCookbook.h"
#import "DRBRecipe.h"
#import "AFJSONRequestOperation.h"

@implementation DRBRecipeProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(DRBCookbook *)cookbook completion:(void (^)(NSArray *))completion
{
    completion(cookbook.recipeIDs);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node operationForObject:(NSString *)recipeID success:(void (^)(id))success failure:(void (^)())failure
{
    NSString *path = [NSString stringWithFormat:@"http://api.example.com/api/recipes/%@", recipeID];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DRBRecipe *recipe = [DRBRecipe recipeWithJSON:responseObject];
        success(recipe);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end
