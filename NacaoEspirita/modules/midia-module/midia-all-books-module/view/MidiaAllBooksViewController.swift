//
//  MidiaAllBooksViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/20/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MidiaAllBooksViewController: LoginBaseViewController {

    var presenter: MidiaAllBooksViewToPresenterProtocol?
    
    @IBOutlet weak var collectionTableView: UICollectionView!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var searchFooterBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeSearchOption: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func closeSearchOptionAction(_ sender: Any) {
        self.searchController.searchBar.endEditing(true)
        closeSearchOption.isHidden = true
    }
    
    var bookArray: [BookModel] = []
    let storage = Storage.storage()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredBooks: [BookModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        presenter?.startFetchingBooks()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = "Livros"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColor.MAIN_BLUE,
             NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 21)!]
    }
    
    func setSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Procure por autor ou título"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredBooks = bookArray.filter { (book: BookModel) -> Bool in
            return ((book.name?.lowercased().contains(searchText.lowercased()))! || (book.author?.lowercased().contains(searchText.lowercased()))!)
        }
        
        collectionTableView.reloadData()
    }
    
    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }
        
        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.closeSearchOption.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
}

//MARK: Interaction between Presenter and View
extension MidiaAllBooksViewController: MidiaAllBooksPresenterToViewProtocol {

    func showBooks(booksArray: [BookModel]) {
        self.bookArray = booksArray
        self.collectionTableView.reloadData()
        loading.isHidden = true
    }
    
    func showError() {
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: "Problem Fetching Cards", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: Tableview
extension MidiaAllBooksViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setCollectionView() {
        self.collectionTableView.delegate = self
        self.collectionTableView.dataSource = self
        self.collectionTableView.register(UINib(nibName: "BookCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BookCollectionCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredBooks.count, of: bookArray.count)
            return filteredBooks.count
        }
        
        searchFooter.setNotFiltering()
        return bookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionCell", for: indexPath) as! BookCollectionViewCell
        
        let book: BookModel
        
        if isFiltering {
            book = filteredBooks[indexPath.row]
        } else {
            book = bookArray[indexPath.row]
        }
        
        cell.bookTitleLabel.text = book.name

        // Reference to an image file in Firebase Storage
        let storageRef = storage.reference(withPath: "images/")
        let reference = storageRef.child("\(book.linkImage!).jpg")
        // Placeholder image
        let placeholderImage = UIImage(named: "placeholder.png")
        // Load the image using SDWebImage
        cell.bookImage.sd_setImage(with: reference, placeholderImage: placeholderImage)

        cell.buttonTappedAction = { (cell) in
            self.downloadBook(linkBook: book.linkBook!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsPerRow : CGFloat = 3.0
        let itemWidth = (collectionView.bounds.width / numberOfCellsPerRow)
        let itemHeight = itemWidth * 1.5
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func downloadBook(linkBook: String) {
        showProgressIndicator(view: navigationController!.view)
        
        // Create a reference to the file you want to download
        let storageRef = storage.reference(withPath: "books/")
        let bookRef = storageRef.child("\(linkBook).pdf")
        
        // Create local filesystem URL
        let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
        let localURL = tmporaryDirectoryURL.appendingPathComponent("\(linkBook).pdf")
        
        // Download to the local filesystem
        _ = bookRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("$$$$$$$$$$$$ ERROR -> \(error)")
            } else {
                self.goToPdfScreen(urlBook: url!)
            }
        }
    }
    
    func goToPdfScreen(urlBook: URL) {
        hideProgressIndicator(view: navigationController!.view)
        
        let pdfModule = MidiaBookDisplayRouter.createModule(pdfUrl: urlBook)
        self.navigationController?.pushViewController(pdfModule, animated: true)
    }
}

extension MidiaAllBooksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
