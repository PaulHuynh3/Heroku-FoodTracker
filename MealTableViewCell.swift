//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Paul on 2017-10-08.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class MealTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    func setUpCell(meal:Meal){
        
        nameLabel.text = meal.name
        ratingControl.rating = meal.star
        
        if let photo = meal.photo {
            photoImageView.image = photo
        } else {
            if let photoFile: PFFile = meal["pfFile"] as? PFFile {
                //the getDataInBackground is passing the actual completion block which we did for cloudtracker. think of the getdataInBackground as the completion handler being called.
                photoFile.getDataInBackground { (data, err) in
                    if let err = err{
                        print(#line, err.localizedDescription)
                        return
                    }
                    
                    guard let data = data else {
                        return
                    }
                    //acess it using pfFile and save it to the meal.photo property.
                    meal.photo = UIImage(data: data)
                    // might need to check cell is still displaying this meal
                    OperationQueue.main.addOperation {
                        self.photoImageView.image = meal.photo
                    }
                }
            }
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
