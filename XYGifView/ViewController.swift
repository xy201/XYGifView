//
//  ViewController.swift
//  XYGifView
//
//  Created by xuyou on 2016/12/8.
//  Copyright © 2016年 xuyou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var showGifView: XYView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showGifView.showGifImageWithLocalName(name: "lufei")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

