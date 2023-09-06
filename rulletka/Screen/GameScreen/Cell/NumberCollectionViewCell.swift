//
//  NumberCollectionViewCell.swift
//  rulletka
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var viewColor: UIView!
    private var item: NumbersModel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    func setupCell(item: NumbersModel, index: Int) {
        self.item = item
        
        numberLabel.text = String(item.number)
        switch item.number {
        case 1:
            viewColor.backgroundColor = .red
        case 2:
            viewColor.backgroundColor = .black
        case 3:
            viewColor.backgroundColor = .red
        case 4:
            viewColor.backgroundColor = .black
        case 5:
            viewColor.backgroundColor = .red
        case 6:
            viewColor.backgroundColor = .black
        case 7:
            viewColor.backgroundColor = .red
        case 8:
            viewColor.backgroundColor = .black
        case 9:
            viewColor.backgroundColor = .red
        case 10:
            viewColor.backgroundColor = .black
        case 11:
            viewColor.backgroundColor = .black
        case 12:
            viewColor.backgroundColor = .red
        case 13:
            viewColor.backgroundColor = .black
        case 14:
            viewColor.backgroundColor = .red
        case 15:
            viewColor.backgroundColor = .black
        case 16:
            viewColor.backgroundColor = .red
        case 17:
            viewColor.backgroundColor = .black
        case 18:
            viewColor.backgroundColor = .red
        case 19:
            viewColor.backgroundColor = .red
        case 20:
            viewColor.backgroundColor = .black
        case 21:
            viewColor.backgroundColor = .red
        case 22:
            viewColor.backgroundColor = .black
        case 23:
            viewColor.backgroundColor = .red
        case 24:
            viewColor.backgroundColor = .black
        case 25:
            viewColor.backgroundColor = .red
        case 26:
            viewColor.backgroundColor = .black
        case 27:
            viewColor.backgroundColor = .red
        case 28:
            viewColor.backgroundColor = .red
        case 29:
            viewColor.backgroundColor = .black
        case 30:
            viewColor.backgroundColor = .red
        case 31:
            viewColor.backgroundColor = .black
        case 32:
            viewColor.backgroundColor = .red
        case 33:
            viewColor.backgroundColor = .black
        case 34:
            viewColor.backgroundColor = .red
        case 35:
            viewColor.backgroundColor = .black
        case 36:
            viewColor.backgroundColor = .red
        default:
            break
        }
    }
}
