//
//  StudentDetailsTableViewController.h
//  SQLite
//
//  Created by pcs20 on 9/22/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Student.h"

@interface StudentDetailsTableViewController : UITableViewController{

    sqlite3 *database;

}
@property(nonatomic,strong)Student *studentObject;
@property(nonatomic,strong)NSString *studentName;

-(void)updateData;
    

@end
