//
//  BaseViewController.swift
//  Recycle Now
//
//  Created by Carl on 25/02/2018.
//  Copyright © 2018 CarlJNash. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    // TODO: make category on nsobject?
    func className() -> String {
        return String.init(describing: self)
    }
    
    //TODO: move to category on storyboard?
    class func loadFromStoryboard() -> UIViewController? {
        let className = String.init(describing: self)
        let storyboard = UIStoryboard.init(name: className, bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
}
