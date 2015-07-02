/* ***************************************************************************************************** */
/*                                                                                                                                              */
/*  							   Copyright (c) 2015  Robert Bosch  																	*/
/*                                 India                                                                                                      */
/*                                 All rights reserved                                                                                 */
/*                                                                                                                                               */
/**********************************************************************************************************
$Source: ZedGraphLib/ZedGraphWrapper/ErrorCodes.cpp $
$Revision: 1.1 $
$Author: Arulkumar S (RBEI/ESP2) (ASR2COB) $
$State: develop $
$Date: 2015/03/05 15:01:22IST $

History:

$Log: ZedGraphLib/ZedGraphWrapper/ErrorCodes.cpp  $
Revision 1.1 2015/03/05 15:01:22IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
Revision 1.1 2015/02/17 19:11:19IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
*********************************************************************************************************/


#include "ErrorCodes.h"


ErrorCodes::ErrorCodes(void)
{
}

String^ ErrorCodes::getErrorString(int nErrorCode)
{
	if(m_dictErrorCodes->ContainsKey(nErrorCode) == false)
	{
		return "No error description found!";
	}

	return m_dictErrorCodes[nErrorCode];
}


/**
@brief to store a programmer-defined error string at runtime
used to handle exceptions

@param[in]  nErrorCode -  error code
@param[in]  strAdditionalInfo -  additional info to be associated with the error code description

@return ERROR_DLL_DYNAMIC_ERROR
*/
int ErrorCodes::setDynamicError(int nErrorCode, String^ strAdditionalInfo)
{
    return setDynamicError(nErrorCode + ": " + getErrorString(nErrorCode) + " (" + strAdditionalInfo + ")");
}

/**
@brief to store a programmer-defined error string at runtime
used to handle exceptions

@param[in]  strDynamicErrorText -  error text to be stored

@return ERROR_DLL_DYNAMIC_ERROR
*/

int ErrorCodes::setDynamicError(String^ strDynamicErrorText)
{
	int nStatus = ERROR_DLL_DYNAMIC_ERROR;
	m_dictErrorCodes[ERROR_DLL_DYNAMIC_ERROR] = strDynamicErrorText;
	return nStatus;
}

/**
@brief to store a programmer-defined error string at runtime
used to handle exceptions

@param[in]  strDynamicErrorText -  error text to be stored

@return ERROR_DLL_DYNAMIC_ERROR
*/
int ErrorCodes::setDynamicError(String^ strEntityName, String^ strFileName)
{
	return setDynamicError(strEntityName + " not defined in file " + strFileName);
}

/**
@brief to store a programmer-defined error string at runtime
used to handle exceptions

@param[in]  strDynamicErrorText -  error text to be stored

@return ERROR_DLL_DYNAMIC_ERROR
*/
int ErrorCodes::setDynamicError(String^ strEntityName, char* caFileName)
{
	return setDynamicError(strEntityName + " not defined in file " + gcnew String(caFileName));
}


/**
@brief to give the error message for API/configuration unavailability in a file

@param[in]  caEntityName -  API/config parameter name
@param[in]  caFileName - File name

@return ERROR_DLL_DYNAMIC_ERROR
*/
int ErrorCodes::setDynamicError(char* caEntityName, char* caFileName)
{
	return setDynamicError(gcnew String(caEntityName) + " not defined in file " + gcnew String(caFileName));
}
