//
//  Meal.swift
//  FoodTracker
//
//  Created by Paul on 2017-10-08.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import os.log
import Parse

//since this is a subclass of PFObject it allows us to use its property must use @NSManaged
// Image is a little different you have to save it as a PFFile then retrieve it using data and saving it as an image so it requires another thread.(they have a reference to the photo) they dont want to upload the picture on to their domain.
class Meal: PFObject{
    
    //MARK: Properties
    @NSManaged var name: String
    //when i call pffile i store the image as this photo
    var photo: UIImage?
    
    //picture currently saved as data so i need to call this pffile to get image.
    @NSManaged var pfFile: PFFile?
    
    @NSManaged var star: Int
    
    
    
    //MARK: Initialization
    //init will fail if there is no name or if the rating is negative
    convenience init?(name: String, rating: Int, pfFile: PFFile)
    {
        self.init()

        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.pfFile = pfFile
        self.star = rating
    }
    
}


//Allows me to use subclass in MealViewController save button.. so i can use dot notation properties.
extension Meal: PFSubclassing {

    static func parseClassName() -> String {
        return "Meal"
    }

}
