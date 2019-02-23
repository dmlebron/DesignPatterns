//
//  MainViewControllerswift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private(set) var jobs: Jobs = []

    @IBOutlet weak var topDividerView: UIView!
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
        CurrentEnvironment.locationService.currentAddress { [unowned self] (placemark) in
            guard let city = placemark?.locality, let postalCode = placemark?.postalCode else {
                self.navigationItem.title = "No Address"
                return
            }
            self.navigationItem.title = "\(city), \(postalCode)"
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
}

// MARK: - Private Methods
private extension MainViewController {
    func updateAddressFor(postalCode: String) {
        CurrentEnvironment.locationService.addressFor(postalCode: postalCode) { [unowned self] (placemark) in
            guard let city = placemark?.locality, let postalCode = placemark?.postalCode else {
                self.navigationItem.title = "No Address"
                return
            }
            self.navigationItem.title = "\(city), \(postalCode)"
        }
    }
    
    func showAlert(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
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
        guard let viewController = UIStoryboard.detail.instantiateInitialViewController() as? DetailViewController else { return }
        let selectedJob = jobs[indexPath.row]
        viewController.set(job: selectedJob)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard range.length == 1 || range.location < 5 else { return false }
        return true
    }
}

// MARK: - ViewCustomization
extension MainViewController: ViewCustomizing {
    func setupUI() {
        tableView.backgroundColor = CurrentEnvironment.color.light
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        searchButton.setTitleColor(CurrentEnvironment.color.softRed, for: .normal)
        topDividerView.backgroundColor = CurrentEnvironment.color.darkGray
    }
    
    func setupSelectors() {
        searchButton.addTarget(self, action: #selector(updateLocationTapped), for: .touchUpInside)
    }
    
    func additionalSetup() {
        tableView.register(MainTableViewCell.nib, forCellReuseIdentifier: MainTableViewCell.identifier)
    }
}
