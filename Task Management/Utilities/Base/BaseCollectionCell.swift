//
//  BaseCollectionCell.swift
//  Task Management
//
//  Created by MAC on 08/03/25.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell, StoryboardCell{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initalize()
    }
    override var isHighlighted: Bool{
        didSet{
            var transform = CGAffineTransform.identity
            if isHighlighted{
                transform = .init(scaleX: 0.95, y: 0.95)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                self.transform = transform
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initalize()
    }
    func initalize(){
        backgroundColor = .clear
    }
}

protocol StoryboardCell{
    static var reuseIdentifer: String{ get }
}
extension StoryboardCell{
    static var reuseIdentifer: String{ return String(describing: self) }
}
