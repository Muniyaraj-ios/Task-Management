//
//  MostPopularCollectionCell.swift
//  Task Management
//
//  Created by MAC on 07/03/25.
//

import UIKit

class MostPopularCollectionCell: BaseCollectionCell {
    
    lazy var customLabel: CustomSizedLabel = {
        let label = CustomSizedLabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.font = .customFont(style: .regular, size: 15)
        return label
    }()
    
    var selected_: Bool = false{
        didSet{
            customLabel.backgroundColor = selected_ ? .TextPlumColor : .clear
            customLabel.textColor = selected_ ? .white : .TextColor
            customLabel.font = selected_ ? .customFont(style: .medium, size: 16) : .customFont(style: .regular, size: 15)
            if !selected_{
                customLabel.cornerRadiusWithBorder(isRound: true,isBorder: true,borWidth: 1,borColor: .darkGray)
            }else{
                customLabel.cornerRadiusWithBorder(isRound: true,isBorder: true,borWidth: 0,borColor: .clear)
            }
            setNeedsLayout()
        }
    }
    
    override func initalize() {
        super.initalize()
        addSubview(customLabel)
        customLabel.makeEdgeConstrains(toView: self,edge: .init(top: 6, left: 10, bottom: 10, right: 6))
    }
    func setupData(_ data: /*CatgorySection*/ TaskSection){
        customLabel.text = data.name.rawValue
        selected_ = data.isSelected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !selected_{
            customLabel.cornerRadiusWithBorder(isRound: true,isBorder: true,borWidth: 1,borColor: .darkGray)
        }else{
            customLabel.cornerRadiusWithBorder(isRound: true,isBorder: true,borWidth: 0,borColor: .clear)
        }
    }
}
