//
//  DRBRecipeProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBRecipeProvider.h"
#import "DRBCookbook.h"
#import "DRBRecipe+Example.h"
#import "AFJSONRequestOperation.h"

@interface DRBRecipeProvider () {
    NSManagedObjectContext *_managedObjectContext;
}
@end

@implementation DRBRecipeProvider

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    if ((self = [super init])) {
        _managedObjectContext = context;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(DRBCookbook *)cookbook completion:(void (^)(NSArray *))completion
{
    completion(cookbook.recipeIDs);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSString *)recipeID
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSString *path = [NSString stringWithFormat:@"http://api.example.com/recipes/%@", recipeID];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        context.parentContext = _managedObjectContext;
        DRBRecipe *recipe = [DRBRecipe recipeWithJSON:responseObject context:context];
                             
        continuation(recipe, ^{
            [context performBlock:^{
                [context save:nil];
            }];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
    }];
    return operation;
}

@end
