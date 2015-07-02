/* ***************************************************************************************************** */
/*                                                                                                                                              */
/*  							   Copyright (c) 2015  Robert Bosch  																	*/
/*                                 India                                                                                                      */
/*                                 All rights reserved                                                                                 */
/*                                                                                                                                               */
/**********************************************************************************************************
$Source: ZedGraphLib/ZedGraphWrapper/XYGraph.h $
$Revision: 1.1 $
$Author: Arulkumar S (RBEI/ESP2) (ASR2COB) $
$State: develop $
$Date: 2015/03/05 15:01:34IST $

History:

$Log: ZedGraphLib/ZedGraphWrapper/XYGraph.h  $
Revision 1.1 2015/03/05 15:01:34IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
Revision 1.1 2015/02/17 19:11:25IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
*********************************************************************************************************/

#pragma once
#include "ErrorCodes.h"

using namespace System;
using namespace System::Drawing;
using namespace System::Reflection;
using namespace System::Windows::Forms;
using namespace System::IO;
using namespace ZedGraph;

public ref class XYGraph
{
public:
    XYGraph(void);

    static XYGraph^ getInstance() {
        return oInstance;
    }

    int StartGraph(char* caName, char* caXAxisName, char* caYAxisName);
    int AppendPoints(char* caLabel,double* dXPoints, double* dYPoints, int nCount, char* caColor);
    int AppendPoint(char* caLabel,double dXvalue, double dYvalue);
    int PublishGraph(char* caFilePath);
    int DiscardGraph();
    static char* GetErrorString(int nErrorCode);

private:
    //single ton pattern instance
    static XYGraph^ oInstance;

    // zedgraph instance & used as a flag to indicate whether a graph is being drawn, by checking Non-nullity
    ZedGraph::ZedGraphControl^  zedGraph;

    static Assembly^ currentDomain_AssemblyResolve(Object^ sender, ResolveEventArgs^ args);

    static XYGraph() {
        oInstance = gcnew XYGraph();
    }
};
