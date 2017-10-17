//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Paul on 2017-10-08.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import os.log
import Parse

class MealTableViewController: UITableViewController, SaveItemDelegate
{
    
    //MARK: Properties
    
    var meals = [Meal]()
    //happens everytime the view navigates from save to this screen
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        fetchMeal()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return meals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        //guard let safely unwraps the optional
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell
            else
        {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        
        cell.setUpCell(meal: meal)

        return cell
    }
    
    
    // Allows delete functionality in main view!
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: Delegate for saving
    
    func addMealObject(meal: Meal) -> Void {
    
        meals.append(meal)
        self.tableView.reloadData()
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        //different case for different scenarios
        case "AddItem":

        
            guard let mealViewController = segue.destination as? MealViewController else{
                fatalError("Unexpected destination:\(segue.destination)")
            }
            
            mealViewController.saveDelegate = self
            
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    

    
    
    
    
    
    //DATA persist function
    private func saveMeals () {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
        
        
        
        
    }
    
    //Load the meal list
    
    private func loadMeals() -> [Meal]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
    //fetch meals from cloud
    func fetchMeal() {
        let query = PFQuery(className: "Meal")
        //findObjectsInBackground already made the network request since its a server therefore we dont need to call it back like the regular network request.
        query.findObjectsInBackground {(mealsContent:[PFObject]?, error: Error?) in
            

            if let error = error{
                print(#line, error.localizedDescription)
                return
            }
            
            self.meals.append(contentsOf: mealsContent as! [Meal])
            self.tableView.reloadData()
        }
        
    }
    
    
    
}
