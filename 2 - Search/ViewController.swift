//
//  ViewController.swift
//  2 - Search
//
//  Created by Nicholas Furness on 1/27/15.
//  Copyright (c) 2015 Nicholas Furness. All rights reserved.
//

import UIKit
import ArcGIS

class ViewController: UIViewController, UISearchBarDelegate, AGSLocatorDelegate {

    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let locator = AGSLocator(URL: NSURL(string: "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Add a basemap layer
        let basemapUrl = "http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"
        let basemap = AGSTiledMapServiceLayer(URL: NSURL(string: basemapUrl))
        
        self.mapView.addMapLayer(basemap, withName: "Basemap")

        let centerPoint = AGSPoint(x: -77.0455, y:38.9067, spatialReference: AGSSpatialReference.wgs84SpatialReference())
        self.mapView.zoomToScale(61315, withCenterPoint: centerPoint, animated: true)
        
        self.locator.delegate = self
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("Search for \(searchBar.text)")
        searchBar.resignFirstResponder()

        let params = AGSLocatorFindParameters()
        params.text = searchBar.text
        locator.findWithParameters(params)
    }
    
    func locator(locator: AGSLocator!, operation op: NSOperation!, didFind results: [AnyObject]!) {
        if results.count > 0 {
            if let location = results[0] as? AGSLocatorFindResult {
                self.mapView.zoomToEnvelope(location.extent, animated: true)
                searchBar.text = ""
            }
        } else {
            UIAlertView(title: "No results", message: "Could not find \"\(self.searchBar.text)\"", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func locator(locator: AGSLocator!, operation op: NSOperation!, didFailToFindWithError error: NSError!) {
        UIAlertView(title: "Geocode Failed", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

