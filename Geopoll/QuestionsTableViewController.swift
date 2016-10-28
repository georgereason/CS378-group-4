//
//  QuestionsTableViewController.swift
//  Geopoll
//
//  Created by Michael Volk on 10/23/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import UIKit
import Firebase

class QuestionsTableViewController: UITableViewController {
    
    
    let questionRef = FIRDatabase.database().reference(withPath: "questions")
    var questions = [Question]()

    var alertController:UIAlertController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset.top = UIApplication.shared.statusBarFrame.height

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        questionRef.observe(.value, with: { snapshot in
            // 2
            var newQuestions: [Question] = []
            
            
            // 3
            for q in snapshot.children {
                // 4
                let question = Question(snapshot: q as! FIRDataSnapshot)
                newQuestions.append(question)
            }
            
            // 5
            self.questions = newQuestions
            self.tableView.reloadData()
        })
        
//        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
//            guard let user = user else { return }
//            self.user = User(authData: user)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        questionRef.observe(.value, with: { snapshot in
            // 2
            var newQuestions: [Question] = []
            
            //            print("\n\n\n\n\n\nHHHHHEEEEEEYYYYYYY\n\n\n\n\n\n\n")
            
            // 3
            for q in snapshot.children {
                // 4
                let question = Question(snapshot: q as! FIRDataSnapshot)
                newQuestions.append(question)
            }
            
            // 5
            self.questions = newQuestions
            self.tableView.reloadData()
        })
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
        return questions.count
    }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc:VoteViewController? = nil
        let path = self.tableView.indexPathForSelectedRow!
        let currentUser = FIRAuth.auth()?.currentUser
        let userUID = currentUser?.uid
        let invalidVoters = questions[path.row].answeredBy
    if(invalidVoters[userUID!] == nil) {
        print("allowing vote to occur")
        print("current users \(questions[path.row].answeredBy)")
        if (segue.identifier == "voteSegue") {
            vc = segue.destination as! VoteViewController
            // pass data to next view
            
        }
        if let v = vc {
            // Set the navigation bar title to what was selected
            v.question = self.questions[path.row]
        }
    }
    else {
        self.alertController = UIAlertController(title: "You already voted for this poll", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) { (action) -> Void in
            print("Okay Button Pressed")
        }
        self.alertController!.addAction(ok)
        present(self.alertController!, animated: true, completion: nil)
    }

    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)

        // Configure the cell...
        let question = questions[indexPath.row]
        
        cell.textLabel?.text = question.text

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
