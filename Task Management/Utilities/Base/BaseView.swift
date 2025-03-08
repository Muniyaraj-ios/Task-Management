//
//  BaseView.swift
//  Task Management
//
//  Created by MAC on 05/03/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalizeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalizeUI()
    }
    
    func initalizeUI(){
        
    }
}
