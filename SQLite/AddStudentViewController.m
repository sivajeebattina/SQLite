//
//  AddStudentViewController.m
//  SQLite
//
//  Created by pcs20 on 9/22/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import "AddStudentViewController.h"
#import "Student.h"
#import "StudentDetailsTableViewController.h"

@interface AddStudentViewController ()

@end

@implementation AddStudentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self getStudentsDetails];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
   
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    
    [_studentAgeTF resignFirstResponder];
    return YES;

}

-(IBAction)saveButtonClicked:(id)sender{

    NSString *dbFilePath =[self getDBFileFromDocumentDirectory];
    const char *dbUtfString = [dbFilePath UTF8String];
    if (sqlite3_open(dbUtfString, &database)==SQLITE_OK)
    {
       
        NSString *name = _studentNameTF.text;
        NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        NSString *deparment = _studentDepartmentTF.text;
        NSString *age = _studentAgeTF.text;
       
        
        NSString *insertQuery = [NSString stringWithFormat:@"Insert Into Student Values('%@','%@','%@',%d)",name,timestamp,deparment,[age intValue]];
        const char *queryUtf8 = [insertQuery UTF8String];
        sqlite3_stmt *statment;
        if (sqlite3_prepare(database, queryUtf8, -1, &statment, NULL)==SQLITE_OK )
        {
            if (sqlite3_step(statment)==SQLITE_DONE)
            {
                NSLog(@"Inserted Scussessfully");
                [self.firstDelegate updateData];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                NSAssert1(0, @"Error Description", sqlite3_errmsg(database));
            }
        }
        sqlite3_finalize(statment);
    }
    sqlite3_close(database);
    
}

-(NSString *)getDBFileFromDocumentDirectory{
    
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbpath=[pathArray objectAtIndex:0];
    dbpath=[dbpath stringByAppendingPathComponent:@"StudentDB.sqlite"];
    
    return dbpath;
    
}






@end
