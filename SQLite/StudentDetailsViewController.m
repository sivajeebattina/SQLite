//
//  StudentDetailsViewController.m
//  SQLite
//
//  Created by pcs20 on 9/22/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import "StudentDetailsViewController.h"

@interface StudentDetailsViewController ()

@end

@implementation StudentDetailsViewController

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
    
    _studentID.text=_identification;
    [_studentName setEnabled:NO];
    [_studentID setEnabled:NO];
    [_studentDepartment setEnabled:NO];
    [_studentAge setEnabled:NO];

    
    [self getStudentsDetails];
    
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getStudentsDetails
{
    
    NSString *dbFilePath =[self getDBFileFromDocumentDirectory];
    const char *dbUtfString = [dbFilePath UTF8String];
    if (sqlite3_open(dbUtfString, &database)==SQLITE_OK)
    {
        NSString *selectQuery = [NSString stringWithFormat:@"Select * from  Student where StudentID='%@'",_identification];
        const char *queryUtf8 = [selectQuery UTF8String];
        sqlite3_stmt *statment;
        if (sqlite3_prepare(database, queryUtf8, -1, &statment, NULL)==SQLITE_OK )
        {
            
            
             while (sqlite3_step(statment)==SQLITE_ROW){
                Student *studentOBj = [[Student alloc] init];
                studentOBj.studentName =[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statment, 0)];
                studentOBj.studentID= [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 1)];
                 studentOBj.studentDepartment=[NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 2)];
                 studentOBj.studentAge=[NSString stringWithFormat:@"%d",sqlite3_column_int(statment, 3)];

                 
                 _studentName.text=studentOBj.studentName;
                 _studentID.text=studentOBj.studentID;
                 _studentDepartment.text=studentOBj.studentDepartment;
                 _studentAge.text=studentOBj.studentAge;
                 
            
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
