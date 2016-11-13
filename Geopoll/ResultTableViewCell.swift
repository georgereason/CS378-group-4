//
//  ResultTableViewCell.swift
//  Geopoll
//
//  Created by Michael Volk on 11/8/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var numVotes: UILabel!
    @IBOutlet weak var answerTable: UITableView!
    
    var question: Question?
    var answers: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        answerTable.delegate = self
        answerTable.dataSource = self
        answerTable.rowHeight = UITableViewAutomaticDimension
        answerTable.estimatedRowHeight = 44
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answerCell = answerTable.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
//        for a in (question?.answers)! {
//            newAnswers.append(a.key)
//        }
        if(indexPath.row < answers.count) {
            let answer = self.answers[indexPath.row]
            answerCell.textLabel?.text = answer
            let numAnswers = Double((question?.answers[answer])!)
            var numResponses = 1.0
            if(question?.answeredBy.count != 0) {
                numResponses = Double((question?.answeredBy.count)!)
            }
            let percent = numAnswers / numResponses * 100
            answerCell.detailTextLabel?.text = String(percent) + "%"
        }
        return answerCell
    }
    
    func setupTable() {
        answerTable.reloadData()
    }
    
}
