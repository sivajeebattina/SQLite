//
//  StudentDetailsViewController.h
//  SQLite
//
//  Created by pcs20 on 9/22/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Student.h"

@protocol gotoStudentTable <NSObject>

@required

-(void)updateData;

@end



@interface StudentDetailsViewController : UIViewController<UITextFieldDelegate>{

    sqlite3 *database;
    

}

@property(nonatomic,strong)IBOutlet UITextField *studentName;
@property(nonatomic,strong)IBOutlet UITextField *studentID;
@property(nonatomic,strong)IBOutlet UITextField *studentDepartment;
@property(nonatomic,strong)NSString *identification;
@property(nonatomic,weak)id<gotoStudentTable>secondDelegate;


@property(nonatomic,strong)IBOutlet UIButton *editButton;

@property(nonatomic,strong)IBOutlet UITextField *studentAge;


-(IBAction)editButtonClicked:(id)sender;



@end
