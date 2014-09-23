//
//  AddStudentViewController.h
//  SQLite
//
//  Created by pcs20 on 9/22/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@protocol gotoStudentTable <NSObject>

@required

-(void)updateData;

@end


@interface AddStudentViewController : UIViewController<UITextFieldDelegate>{

    sqlite3 *database;

}

@property(nonatomic,strong)IBOutlet UITextField *studentNameTF;
@property(nonatomic,strong)IBOutlet UITextField *studentDepartmentTF;
@property(nonatomic,strong)IBOutlet UITextField *studentAgeTF;
@property(nonatomic,strong)IBOutlet UIButton *saveButton;
@property(nonatomic,weak)id<gotoStudentTable>firstDelegate;


- (BOOL)textFieldShouldReturn:(UITextField *)textField;
-(NSString *)getDBFileFromDocumentDirectory;
-(NSString *)getDBFileFromAppBundle;
-(void)copyDatabaseBundleToDocument;
-(IBAction)saveButtonClicked:(id)sender;

@end
