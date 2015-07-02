/* ***************************************************************************************************** */
/*                                                                                                                                              */
/*  							   Copyright (c) 2015  Robert Bosch  																	*/
/*                                 India                                                                                                      */
/*                                 All rights reserved                                                                                 */
/*                                                                                                                                               */
/**********************************************************************************************************
$Source: ZedGraphLib/ZedGraphWrapper/XYGraph.cpp $
$Revision: 1.1 $
$Author: Arulkumar S (RBEI/ESP2) (ASR2COB) $
$State: develop $
$Date: 2015/03/05 15:01:33IST $

History:

$Log: ZedGraphLib/ZedGraphWrapper/XYGraph.cpp  $
Revision 1.1 2015/03/05 15:01:33IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
Revision 1.1 2015/02/17 19:11:24IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
*********************************************************************************************************/

#include "XYGraph.h"


/**
@fn XYGraph

@brief Brief description about the function 



@return status of operation

@retval   0   Success
@retval   0   Success
*/

XYGraph::XYGraph(void)
{
   //The AssemblyResolve event is called when the common language runtime tries to bind to the assembly and fails.
    AppDomain^ currentDomain = AppDomain::CurrentDomain;
    currentDomain->AssemblyResolve += gcnew ResolveEventHandler(&XYGraph::currentDomain_AssemblyResolve);
}



/**
@fn currentDomain_AssemblyResolve

@brief Brief description about the function 

@param[in/out]  sender - description for "sender"
@param[in/out]  args - description for "args"


@return status of operation

@retval   0   Success
@retval   0   Success
*/

Assembly^ XYGraph::currentDomain_AssemblyResolve(Object^ sender, ResolveEventArgs^ args)
{
    //This handler is called only when the common language runtime tries to bind to the assembly and fails.
    //Retrieve the list of referenced assemblies in an array of AssemblyName.
    Assembly^ objExecutingAssembly = Assembly::GetExecutingAssembly();
    Assembly^ ZedAssembly;

    String^ strTempAssmbPath = "";

    array<AssemblyName^>^ arrReferencedAssmbNames = objExecutingAssembly->GetReferencedAssemblies();

    //Loop through the array of referenced assembly names.
    for each (AssemblyName^ strAssmbName in arrReferencedAssmbNames)
    {
        //Check for the assembly names that have raised the "AssemblyResolve" event & whether the ZedGraph assembly is present in that
        if (args->Name->Substring(0, args->Name->IndexOf(","))->Equals("zedgraph", StringComparison::InvariantCultureIgnoreCase))
        {
            //Build the path of the assembly (ZedGraph) from where it has to be loaded.
            strTempAssmbPath = Path::GetDirectoryName(objExecutingAssembly->Location->ToString());

            if (!strTempAssmbPath->EndsWith("\\")) {
                strTempAssmbPath += "\\";
            }

            strTempAssmbPath += args->Name->Substring(0, args->Name->IndexOf(",")) + ".dll";
            break;
        }

    }
    //Load the assembly from the specified path.
    ZedAssembly = Assembly::LoadFrom(strTempAssmbPath);

    //Return the loaded assembly.
    return ZedAssembly;
}

/**
@fn StartGraph

@brief Brief description about the function 

@param[in/out]  caName - description for "caName"
@param[in/out]  caXAxisName - description for "caXAxisName"
@param[in/out]  caYAxisName - description for "caYAxisName"


@return status of operation

@retval   0   Success
@retval   0   Success
*/

int XYGraph::StartGraph(char* caName, char* caXAxisName, char* caYAxisName)
{
    zedGraph = gcnew ZedGraph::ZedGraphControl();
    zedGraph->Size = System::Drawing::Size(900, 700);
    zedGraph->Name =  gcnew String(caName);
    zedGraph->IsShowPointValues = true;
    zedGraph->GraphPane->Title = gcnew String(caName);

    zedGraph->GraphPane->XAxis->Title = gcnew String(caXAxisName);
    zedGraph->GraphPane->YAxis->Title = gcnew String(caYAxisName);
    zedGraph->GraphPane->PaneFill->Color = Color::White;
    zedGraph->GraphPane->AxisFill->Color = Color::Black;
    zedGraph->GraphPane->AxisFill->Type = FillType::Solid;
    zedGraph->GraphPane->XAxis->MaxAuto = true;
    zedGraph->GraphPane->YAxis->MaxAuto = true;
    return 0;
}


/**
@fn AppendPoints

@brief Brief description about the function 

@param[in/out]  caLabel - description for "caLabel"
@param[in/out]  dXPoints - description for "dXPoints"
@param[in/out]  dYPoints - description for "dYPoints"
@param[in/out]  nCount - description for "nCount"
@param[in/out]  caColor - https://msdn.microsoft.com/en-us/library/system.drawing.knowncolor%28v=vs.110%29.aspx


@return status of operation

@retval   0   Success
@retval   0   Success
*/

//TODO: check if any additional parameters are needed, such as Symbol marker size, Fill type etc.,
int XYGraph::AppendPoints(char* caLabel, double* dXPoints, double* dYPoints, int nCount, char* caColor)
{
    if(zedGraph == nullptr) {
        return ERROR_DLL_GRAPH_NOT_STARTED;
    }

    array<double>^ arrXAxisPoints = gcnew array<double>(nCount);
    array<double>^ arrYAxisPoints = gcnew array<double>(nCount);

    for(int index = 0; index < nCount; index++) {
        arrXAxisPoints[index] = dXPoints[index];
        arrYAxisPoints[index] = dYPoints[index];
    }

    LineItem^ currentCurve = zedGraph->GraphPane->AddCurve(gcnew String(caLabel), arrXAxisPoints, arrYAxisPoints, Color::FromName(gcnew String(caColor)), SymbolType::Circle);
    currentCurve->Symbol->Size = 3.0f;
    currentCurve->Symbol->Fill->Type = FillType::GradientByX;

    zedGraph->AxisChange();
    zedGraph->Invalidate();
    return 0;
}


/**
@fn AppendPoint

@brief Brief description about the function 

@param[in/out]  caLabel - description for "caLabel"
@param[in/out]  dXvalue - description for "dXvalue"
@param[in/out]  dYvalue - description for "dYvalue"


@return status of operation

@retval   0   Success
@retval   0   Success
*/

//TODO: assign random color to the newly created curve
int XYGraph::AppendPoint(char* caLabel, double dXvalue, double dYvalue)
{
    if(zedGraph == nullptr) {
        return ERROR_DLL_GRAPH_NOT_STARTED;
    }

    String^ givenLabel = gcnew String(caLabel);
    
    //TODO: create a seperate API to check if the curve with given label already exists
    CurveList^ curveList = zedGraph->GraphPane->CurveList;
    LineItem^ curveReference = nullptr;
    for each(LineItem^ oCurve in curveList) {
        if(givenLabel->Equals(oCurve->Label, StringComparison::CurrentCultureIgnoreCase)) {
            curveReference = oCurve;
            break;
        }
    }

    if(curveReference == nullptr) {
        array<double>^ arrXAxisPoints = gcnew array<double>(1) {dXvalue};
        array<double>^ arrYAxisPoints = gcnew array<double>(1) {dYvalue};
        LineItem^ currentCurve = zedGraph->GraphPane->AddCurve(gcnew String(caLabel), arrXAxisPoints, arrYAxisPoints, Color::FromName(gcnew String("DarkOrange")), SymbolType::Circle);
        currentCurve->Symbol->Size = 3.0f;
        currentCurve->Symbol->Fill->Type = FillType::Solid;
    } else {
        curveReference->Points->Add(dXvalue, dYvalue);
    }

    return 0;
}

/**
@fn PublishGraph

@brief Brief description about the function 

@param[in/out]  caFilePath - description for "caFilePath"


@return status of operation

@retval   0   Success
@retval   0   Success
*/

int XYGraph::PublishGraph(char* caFilePath)
{
    if(zedGraph == nullptr) {
        return ERROR_DLL_GRAPH_NOT_STARTED;
    }

    zedGraph->AxisChange();
    zedGraph->Invalidate();
    zedGraph->GraphPane->Image->Save(gcnew String(caFilePath));
    zedGraph = nullptr;

    GC::WaitForPendingFinalizers();
    GC::Collect();

    return 0;
}

/**
@fn DiscardGraph

@brief Brief description about the function 



@return status of operation

@retval   0   Success
@retval   0   Success
*/

int XYGraph::DiscardGraph()
{
    if(zedGraph == nullptr) {
        return ERROR_DLL_GRAPH_NOT_STARTED;
    }

    zedGraph->GraphPane->CurveList->Clear();
    zedGraph->AxisChange();
    zedGraph->Invalidate();
    zedGraph = nullptr;
    return 0;
}

/**
@fn GetErrorString

@brief Brief description about the function 

@param[in/out]  nErrorCode - description for "nErrorCode"


@return status of operation

@retval   0   Success
@retval   0   Success
*/

char* XYGraph::GetErrorString(int nErrorCode)
{
    String^ strErrorString = ErrorCodes::getErrorString(nErrorCode);
    char* caErrorString = (char*)(void*)System::Runtime::InteropServices::Marshal::StringToHGlobalAnsi(strErrorString);
    return caErrorString;
}
