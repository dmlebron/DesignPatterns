//
//  MainViewControllerswift
//
//  Created by David Martinez-Lebron on 1/1/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import UIKit
import Combine

private extension MainViewController {
    enum Constants {
        enum Text {
            static var title: String { return "Search Github Jobs" }
            static var noLocation: String { return "No Location" }
            static var errorTitle: String { return "Error" }
            static var okButtonTitle: String { return "OK" }
            static var placeholderTitle: String { return "Input Search" }
            static var placeholderZipcode: String { return "Enter Zipcode" }
        }
        
        static let estimatedRowHeight: CGFloat = 80
    }
}

typealias MainTableViewViewData = MainViewController.TableViewViewData

final class MainViewController: UIViewController {
    
    struct TableViewViewData: Equatable {
        let numberOfSections: Int
        let numberOfRows: Int
        let items: Jobs
    }
    
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var currentLocationButton: UIButton!
    private var cancellables: [AnyCancellable] = []
    private var viewModel: MainViewModelType!
    private let color = Color()
    private var tableViewData: TableViewViewData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.input.viewDidAppear()
    }
}

// MARK: - Private Methods
private extension MainViewController {
    @objc func updateCurrentLocationTapped() {
        viewModel.input.updateCurrentLocationTapped()
    }
    
    func bindViewModel() {
        viewModel.output.tableViewDataPublisher?
            .sink { [weak self] data in
                self?.tableViewData = data
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.locationPublisher
            .sink { [weak self] location in
                self?.locationChanged(location)
            }
            .store(in: &cancellables)
        
        viewModel.output.detailViewControllerPublisher
            .sink { [weak self] in
                self?.pushViewController($0)
            }
            .store(in: &cancellables)
    }
    
    func locationChanged(_ location: Location?) {
        locationText.text = location?.parsed
    }
}

// MARK: - MainViewModelOutput
extension MainViewController {
    func bind(viewModel: MainViewModelType) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    func showAlert(error: Error) {
        let alertController = UIAlertController(title: Constants.Text.errorTitle, message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Constants.Text.okButtonTitle, style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let job = tableViewData?.items[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        let cellViewData = MainTableViewCell.ViewData(titleLabelColor: color.darkGray, companyLabelColor: color.darkGray, title: job.title, companyName: job.companyName)
        
        cell.setup(viewData: cellViewData)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let job = tableViewData?.items[indexPath.row] else { return }
        viewModel.input.cellTapped(job: job)
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if range.isBackspacing {
//            return true
//        }
//
//        // TODO: Should this onoly accepts zipcode?
//        // we can show a carousel with possible locations based on the input zipcode
//        if textField == locationText {
//            guard !string.trimmingCharacters(in: .letters).isEmpty else {
//                return false
//            }
//        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchText.text, !query.isEmpty {
             viewModel.input.searchTapped(query: query, address: locationText.text)
         }

        view.endEditing(true)
        return false
    }
}

// MARK: - ViewCustomization
extension MainViewController: ViewCustomizing {
    func setupUI() {
        navigationItem.title = Constants.Text.title
        
        tableView.backgroundColor = color.white
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        
        topDividerView.backgroundColor = UIColor.black
        
        let searchPlaceholder = NSAttributedString(string: Constants.Text.placeholderTitle, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
        searchText.attributedPlaceholder = searchPlaceholder
        searchText.clearButtonMode = .whileEditing
        searchText.textColor = color.white
        
        let locationPlaceholder = NSAttributedString(string: Constants.Text.placeholderZipcode, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0.6, alpha: 0.5)])
        locationText.attributedPlaceholder = locationPlaceholder
        locationText.clearButtonMode = .whileEditing
        locationText.textColor = color.white
        
        locationView.backgroundColor = color.darkGray
        
        currentLocationButton.setImage(UIImage.location, for: .normal)
        currentLocationButton.imageView?.contentMode = .scaleAspectFit
        
        view.backgroundColor = color.darkGray
    }
    
    func additionalSetup() {
        tableView.register(MainTableViewCell.nib, forCellReuseIdentifier: MainTableViewCell.identifier)
    }
    
    func setupSelectors() {
        currentLocationButton.addTarget(self, action: #selector(updateCurrentLocationTapped), for: .touchUpInside)
    }
}
