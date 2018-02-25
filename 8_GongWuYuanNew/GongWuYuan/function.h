//
//  function.h
//  iNotePlus
//
//  Created by 金 柯 on 13-11-27.
//
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
extern BOOL g_isFirstTimeOpenApp;
extern int  g_nDueRepeat ;
extern int  g_applicationIconBadgeNumber;
extern int  command;
extern BOOL g_isDBlinked;

//-----
extern int g_usedTimeSeconds;
//-----


/*typedef enum  // used for SubjectViewController to get subject
{
	enumTestPaperType = 0, //self.testPaperID, self.subjectId
    enumSubjectType = 1,  // random choose subject
} SubjectViewEnum;*/

typedef enum // used for SubjectViewController to get subject by type
{
	enumTrueSubjectType = 0,
    enumSimulatedSubjectType = 1,
    enumSpecializedTrainingType = 2,
    enumWrongSetType = 3,
    enumMyCollectionType = 4,
} FunctionTypeEnum;

enum DropboxOp
{
    KDBXNOOP = 0,
    KDBXSETDIR,
    KDBXREMOVE,
    KDBXDOWNLOAD,
    KDBXUPLOAD,
    KDBXLISTFILES
};
//---------------------------
extern NSArray* g_arrayColors;
extern NSMutableArray* g_arrayColorNames;
//==========================================
NSString * getTimeStrFromSec(int Seconds);
//------------------
NSString * applicationDocumentsDirectory();
NSString * getLocalPlistFilePath(int bWorkOrLife);
//---dropbox sync api----
//BOOL saveTolocalPlist(NSMutableArray * notesArray, int bWorkOrLife);
//BOOL uploadFile(DBFile * dbFile, int bWorkOrLife);
//----
NSString * getTheFunctionTypeByEnum(FunctionTypeEnum enumFuncType);

//------
void popShareActivityView(UIViewController * viewCrl, NSString* str, NSMutableArray * arrImages);

NSUInteger REDeviceSystemMajorVersion();
BOOL REDeviceIsUIKit7();
void removeNoticationByDueDate(NSString * strID);
void setNotification(NSDate * firedate, NSString * alertBody, UILocalNotification * notification);
BOOL isDateSame(NSDate * date1, NSDate* date2);
void setDueRpeat(int repeatType);

//=============datebase==========================================================
sqlite3 * openDB();
void closeDB(sqlite3 *database);
void getTestPapersByTypeFromTestpaperup(NSMutableArray * exaPaperNameArray, FunctionTypeEnum itemIndex);

void getSubjectFromProlemupTable(NSMutableArray * arrLayoutContent, int testPaperID, int subjectId);

int  getSubjectCountFromProlemupTable();

int  getSubjectCountByTypeFromProlemupTable(NSString* typeStr);
void getSubjectByPidAndTypeFromProlemupTable(NSMutableArray * arrLayoutContent, NSString* typeStr,int pid, FunctionTypeEnum enumType);

int  getSubjectCountByTestpaperIDFromProblemup(int testPaperID);

int  getSubjectTypeCount(NSString * subjectTypeStr);
int  getSubjectByTypeAndStatusCount(NSString * subjectTypeStr, NSString * statusStr);
int  getSubjectByTypeAndFavoriteCount(NSString * subjectTypeStr);


NSString* getUsedTimeFromtestup(int testPaperID);

void initializeDatebase(int testPaperID);
int  largestFinishedSubjectID(int testPaperID);


void updateStatusInProblemTB(NSString *status, NSNumber *problemID);
void updateCustomerAnswer(NSMutableString *customerAnswer, NSNumber *problemID);
void updateFavoriteToProblemupTB(NSNumber *problemID, NSNumber* Favorite);







