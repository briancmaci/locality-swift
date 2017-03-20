//
//  LocationSlider.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/6/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

protocol LocationSliderDelegate {
    func sliderValueChanged(step:Int)
}
class LocationSlider: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var slider:UISlider!
    @IBOutlet weak var stepLabel:UILabel!
    @IBOutlet weak var tickView:UIView!
    
    var sliderRange:[RangeStep]!
    var stepsCount:Int!
    var currentStep:Int!
    
    var delegate:LocationSliderDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.LocationSlider, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func initSlider() -> [RangeStep] {
        let stepsArray = Util.getPList(name: K.PList.RangeValuesFeet)["Steps"] as! [AnyObject]
        var steps:[RangeStep] = [RangeStep]()
        
        for i in 0...stepsArray.count-1 {
            let step:RangeStep = RangeStep(distance: stepsArray[i]["distance"] as! CGFloat,
                                           label:stepsArray[i]["label"] as! String,
                                           unit:stepsArray[i]["unit"] as! String)
            steps.append(step)
        }
        
        populate(range: steps)
        
        return steps
    }
    
    func populate(range:[RangeStep]) {
        
        sliderRange = range
        stepsCount = sliderRange.count - 1
        currentStep = stepsCount/2
        
        slider.addTarget(self, action: #selector(sliderValueDidUpdate), for: .valueChanged)
        setSliderAttributes()
        updateRangeLabel()
    }
    
    func setSliderAttributes() {
        slider.minimumValue = 0
        slider.maximumValue = Float(stepsCount)
        slider.value = Float(currentStep)
        
        slider.setThumbImage(UIImage(named:K.Image.SliderKnob), for: .normal)
        
        tickView.backgroundColor = UIColor(patternImage:UIImage(named:K.Image.SliderTickMark)!)
    }
    
    func updateRangeLabel() {
        let step:String = sliderRange[Int(slider.value)].label
        let unit:String = sliderRange[Int(slider.value)].unit
        
        stepLabel.attributedText = Util.attributedRangeString(value: step, unit: unit.uppercased())
    }
    
    func sliderValueDidUpdate(sender:UISlider) {
        
        let newStep:Int = Int(roundf(sender.value))
        sender.value = Float(newStep)
        
        if currentStep == newStep {
            return
        }
        
        currentStep = newStep
        updateRangeLabel()
        
        delegate?.sliderValueChanged(step: Int(sender.value))
    }

}
