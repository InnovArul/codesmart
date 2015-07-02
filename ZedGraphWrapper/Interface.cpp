/* ***************************************************************************************************** */
/*                                                                                                                                              */
/*  							   Copyright (c) 2015  Robert Bosch  																	*/
/*                                 India                                                                                                      */
/*                                 All rights reserved                                                                                 */
/*                                                                                                                                               */
/**********************************************************************************************************
$Source: ZedGraphLib/ZedGraphWrapper/Interface.cpp $
$Revision: 1.1 $
$Author: Arulkumar S (RBEI/ESP2) (ASR2COB) $
$State: develop $
$Date: 2015/03/05 15:01:25IST $

History:

$Log: ZedGraphLib/ZedGraphWrapper/Interface.cpp  $
Revision 1.1 2015/03/05 15:01:25IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
Revision 1.1 2015/02/17 19:11:21IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
*********************************************************************************************************/

#include "Interface.h"
#include "XYGraph.h"

int __stdcall StartGraph(char* caName, char* caXAxisName, char* caYAxisName) 
{
    XYGraph::getInstance()->StartGraph(caName, caXAxisName, caYAxisName);
    return 0;
}

int __stdcall AppendPoints(char* caLabel, double* dXPoints, double* dYPoints, int nCount, char* caColor)
{
    XYGraph::getInstance()->AppendPoints(caLabel, dXPoints, dYPoints, nCount, caColor);
    return 0;
}

int __stdcall AppendPoint(char* caLabel, double dXvalue, double dYvalue)
{
    XYGraph::getInstance()->AppendPoint(caLabel, dXvalue, dYvalue);
    return 0;
}

int __stdcall PublishGraph(char* caFilePath)
{
    XYGraph::getInstance()->PublishGraph(caFilePath);
    return 0;
}

int __stdcall DiscardGraph()
{
    XYGraph::getInstance()->DiscardGraph();
    return 0;
}