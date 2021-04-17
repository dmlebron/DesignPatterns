//
//  MainViewControllerswift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

// MARK: - Constants
private extension MainViewController {
    enum Constants {
        enum Text {
            static let title = "Search Github Jobs"
            static let noLocation = "No Location"
            static let errorTitle = "Error"
            static let okButtonTitle = "OK"
            static let placeholderTitle = "Input Search"
            static let placeholderZipcode = "Enter Zipcode"
            
        }
        
        static let minimumQueryLength = 2
    }
}

final class MainViewController: UIViewController {
    private(set) var userLocation: Location? {
        didSet {
            guard let userLocation = self.userLocation else {
                locationText.text = Constants.Text.noLocation
                return
            }
            locationText.text = userLocation.parsed
        }
    }
    private(set) var jobs: Jobs = []
    private var searchTextTimer: Timer?
    
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
    func search(query: String) {
        guard !query.isEmpty else { return }
        
        if let address = locationText.text, address.count > Constants.minimumQueryLength {
            fetchJobs(query: query, city: address)
            
        } else {
            fetchJobs(query: query)
        }
    }
    
    func fetchJobs(query: String, city: String? = nil) {
        let route = city != nil ? Route.parameters([.jobType: query, .location: city!]) : Route.parameters([Parameter.jobType: query])
        
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
        CurrentEnvironment.locationService.currentAddress { [unowned self] (location) in
            if let location = location {
                self.userLocation = location
            }
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let query: String
        
        if textField == searchText {
            let newText = (textField.text! as NSString)
                .replacingCharacters(in: range, with: string)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            query = newText
            
        } else {
            query = searchText?.text ?? ""
        }
        
        guard query.count > Constants.minimumQueryLength else { return true }
        
        if let timer = searchTextTimer {
            timer.invalidate()
        }
        
        searchTextTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
            self?.search(query: query)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
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
        
        let searchPlaceholder = NSAttributedString(string: Constants.Text.placeholderTitle, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
        searchText.attributedPlaceholder = searchPlaceholder
        searchText.clearButtonMode = .whileEditing
        searchText.textColor = CurrentEnvironment.color.white
        
        let locationPlaceholder = NSAttributedString(string: Constants.Text.placeholderZipcode, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
        locationText.textColor = CurrentEnvironment.color.white
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
