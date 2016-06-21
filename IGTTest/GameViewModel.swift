//
//  GameViewModel.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 21/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

struct GameViewModel {
    var currency : String
    var model : Game
    
    var title : String {
        return model.name
    }
    
    var jackpot : String {
        // TODO: Local and currency
        return "\(currency) \(model.jackpot)"
    }
    
    var date : String {
        // TODO: localise
        return "\(model.date)"
    }
    
}