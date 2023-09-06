//
//  RatingCell.swift
//  rulletka
//
//  Created by MacBook on 15/08/2023.
//

import Foundation
import UIKit


class RatingCell: UITableViewCell {
    
   private var item: RatingModel!
    
    
    
    static let reuseId = String(describing: RatingCell.self)
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    let balanceImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "coins"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [nameLabel,balanceLabel,balanceImageView].forEach(addSubview(_:))
        self.backgroundColor = UIColor(red: 51/255, green: 113/255, blue: 35/255, alpha: 1)
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    
        nameLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(16)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(41)
            make.top.equalToSuperview().offset(16)
        }
        
        balanceImageView.snp.makeConstraints { make in
               make.centerY.equalTo(balanceLabel)
               make.left.equalTo(balanceLabel.snp.right).offset(5)
               make.width.height.equalTo(20)
           }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        balanceLabel.text = nil
    }
    
    func setupCell(item: RatingModel, index: Int) {
        self.item = item
        nameLabel.text = item.name
        balanceLabel.text = String(item.balance)
    }
}
