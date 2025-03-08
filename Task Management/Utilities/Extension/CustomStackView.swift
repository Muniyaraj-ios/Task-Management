//
//  CustomStackView.swift
//  Task Management
//
//  Created by MAC on 05/03/25.
//

import UIKit

class HorizontalStack: UIStackView{
    
    init(arrangedSubViews: [UIView],spacing: CGFloat = 0,alignment: UIStackView.Alignment = .center,distribution: UIStackView.Distribution = .fill){
        super.init(frame: .zero)
        arrangedSubViews.forEach{ addArrangedSubview($0) }
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.axis = .horizontal
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VerticalStack: UIStackView{
    
    init(arrangedSubViews: [UIView],spacing: CGFloat = 0,alignment: UIStackView.Alignment = .center,distribution: UIStackView.Distribution = .fill) {
        super.init(frame: .zero)
        arrangedSubViews.forEach{ addArrangedSubview($0) }
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
