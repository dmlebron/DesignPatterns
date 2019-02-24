//
//  MainViewControllerswift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

// MARK: - DataDisplayable
extension MainViewController: DataDisplayable {
    private enum Constants {
        enum Text {
            static var title: String { return "Search Github Jobs" }
            static var noLocation: String { return "No Location" }
            static var errorTitle: String { return "Error" }
            static var okButtonTitle: String { return "OK" }
            static var placeholderTitle: String { return "Input Search" }
        }
    }
    
    struct ViewData {
        let postalCode: String
        let city: String
        let country: String
        
        var parsed: String {
            return "\(city), \(country)"
        }
    }
}

class MainViewController: UIViewController {
    private(set) var viewData: ViewData? {
        didSet {
            guard let viewData = self.viewData else {
                locationText.text = Constants.Text.noLocation
                return
            }
            locationText.text = viewData.parsed
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
        viewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCurrentAddress()
        searchText.becomeFirstResponder()
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
        let route = viewData != nil ? Route.parameters([.jobType: query, .location: viewData!.postalCode]) : Route.parameters([Parameter.jobType: query])
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
                self.viewData = ViewData(postalCode: postalCode, city: city, country: country)
            }
        }
    }
    
    func updateAddressFor(location: String, completion: @escaping () -> Void) {
        CurrentEnvironment.locationService.addressFor(location: location) { [unowned self] (placemark) in
            guard let city = placemark?.locality, let postalCode = placemark?.postalCode, let country = placemark?.isoCountryCode else {
                return completion()
            }
            self.viewData = ViewData(postalCode: postalCode, city: city, country: country)
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
        if let name = jobs[indexPath.row].companyName {
            let urlString = jobs[indexPath.row].companyUrlString
            let attributedDescription = jobs[indexPath.row].attributedDescriptionText
            let location = jobs[indexPath.row].location
            let imageUrlString = jobs[indexPath.row].companyLogo
            let detailViewData = DetailViewController.ViewData(name: name, companyUrl: urlString, attributedDescription: attributedDescription, location: location, imageUrlString: imageUrlString)
            viewController.set(viewData: detailViewData)
            navigationController?.pushViewController(viewController, animated: true)
        }
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
        tableView.backgroundColor = CurrentEnvironment.color.white
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        topDividerView.backgroundColor = UIColor.black
        searchText.textColor = CurrentEnvironment.color.white
        let searchPlaceholder = NSAttributedString(string: Constants.Text.placeholderTitle, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
        searchText.attributedPlaceholder = searchPlaceholder
        locationText.textColor = CurrentEnvironment.color.white
        let locationPlaceholder = NSAttributedString(string: "Location", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
        locationText.attributedPlaceholder = locationPlaceholder
        locationText.clearsOnBeginEditing = true
        navigationItem.title = Constants.Text.title
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
