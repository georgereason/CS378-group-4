//
//  AddFilterViewController.swift
//  Geopoll
//
//  Created by Nathan Poag on 12/4/16.
//  Copyright © 2016 cs378Group4. All rights reserved.
//

import UIKit

protocol AddFilterViewControllerDelegate: class {
    func sendChosenTime(data: Int)
    func sendChosenDistance(data: Int)
    func sendStartAge(start: Int)
    func sendEndAge(end: Int)
    func sendGender(gender: String)
    func getDefaultTime() -> Int
    func getDefaultDistance() -> Int
    func getDefaultStartAge() -> Int
    func getDefaultEndAge() -> Int
    func getDefaultGenderIndex() -> Int
}

class AddFilterViewController: UIViewController {
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var geoLabel: UILabel!
    
    @IBOutlet weak var geoSlider: UISlider!
    
    @IBOutlet weak var startAgeRange: UITextField!
    
    @IBOutlet weak var endAgeRange: UITextField!
    
    @IBOutlet weak var genderSelector: UISegmentedControl!
    
    
    var delegate: AddFilterViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .up
        let defaultTime = delegate?.getDefaultTime()
        let defaultDistance = delegate?.getDefaultDistance()
        let defaultStartAge = delegate?.getDefaultStartAge()
        let defaultEndAge = delegate?.getDefaultEndAge()
        timeSlider.value = Float(defaultTime!)
        timeLabel.text = formatter.string(from: NSNumber(value: timeSlider.value))! + " days"
        geoSlider.value = Float(defaultDistance!)
        geoLabel.text = formatter.string(from: NSNumber(value:geoSlider.value))! + " miles"
        startAgeRange.keyboardType = UIKeyboardType.numberPad
        endAgeRange.keyboardType = UIKeyboardType.numberPad
        startAgeRange.text = String(defaultStartAge!)
        endAgeRange.text = String(defaultEndAge!)
        genderSelector.selectedSegmentIndex = (delegate?.getDefaultGenderIndex())!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func timeSliderChanged(_ sender: AnyObject) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .up
        
        let timeSliderValue = formatter.string(from: NSNumber(value: timeSlider.value))!
        
        
        timeLabel.text = timeSliderValue + " days"
        if delegate != nil {
            delegate?.sendChosenTime(data: Int(timeSliderValue)!)
        }
        
    }
    
    @IBAction func geoSliderChanged(_ sender: AnyObject) {
        
        let geoSliderValue = Int(geoSlider.value)
        
        geoLabel.text = String(geoSliderValue) + " miles"
        if delegate != nil {
            delegate?.sendChosenDistance(data: geoSliderValue)
        }
    }
    
    @IBAction func startAgeChanged(_ sender: Any) {
        if startAgeRange.text == "" {
            delegate?.sendStartAge(start: 0)
        }
        else {
            delegate?.sendStartAge(start: Int(startAgeRange.text!)!)
        }
    }
    
    @IBAction func endAgeChanged(_ sender: Any) {
        if endAgeRange.text == "" {
            delegate?.sendEndAge(end: 150)
        }
        else {
            delegate?.sendEndAge(end: Int(endAgeRange.text!)!)
        }
    }
    
    @IBAction func genderFilterChanged(_ sender: Any) {
        delegate?.sendGender(gender: genderSelector.titleForSegment(at: genderSelector.selectedSegmentIndex)!)
    }
    
    
    //    func submitChanges() {
    //        if delegate != nil {
    //            delegate?.sendChosenTime(data: Int(timeSlider.value))
    //            delegate?.sendChosenDistance(data: Int(geoSlider.value))
    //            if startAgeRange.text == "" {
    //                startAgeRange.text = String(Int.min)
    //            }
    //            if endAgeRange.text == "" {
    //                endAgeRange.text = String(Int.max)
    //            }
    //            delegate?.sendAgeRange(start: Int(startAgeRange.text!)!, end: Int(endAgeRange.text!)!)
    //            delegate?.sendGender(gender: genderSelector.titleForSegment(at: genderSelector.selectedSegmentIndex)!)
    //        }
    //    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //        if segue.identifier == "submitFilterSegue" {
    //            submitChanges()
    //        }
    //    }
    
    
}
