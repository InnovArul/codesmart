
/* ***************************************************************************************************** */
/*                                                                                                                                              */
/*  							   Copyright (c) 2015  Robert Bosch  																	*/
/*                                 India                                                                                                      */
/*                                 All rights reserved                                                                                 */
/*                                                                                                                                               */
/**********************************************************************************************************
$Source: ZedGraphLib/ZedGraphWrapper/Interface.h $
$Revision: 1.2 $
$Author: Arulkumar S (RBEI/ESP2) (ASR2COB) $
$State: develop $
$Date: 2015/05/22 12:09:13IST $

History:

$Log: ZedGraphLib/ZedGraphWrapper/Interface.h  $
Revision 1.2 2015/05/22 12:09:13IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
comments added about DO_NOT_DEFINE_EXTERN_DECLARATION preprocessor declaration
Revision 1.1 2015/03/05 15:01:27IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
Revision 1.1 2015/02/17 19:11:22IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
*********************************************************************************************************/

#pragma once
#include <windows.h>
#include <stdio.h>

static char *pcaDllFilePath = NULL;
static HMODULE hDllHandle = NULL;

#define CONCAT(str1, str2) str1##str2
#define CONCAT2(str1, str2) CONCAT(str1, str2)

#define _CALLING_CONVENTION  __stdcall
#define CWRAPPER_PREFIX  CW_
#define DLL_FILENAME    ".\\ZedGraphWrapper.dll"

#ifdef DO_NOT_DEFINE_EXTERN_DECLARATION
// DO_NOT_DEFINE_EXTERN_DECLARATION = if it is defined, then it acts as in DLL project
// All DECL_FUNC have return type XLstatus
#define DECL_FUNC(returntype, apiname, args)    \
    returntype _CALLING_CONVENTION apiname args

#else // DO_NOT_DEFINE_EXTERN_DECLARATION
// DO_NOT_DEFINE_EXTERN_DECLARATION = if it is not defined, then it acts as in Perl XS project
#define DECL_FUNC(returntype, apiname, args)    \
    typedef returntype (_CALLING_CONVENTION *apiname) args; \
    /* double indirection (CONCAT2 --> CONCAT) to expand the macro CWRAPPER_PREFIX */ \
    returntype CONCAT2(CWRAPPER_PREFIX,apiname) args; \
    static apiname fp##apiname

#endif // DO_NOT_DEFINE_EXTERN_DECLARATION


#define CREATE_C_WRAPPER(returntype, apiname, argsWithType, argsWithoutType) \
     /* double indirection (CONCAT2 --> CONCAT) to expand the macro CWRAPPER_PREFIX */ \
    returntype CONCAT2(CWRAPPER_PREFIX,apiname) argsWithType  \
    { \
        if(iINITstate == ciINITok)	 return(fp##apiname argsWithoutType); \
            else return(-10); \
    }

#define FUNC_LOAD(apiname)\
    fp##apiname = (apiname)GetProcAddress(hDllHandle, #apiname); \
    if(fp##apiname == NULL) { iStatus = -2;printf("CW " #apiname ": %d\n",iStatus); }


DECL_FUNC(int, StartGraph, (char* caName, char* caXAxisName, char* caYAxisName));
DECL_FUNC(int, AppendPoints, (char* caLabel, double* dXPoints, double* dYPoints, int nCount, char* caColor));
DECL_FUNC(int, AppendPoint, (char* caLabel, double dXvalue, double dYvalue));
DECL_FUNC(int, PublishGraph, (char* caFilePath));
DECL_FUNC(int, DiscardGraph, ());
