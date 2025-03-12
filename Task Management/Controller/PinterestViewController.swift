//
//  PinterestViewController.swift
//  Task Management
//
//  Created by MAC on 11/03/25.
//


import UIKit

class PinterestViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let images = PinterestData.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PinterestCell.self, forCellWithReuseIdentifier: PinterestCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let columns = 2
            let spacing: CGFloat = 10
            
            let group = NSCollectionLayoutGroup.custom(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(300))) { environment in
                    
                var items: [NSCollectionLayoutGroupCustomItem] = []
                var leftColumnHeight: CGFloat = 0
                var rightColumnHeight: CGFloat = 0
                
                let totalWidth = environment.container.contentSize.width - spacing
                let columnWidth = totalWidth / CGFloat(columns)
                
                for (index, item) in self.images.enumerated() {
                    let imageHeight = item.image?.size.height ?? 200 // Fallback height
                    let textHeight = item.title.height(withConstrainedWidth: columnWidth, font: UIFont.systemFont(ofSize: 14))
                    let totalHeight = imageHeight + textHeight + 10 // 10 for padding
                    
                    let x = index % 2 == 0 ? 0 : columnWidth + spacing
                    let y = index % 2 == 0 ? leftColumnHeight : rightColumnHeight
                    
                    if index % 2 == 0 {
                        leftColumnHeight += totalHeight + spacing
                    } else {
                        rightColumnHeight += totalHeight + spacing
                    }
                    
                    let frame = CGRect(x: x, y: y, width: columnWidth, height: totalHeight)
                    let layoutItem = NSCollectionLayoutGroupCustomItem(frame: frame)
                    items.append(layoutItem)
                }
                
                return items
            }
            
            return NSCollectionLayoutSection(group: group)
        }
    }
}

// 🔹 Sample Data Model
struct PinterestData {
    let image: UIImage?
    let title: String
    
    static let sampleData: [PinterestData] = [
        PinterestData(image: UIImage(named: "image1"), title: "Beautiful Landscape"),
        PinterestData(image: UIImage(named: "image2"), title: "Amazing Sunset"),
        PinterestData(image: UIImage(named: "image3"), title: "City Lights at Night"),
        PinterestData(image: UIImage(named: "image4"), title: "Snowy Mountain View"),
        PinterestData(image: UIImage(named: "image5"), title: "Beach Vibes"),
        PinterestData(image: UIImage(named: "image6"), title: "Modern Architecture")
    ]
}

// 🔹 Pinterest Cell
class PinterestCell: UICollectionViewCell {
    static let identifier = "PinterestCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: PinterestData) {
        imageView.image = data.image
        titleLabel.text = data.title
    }
}

// 🔹 UICollectionView DataSource
extension PinterestViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinterestCell.identifier, for: indexPath) as! PinterestCell
        let data = images[indexPath.item]
        cell.configure(with: data)
        return cell
    }
}

// 🔹 UILabel Extension for Dynamic Text Height Calculation
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
