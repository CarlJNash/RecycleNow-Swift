//
//  RecyclePointCell.swift
//  Recycle Now
//
//  Created by Carl on 02/03/2018.
//  Copyright © 2018 CarlJNash. All rights reserved.
//

import Foundation
import UIKit

class RecyclePointCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    private var recyclePoint: RecyclePoint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(withRecyclePoint recyclePoint: RecyclePoint?) {
        self.recyclePoint = recyclePoint
    }
    
    func render() {
        self.titleLabel.text = self.recyclePoint?.name
        self.detailLabel.text = self.recyclePoint?.address
    }
}
