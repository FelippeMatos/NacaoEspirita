//
//  MidiaInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

class MidiaInteractor: MidiaPresenterToInteractorProtocol {
    
    var presenter: MidiaInteractorToPresenterProtocol?
    var bookArrayList = [BookModel]()
    var videoArrayList = [VideoModel]()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    let dateUtils = DateUtils()
    
    func fetchBooks() {
      
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        var bookArray = [BookModel]()
        
        db.collection("books").order(by: "name", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchBooks : ERROR = \(err)")
                self.presenter?.booksFetchFailed()
            } else {
                for document in querySnapshot!.documents {
                    bookArray.append(BookModel(document: document)!)
                }
                self.bookArrayList = bookArray
                self.presenter?.booksFetchedSuccess(bookModelArray: self.bookArrayList)
            }
        }
    }
    
    func checkStatusVideos() {
        let currentHour = dateUtils.currentHour()
        
        switch currentHour {
        case 6, 7, 8, 9, 11, 12, 13, 15, 17, 18, 19, 20, 21, 22, 0:
            compareLastUpdateDateWithCurrentDate()
        default:
            //SE NAO - Chamar FetchVideosInFirebase()
            print("$$$$$$$$ PEGAR DADOS EXISTENTES")
        }
    }
    
    func compareLastUpdateDateWithCurrentDate() {
        
        let currentDate = dateUtils.currentDateToUpdateVideos()
        print("$$$$$$$$$$ CURRENT DATE: \(currentDate)")
        
        db.collection("videosLastUpdate").document("01").getDocument() { (querySnapshot, err) in
            if let err = err {
                print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchQuestions : ERROR = \(err)")
            } else {
                if querySnapshot!.exists {
                    let data = querySnapshot!.data()
                    let lastUpdate = data!["lastUpdate"] as? String
                    let lastUpdateDate = self.dateUtils.stringToDate(lastUpdate!)
                    
                    if currentDate <= lastUpdateDate {
                        // SE MENOR OU IGUAL QUE DATA DO FB - Chamar FetchVideosInFirebase()
                        print("$$$$$$$$ PEGAR DADOS EXISTENTES")
                        
                    } else {
                        print("$$$$$$$$ ATT")
//                        fetchVideosInYoutube()
                    }
                } else {
                    print("$$$$$$$ DEU MERDA")
                }
            }
        }
       
    }
    
    func fetchVideosInYoutube() {
        var videoArray = [VideoModel]()
        var count = [Int]()
        for channel in AppKeys.YOUTUBE_CHANNEL_KEYS {
            let youtubeQuery = "https://www.googleapis.com/youtube/v3/search?key=\(AppKeys.YOUTUBE_API_KEY)&channelId=\(channel)&part=snippet,id&order=date&maxResults=1"
            print("$$$$$$$$$$$$$ QUERY: \(youtubeQuery)")
            AF.request(youtubeQuery).responseJSON { response in
                if let data = response.data {
                    do {
                        let video = try JSONDecoder().decode(VideoModel.self, from: data)
                        videoArray.append(video)
                        count.append(0)
                        if count.count == AppKeys.YOUTUBE_CHANNEL_KEYS.count {
                            self.videoArrayList = videoArray
                            self.presenter?.videosFetchedSuccess(videoModelArray: self.videoArrayList)
                        }
                    } catch let error {
                        print(error)
                        print("======>> DEBUG INFORMATION: QuestionsInteractor/fetchVideos : ERROR = \(error)")
                        self.presenter?.videosFetchFailed()
                    }
                }
            }
        }
    }
}

