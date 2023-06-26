//
//  NetworkService.swift
//  RunnersHi
//
//  Created by 황원상 on 2023/04/30.
//

import UIKit

final class NetworkService{
    
    private static let session = URLSession(configuration: configuration)
    private static let configuration:URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.networkServiceType = .responsiveData
        configuration.timeoutIntervalForRequest = 10
        // server error
        configuration.httpAdditionalHeaders = ["Authorization":Global.UUID, "User-Agent": Global.BUNDLEIDENTIFIER]
        return configuration
    }()
    
    //nil 을 return 하면 viewmodel에서 error 처리 -> 전부 서버에러이기 때문
    static func fetchJSON(httpbaseresource:HttpBaseResource) async throws -> [String:Any]{
        var result:[String:Any] = [:]
        let (data, response)  = try await session.data(for: httpbaseresource.request())
        guard let status = response as? HTTPURLResponse,
                (200...299) ~= status.statusCode else {
            
            // 에러 분기처리 한번 더 해야함
            
            let error = MyServerError(statusCode: (response as? HTTPURLResponse)!.statusCode)
            throw error
        }
            let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [String:Any]
            result = jsonData
            return result
    }
    
    /*
     1. 임시캐시
     2. image를 불러오지 못했을 경우, joker 사용
     3. 조커는 무조건 정답으로 쳐야한다. name = * 이면 wildcard
     */
    static func fetchImage(_ data:Dictionary<String,Any>) async -> [GuessWhoPlayModel]{
        // data 순회 -> url  이미지 불러오기 백그라운드로 날려버리기
        var result:Array<GuessWhoPlayModel> = []
        for (name, url) in data{
            let dbName = name
            var photo:UIImage?
            do{
                if cacheCheck(dbName) != nil{
                    photo = cacheCheck(url as! String)
                    let model = GuessWhoPlayModel(name: dbName, photo: photo!, url: url as! String)
                    result.append(model)
                    continue
                } else {
                    guard let stringUrl = url as? String else {throw NetworkError.notconnected }
                    let dbUrl = URL(string: stringUrl)
                    guard let dbUrl = dbUrl else { throw NetworkError.notconnected }
                    let (data, response) = try await session.data(from:dbUrl)
                    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.notconnected }
                    photo = UIImage(data: data)
                    guard let urlPhoto = photo else { throw NetworkError.disconnected }
                    ImageCacheManager.shared.setObject(urlPhoto, forKey: (dbName as NSString))
                    let model = GuessWhoPlayModel(name: dbName, photo: urlPhoto, url:url as! String)
                    result.append(model)
                    continue
                }
            } catch{
                let joker = GuessWhoPlayModel(name: "조커", photo: UIImage(named: "joker")!, url: "joker")
                result.append(joker)
            }
        }
        return result
    }
    // 캐시에 있으면 사용, 없으면 temp cache를 봄.
    private static func cacheCheck(_ name:String) -> UIImage?{
        let cacheKey = name as NSString
        let dbCache = TempCache.shared.cache
        if let cacheImage = ImageCacheManager.shared.object(forKey: cacheKey){
            return cacheImage
        } else if let dbPhoto = dbCache[name] {
            return dbPhoto
        }
        return nil
    }
}
