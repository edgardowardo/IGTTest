//
//  MasterViewModel.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 20/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

struct MasterViewModel {

    var model : Game
    
    /// Any formatting is done in the view model. It may be overkill at this glance but when changes are made in the 
    /// future, it will be easier to make those changes here!
    var name : String {
        return model.name
    }
}
