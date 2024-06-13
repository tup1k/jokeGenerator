//
//  ViewController.swift
//  jokeGenerator
//
//  Created by Олег Кор on 11.06.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var numberOfJoke: UILabel!
    @IBOutlet private weak var jokeLabel: UILabel!
    @IBOutlet private weak var nextJokeButton: UIButton!
    
  
    private class DataLoader {
        @Published var myFirstJoke: String? = ""
        
        init() {
            load()
        }
        
        func load() {
            let jokeUrl = "https://api.api-ninjas.com/v1/jokes?limit=1"
            guard let url = URL(string: jokeUrl) else {return}
            var request = URLRequest(url: url)
            request.setValue("s6OxNiFnD2d4aKoMuQho9Q==D1qeKZLGqBEIx2jZ", forHTTPHeaderField: "X-Api-Key")
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let error = error {
                    print(error)
                }
                guard let data = data else { return }
                do {
                    let myJoke = try JSONDecoder().decode([jokeStruct].self, from: data)
                    self.myFirstJoke = myJoke.first?.joke
                } catch {
                    print(error)
                }
                //print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    ///  Тут можно видимо что-то добавить для выноса переменной myFirstJoke за пределы класса
    
    @IBAction func nextJokeButtonClicked(_ sender: Any) {
        DataLoader().load()
        let myJokes = DataLoader().myFirstJoke
        jokeLabel.text = myJokes
        print(myJokes)
    }
}

