//
//  Marvel.swift
//  HeroesOfMarvel
//
//  Created by Kirill Koleno on 04/11/2018.
//  Copyright © 2018 i17215. All rights reserved.
//

import Foundation
import Moya

public enum Marvel {
    static private let publicKey = "cb5cd1724b96f40ada4d7224a9f951c9"
    static private let privateKey = "137f29ae0116ffe67f99fc81365ea75e8debb959"
    
    case getHeroes
}

extension Marvel: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/v1/public")!
    }
    
    public var path: String {
        switch self {
        case .getHeroes: return "/characters"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHeroes: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        // a timestamp (or other long string which can change on a request-by-request basis)
        let timestamp = "\(Date().timeIntervalSince1970)"
        
        //a md5 digest of the timestamp parameter, your private key and your public key (e.g. md5(timestamp+privateKey+publicKey)
        let hash = (timestamp + Marvel.privateKey + Marvel.publicKey).md5
        
        switch self {
        case .getHeroes:
            return .requestParameters(parameters: ["orderBy": "name",
                                                   "limit": 100,
                                                   "apikey": Marvel.publicKey,
                                                   "ts": timestamp,
                                                   "hash": hash],
                                      encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
