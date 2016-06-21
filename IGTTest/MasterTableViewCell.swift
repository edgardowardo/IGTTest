//
//  MasterTableViewCell.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 21/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import Foundation
import UIKit

class MasterTableViewCell : UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel : MasterViewModel! {
        didSet {
            self.textLabel?.text = viewModel.name
        }
    }
}
