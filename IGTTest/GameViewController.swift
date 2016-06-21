//
//  GameViewController.swift
//  IGTTest
//
//  Created by EDGARDO AGNO on 20/06/2016.
//  Copyright © 2016 EDGARDO AGNO. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModel : GameViewModel? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        if let vm = viewModel, jackpot = detailDescriptionLabel, date = dateLabel {
            self.title = vm.title
            jackpot.text = vm.jackpot
            date.text = vm.date
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

