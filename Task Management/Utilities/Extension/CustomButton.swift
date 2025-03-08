//
//  CustomButton.swift
//  Task Management
//
//  Created by MAC on 08/03/25.
//

import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureButton(title: String, titleColor: UIColor = .white, bgColor: UIColor = .TextPlumColor, font: UIFont = .customFont(style: .medium, size: 16)) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = font
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}

class CustomIconButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureButton(iconName: String, content_Mode: UIView.ContentMode = .scaleToFill, tint_Color: UIColor = .TextColor, title: String = "", titleColor: UIColor = .clear, bgColor: UIColor = .clear, font: UIFont = .customFont(style: .medium, size: 16)) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = font
        
        setImage(UIImage(systemName: iconName), for: .normal)
        tintColor = tint_Color
        contentMode = content_Mode
        imageView?.contentMode = content_Mode
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}
