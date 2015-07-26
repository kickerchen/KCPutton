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
        
        let itemButton1 = PuttonItem(image: UIImage(named: "mario")!)
        itemButton1.addTarget(self, action: "hitOnMario1:", forControlEvents: .TouchUpInside)
        let itemButton2 = PuttonItem(image: UIImage(named: "mario")!)
        itemButton2.addTarget(self, action: "hitOnMario2:", forControlEvents: .TouchUpInside)
        let itemButton3 = PuttonItem(image: UIImage(named: "mario")!)
        itemButton3.addTarget(self, action: "hitOnMario3:", forControlEvents: .TouchUpInside)
        let itemButton4 = PuttonItem(image: UIImage(named: "mario")!)
        itemButton4.addTarget(self, action: "hitOnMario4:", forControlEvents: .TouchUpInside)
        let itemButton5 = PuttonItem(image: UIImage(named: "mario")!)
        itemButton5.addTarget(self, action: "hitOnMario5:", forControlEvents: .TouchUpInside)
        let itemButton6 = PuttonItem(image: UIImage(named: "mario")!)
        itemButton6.addTarget(self, action: "hitOnMario6:", forControlEvents: .TouchUpInside)
    
        let items = NSArray(array: [itemButton1, itemButton2, itemButton3, itemButton4, itemButton5, itemButton6])
        
        let putton = Putton(frame: CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds)/2-26, CGRectGetHeight(UIScreen.mainScreen().bounds)/2-26, 52, 52), startItem: startButton, expandItems: items)
        
        self.view.addSubview(putton)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func hitOnMario1(sender: UIButton!){
        println("Mario 1 is hit")
    }

    func hitOnMario2(sender: UIButton!){
        println("Mario 2 is hit")
    }
    
    func hitOnMario3(sender: UIButton!){
        println("Mario 3 is hit")
    }
    
    func hitOnMario4(sender: UIButton!){
        println("Mario 4 is hit")
    }
    
    func hitOnMario5(sender: UIButton!){
        println("Mario 5 is hit")
    }
    
    func hitOnMario6(sender: UIButton!){
        println("Mario 6 is hit")
    }
}

