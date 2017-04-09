//
//  LocationSliderFluid.swift
//  locality-swift
//
//  Created by Chelsea Power on 4/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

protocol LocationSliderFluidDelegate {
    func sliderValueChanged(value: CGFloat)
}

class LocationSliderFluid: UIView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var slider:UISlider!
    @IBOutlet weak var stepLabel:UILabel!
    @IBOutlet weak var tickView:UIView!
   
    let kTickCount = 10
    
    
    var delegate:LocationSliderFluidDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.LocationSlider, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    func initFluidSlider() {
        
        slider.minimumValue = 0
        slider.maximumValue = Float(K.NumberConstant.RangeMaximumInMeters)
        
        populate()
    }
    
    func populate() {
        
        slider.addTarget(self, action: #selector(sliderValueDidUpdate), for: .valueChanged)
        setSliderAttributes()
        updateRangeLabel()
    }
    
    func setSliderAttributes() {
        
        slider.value = Float(K.NumberConstant.RangeMaximumInMeters / 2)
        slider.setThumbImage(UIImage(named:K.Image.SliderKnob), for: .normal)
        tickView.backgroundColor = UIColor(patternImage:UIImage(named:K.Image.SliderTickMark)!)
    }
    
    func updateRangeLabel() {
        
        let rangeStep = Util.distanceToDisplay(distance: CGFloat(slider.value))
        stepLabel.attributedText = Util.attributedRangeString(value: rangeStep.distance, unit: rangeStep.unit.uppercased())
    }
    
    func sliderValueDidUpdate(sender:UISlider) {
        
        updateRangeLabel()
        delegate?.sliderValueChanged(value: CGFloat(sender.value))
    }
    
    func getSliderValue() -> CGFloat {
        
        return CGFloat(slider.value)
    }
    
    func setRange(range: CGFloat) {
        
        slider.value = Float(range)
        updateRangeLabel()
    }
}
