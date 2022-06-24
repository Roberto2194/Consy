//
//  ResultsView.swift
//  Consy WatchKit Extension
//
//  Created by Ivan Tilev on 22/01/2020.
//  Copyright © 2020 Ivan Tilev. All rights reserved.
//

import SwiftUI
import Foundation

struct Word: Identifiable{
    var id: UUID = UUID()
    var word: String
    
    init(word: String) {
        self.word = word
    }
}

struct Cell: View{
    var word: Word
    
    var body: some View{
        Text(self.word.word)
    }
    
    init(word: Word){
        self.word = word
    }
}

//MARK: Here we present to the user the two cards with the synms and antoms:
struct ResultsView: View {
    
    @State public var chosenWord: String = ""
    
    // Response from the Synonyms RestAPI
    @State public var synonymsResponse:[String] = [" ", " ", " "]
    @State public var synonymNum = 0
    
    // Response from the Antonyms RestAPI
    @State public var antonymsResponse:[String] = [" ", " "]
    
    var body: some View {
        
        // Type og request: Get
        getSynonyms(word: chosenWord)
        getAntonyms(word: chosenWord)
        
        //MARK: Do the styling of the cards
        return VStack{
            List {
                NavigationLink(destination: SynonymView(syn: synonymsResponse, synNum: self.synonymNum)) {
                    VStack {
                        Text("Synonyms")
                            .foregroundColor(.blue)
                        Text(synonymsResponse[0])
                        Text(synonymsResponse[1])
                        Text(synonymsResponse[2])
                    }
                }
                
                NavigationLink(destination: AntonymView(ant: antonymsResponse)) {
                    VStack {
                        Text("Antonyms")
                            .foregroundColor(.blue)
                        Text(antonymsResponse[0])
                    }
                }
            }
        }.navigationBarTitle(chosenWord)
        //            return List(0 ..< synonymsResponse.count) {Index in
        //                Text(self.synonymsResponse[Index])
        //
        //            }
        
    }
    
    //MARK: Get the Synonyms of the word!
    func getSynonyms(word: String) {
        // Setting header and request of HTTP Request
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "21a9f366cemsh860a4936298a771p1b3e47jsn8069f0e77326"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/" + word + "/synonyms")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Errore")
            } else {
                // Let httpResponse = response as? HTTPURLResponse
                // Parsing data in json object to string array
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    let results = json?["synonyms"] as? [String] ?? []
                    if !results.isEmpty {
                        self.synonymsResponse = results
                        self.synonymNum = results.count
                    }
                    //                        print("Synonyms")
                    
                    //                        for i in 0 ... self.synonymsResponse.count - 1 {
                    //                            print(self.synonymsResponse[i])
                    //                        }
                    
                    
                } catch {
                    print(error)
                }
            }
        })
        
        dataTask.resume()
    }
    
    //MARK: Get the Antonyms of the word!
    func getAntonyms(word: String) {
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "21a9f366cemsh860a4936298a771p1b3e47jsn8069f0e77326"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/" + word + "/antonyms")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                // Parsing data in json object to string array
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                    let results = json?["antonyms"] as? [String] ?? []
                    if !results.isEmpty {
                        self.antonymsResponse = results
                    }
                    
                    //                    print("Antonyms")
                    //
                    //                        for i in 0 ... self.antonymsResponse.count - 1 {
                    //                            print(self.antonymsResponse[i])
                    //                        }
                    
                } catch {
                    print(error)
                }
            }
        })
        
        dataTask.resume()
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}

//MARK: SynonymView
struct SynonymView: View {
    
    @State public var syn: [String] = ["", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    @State public var synNum: Int = 1
    
    var body: some View {
        
        return VStack {
            Text("Synonyms")
                .foregroundColor(.blue)
            List {
                Text(syn[0])
                Text(syn[1])
                Text(syn[2])
            }
        }
    }
}

//MARK: AntonymView
struct AntonymView: View {
    
    @State public var ant: [String] = [" "]
    
    var body: some View {
        
        return VStack {
            Text("Antonyms")
                .foregroundColor(.blue)
            List {
                Text(ant[0])
            }
        }
    }
    
}

struct ChosenView_Previews: PreviewProvider {
    static var previews: some View {
        AntonymView()
    }
}
