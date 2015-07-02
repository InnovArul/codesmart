/* ***************************************************************************************************** */
/*                                                                                                                                              */
/*  							   Copyright (c) 2015  Robert Bosch  																	*/
/*                                 India                                                                                                      */
/*                                 All rights reserved                                                                                 */
/*                                                                                                                                               */
/**********************************************************************************************************
$Source: ZedGraphLib/ZedGraphWrapper/ErrorCodes.h $
$Revision: 1.1 $
$Author: Arulkumar S (RBEI/ESP2) (ASR2COB) $
$State: develop $
$Date: 2015/03/05 15:01:23IST $

History:

$Log: ZedGraphLib/ZedGraphWrapper/ErrorCodes.h  $
Revision 1.1 2015/03/05 15:01:23IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
Revision 1.1 2015/02/17 19:11:20IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
*********************************************************************************************************/

#pragma once

#pragma once
using namespace System::Collections::Generic;
using namespace System;

#define BREAK_ON_NEGATIVE_STATUS(status)	if((status) < 0) break
#define RETURN_ON_NEGATIVE_STATUS(status)	if((status) < 0) return (status)

static enum
{
    ERROR_DLL_CANNOT_WRITE_IMAGE						 	=	-11,
    ERROR_DLL_GRAPH_NOT_STARTED						 	=	-12,

    NEGATIVE_ERROR							=   -1,
    ERROR_DLL_DYNAMIC_ERROR					=	-500,
};

ref class ErrorCodes
{
    ErrorCodes(void);
    static Dictionary<int, String^>^ m_dictErrorCodes;

    static ErrorCodes()
    {
        m_dictErrorCodes = gcnew Dictionary<int, String^>();

        m_dictErrorCodes[ERROR_DLL_CANNOT_WRITE_IMAGE]						= "Error in writing the image file : check if Destination Directory exists and have write access";
        m_dictErrorCodes[ERROR_DLL_GRAPH_NOT_STARTED]						= "Graph is not started usinjg StartGraph() API";
        m_dictErrorCodes[NEGATIVE_ERROR]										= "Negative status. unknown error";
        m_dictErrorCodes[ERROR_DLL_DYNAMIC_ERROR]								= "Dynamic error or exception occured!";

    }

public:
    static String^ getErrorString(int nErrorCode);
    static int setDynamicError(int nErrorCode, String^ strAdditionalInfo);
    static int setDynamicError(String^ strDynamicErrorText);
    static int setDynamicError(String^ strEntityName, String^ strFileName);
    static int setDynamicError(String^ strEntityName, char* caFileName);
    static int setDynamicError(char* caEntityName, char* caFileName);
};
