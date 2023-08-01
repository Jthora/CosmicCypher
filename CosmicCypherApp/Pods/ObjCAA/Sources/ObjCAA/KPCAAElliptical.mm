//
//  KPCAAElliptical.m
//  SwiftAA
//
//  Created by Cédric Foellmi on 06/07/15.
//  Licensed under the MIT License (see LICENSE file)
//

#import "KPCAAElliptical.h"
#import "KPCAAElementsPlanetaryOrbit.h"
#import "KPCAAPlanetPerihelionAphelion.h"
#import "KPCAADate.h"
#import "AADate.h"
#import "AAElliptical.h"
#include <stdexcept>

CAAElliptical::Object ellipticalObjectFromKPCAAEllipticalObject(KPCAAEllipticalObject object);
CAAElliptical::Object ellipticalObjectFromKPCAAEllipticalObject(KPCAAEllipticalObject object) {
    switch (object) {
        case SUN_elliptical:
            return CAAElliptical::Object::SUN;
            break;
        case MERCURY_elliptical:
            return CAAElliptical::Object::MERCURY;
            break;
        case VENUS_elliptical:
            return CAAElliptical::Object::VENUS;
            break;
        case MARS_elliptical:
            return CAAElliptical::Object::MARS;
            break;
        case JUPITER_elliptical:
            return CAAElliptical::Object::JUPITER;
            break;
        case SATURN_elliptical:
            return CAAElliptical::Object::SATURN;
            break;
        case URANUS_elliptical:
            return CAAElliptical::Object::URANUS;
            break;
        case NEPTUNE_elliptical:
            return CAAElliptical::Object::NEPTUNE;
            break;
        default:
            throw std::invalid_argument("invalid object parameter");
            break;
    }
}

double KPCAAElliptical_DistanceToLightTime(double Distance)
{
    return CAAElliptical::DistanceToLightTime(Distance);
}

KPCAAEllipticalPlanetaryDetails KPCAAElliptical_CalculatePlanetaryDetails(double JD, KPCAAEllipticalObject object, BOOL highPrecision)
{
    CAAElliptical::Object ellipticalObject = ellipticalObjectFromKPCAAEllipticalObject(object);
    CAAEllipticalPlanetaryDetails detailsPlus = CAAElliptical::Calculate(JD, ellipticalObject, highPrecision);
    
    struct KPCAAEllipticalPlanetaryDetails details;
    details.ApparentGeocentricLongitude = detailsPlus.ApparentGeocentricLongitude;
    details.ApparentGeocentricLatitude = detailsPlus.ApparentGeocentricLatitude;
    details.ApparentGeocentricDistance = detailsPlus.ApparentGeocentricDistance;
    details.ApparentLightTime = detailsPlus.ApparentLightTime;
    details.ApparentGeocentricRA = detailsPlus.ApparentGeocentricRA;
    details.ApparentGeocentricDeclination = detailsPlus.ApparentGeocentricDeclination;

    return details;
}

double KPCAAElliptical_SemiMajorAxisFromPerihelionDistance(double q, double e)
{
    return CAAElliptical::SemiMajorAxisFromPerihelionDistance(q, e);
}

double KPCAAElliptical_MeanMotionFromSemiMajorAxis(double a)
{
    return CAAElliptical::MeanMotionFromSemiMajorAxis(a);
}

KPCAAEllipticalObjectDetails KPCAAElliptical_CalculateObjectDetails(double JD, KPCAAEllipticalObjectElements *elements, BOOL highPrecision)
{
    CAAEllipticalObjectElements elementsPlus = CAAEllipticalObjectElements();
    
    elementsPlus.a = (*elements).a;
    elementsPlus.e = (*elements).e;
    elementsPlus.i = (*elements).i;
    elementsPlus.w = (*elements).w;
    elementsPlus.omega = (*elements).omega;
    elementsPlus.JDEquinox = (*elements).JDEquinox;
    elementsPlus.T = (*elements).T;

    CAAEllipticalObjectDetails detailsPlus = CAAElliptical::Calculate(JD, elementsPlus, highPrecision);
    
    struct KPCAAEllipticalObjectDetails details;
    
    details.HeliocentricRectangularEquatorialCoordinateComponents = KPCAA3DCoordinateComponentsMake(detailsPlus.HeliocentricRectangularEquatorial.X,
                                                                                                    detailsPlus.HeliocentricRectangularEquatorial.Y,
                                                                                                    detailsPlus.HeliocentricRectangularEquatorial.Z);
    
    details.HeliocentricRectangularEclipticalCoordinateComponents = KPCAA3DCoordinateComponentsMake(detailsPlus.HeliocentricRectangularEcliptical.X,
                                                                                                    detailsPlus.HeliocentricRectangularEcliptical.Y,
                                                                                                    detailsPlus.HeliocentricRectangularEcliptical.Z);
    
    details.HeliocentricEclipticLongitude = detailsPlus.HeliocentricEclipticLongitude;
    details.HeliocentricEclipticLatitude = detailsPlus.HeliocentricEclipticLatitude;
    details.TrueGeocentricRA = detailsPlus.TrueGeocentricRA;
    details.TrueGeocentricDeclination = detailsPlus.TrueGeocentricDeclination;
    details.TrueGeocentricDistance = detailsPlus.TrueGeocentricDistance;
    details.TrueGeocentricLightTime = detailsPlus.TrueGeocentricLightTime;
    details.AstrometricGeocentricRA = detailsPlus.AstrometricGeocentricRA;
    details.AstrometricGeocentricDeclination = detailsPlus.AstrometricGeocentricDeclination;
    details.AstrometricGeocentricDistance = detailsPlus.AstrometricGeocentricDistance;
    details.AstrometricGeocentricLightTime = detailsPlus.AstrometricGeocentricLightTime;
    details.Elongation = detailsPlus.Elongation;
    details.PhaseAngle = detailsPlus.PhaseAngle;
    
    return details;
}

KPCAAEllipticalObjectDetails KPCAAElliptical_CalculateObjectDetailsNoElements(double JD, KPCAAPlanetStrict planetStrict, BOOL highPrecision)
{
    struct KPCAAEllipticalObjectElements elements;
    
    elements.a = KPCAAElementsPlanetaryOrbit_SemimajorAxis(planetStrict, JD);
    elements.e = KPCAAElementsPlanetaryOrbit_Eccentricity(planetStrict, JD);
    elements.i = KPCAAElementsPlanetaryOrbit_Inclination(planetStrict, JD);
    elements.w = KPCAAElementsPlanetaryOrbit_LongitudePerihelion(planetStrict, JD);
    elements.omega = KPCAAElementsPlanetaryOrbit_LongitudeAscendingNode(planetStrict, JD);
    
    elements.JDEquinox = 2451545.0; // J2000
    
    double fractionalYear = CAADate(JD, true).FractionalYear();
    long k = KPCAAPlanetPerihelionAphelion_K(fractionalYear, planetStrict);
    elements.T = KPCAAPlanetPerihelionAphelion_Perihelion(k, planetStrict);
    
    return KPCAAElliptical_CalculateObjectDetails(JD, &elements, highPrecision);
}

double KPCAAElliptical_InstantaneousVelocity(double r, double a)
{
    return CAAElliptical::InstantaneousVelocity(r, a);
}

double KPCAAElliptical_VelocityAtPerihelion(double e, double a)
{
    return CAAElliptical::VelocityAtPerihelion(e, a);
}

double KPCAAElliptical_VelocityAtAphelion(double e, double a)
{
    return CAAElliptical::VelocityAtAphelion(e, a);
}

double KPCAAElliptical_LengthOfEllipse(double e, double a)
{
    return CAAElliptical::LengthOfEllipse(e, a);
}

double KPCAAElliptical_CometMagnitude(double g, double delta, double k, double r)
{
    return CAAElliptical::CometMagnitude(g, delta, k, r);
}

double KPCAAElliptical_MinorPlanetMagnitude(double H, double delta, double G, double r, double PhaseAngle)
{
    return CAAElliptical::MinorPlanetMagnitude(H, delta, G, r, PhaseAngle);
}

