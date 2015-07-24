//
//  ViewController.swift
//  Putton
//
//  Created by CHENCHIAN on 7/22/15.
//  Copyright (c) 2015 KICKERCHEN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let startButton = PuttonItem(image: UIImage(named: "mushroom")!)
        
        let itemButton = PuttonItem(image: UIImage(named: "mario")!)
        
        let putton = Putton(frame: CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds)/2-26, CGRectGetHeight(UIScreen.mainScreen().bounds)/2-26, 52, 52), startItem: startButton, expandItem: itemButton, itemCount: 6)
        
        self.view.addSubview(putton)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

