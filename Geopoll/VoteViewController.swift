//
//  VoteViewController.swift
//  Geopoll
//
//  Created by Nathan Poag on 10/26/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class VoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var question: Question!
    var numRows = 0
    var listAnswers: [String] = []
    var invalidVoters: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        voteTable.delegate = self
        voteTable.dataSource = self
        
        self.QuestionText.text = self.question!.text
        self.listAnswers = Array(self.question.answers.keys)
        invalidVoters = question.answeredBy
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var voteTable: UITableView!
    @IBOutlet weak var QuestionText: UILabel!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.answers.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteChoices", for: indexPath as IndexPath)
//        cell.textLabel?.text = self.question.answers[indexPath.row]
        cell.textLabel?.text = self.listAnswers[indexPath.row]
        // set cell's textLabel.text property
        // set cell's detailTextLabel.text property
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        let currentUser = FIRAuth.auth()?.currentUser
        let userUID = currentUser?.uid
        let key = question.ref?.child("answers").childByAutoId().key
        let childUpdates = ["/answeredBy/\(userUID!)": self.listAnswers[indexPath.row]]
//        question.ref?.child("answers").updateChildValues([self.listAnswers[indexPath.row] : question.answers[self.listAnswers[indexPath.row]]! + 1])
        question.ref?.updateChildValues(childUpdates)//([userUID! : self.listAnswers[indexPath.row]])
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
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
