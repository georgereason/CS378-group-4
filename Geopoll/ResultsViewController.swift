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
    
    var refreshControl: UIRefreshControl?
    
    let questionRef = FIRDatabase.database().reference(withPath: "questions")
    var myPostedQuestions = [Question]()
    var myAnsweredQuestions = [Question]()
    
    var myPostedCells = [ResultTableViewCell]()
    var myAnsweredCells = [ResultTableViewCell]()
    
    var selectedIndexPath: IndexPath? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultsTable.delegate = self
        resultsTable.dataSource = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.resultsTable.addSubview(refreshControl!)
        self.loadResultsTable()
        
        
//        questionRef.observeSingleEvent(of: .value, with: { snapshot in
//            // 2
//            var newPosted: [Question] = []
//            var newAnswered: [Question] = []
//            
//            
//            // 3
//            for q in snapshot.children {
//                // 4
//                let question = Question(snapshot: q as! FIRDataSnapshot)
//                let currentUser = FIRAuth.auth()?.currentUser
//                let userUID = currentUser?.uid
//                let asker = question.addedByUser
//                let responders = question.answeredBy
//                if(userUID == asker) {
//                    newPosted.append(question)
//                }
//                else if(responders[userUID!] != nil) {
//                    newAnswered.append(question)
//                }
//            }
//            
//            // 5
//            self.myPostedQuestions = newPosted
//            self.myAnsweredQuestions = newAnswered
//            self.resultsTable.reloadData()
//        })
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
            break
        }
        
        return returnVal
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell = resultsTable.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultTableViewCell
        
        
        var question:Question?
        
        switch(postFilterSegment.selectedSegmentIndex) {
            
        case 0:
            question = myPostedQuestions[indexPath.row]
            myPostedCells.append(resultCell)
        case 1:
            question = myAnsweredQuestions[indexPath.row]
            myAnsweredCells.append(resultCell)
        default:
            break
        }
        let numVotes = question?.answeredBy.count
        resultCell.questionText?.text = question?.text
        resultCell.numVotes?.text = "Votes: " + String(describing: numVotes!)
        resultCell.question = question
        var answers = [String]()
        for a in (question?.answers)! {
            answers.append(a.key)
        }
        resultCell.answers = answers
        resultCell.setupTable()
        return resultCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndexPath != nil {
            if indexPath == selectedIndexPath {
                var resultCell: ResultTableViewCell?
                if(postFilterSegment.selectedSegmentIndex == 0) {
                    resultCell = myPostedCells[indexPath.row]
                }
                else {
                    resultCell = myAnsweredCells[indexPath.row]
                }
                return 60 + (CGFloat((resultCell?.answers.count)!) * 44)
            }else {
                return 60
            }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch selectedIndexPath {
        case nil:
            selectedIndexPath = indexPath
        default:
            if selectedIndexPath == indexPath {
                selectedIndexPath = nil
                
            } else {
                selectedIndexPath = indexPath
            }
        }
        resultsTable.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func refresh(sender:AnyObject) {
        self.loadResultsTable()
    }
    
    func loadResultsTable() {
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
            if(self.refreshControl?.isRefreshing)! {
                self.refreshControl?.endRefreshing()
            }
            self.resultsTable.reloadData()
        })
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        selectedIndexPath = nil
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
