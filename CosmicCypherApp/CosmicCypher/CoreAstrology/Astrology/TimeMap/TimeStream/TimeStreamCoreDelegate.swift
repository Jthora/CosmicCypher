//
//  TimeStreamCoreDelegate.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/19/22.
//

import Foundation


protocol TimeStreamCoreReactive: AnyObject {
    func timeStreamCore(didAction action:TimeStream.Core.Action)
}

extension TimeStream.Core {
    
    enum Action {
        case onLoadTimeStream(loadTimeStreamAction: LoadTimeStream)
        case update(updateAction: Update)
        
        enum Update {
            case composites(composites:[UUID:TimeStream.Composite])
            case currentComposite(composite:TimeStream.Composite)
        }
        
        enum LoadTimeStream {
            case start(uuid:UUID, name:String, configuration:TimeStream.Configuration)
            case progress(uuid:UUID, completion: Double)
            case complete(uuid:UUID, composite:TimeStream.Composite)
        }
    }
}
