//
//  GroceryItemCell.swift
//  coreDataDemoApp
//
//  Created by Saranya Kalyanasundaram on 5/30/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import UIKit

class GroceryItemCell: UITableViewCell {

    @IBOutlet weak var groceryNameLabel: UILabel!
    @IBOutlet weak var addedDateLabel: UILabel!
    @IBOutlet weak var groceryImageInList: UIImageView!
    
    func setData(_ groceryData : Grocery){
        
        groceryNameLabel.text = groceryData.name ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let addedDate = dateFormatter.string(from: groceryData.addedDate!)
        addedDateLabel.text =  addedDate
        
        if let image = groceryData.groceryImage{
            groceryImageInList.image = UIImage(data: image)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
