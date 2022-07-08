/*
Module : AAPhysicalJupiter.h
Purpose: Implementation for the algorithms which obtain the physical parameters of Jupiter
Created: PJN / 05-01-2004

Copyright (c) 2003 - 2019 by PJ Naughter (Web: www.naughter.com, Email: pjna@naughter.com)

All rights reserved.

Copyright / Usage Details:

You are allowed to include the source code in any product (commercial, shareware, freeware or otherwise) 
when your product is released in binary form. You are allowed to modify the source code in any way you want 
except you cannot modify the copyright details at the top of each module. If you want to distribute source 
code with your application, then you are only allowed to distribute versions released by the author. This is 
to maintain a single distribution point for the source code. 

*/


/////////////////////// Macros / Defines //////////////////////////////////////

#if _MSC_VER > 1000
#pragma once
#endif //#if _MSC_VER > 1000

#ifndef __AAPHYSICALJUPITER_H__
#define __AAPHYSICALJUPITER_H__

#ifndef AAPLUS_EXT_CLASS
#define AAPLUS_EXT_CLASS
#endif //#ifndef AAPLUS_EXT_CLASS


/////////////////////// Classes ///////////////////////////////////////////////

class AAPLUS_EXT_CLASS CAAPhysicalJupiterDetails
{
public:
//Constructors / Destructors
  CAAPhysicalJupiterDetails() noexcept : DE(0),
                                         DS(0),
                                         Geometricw1(0),
                                         Geometricw2(0),
                                         Apparentw1(0),
                                         Apparentw2(0),
                                         P(0)
  {
  };

//Member variables
  double DE;
  double DS;
  double Geometricw1;
  double Geometricw2;
  double Apparentw1;
  double Apparentw2;
  double P;
};

class AAPLUS_EXT_CLASS CAAPhysicalJupiter
{
public:
//Static methods
  static CAAPhysicalJupiterDetails Calculate(double JD, bool bHighPrecision) noexcept;
};

#endif //#ifndef __AAPHYSICALJUPITER_H__
