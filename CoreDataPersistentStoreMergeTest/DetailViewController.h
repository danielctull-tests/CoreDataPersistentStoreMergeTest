//
//  DetailViewController.h
//  CoreDataPersistentStoreMergeTest
//
//  Created by Daniel Tull on 28/03/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
