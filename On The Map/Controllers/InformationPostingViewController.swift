//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 07-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var findMapSubmit: UIButton!
    @IBOutlet weak var linkToShare: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topInitialView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
