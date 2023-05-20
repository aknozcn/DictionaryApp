//
//  SearchViewController.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import UIKit

class SearchViewController: UIViewController, Storyboardable {

    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var recentSearchTableView: UITableView!

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupNavigationController()

    }

    override func viewWillAppear(_ animated: Bool) {
        recentSearchTableView.reloadData()
    }

    // MARK: - Actions
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        guard let searchText = searchBar.text else {
            return
        }

        guard searchText.count > 1 else {
            return
        }

        let detailViewController = DetailViewController.instantiate(storyboardName: .detailScreen)
        detailViewController.setSearchWord(word: searchBar.text ?? "")
        navigationController?.pushViewController(detailViewController, animated: true)
        SearchManager.shared.addRecentSearches(word: searchBar.text ?? "")
    }
}

// MARK: - Private Methods
private extension SearchViewController {
    func setupSearchBar() {
        searchBar.setPlaceHolder(fontName: Fonts.robotoRegular, size: 17)
    }

    func setupTableView() {
        let nib = UINib(nibName: RecentSearchCell.identifier, bundle: nil)
        recentSearchTableView.register(nib, forCellReuseIdentifier: RecentSearchCell.identifier)
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        recentSearchTableView.rowHeight = 44
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController.instantiate(storyboardName: .detailScreen)
        detailViewController.setSearchWord(word: SearchManager.shared.getRecentSearches()[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
        SearchManager.shared.addRecentSearches(word: SearchManager.shared.getRecentSearches()[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchManager.shared.getRecentSearches().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recentSearchTableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else {
            return UITableViewCell()
        }
        
        let word = SearchManager.shared.getRecentSearches()[indexPath.row]
        cell.configure(word: word)
        return cell
    }
}
