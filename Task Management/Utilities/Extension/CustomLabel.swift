//
//  CustomLabel.swift
//  Task Management
//
//  Created by MAC on 08/03/25.
//

import UIKit

class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLabel(labeltext: String, color: UIColor = .label, labelfont: UIFont = .customFont(style: .medium, size: 16)){
        textColor = color
        font = labelfont
        text = labeltext
    }
}

class CustomSizedLabel: UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize{
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 16
        let width  = originalContentSize.width + 40
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: width, height: height)
    }
}
