//
//  MasterList.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 21/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation

class MasterList : NSObject {
    var currency : String!
    var data : [Game]!
    
    init(currency : String, data : [Game]) {
        super.init()
        self.currency = currency
        self.data = data
    }
}