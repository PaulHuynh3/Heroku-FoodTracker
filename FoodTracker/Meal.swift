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
    //this is stored when pffile is called and shit
    var photo: UIImage?
    
    @NSManaged var pfFile: PFFile?
    
    @NSManaged var star: Int
    
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
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




//THIS ALLOWS ME TO SUBCLASS SO I CAN USE the properties the normal way
extension Meal: PFSubclassing {

    static func parseClassName() -> String {
        return "Meal"
    }

}
