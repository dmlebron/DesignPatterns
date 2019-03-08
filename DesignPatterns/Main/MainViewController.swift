//
//  MainViewControllerswift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit

//MARK: - To be Conformed by MainViewController
protocol MainViewInput: AnyObject {
    func changed(viewDataType: MainViewController.ViewDataType)
    func showAlert(error: Error)
}

//MARK: - To be Conformed by MainPresenter
protocol MainViewOutput: AnyObject {
    func set(view: MainViewInput)
    func viewDidAppear()
    func searchTapped(query: String, address: String?)
    func updateCurrentLocationTapped()
    func cellTapped(job: Job?, navigationController: UINavigationController?)
}

// MARK: - Objects
extension MainViewController {
    enum ViewDataType {
        case tableViewData(TableViewViewData)
        case location(Location?)
    }
    
    struct TableViewViewData {
        let numberOfSections: Int
        let numberOfRows: Int
        let items: [IndexPath: Job]
    }
    
    enum Constants {
        enum Text {
            static var title: String { return "Search Github Jobs" }
            static var noLocation: String { return "No Location" }
            static var errorTitle: String { return "Error" }
            static var okButtonTitle: String { return "OK" }
            static var placeholderTitle: String { return "Input Search" }
            static var placeholderZipcode: String { return "Enter Zipcode" }
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
    private(set) var presenter: MainViewOutput!
    private var tableViewData = TableViewViewData(numberOfSections: 0, numberOfRows: 0, items: [:]) {
        didSet {
            tableView.reloadData()
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
    
    func changed(viewDataType: ViewDataType) {
        switch viewDataType {
        case .tableViewData(let data):
            self.tableViewData = data
            
        case .location(let location):
            locationText.text = location?.parsed
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
        return tableViewData.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        let job = tableViewData.items[indexPath]
        cell.titleLabel.text = job?.title
        cell.companyNameLabel.text = job?.companyName
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let job = tableViewData.items[indexPath]
        presenter.cellTapped(job: job, navigationController: navigationController)
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchText.text {
            presenter.searchTapped(query: query, address: locationText.text)
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
        let locationPlaceholder = NSAttributedString(string: Constants.Text.placeholderZipcode, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
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
