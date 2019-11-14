//
//  CategoryRow.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class BookSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionTableView: UICollectionView!
    var bookArray: [String] = []
    var navigationController: UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionTableView()
    }
    //CONFIGURAR A COLLECTIONVIEW AQUI E FAZER O MESMO PROCESSO!!!!!!!! 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
        
        cell.testLabel.text = bookArray[indexPath.row]
        cell.buttonTappedAction = { (cell) in
            self.goToPdfScreen()
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 2.5
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func goToPdfScreen() {
        
        guard let path = Bundle.main.url(forResource: "book-livro-dos-espiritos", withExtension: "pdf") else {
            print("failed to unwrap fileURL")
            return
        }
        
        let pdfModule = MidiaBookDisplayRouter.createModule(pdfUrl: path)
        self.navigationController?.pushViewController(pdfModule, animated: true)
    }
}


