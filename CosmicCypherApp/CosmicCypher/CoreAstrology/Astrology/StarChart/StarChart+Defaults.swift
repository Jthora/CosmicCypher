//
//  StarChart+Defaults.swift
//  CosmicCypher
//
//  Created by Jono Tho'ra on 12/7/24.
//

import Foundation
import SwiftAA
import CoreLocation

let DEFAULT_GEOLOCATION = GeographicCoordinates(CLLocation(latitude: 47.49442617153722, longitude: -122.2749018855393))

let DEFAULT_STARCHART = StarChart(date: Date(), coordinates: DEFAULT_GEOLOCATION)

let DEFAULT_SELECTED_ASPECTS:[CoreAstrology.AspectRelationType] = [.conjunction,
                                                                   .opposition,
                                                                   .sextile,
                                                                   .trine,
                                                                   .square]

let DEFAULT_SELECTED_NODETYPES:[CoreAstrology.AspectBody.NodeType] = [.ascendant,
                                                                    .midheaven,
                                                                    .lunarAscendingNode,
                                                                    .lunarPerigee,
                                                                    .moon,
                                                                    .sun,
                                                                    .mercury,
                                                                    .venus,
                                                                    .mars,
                                                                    .jupiter,
                                                                    .saturn,
                                                                    .uranus,
                                                                    .neptune]

let DAYTODAY_SELECTED_ASPECTS:[CoreAstrology.AspectRelationType] = [.conjunction,
                                                                    .opposition,
                                                                    .sextile,
                                                                    .trine,
                                                                    .square]
                                                                   
let DAYTODAY_SELECTED_NODETYPES:[CoreAstrology.AspectBody.NodeType] = [.lunarAscendingNode,
                                                                       .lunarPerigee,
                                                                       .moon,
                                                                       .sun,
                                                                       .mercury,
                                                                       .venus,
                                                                       .mars,
                                                                       .jupiter,
                                                                       .saturn,
                                                                       .uranus,
                                                                       .neptune]

let ONEDAYSCRUB_SELECTED_ASPECTS:[CoreAstrology.AspectRelationType] = [.conjunction,
                                                                       .opposition,
                                                                       .sextile,
                                                                       .trine,
                                                                       .square]
                                                                   
let ONEDAYSCRUB_SELECTED_NODETYPES:[CoreAstrology.AspectBody.NodeType] = [.ascendant,
                                                                          .midheaven,
                                                                          .lunarAscendingNode,
                                                                          .lunarPerigee,
                                                                          .moon,
                                                                          .sun,
                                                                          .mercury,
                                                                          .venus,
                                                                          .mars,
                                                                          .jupiter,
                                                                          .saturn,
                                                                          .uranus,
                                                                          .neptune]
