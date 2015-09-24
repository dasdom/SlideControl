//
//  ViewController.swift
//  SlideControlDemo
//
//  Created by dasdom on 11.09.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var label: UILabel?
  let titles = ["1st Option", "2nd Option", "3rd Option", "4th Option"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let slideControl = DHSlideControl(titles: titles)
    slideControl.translatesAutoresizingMaskIntoConstraints = false
    slideControl.addTarget(self, action: "didChange:", forControlEvents: .ValueChanged)
    slideControl.color = UIColor(hue: 0.6, saturation: 0.9, brightness: 0.65, alpha: 1.0)
    slideControl.layer.cornerRadius = 10
    
    label = UILabel()
    label?.translatesAutoresizingMaskIntoConstraints = false
    label?.text = titles.first
    label?.textAlignment = .Center
    
    view.addSubview(slideControl)
    view.addSubview(label!)
    
    let views = ["slide": slideControl, "label": label!]
    var layoutConstraints = [NSLayoutConstraint]()
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|-20-[slide]-20-|", options: [], metrics: nil, views: views)
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-50-[slide(80)]-50-[label]", options: [.AlignAllLeading, .AlignAllTrailing], metrics: nil, views: views)
    NSLayoutConstraint.activateConstraints(layoutConstraints)
    
  }

  func didChange(sender: DHSlideControl) {
    print(sender.selectedIndex)
    label?.text = titles[sender.selectedIndex]
  }

}

