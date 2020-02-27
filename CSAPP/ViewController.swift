//
//  ViewController.swift
//  CSAPP
//
//  Created by Maks on 21.02.2020.
//  Copyright © 2020 Maks. All rights reserved.
//

import UIKit

struct  SongListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case results
    }
    let results: [Song]
}

struct Song: Decodable {
    var trackName: String?
    var collectionName: String?
    var trackPrice: Double?
 
    enum CodingKeys: String, CodingKey {
        case trackName
        case collectionName
        case trackPrice
    }


     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

         self.trackName = try? container.decode(String.self, forKey: .trackName)
         self.collectionName = try? container.decode(String.self, forKey: .collectionName)
         self.trackPrice = try? container.decode(Double.self, forKey: .trackPrice)


    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBOutlet weak var songerName: UITextField!
    
    @IBOutlet weak var songInfo: UILabel!
    
    @IBAction func getButton(_ sender: UIButton) {
        
        let urlBefore = "https://itunes.apple.com/search?term=" + (String(songerName.text!))
        print (urlBefore)
        guard let url = URL(string: urlBefore) else { return }

        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                //let json = try JSONSerialization.jsonObject(with: data, options: [])
                let parsedResult: SongListResponse = try! JSONDecoder().decode(SongListResponse.self, from: data)

                //print (parsedResult)
                print("------------------------------")
                print (parsedResult.results[0])
                
                
                
                DispatchQueue.main.async {
                    self.songInfo.isHidden = false
                    self.songInfo.text = "\(parsedResult)"
                    
                    
                }
            }
            catch {
                print (error)
                }

            
        }.resume()
        }
        
    
}

