//
//  MidiaBookDisplayViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/8/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import PDFKit

class MidiaBookDisplayViewController: UIViewController {

    var presenter: MidiaBookDisplayViewToPresenterProtocol?
    var pdfUrl: URL!
    var document: PDFDocument!
    var outline: PDFOutline?
    var pdfView = PDFView()
    private var thumbnailView = PDFThumbnailView()
    private var outlineButton = UIButton()
    private var dismissButton = UIButton()
    
    @IBOutlet private var doubleTapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPDFView()
        setupThumbnailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let thumbanilHeight: CGFloat = 80
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: thumbnailView)
        view.addConstraintsWithFormat(format: "V:[v0(\(thumbanilHeight))]|", views: thumbnailView)
    }
    
    private func setupPDFView() {
        view.addSubview(pdfView)
        pdfView.displayDirection = .horizontal
        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true

        let touch = UITapGestureRecognizer(target: self, action: #selector(toggleTools))
        touch.numberOfTapsRequired = 1
        touch.numberOfTouchesRequired = 1
        
        pdfView.addGestureRecognizer(touch)
        pdfView.addGestureRecognizer(doubleTapGesture)
        
        pdfView.scrollView?.contentInsetAdjustmentBehavior = .scrollableAxes
        pdfView.getScaleFactorForSizeToFit()
        pdfView.setMinScaleFactorForSizeToFit()
        pdfView.setScaleFactorForUser()
    }
    
    @objc func toggleTools() {
        if outlineButton.alpha != 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.outlineButton.alpha = 0
                self.thumbnailView.alpha = 0
                self.dismissButton.alpha = 0
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.outlineButton.alpha = 1
                self.thumbnailView.alpha = 1
                self.dismissButton.alpha = 1
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
    }

    @IBAction private func doubleTapAction(_ sender: UITapGestureRecognizer) {
        print("DOUBLE TAP")
        pdfView.autoZoomInOrOut(location: sender.location(in: pdfView), animated: true)
    }
    
    private func setupThumbnailView() {
        thumbnailView.pdfView = pdfView
        thumbnailView.backgroundColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 179/255, alpha: 0.5)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.thumbnailSize = CGSize(width: 40, height: 60)
        thumbnailView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.addSubview(thumbnailView)
    }
    
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


//MARK: Interaction between Presenter and View
extension MidiaBookDisplayViewController: MidiaBookDisplayPresenterToViewProtocol {
    
}
