//
//  SearchViewController.swift
//  MyWeatherApp
//
//  Created by Suresh on 29/03/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchNavigationBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - vars/lets
    var viewModel = SearchViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }

    //MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - flow func
    
    private func updateUI() {
        view.backgroundColor = .clear
        searchNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchNavigationBar.topItem?.title = "Location".localize
        searchNavigationBar.tintColor = .white
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search".localize, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    private func bind() {
        viewModel.reloadTablView = { 
            DispatchQueue.main.async { self.searchTableView.reloadData() }
        }
        viewModel.getCity()
    }
}

//MARK: - Extensions
// Search delegate
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        viewModel.searchCity(text: text)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCity(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCity(text: searchBar.text!)
        self.searchBar.endEditing(true)
    }
}

// TableView delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        if viewModel.filteredCityIsEmpty() {
            
            guard let locationCell = tableView.dequeueReusableCell(withIdentifier: Constants.cells.selfLocationTableViewCell, for: indexPath) as? SelfLocationTableViewCell else { return UITableViewCell() }
            locationCell.configure()
            return locationCell
            
        } else {
            
            guard let searchCell = tableView.dequeueReusableCell(withIdentifier: Constants.cells.searchTableViewCell, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            let cellVieModel = viewModel.getCellViewModel(at: indexPath)
            searchCell.configure(filteredCities: cellVieModel)
            return searchCell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.didSelectRow(at: indexPath)
        self.dismiss(animated: true)

    }
}

