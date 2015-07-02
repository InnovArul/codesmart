/* ***************************************************************************************************** */
/*                                                                                                                                              */
/*  							   Copyright (c) 2015  Robert Bosch  																	*/
/*                                 India                                                                                                      */
/*                                 All rights reserved                                                                                 */
/*                                                                                                                                               */
/**********************************************************************************************************
$Source: ZedGraphLib/ZedGraphTester/XYGraphTest.cpp $
$Revision: 1.1 $
$Author: Arulkumar S (RBEI/ESP2) (ASR2COB) $
$State: develop $
$Date: 2015/03/05 15:01:16IST $

History:

$Log: ZedGraphLib/ZedGraphTester/XYGraphTest.cpp  $
Revision 1.1 2015/03/05 15:01:16IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
Revision 1.1 2015/02/17 19:11:12IST Arulkumar S (RBEI/ESP2) (ASR2COB) 
Initial revision
Member added to project g:/MKS/Projects/TurboLIFT/System/develop/develop.pj
*********************************************************************************************************/

#include "StdAfx.h"


using namespace Microsoft::VisualStudio::TestTools::UnitTesting;
namespace ZedGraphTester {
    using namespace System;
    ref class XYGraphTest;
    
    
    /// <summary>
///This is a test class for XYGraphTest and is intended
///to contain all XYGraphTest Unit Tests
///</summary>
    [TestClass]
    public ref class XYGraphTest
    {

    private: Microsoft::VisualStudio::TestTools::UnitTesting::TestContext^  testContextInstance;
             /// <summary>
             ///Gets or sets the test context which provides
             ///information about and functionality for the current test run.
             ///</summary>
    public: property Microsoft::VisualStudio::TestTools::UnitTesting::TestContext^  TestContext
            {
                Microsoft::VisualStudio::TestTools::UnitTesting::TestContext^  get()
                {
                    return testContextInstance;
                }
                System::Void set(Microsoft::VisualStudio::TestTools::UnitTesting::TestContext^  value)
                {
                    testContextInstance = value;
                }
            }

#pragma region Additional test attributes
            // 
            //You can use the following additional attributes as you write your tests:
            //
            //Use ClassInitialize to run code before running the first test in the class
            //public: [ClassInitialize]
            //static System::Void MyClassInitialize(TestContext^  testContext)
            //{
            //}
            //
            //Use ClassCleanup to run code after all tests in a class have run
            //public: [ClassCleanup]
            //static System::Void MyClassCleanup()
            //{
            //}
            //
            //Use TestInitialize to run code before running each test
            //public: [TestInitialize]
            //System::Void MyTestInitialize()
            //{
            //}
            //
            //Use TestCleanup to run code after each test has run
            //public: [TestCleanup]
            //System::Void MyTestCleanup()
            //{
            //}
            //
#pragma endregion

   public: [TestMethod]
            void StartGraphTest()
            {
                XYGraph^ target = (gcnew XYGraph()); // Initialize to an appropriate value
                int expected = 0; // Initialize to an appropriate value
                int actual;
                char* label = "square graph";
                char* xlabel = "xAxis";
                char* ylabel = "yAxis";
                actual = target->StartGraph((char*)label, (char*)xlabel, (char*)ylabel);
                Assert::AreEqual(expected, actual);
            }


            /// <summary>
            ///A test for AppendPoints
            ///</summary>

    public: [TestMethod]
            void AppendPointsTest()
            {
                XYGraph^ target = (gcnew XYGraph()); // Initialize to an appropriate value
                int expected = 0; // Initialize to an appropriate value
                int actual = 0;
                char* label = "square graph";
                char* xlabel = "xAxis";
                char* ylabel = "yAxis";
                actual = target->StartGraph((char*)label, (char*)xlabel, (char*)ylabel);
                Assert::AreEqual(expected, actual);
                const int size = 10000;

                double* xAxis = new double[size];
                double* yAxis = new double[size];
                for(int index = 0; index < size; index++) {
                    xAxis[index] = index;
                    yAxis[index] = index * index;
                }

                actual = target->AppendPoints((char*) label, xAxis, yAxis, size, "red");
                Assert::AreEqual(expected, actual);
            }

         /// <summary>
            ///A test for AppendPoint
            ///</summary>

    public: [TestMethod]
            void AppendPointTest()
            {
                XYGraph^ target = (gcnew XYGraph()); // Initialize to an appropriate value
                int expected = 0; // Initialize to an appropriate value
                int actual = 0;
                char* label = "square graph";
                char* xlabel = "xAxis";
                char* ylabel = "yAxis";
                actual = target->StartGraph((char*)label, (char*)xlabel, (char*)ylabel);
                Assert::AreEqual(expected, actual);
                const int size = 10;

                double xAxisPoint, yAxisPoint;
                for(int index = size; index >= 0; index--) {
                    xAxisPoint = index;
                    yAxisPoint = index * index;
                    actual = target->AppendPoint((char*) label, xAxisPoint, yAxisPoint);
                    Assert::AreEqual(expected, actual);
                }

                char* tempFilePath = "C:\\temp\\sampleImageAppentPoint.png";
                actual = target->PublishGraph(tempFilePath);
                Assert::AreEqual(expected, actual);
            }


            /// <summary>
            ///A test for PublishGraph
            ///</summary>
    public: [TestMethod]
            void PublishGraphTest()
            {
                XYGraph^ target = (gcnew XYGraph()); // Initialize to an appropriate value
                int expected = 0; // Initialize to an appropriate value
                int actual;

                char* label = "square graph";
                char* xlabel = "xAxis";
                char* ylabel = "yAxis";
                actual = target->StartGraph((char*)label, (char*)xlabel, (char*)ylabel);
                Assert::AreEqual(expected, actual);
                const int size = 500;

                double* xAxis = new double[size];
                double* yAxis = new double[size];
                int count = 0;

                for(int index = 0; index < size; index++) {
                    if(index % 2) { continue;}
                    xAxis[count] = 2 * index ;
                    yAxis[count] = index  + 10;
                    count++;
                }
                
                actual = target->AppendPoints((char*) label, xAxis, yAxis, count, "red");
                Assert::AreEqual(expected, actual);

                char* tempFilePath = "C:\\temp\\sampleImage+ve.png";
                actual = target->PublishGraph(tempFilePath);
                Assert::AreEqual(expected, actual);
            }

           /// <summary>
            ///A test for DiscardGraph
            ///</summary>
    public: [TestMethod]
            void DiscardGraphTest()
            {
                XYGraph^ target = (gcnew XYGraph()); // Initialize to an appropriate value
                int actual;

                char* label = "square graph";
                char* xlabel = "xAxis";
                char* ylabel = "yAxis";
                actual = target->StartGraph((char*)label, (char*)xlabel, (char*)ylabel);
                Assert::AreEqual(0, actual);

                actual = target->DiscardGraph();
                Assert::AreEqual(0, actual); 
            }

            /// <summary>
            ///A test for PublishGraph
            ///</summary>
    public: [TestMethod]
            void PublishGraphTestWithoutStartGraph()
            {
                XYGraph^  target = (gcnew XYGraph()); // Initialize to an appropriate value
                int actual;
                char* tempFilePath = "C:\\temp\\sampleImage-ve.png";
                actual = target->PublishGraph(tempFilePath);
                Assert::AreEqual(true, (actual < 0));
            }
            /// <summary>
            ///A test for getInstance
            ///</summary>
    public: [TestMethod]
            void getInstanceTest()
            {
                XYGraph^  actual;
                actual = XYGraph::getInstance();
                Assert::IsNotNull(actual);
            }
            /// <summary>
            ///A test for DiscardGraph
            ///</summary>
    public: [TestMethod]
            void DiscardGraphTestWithoutStartGraph()
            {
                XYGraph^  target = (gcnew XYGraph()); // Initialize to an appropriate value
                int actual;
                actual = target->DiscardGraph();
                Assert::AreEqual(true, (actual < 0)); 
            }
            /// <summary>
            ///A test for XYGraph Constructor
            ///</summary>
    public: [TestMethod]
            void XYGraphConstructorTest()
            {
                XYGraph^  target = (gcnew XYGraph());
            }
    };
}
namespace ZedGraphTester {
    
}
