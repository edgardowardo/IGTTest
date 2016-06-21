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
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        if let jackpot = formatter.stringFromNumber(NSNumber(integer: model.jackpot)) {
            return "\(currency) \(jackpot)"
        }
        return "\(currency) \(model.jackpot)"
    }
    
    var date : String {
        let date = NSDateFormatter.localizedStringFromDate(model.date, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return "\(date)"
    }
}