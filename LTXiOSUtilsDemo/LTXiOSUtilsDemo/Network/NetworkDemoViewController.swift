//
//  NetworkDemoViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/3/16.
//

import Foundation

class NetworkDemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let request = CSApiRequest(dataType: HomeBanner.self, url: "https://www.fastmock.site/mock/5abd18409d0a2270b34088a07457e68f/LTXMock/config/homeBanner")

        let defaultAPIService = APIService.default

        defaultAPIService.send(request: request) { result in
            switch result.result {
            case let .success(model):
                Log.d(model)
            case let .failure(error):
                Log.d(error)
            }
        }
    }
}

struct HomeBanner: APIParsable, Codable {
    var interval: Int = 0
}
