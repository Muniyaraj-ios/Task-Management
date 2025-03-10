//
//  MapLocationController.swift
//  Task Management
//
//  Created by MAC on 06/03/25.
//

import UIKit
import MapKit
import SwiftUI

struct MapKeySettings{
    static let coordinate_region = 500
    static let entryKey = "-entry"
    static let exitKey = "-exit"
    static let calendar = "-calendar"
}

final class MapLocationController: BaseController {
    
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var saveButton: CustomButton!
    
    weak var mapLocdelegate: MapSettingsPlaceMark?
    
    var selectedPlaceMark: MKPlacemark?{
        didSet{
            saveButton.isEnabled = selectedPlaceMark != nil
        }
    }
    
    private let viewModel = LocationSearchViewModel()
    
    private let locationViewModel = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDelegate()
        mapViewSetup()
    }
    
    private func setupView(){
        searchTF.configureTextField(placeholder: "Search Location", placeholderColor: .darkGray, returnType: .search)
        searchTF.delegate = self
        saveButton.isEnabled = selectedPlaceMark != nil
        saveButton.configureButton(title: "Save")
        saveButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    
    private func setupDelegate(){
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func mapViewSetup(){
        mapView.delegate = self
        locationViewModel.locationDelegate = self
        locationViewModel.start()
    }
    @objc func buttonAction(_ sender: Any){
        if let selectedPlaceMark{
            mapLocdelegate?.getfetchedUserPlaceMark(with: selectedPlaceMark)
        }
        dismiss(animated: true)
    }
    
    private func searchLocations(query: String) {
        Task {
            do {
                _ = try await viewModel.fetchLocations(for: query)
                tableView.reloadData()
            } catch let error {
                switch error {
                case LocationSearchError.emptyQuery:
                    print("Search query is empty. Please enter a location.")
                    break
                case LocationSearchError.searchFailed(let error):
                    print("Network error occurred. searchFailed : \(error.localizedDescription).")
                    break
                default:
                    print("Error fetching locations: \(error.localizedDescription)")
                    break
                }
                tableView.reloadData()
            }
        }
    }
}


extension MapLocationController: LocationDelegate{
    
    func currentLocation() {
        guard let location = locationViewModel.latestLocation else{ return }
        print("the current coordinats : \(location.coordinate)")
        locationViewModel.stop()
    }
    
    private func getAddressFromCoordinates(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse Geocode Error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                
                let address = [
                    placemark.subThoroughfare,
                    placemark.thoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
                
                print("Address: \(address)")
            }
        }
    }
    
}
extension MapLocationController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = textField.text, !query.isEmpty {
            searchLocations(query: query)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchLocations(query: "")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let newText = text.replacingCharacters(in: range, with: string)
            searchLocations(query: newText)
        }
        return true
    }
}
extension MapLocationController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else{ return MKOverlayRenderer() }
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red.withAlphaComponent(0.4)
        circleRenderer.lineWidth = 1.2
        return circleRenderer
    }
}
extension MapLocationController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        let results = viewModel.searchResults[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration(content: {
            VStack(alignment: .leading) {
                Text(results.placemark.title ?? "")
                    .foregroundStyle(.black)
                Text(results.placemark.subtitle ?? "")
                    .foregroundStyle(.black)
                Divider()
                    .frame(height: 1)
            }.font(.custom("Poppins-Regular", size: 14))
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let results = viewModel.searchResults[indexPath.row]
        print("selected loc  : \(results.placemark.description)")
        selectedPlaceMark = results.placemark
        addSelectedLocation(placeMark: results.placemark)
    }
    
    private func addSelectedLocation(placeMark: MKPlacemark){
//        defer{
//            searchTF.text?.removeAll()
//            searchLocations(query: "")
//        }
        setupDrawOverlay(placeMark: placeMark)
        setupZoomRegion(placeMark: placeMark)
    }
    
    private func setupDrawOverlay(placeMark: MKPlacemark){
        
        let region = CLCircularRegion(center: placeMark.coordinate, radius: CLLocationDistance(MapKeySettings.coordinate_region), identifier: "geofence_id")
        mapView.removeOverlays(mapView.overlays)
        
        let circle = MKCircle(center: placeMark.coordinate, radius: region.radius)
        mapView.addOverlay(circle)
    }
    
    private func setupZoomRegion(placeMark: MKPlacemark){
        
        let zoom_region = MKCoordinateRegion(center: placeMark.coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(zoom_region, animated: true)
    }
}

protocol MapSettingsPlaceMark: AnyObject{
    func getfetchedUserPlaceMark(with place: MKPlacemark)
}
