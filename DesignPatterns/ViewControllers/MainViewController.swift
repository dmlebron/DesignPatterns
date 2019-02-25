//
//  MainViewControllerswift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

// MARK: - DataDisplayable
extension MainViewController {
    private enum Constants {
        enum Text {
            static var title: String { return "Search Github Jobs" }
            static var noLocation: String { return "No Location" }
            static var errorTitle: String { return "Error" }
            static var okButtonTitle: String { return "OK" }
            static var placeholderTitle: String { return "Input Search" }
        }
    }
}

class MainViewController: UIViewController {
    private(set) var userLocation: UserLocation? {
        didSet {
            guard let userLocation = self.userLocation else {
                locationText.text = Constants.Text.noLocation
                return
            }
            locationText.text = userLocation.parsed
        }
    }
    private(set) var jobs: Jobs = []
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCurrentAddress()
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func search() {
        guard let query = searchText.text, !query.isEmpty else { return }
        if let location = locationText.text {
            updateAddressFor(location: location) { [weak self] in
                self?.fetchJobs(query: query)
            }
        } else {
            self.fetchJobs(query: query)
        }
        searchText.resignFirstResponder()
    }
    
    func fetchJobs(query: String) {
        let route = userLocation != nil ? Route.parameters([.jobType: query, .location: userLocation!.city]) : Route.parameters([Parameter.jobType: query])
        guard let url = URL(string: route.completeUrl) else { return }
        CurrentEnvironment.apiClient.get(url: url) { [unowned self] result in
            switch result {
            case .success(let jobs):
                self.jobs = jobs
                self.tableView.reloadData()
                
            case .failed(let error):
                self.showAlert(error: error)
            }
        }
    }
    
    @objc func updateCurrentAddress() {
        CurrentEnvironment.locationService.currentAddress { [unowned self] (placemark) in
            if let city = placemark?.locality, let postalCode = placemark?.postalCode, let country = placemark?.isoCountryCode {
                self.userLocation = UserLocation(postalCode: postalCode, city: city, country: country)
            }
        }
    }
    
    func updateAddressFor(location: String, completion: @escaping () -> Void) {
        CurrentEnvironment.locationService.addressFor(location: location) { [unowned self] (placemark) in
            guard let city = placemark?.locality, let postalCode = placemark?.postalCode, let country = placemark?.isoCountryCode else {
                return completion()
            }
            self.userLocation = UserLocation(postalCode: postalCode, city: city, country: country)
            completion()
        }
    }
    
    func showAlert(error: Error) {
        let alertController = UIAlertController(title: Constants.Text.errorTitle, message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Constants.Text.okButtonTitle, style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.titleLabel.text = jobs[indexPath.row].title
        cell.companyNameLabel.text = jobs[indexPath.row].companyName
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewController = UIStoryboard.detail.instantiateInitialViewController() as? DetailViewController else { return }
        let job = jobs[indexPath.row]
        viewController.set(job: job)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return false
    }
}

// MARK: - ViewCustomization
extension MainViewController: ViewCustomizing {
    func setupUI() {
        navigationItem.title = Constants.Text.title
        tableView.backgroundColor = CurrentEnvironment.color.white
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        topDividerView.backgroundColor = UIColor.black
        searchText.textColor = CurrentEnvironment.color.white
        let searchPlaceholder = NSAttributedString(string: Constants.Text.placeholderTitle, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
        searchText.attributedPlaceholder = searchPlaceholder
        searchText.clearButtonMode = .whileEditing
        locationText.textColor = CurrentEnvironment.color.white
        let locationPlaceholder = NSAttributedString(string: "Location", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
        locationText.attributedPlaceholder = locationPlaceholder
        locationText.clearButtonMode = .whileEditing
        view.backgroundColor = CurrentEnvironment.color.darkGray
        locationView.backgroundColor = CurrentEnvironment.color.darkGray
        currentLocationButton.setImage(UIImage.location, for: .normal)
        currentLocationButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func additionalSetup() {
        tableView.register(MainTableViewCell.nib, forCellReuseIdentifier: MainTableViewCell.identifier)
    }
    
    func setupSelectors() {
        currentLocationButton.addTarget(self, action: #selector(updateCurrentAddress), for: .touchUpInside)
    }
}
