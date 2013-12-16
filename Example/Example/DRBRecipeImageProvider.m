//
//  DRBRecipeImageProvider.m
//  Example
//
//  Created by Dustin Barker on 12/15/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBRecipeImageProvider.h"
#import "DRBRecipe+Example.h"
#import "AFImageRequestOperation.h"

@implementation DRBRecipeImageProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(DRBRecipe *)recipe completion:(void (^)(NSArray *))completion
{
    NSURL *URL = [NSURL URLWithString:recipe.imagePath];
    completion(@[ @[ URL, recipe.imageFilePath ] ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(NSArray *)params
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSURL *URL = params[0];
    NSString *filePath = params[1];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    return [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                imageProcessingBlock:nil
                                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                 [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                                                                 continuation(image, nil);
                                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                 failure();
                                                             }];
}

@end
