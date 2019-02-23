//
//  MainView.swift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

class MainView: UIViewController {
    private(set) var jobs: Jobs = []
    
    var apiClient: ApiClientType {
        return CurrentEnvironment.apiClient
    }
    var locationService: LocationServiceType {
        return CurrentEnvironment.locationService
    }

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoaded()
        updateCurrentAddress()
    }
    
    @objc func updateCurrentAddress() {
        locationService.currentAddress { [unowned self] (placemark) in
            guard let city = placemark?.locality, let postalCode = placemark?.postalCode else {
                self.addressLabel.text = "No Address"
                return
            }
            self.addressLabel.text = "\(city), \(postalCode)"
        }
    }
    
    @objc func updateLocationTapped() {
        searchText.resignFirstResponder()
        guard let postalCode = searchText.text, !postalCode.isEmpty else { return }
        updateAddressFor(postalCode: postalCode)
        fetchJobsAround(postalCode: postalCode)
    }
    
    @objc func fetchJobsAround(postalCode: String) {
        guard let url = URL(string: Route.parameters([Parameter.location: postalCode]).completeUrl) else { return }
        apiClient.get(url: url) { [unowned self] result in
            switch result {
            case .success(let jobs):
                self.jobs = jobs
                self.tableView.reloadData()
                
            case .failed(let error):
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            }
        }
    }
}

// MARK: - Private Methods
private extension MainView {
    func updateAddressFor(postalCode: String) {
        locationService.addressFor(postalCode: postalCode) { [unowned self] (placemark) in
            guard let city = placemark?.locality, let postalCode = placemark?.postalCode else {
                self.addressLabel.text = "No Address"
                return
            }
            self.addressLabel.text = "\(city), \(postalCode)"
        }
    }
}

// MARK: - UITableViewDataSource
extension MainView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = jobs[indexPath.row].title
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension MainView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard range.length == 1 || range.location < 5 else { return false }
        return true
    }
}

extension MainView: ViewCustomization {
    func setupUI() {
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        topView.backgroundColor = UIColor(red: 45/255, green: 49/255, blue: 66/255, alpha: 1)
        addressLabel.textColor = .white
        searchButton.setTitleColor(UIColor(red: 239/255, green: 131/255, blue: 84/255, alpha: 1), for: .normal)
    }
    
    func setupSelectors() {
        searchButton.addTarget(self, action: #selector(updateLocationTapped), for: .touchUpInside)
    }
}
