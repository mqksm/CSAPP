//
//  ViewController.swift
//  CSAPP
//
//  Created by Maks on 21.02.2020.
//  Copyright © 2020 Maks. All rights reserved.
//

import UIKit

//structures for json parsing
struct  SongListResponse: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    var trackName: String
    var collectionName: String
    var trackPrice: Double
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var songerName: UITextField!
    
    var songs:SongListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songTableView.dataSource = self
        songTableView.delegate = self
        songTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        getResults { (parsedResults) in
            self.songs = parsedResults
            DispatchQueue.main.async {
                self.songTableView.reloadData()
            }
        }
        
    }
    
//    work with iTunes API, getting and parsing JSON
    func getResults(completion: @escaping (SongListResponse?) -> Void ) {
        
        guard let enterSinger = (songerName.text) else { return }
        guard let url = URL(string: "https://itunes.apple.com/search?term=" + (enterSinger) + "&limit=50") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let parsedResult: SongListResponse = try! JSONDecoder().decode(SongListResponse.self, from: data)
                completion(parsedResult)
            }
        }.resume()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs?.results[indexPath.row]
        cell.textLabel?.text = song?.trackName
        return cell
    }
    
    
}
