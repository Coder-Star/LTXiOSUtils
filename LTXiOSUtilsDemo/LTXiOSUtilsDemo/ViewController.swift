//
//  ViewController.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2021/8/9.
//

import UIKit

public struct DescBaseResponseModel<T>: APIParsable & Decodable where T: APIParsable & Decodable {
    public var code: Int
    public var desc: String
    public var data: T?

    public static func parse(data: Data) -> APIResult<DescBaseResponseModel<T>> {
        do {
            let model = try JSONDecoder().decode(self, from: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
}

extension DefaultNetRequest {
    public init<S>(descDataType: S.Type, url: String, method: NetRequestMethod = .get) where DescBaseResponseModel<S> == T {
        self.init(responseType: DescBaseResponseModel<S>.self, url: url, method: method)
    }
}

struct HomeBanner: APIParsable, Codable {
    var interval: Int = 0
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "首页"
        setupUI()
    }

    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "Welcome"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let request = DefaultNetRequest(descDataType: HomeBanner.self, url: "https://www.fastmock.site/mock/5abd18409d0a2270b34088a07457e68f/LTXMock/config/homeBanner")

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
