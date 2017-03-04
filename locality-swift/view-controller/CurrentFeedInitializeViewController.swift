//
//  CurrentFeedInitializeViewController.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/4/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit
import Mapbox

class CurrentFeedInitializeViewController: LocalityBaseViewController {

    @IBOutlet weak var map : MGLMapView!
    @IBOutlet weak var locationLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMap() {
        map.setCenter(CLLocationCoordinate2D(latitude: 40.712791, longitude: -73.997848),
                                zoomLevel: 12,
                                animated: false)
        
        //init light style
        //let lightURL = URL(string: "asset://styles/light-v8.json")
        //map.styleURL = lightURL
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
