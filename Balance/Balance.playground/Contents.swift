import UIKit

let apiKey = "UAK26de0212877e2d1b069beef2c76abb90"
let baseURL = URL(string: "https://web3api.io/api/v1/")!

let session = URLSession.shared
var request = URLRequest(url: requestUrl)

request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

let task = session.dataTask(with: request) { data, response, error in
    guard error == nil, data != nil else {
        print("Client error!")
        return
    }

    guard let response = response as? HTTPURLResponse, (200 ... 299).contains(response.statusCode) else {
        print("Server error!")
        return
    }

    do {
        let response = try JSONDecoder().decode(AmberdataAccountBalanceRequest.self, from: data!)
    } catch {
        print("JSON error: \(error.localizedDescription)")
    }
}

task.resume()
