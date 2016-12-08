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
}

class AddFilterViewController: UIViewController {

    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var geoLabel: UILabel!
    
    @IBOutlet weak var geoSlider: UISlider!
    
    var delegate: AddFilterViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
