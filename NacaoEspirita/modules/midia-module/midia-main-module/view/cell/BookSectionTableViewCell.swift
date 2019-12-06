//
//  CategoryRow.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class BookSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionTableView: UICollectionView!
    var bookArray: [BookModel] = []
    var navigationController: UINavigationController?
    let storage = Storage.storage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionTableView()
    }
    
    //CONFIGURAR A COLLECTIONVIEW AQUI E FAZER O MESMO PROCESSO!!!!!!!! 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func reloadCell(bookArrayList: [BookModel]) {
        self.bookArray = bookArrayList
        collectionTableView.reloadData()
        loading.isHidden = true
    }

}

extension BookSectionTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setCollectionTableView() {
        self.collectionTableView.delegate = self
        self.collectionTableView.dataSource = self
        self.collectionTableView.register(UINib(nibName: "BookCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BookCollectionCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionCell", for: indexPath) as! BookCollectionViewCell
        
        let book = bookArray[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.bounds.height
        let itemWidth = itemHeight * 0.66
        
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


