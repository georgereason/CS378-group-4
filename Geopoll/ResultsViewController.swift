//
//  ResultsViewController.swift
//  Geopoll
//
//  Created by Michael Volk on 11/7/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import UIKit
import Firebase

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var postFilterSegment: UISegmentedControl!
    @IBOutlet weak var resultsTable: UITableView!
    
    let questionRef = FIRDatabase.database().reference(withPath: "questions")
    var myPostedQuestions = [Question]()
    var myAnsweredQuestions = [Question]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultsTable.delegate = self
        resultsTable.dataSource = self
        
        questionRef.observeSingleEvent(of: .value, with: { snapshot in
            // 2
            var newPosted: [Question] = []
            var newAnswered: [Question] = []
            
            
            // 3
            for q in snapshot.children {
                // 4
                let question = Question(snapshot: q as! FIRDataSnapshot)
                let currentUser = FIRAuth.auth()?.currentUser
                let userUID = currentUser?.uid
                let asker = question.addedByUser
                let responders = question.answeredBy
                if(userUID == asker) {
                    newPosted.append(question)
                }
                else if(responders[userUID!] != nil) {
                    newAnswered.append(question)
                }
            }
            
            // 5
            self.myPostedQuestions = newPosted
            self.myAnsweredQuestions = newAnswered
            self.resultsTable.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnVal = 0
        
        switch(postFilterSegment.selectedSegmentIndex) {
        
        case 0:
            returnVal = myPostedQuestions.count
            
        case 1:
            returnVal = myAnsweredQuestions.count
            
        default:
            returnVal = myPostedQuestions.count
        }
        
        return returnVal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = resultsTable.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        var question:Question?
        
        switch(postFilterSegment.selectedSegmentIndex) {
            
        case 0:
            question = myPostedQuestions[indexPath.row]
            
        case 1:
            question = myAnsweredQuestions[indexPath.row]
            
        default:
            question = myPostedQuestions[indexPath.row]
        }
        let numVotes = question?.answeredBy.count
        resultCell.textLabel?.text = question?.text
        resultCell.detailTextLabel?.text = "Votes: " + String(describing: numVotes!)
        
        return resultCell
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        resultsTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
