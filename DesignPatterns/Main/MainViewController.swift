//
//  MainViewControllerswift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

protocol MainViewInput: AnyObject {
    func changed(viewData: MainViewController.ViewData)
    func showAlert(error: Error)
}

protocol MainViewOutput: AnyObject {
    func set(view: MainViewInput)
    func viewDidAppear()
    func searchTapped(query: String, location: String?)
    func updateCurrentLocationTapped()
    func cellTapped(job: Job?, navigationController: UINavigationController?)
}

// MARK: - DataDisplayable
extension MainViewController {
    enum ViewData {
        case jobs(Jobs)
        case userLocation(UserLocation?)
    }
    
    private enum Constants {
        enum TableView {
            static var numberOfSections: Int { return 1 }
        }
        
        enum Text {
            static var title: String { return "Search Github Jobs" }
            static var noLocation: String { return "No Location" }
            static var errorTitle: String { return "Error" }
            static var okButtonTitle: String { return "OK" }
            static var placeholderTitle: String { return "Input Search" }
        }
    }
}

final class MainViewController: UIViewController {
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var currentLocationButton: UIButton!
    private var presenter: MainViewOutput!
    private var viewData: ViewData?
    private var jobs: Jobs = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var userLocation: UserLocation? {
        didSet {
            locationText.text = userLocation?.parsed ?? Constants.Text.noLocation
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
    }
}

// MARK: - Private Methods
private extension MainViewController {
    @objc func updateCurrentLocationTapped() {
        presenter.updateCurrentLocationTapped()
    }
}

// MARK: - MainViewModelOutput
extension MainViewController: MainViewInput {
    func set(presenter: MainViewOutput) {
        self.presenter = presenter
    }
    
    func changed(viewData: MainViewController.ViewData) {
        switch viewData {
        case .jobs(let jobs):
            self.jobs = jobs
            
        case .userLocation(let userLocation):
            self.userLocation = userLocation
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
        return Constants.TableView.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        let job = jobs[indexPath.row]
        cell.titleLabel.text = job.title
        cell.companyNameLabel.text = job.companyName
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let job = jobs[indexPath.row]
        presenter.cellTapped(job: job, navigationController: navigationController)
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchText.text {
            presenter.searchTapped(query: query, location: locationText.text)
        }
        view.endEditing(true)
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
        currentLocationButton.addTarget(self, action: #selector(updateCurrentLocationTapped), for: .touchUpInside)
    }
}
