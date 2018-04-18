//
//  ViewController.swift
//  example
//
//  Created by Alejandro Gonzalez on 4/12/18.
//  Copyright © 2018 dostuff. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var locationManager: CLLocationManager!
    var dict = Dictionary<String, String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //geostuff
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        //method that gets location then pulls data from firebase
        reverseGeocodeAndFirebase(location: locationManager.location!)
        
        //creating subview
        dict = ["party time": "woot woot", "Silent Disco": "dance with friends at pace", "partie" : "I'm a stupid description"]
//        didSeeObject(thing: "THIS IS A DESCRIPTION THAT WILL COME ONCE THERE IS DATA TO BE PULLED FROM FIREBASE", dict: myDict)
        
    }
    
    
    
    func reverseGeocodeAndFirebase(location: CLLocation){
        //getting city name
        var cityOfUser = ""
        CLGeocoder().reverseGeocodeLocation(locationManager.location!) { (placemark, error) in
            if error != nil{
                print("there was an error")
            } else {
                if let place = placemark?[0] {
                    print(place.locality!)
                    cityOfUser = place.locality!
                }
            }
            
            //getting firebase stuff
            let ref = Database.database().reference(withPath: "City")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                if !snapshot.exists() {return}
                let proofOfConceptDict = snapshot.childSnapshot(forPath: cityOfUser).value as! NSDictionary
                print(proofOfConceptDict)
            })
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let titles = Array(dict.keys)
        let descriptions = Array(dict.values)
        let label = cell.viewWithTag(2) as! UILabel
        label.text = titles[indexPath.row]
        let textView = cell.viewWithTag(1) as! UITextView
        textView.text = descriptions[indexPath.row]
        cell.backgroundColor = UIColor.orange
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: 100, height:self.view.frame.height - 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: 100)
    }
    
    
}

