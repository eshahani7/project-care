//
//  WorkoutTableViewController.swift
//  projectCARE
//
//  Created by Cindy Lu on 2/21/18.
//  Copyright © 2018 Ekta Shahani. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {

    var list:[WorkoutFacade]?
    let store:HealthStore = HealthStore.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = WorkoutList()
        list = w.getWorkoutList() //[WorkoutFacade]
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(list != nil) {
            return list!.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WorkoutTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WorkoutTableViewCell.")
        }
        let workout = list![indexPath.row]
        
        print("Calorie Burn Goal: \(workout.getCalorieBurnGoal())")
        print("User Entered Time: \(workout.getUserEnteredTime())")
        print("Was goal met?: \(workout.wasGoalMet())")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: workout.getWorkoutDate())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "MM-dd-yyyy"
        let myDate = formatter.string(from: yourDate!)
        
        let date = workout.getWorkoutDate()
        let calender = Calendar.current
        let day = calender.component(.day, from: date)
        let dayString = String(day)
        
        cell.dateLabel.text = myDate
        cell.dayLabel.text = dayString
        
        // Configure the cell...
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
