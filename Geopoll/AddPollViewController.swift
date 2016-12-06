//
//  AddPollViewController.swift
//  Geopoll
//
//  Created by Michael Volk on 10/25/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import UIKit
import Firebase

class AddPollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AddFilterViewControllerDelegate {
    
    let questionRef = FIRDatabase.database().reference(withPath: "questions")
    
    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var answerTable: UITableView!
    
    var answers:[String] = []
    
    var alertController:UIAlertController? = nil
    var answerTextField:UITextField? = nil
    var questionTime:String? = "4"
    var geoRadius:Int? = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        answerTable.delegate = self
        answerTable.dataSource = self
        questionText.delegate = self
        let tapOut: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddPollViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapOut)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAnswerButton(_ sender: AnyObject) {
        self.alertController = UIAlertController(title: "Type Answer", message: "Add a new answer to your poll", preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            if(!(self.answerTextField?.text?.isEmpty)!) {
                self.answers.append((self.answerTextField?.text)!)
                var indexesPath = [IndexPath]()
                indexesPath.append(IndexPath(row: self.answers.count - 1, section: 0))
                self.answerTable.insertRows(at: indexesPath, with: UITableViewRowAnimation.bottom)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        
        self.alertController!.addAction(ok)
        self.alertController!.addAction(cancel)
        
        self.alertController!.addTextField { (textField) -> Void in
            // Enter the textfiled customization code here.
            self.answerTextField = textField
            self.answerTextField?.placeholder = "New Answer"
        }
        
        present(self.alertController!, animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: AnyObject) {
        if(!(self.questionText.text?.isEmpty)! && self.answers.count != 0) {
            var answerDict:[String:Int] = [:]
            for a in answers {
                answerDict[a] = 0
            }
            let key = questionRef.childByAutoId().key
            let currentUser = FIRAuth.auth()?.currentUser
            let uid = currentUser?.uid
            let text = self.questionText.text
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let dateResult = formatter.string(from: currentDate) + " 00:00:00"
            let q = Question(text: text!, addedByUser: uid!, answers: answerDict, answeredBy: [:], location: myLocation, maxDistance:Double(self.geoRadius!), questionDate: dateResult, dateRange: self.questionTime!) //0 should be replaced with the max distance retrieved from textfield in storyboard
            questionRef.child(key).setValue(q.toAnyObject())
            answers.removeAll()
            questionText.text?.removeAll()
            answerTable.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath as IndexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = answers[row]
        return cell
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Is being called")
        self.view.endEditing(true)
        return false
    }
    
    func sendChosenTime(data: String) {
        
        self.questionTime = data
    }
    
    func sendChosenDistance(data: Int) {
        
        self.geoRadius = data
    }
    
    @IBAction func unwindToQuestionCreation(segue: UIStoryboardSegue) {}
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showFilterVC" {
            let sendingVC: AddFilterViewController = segue.destination as! AddFilterViewController
            sendingVC.delegate = self
        }
    }
 

}
