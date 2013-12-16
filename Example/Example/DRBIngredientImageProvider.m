//
//  DRBIngredientImageProvider.m
//  Example
//
//  Created by Dustin Barker on 12/16/13.
//  Copyright (c) 2013 dstnbrkr. All rights reserved.
//

#import "DRBIngredientImageProvider.h"
#import "DRBIngredient.h"
#import "AFImageRequestOperation.h"

@implementation DRBIngredientImageProvider

- (void)operationTree:(DRBOperationTree *)node objectsForObject:(DRBIngredient *)ingredient completion:(void (^)(NSArray *))completion
{
    NSURL *URL = [NSURL URLWithString:ingredient.imagePath];
    completion(@[ @[ URL, ingredient.imageFilePath ] ]);
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
