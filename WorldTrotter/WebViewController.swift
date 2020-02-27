//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by VuTQ10 on 2/26/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webKit: WKWebView!
    let url = URL(string: "https://www.bignerdranch.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webKit.load(URLRequest(url: url!))
    }

   
}
