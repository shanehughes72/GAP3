//
//  GPXViewController.swift
//  Trax
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
import Bolts


class GPXViewController: UIViewController, MKMapViewDelegate, UIPopoverPresentationControllerDelegate, CLLocationManagerDelegate
{
    
    let manager = CLLocationManager()
    var alreadyUpdatedLocation = Bool()
    var point = PFGeoPoint()
    var user = PFUser()
    // MARK: - Outlets

    @IBOutlet weak var mapView: MKMapView! {
                
        didSet {
            mapView.mapType = .Hybrid
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
    }
    
  
    @IBAction func Seach(sender: UIBarButtonItem) {
        
//        var findUsers:PFQuery? = PFUser.query()
//        findUsers!.whereKey("username",  equalTo: "test@test.com")
//        
//        let placesObjects2 = findUsers!.findObjects()!
//        print("placesObjects2 is \( findUsers)")
        
        // get it off the main thread when you move it out of this function to a helper function
        // Break on warnBlockingOperationOnMainThread() to debug
        // Create a query for places
        let query = PFQuery(className:"GeoPoints")
        // Interested in locations near user.
        print(query.whereKey("location", nearGeoPoint:point))
        // Limit what could be a lot of points.
        query.limit = 10
        // Final list of objects
        let placesObjects = query.findObjects()!
        //print("placesObjects is \( placesObjects)")
        
       
        //Start with a simple for loop and print the values for each point,
        //then create the annotation in the loop and set the values,
        //add the annotations to the map (best to create an array or annotations,
        //but one step at a time) –
        
        
        // ### Get waypoint name and callouts and populate from Parse ###
        // do some error checking and get this out of this function into a model
        // at least in a helper function
        //if let GeoPoints =
        for GeoPoints in placesObjects {
            //print(GeoPoints.objectId)
            let point = GeoPoints["location"] as! PFGeoPoint
//            let user = GeoPoints["user"] as! PFUser
//            let objId = user.objectId
//            print("user is \(user)")
//            print("objId is \(objId)")
            
//            let query = PFQuery(className:"User")
//            query.whereKey("objectId", equalTo:objId!)
//            query.limit = 10
//            let placesUsers = query.findObjects()
//            print("placesUsers is \(placesUsers)")
            
            
            
            //print("point is \(point)")
            let waypoint = EditableWaypoint(latitude: point.latitude, longitude: point.longitude)
            
            let userId = GeoPoints["user"] as! PFUser
            
            //print("userId is  \(userId)")
            
            let objId = userId.objectId!
            
            
            print("objId is \(objId)")
            
            
            let query3 = PFQuery.getUserObjectWithId(objId)
            
           print(query3?.username)
            
            
            //query.whereKey(key: String, containedIn:)
            waypoint.name = "Dropped from Parse"
            mapView.addAnnotation(waypoint)
            //let annotation = MKPointAnnotation()
            //annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
            //self.mapView.addAnnotation(annotation)
        }
        
        
    }
    
    
    
    
    // MARK: - Public API
    
    var gpxURL: NSURL? {
        didSet {
            clearWaypoints()
            if let url = gpxURL {
                GPX.parse(url) {
                    if let gpx = $0 {
                        self.handleWaypoints(gpx.waypoints)
                    }
                }
            }
        }
    }

    
    // MARK: - Waypoints
    


    private func clearWaypoints() {
        if mapView?.annotations != nil { mapView.removeAnnotations(mapView.annotations as [MKAnnotation]) }
    }
    
    private func handleWaypoints(waypoints: [GPX.Waypoint]) {
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }

    @IBAction func addWaypoint(sender: UILongPressGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Began {
            
            
            // will make these if lets and optional chaining later
            // make helper function to deal with coord, lat and long plus point to use with
            
            let coordinate = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
            let latitude = coordinate.latitude as Double
            let longitude = coordinate.longitude as Double
            point = PFGeoPoint(latitude:latitude, longitude:longitude)
            let pointer = PFObject(withoutDataWithClassName:"_User", objectId: "\(Constants.ObjectId)")
            //let geoPointer = PFObject(withoutDataWithClassName: <#T##String#>, objectId: <#T##String?#>)
            let placeObject = PFObject(className:"GeoPoints")
            
            //print("latitude is \(latitude)")
            //print("longitude is \(longitude)")
            //let ObjectId = PFUser.currentUser()!.objectId!
            //print(ObjectId) // "I am a programer" YESSSSSSS Now put it in a constants struct
            //let pointer = PFObject(objectWithoutDataWithClassName:"MyClassName", objectId: "xyz")
            //print("PFUser ID is \(PFUser.currentUser()!.objectId) ")
            //print("PFGeoPoint is \(point)"
            
            // User's location
            //let userGeoPoint = userObject["location"] as PFGeoPoint
            placeObject["user"] = pointer // shows up as Pointer <MyClassName> in the Data Browser
            placeObject["location"] = point
            placeObject.saveEventually()
        
            let waypoint = EditableWaypoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            waypoint.name = "Dropped"
            mapView.addAnnotation(waypoint)
            mapView.userTrackingMode = .None
            manager.stopUpdatingLocation()        }
    }
    
    // MARK: - MKMapViewDelegate
    
 
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.AnnotationViewReuseIdentifier)

        //print("annotation is \(annotation.coordinate)")
        //print("mapView.UserLocation is \(mapView.userLocation.coordinate)")
        //We return nil if the annotation is not userLocation to let the mapView display the blue dot & circle animation.
        //In order to show our custom annotation for userLocation just remove the line return nil; and do your customization there.
        //fix this if statement
        if(annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude) &&  (annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude)
       {
           print("they are not the same")
           return nil
       }
       
       if view == nil {
        
            // change? from MKPinAnnotationView
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view!.canShowCallout = true
        } else {
            view!.annotation = annotation
        }
        
        view!.draggable = annotation is EditableWaypoint
        
        view!.leftCalloutAccessoryView = nil
        view!.rightCalloutAccessoryView = nil
        
       if let waypoint = annotation as? GPX.Waypoint {
            
            if waypoint.thumbnailURL != nil {
                
                view!.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
                
            }
            if annotation is EditableWaypoint {
                
                //view!.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure)
                
                //view?.rightCalloutAccessoryView = UIButtonType.DetailDisclosure as? UIButton
                
                view!.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
                view!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
                //view?.rightCalloutAccessoryView = UIButtonType.DetailDisclosure as? UIButton
                
            }
        }
        
        return view
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if let waypoint = view.annotation as? GPX.Waypoint {
            print("waypoint is \(waypoint)")
            if let thumbnailImageButton = view.leftCalloutAccessoryView as? UIButton {
                let image: UIImage = UIImage(named: "cross")!
                thumbnailImageButton.setImage(image, forState: .Normal)
                
                
                //if let imageData = NSData(contentsOfURL: waypoint.thumbnailURL!) { // blocks main thread!
                    //if let image = UIImage(data: imageData) {
                        //thumbnailImageButton.setImage(image, forState: .Normal)
                    //}
                //}
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.DetailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            performSegueWithIdentifier(Constants.EditWaypointSegue, sender: view)
        } else if let waypoint = view.annotation as? GPX.Waypoint {
            if waypoint.imageURL != nil {
                performSegueWithIdentifier(Constants.ShowImageSegue, sender: view)
            }
        }
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
       //print("\(alreadyUpdatedLocation)")
        if(self.alreadyUpdatedLocation) {
            return
        }
        
        stopUpdatingLocation()
        //print("didUpdate")
        
        self.mapView.setRegion(MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1 , 0.1)), animated: true )
        //mapView.
        print("didUpdateUserLocation userLocation is \(mapView.userLocation.location)")
        
        // maybe useful later to stop tracking user
        //mapView.userTrackingMode = .None
        //manager.stopUpdatingLocation()
        
        
        
        
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        //if you want to stop tracking the user
        mapView.userTrackingMode = .None
        manager.stopUpdatingLocation()
        
    }
    
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.ShowImageSegue {
            if let waypoint = (sender as? MKAnnotationView)?.annotation as? GPX.Waypoint {
                if let ivc = segue.destinationViewController.contentViewController as? ImageViewController {
                    ivc.imageURL = waypoint.imageURL
                    ivc.title = waypoint.name
                }
            }
        } else if segue.identifier == Constants.EditWaypointSegue {
            if let waypoint = (sender as? MKAnnotationView)?.annotation as? EditableWaypoint {
                if let ewvc = segue.destinationViewController.contentViewController as? EditWaypointViewController {
                    if let ppc = ewvc.popoverPresentationController {
                        let coordinatePoint = mapView.convertCoordinate(waypoint.coordinate, toPointToView: mapView)
                        ppc.sourceRect = (sender as! MKAnnotationView).popoverSourceRectForCoordinatePoint(coordinatePoint)
                        let minimumSize = ewvc.view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                        ewvc.preferredContentSize = CGSize(width: Constants.EditWaypointPopoverWidth, height: minimumSize.height)
                        ppc.delegate = self
                    }
                    ewvc.waypointToEdit = waypoint
                }
            }
        }
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverFullScreen // full screen, but we can see what's underneath
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController?
    {
        let navcon = UINavigationController(rootViewController: controller.presentedViewController)
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
        visualEffectView.frame = navcon.view.bounds
        navcon.view.insertSubview(visualEffectView, atIndex: 0) // "back-most" subview
        return navcon
    }

    
    
    
    // MARK: - PFQuery stuff
    //User's location - get the users current location from mapView Delegate
    //    let latitude = coordinate.latitude as Double
    //    let longitude = coordinate.longitude as Double
    //    let point = PFGeoPoint(latitude:latitude, longitude:longitude)
    //
    //    already have it as a class var point
    
  
    // User's location
    //let userGeoPoint = placeObject["location"] as PFGeoPoint
    // Create a query for places
    
    // Create a query for places
    //var query = PFQuery(className:"PlaceObject")
    
    
    // Interested in locations near user.
    //query.whereKey(point, nearGeoPoint:userGeoPoint)
    
    
    // Limit what could be a lot of points.
    //query.limit = 10
    
    
    // Final list of objects
    //placesObjects = query.findObjects()
    
    
    
    // MARK: - View Controller Lifecycle


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //retrieve an existing MKUserLocation object from the userLocation mapView.userLocation.location
        
  
        
        // sign up to hear about GPX files arriving
        // we never remove this observer, so we will never leave the heap
        // might make some sense to think about when to remove this observer
        
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate

        center.addObserverForName(GPXURL.Notification, object: appDelegate, queue: queue)  { notification in
            if let url = notification.userInfo?[GPXURL.Key] as? NSURL {
                self.gpxURL = url
            }
        }

        //gpxURL = NSURL(string: "http://cs193p.stanford.edu/Vacation.gpx") // for demo/debug/testing
    }// ViewDidLoad
    
    
override func viewDidAppear(animated: Bool) {
    
    
    
    
    switch CLLocationManager.authorizationStatus() {
    case .AuthorizedAlways:
        print("authalways")
    case .NotDetermined:
        print("notdetermined")
        manager.requestAlwaysAuthorization()
    case .AuthorizedWhenInUse, .Restricted, .Denied:
        let alertController = UIAlertController(
            title: "Background Location Access Disabled",
            message: "In order to be notified about prayers and/or prophecies near you, please open this app's settings and set location access to 'Always'.",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
       
    }
}
    
    // MARK: Helper Functions
    
     private func stopUpdatingLocation() {
        
        //get off the main queue
        dispatch_async(dispatch_get_main_queue()) {
            
            // the building stop updating location function call
            self.manager.stopUpdatingLocation()
            
            self.alreadyUpdatedLocation = true
            
        }

    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImageSegue = "Show Image"
        static let EditWaypointSegue = "Edit Waypoint"
        static let EditWaypointPopoverWidth: CGFloat = 320
        static let ObjectId = PFUser.currentUser()!.objectId!
    }
}

// MARK: - Convenience Extensions

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController!
        } else {
            return self
        }
    }
}

extension MKAnnotationView {
    func popoverSourceRectForCoordinatePoint(coordinatePoint: CGPoint) -> CGRect {
        var popoverSourceRectCenter = coordinatePoint
        popoverSourceRectCenter.x -= frame.width / 2 - centerOffset.x - calloutOffset.x
        popoverSourceRectCenter.y -= frame.height / 2 - centerOffset.y - calloutOffset.y
        return CGRect(origin: popoverSourceRectCenter, size: frame.size)
    }
    

}
