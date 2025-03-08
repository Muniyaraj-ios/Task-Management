//
//  CompostionalLayout.swift
//  Task Management
//
//  Created by MAC on 04/03/25.
//

import UIKit

enum CompostionalGroupAlignment{
    case vertical
    case horizonatal
}

struct CompostionalLayout{
    
    static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension,space: UIEdgeInsets = .zero)-> NSCollectionLayoutItem{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: space.top, leading: space.left, bottom: space.bottom, trailing: space.right)
        return item
    }
    
    static func createGroup(alignment: CompostionalGroupAlignment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, items: [NSCollectionLayoutItem])-> NSCollectionLayoutGroup{
        let layoutSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: items)
        case .horizonatal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: items)
        }
    }
    
    static func createGroup(alignment: CompostionalGroupAlignment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, item: NSCollectionLayoutItem, count: Int)-> NSCollectionLayoutGroup{
        let layoutSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        switch alignment {
        case .vertical:
            if #available(iOS 16.0, *) {
                return NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, repeatingSubitem: item, count: count)
            } else {
                return NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitem: item, count: count)
            }
        case .horizonatal:
            if #available(iOS 16.0, *) {
                return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, repeatingSubitem: item, count: count)
            } else {
                return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: count)
            }
        }
    }
}
