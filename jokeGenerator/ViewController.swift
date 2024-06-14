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
//            load()
        }
        
        func load(onJokeLoad: @escaping (Result<String, Error>) -> Void) {
            // 'Result' - стандартый способ возвратить результат, учитывая возможную ошибку.
            // Вместо String можно использовать, что удобно, например, jokeStruct
            
            let jokeUrl = "https://api.api-ninjas.com/v1/jokes?limit=1"
            guard let url = URL(string: jokeUrl) else {return}
            var request = URLRequest(url: url)
            request.setValue("s6OxNiFnD2d4aKoMuQho9Q==D1qeKZLGqBEIx2jZ", forHTTPHeaderField: "X-Api-Key")
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let error = error {
                    // закомментировал печатание ошибки, потому мы ее выведем сразу о обработчике
//                    print(error)
                    onJokeLoad(.failure(error))
                }
                guard let data = data else { return }
                do {
                    let myJoke = try JSONDecoder().decode([jokeStruct].self, from: data)
                    let jokeItself = myJoke[0].joke
                    onJokeLoad(.success(jokeItself))
                    self.myFirstJoke = myJoke.first?.joke
                } catch {
                    // тут тоже
//                    print(error)
                    onJokeLoad(.failure(error))
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
        // weak self - best practice чтобы не случился retain cycle
        DataLoader().load { [weak self] result in
            DispatchQueue.main.async {  // нужно вызвать код на главной очереди,
                                        // потому что URLSession.shared.dataTask
                                        // возвращает результат на фоновой,
                                        // а с UI нужно работать на главной
                
                switch result {
                case .success(let joke):
                    self?.jokeLabel.text = joke
                case .failure(let error):
                    NSLog("error happened getting joke: \(error)")
                    // NSLog более стандартная тема, потому что добавляет время к сообщению,
                    // и сообщения сразу сбрасываются из буфера в вывод
                    // (иначе потенциально могут не сразу появиться)
                }
            }
        }
        
        let myJokes = DataLoader().myFirstJoke
        jokeLabel.text = myJokes
        print(myJokes)
    }
}

