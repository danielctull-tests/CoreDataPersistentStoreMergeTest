//
//  ViewController.h
//  CoreDataPersistentStoreMergeTest
//
//  Created by Daniel Tull on 28/03/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

@import UIKit;
@import CoreData;

@interface CDPSMTViewController : UITableViewController
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end
