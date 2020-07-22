//
//  YTButtons.swift
//  Assignment 4
//
//  Created by Victor Yang on 2020-05-26.
//  Copyright © 2020 COMP2601. All rights reserved.
//

//import Foundation
import UIKit

class YTRoundedButton: UIButton {
    
    required init(){
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect){
        super.draw(rect)
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
