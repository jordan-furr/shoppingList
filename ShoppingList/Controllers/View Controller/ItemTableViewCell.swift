//
//  ItemTableViewCell.swift
//  ShoppingList
//
//  Created by Jordan Furr on 3/6/20.
//  Copyright © 2020 Jordan Furr. All rights reserved.
//

import UIKit

protocol ItemTableViewCellDelegate: class {
    func tappedButton(for cell: ItemTableViewCell)
}
class ItemTableViewCell: UITableViewCell {
    
    var item: Item?
    weak var delegate: ItemTableViewCellDelegate?

    //MARK: IB OUTLETS
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    //MARK: IB Actions
    @IBAction func checkTapped(_ sender: Any) {
        delegate?.tappedButton(for: self)
    }
 
    
    func setItem(item: Item, isComplete: Bool){
        self.item = item
        updateUI(isComplete: isComplete)
    }
    
    @objc func updateUI(isComplete: Bool){
        guard let item = item else {return}
        labelText.text = item.name
        updateButton(isComplete: isComplete)
    }
    
    func updateButton(isComplete: Bool){
        if (isComplete){
            checkButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            checkButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }
}
