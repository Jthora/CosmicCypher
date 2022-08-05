//
//  TimeStreamCoreDelegate.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/19/22.
//

import Foundation


protocol TimeStreamCoreReactive: class {
    func timeStreamCore(didAction action:TimeStream.Core.Action)
}

extension TimeStream.Core {
    
    enum Action {
        case onLoadTimeStream(loadTimeStreamAction: LoadTimeStreamAction)
        case update(updateAction: UpdateAction)
        
        enum UpdateAction {
            case composites
        }
        
        enum LoadTimeStreamAction {
            case start(uuid:UUID, name:String, configuration:TimeStream.Configuration)
            case progress(uuid:UUID, completion: Double)
            case complete(uuid:UUID, composite:TimeStream.Composite)
        }
    }
}
