//
//  RemoteContext.swift
//  Wasel
//
//  Created by Abdul Rahman on 6/14/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import Foundation

enum ContentType: String{
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
}

final class RemoteContext {
    
    
    //MARK: - Properties
    
    
    private var sessionManager: SessionManager!
    
    //////////////////////////////////
    
    
    //MARK: - Initializers
    /// Initialize session manager and Alamofire configurations
    init(){
        sessionManagerConfiguration()
    }
    
    func sessionManagerConfiguration(token:String = SharedPreference.shared.jwtToken.token ?? "")  {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Labiba.timeoutIntervalForRequest
        configuration.httpAdditionalHeaders?.updateValue("application/json", forKey: "Accept")
        
        if UpdateTokenModel.isTokenRequeird(){
            configuration.httpAdditionalHeaders = ["Authorization":"Bearer \(token)"]
        }
        var serverTrustPolicies: [String: ServerTrustPolicy] = [:]
        if Labiba.bypassSSLCertificateValidation, let url = URL(string: Labiba._basePath) {
            serverTrustPolicies[url.host ?? ""] = .disableEvaluation
        }
        let servertrustManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
        
        sessionManager = SessionManager(configuration: configuration,serverTrustPolicyManager: servertrustManager)
    }
    
    /// check  token  and update it if it's required, then continue with the normal request flow
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint
    ///   - parameters: [String: Any], Optional
    ///   - completion: A callback function invoked when the operation is completed.
    
    func withTokenRequest(endPoint: EndPointProtocol, parameters:Parameters?, completion: @escaping Handler<Data>) {
        checkToken { result in
            switch result {
            case .success(_):
                self.request(endPoint: endPoint, parameters: parameters, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Creates an HTTP request to a given endpoint address
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint
    ///   - parameters: [String: Any], Optional
    ///   - completion: A callback function invoked when the operation is completed.
    func request(endPoint: EndPointProtocol, parameters:Parameters?, completion: @escaping Handler<Data>){
        let urlRequest = buildURlRequest(endPoint: endPoint, params: parameters)
       
        sendRequest(reqestUrl: urlRequest) { (result) in
            switch result{
            case .success(let response):
                guard let wsResponse = response as? DataResponse<Data> else{
                    completion(.failure(ErrorModel.generalError()))
                    return
                }
                if let wsData = wsResponse.data {
                    completion(.success(wsData))
                }else {
                    completion(.failure(ErrorModel(message: "No Data")))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }//End sendRequest
    }
    
    /// Creates an HTTP request to a given endpoint address
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint
    ///   - parameters: [Any], Optional array of objects
    ///   - completion: A callback function invoked when the operation is completed.
    func request(endPoint: EndPointProtocol, paramsAny:[Any]?, completion: @escaping Handler<Any>){
        let params = paramsAny?.asParameters()
        let urlRequest = buildURlRequestArray(endPoint: endPoint, params: params)
        sendRequest(reqestUrl: urlRequest) { (result) in
            switch result{
                
            case .success(let response):
                guard let wsResponse = response as? DataResponse<Data> else{
                    completion(.success(Data()))
                    return
                }
                if let wsData = wsResponse.data {
                        completion(.success(wsData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    
   /*
    func multipartRequest(endPoint: EndPointProtocol, params:Parameters?, multipartName: String?, uploadFiles: [Data]?,encoding:String.Encoding? = nil, completion: @escaping Handler<Any>){
        let relativePath = baseURL + endPoint.address
        let url = URL(string: relativePath)!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue

        if let headers = endPoint.headers {
            headers.keys.forEach({ (key) in
                urlRequest.setValue(headers[key]!, forHTTPHeaderField: key )
            })
        }

        sessionManager.upload(multipartFormData: {(multipartFormData) in
            if let params = params{
                for (key,value) in params {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            }

            if let files = uploadFiles, let name = multipartName{
                for file in files{
                    multipartFormData.append(file, withName: "image", fileName: "file.fileName", mimeType: "")
                }
            }
        }, to: urlRequest as! URLConvertible).responseData { result in
            
        }
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            if let params = params{
                for (key,value) in params {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            }

            if let files = uploadFiles, let name = multipartName{
                for file in files{
                    multipartFormData.append(file, withName: "image", fileName: file.fileName, mimeType: file.mimeType)
                }
            }
        }, with: urlRequest) { (result) in

            switch result {
            case .success(let upload, _, _):
               
                upload.validate().responseData(completionHandler: { [weak self] (dataResponse) in
                    switch dataResponse.result {
                    case .success:
                        if progress {
                            progressView.hideProgress()
                        }
                        if let wsData = dataResponse.data {
                             completion(.success(wsData))
                        }else{
                            completion(.failure(ErrorModel(message: "No Data")))
                        }
                    case .failure(let responseError as NSError):
                        if progress {
                            progressView.hideProgress()
                        }
                        
                        let error = self?.buildError(response: dataResponse, responseError: responseError)
                        completion(.failure(error!))
                    }
                })
            case .failure(let responseError as NSError):
                if progress {
                    progressView.hideProgress()
                }
                completion(.failure(ErrorModel(message: responseError.localizedDescription)))
            }
        }
    }
    
    */
    
    /// Helper method to send an Http request to a given Endpoint.
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint object
    ///   - parameters: Http request parameter as [String: Any], optional.
    ///   - completion: A callback function
    private func sendRequest (reqestUrl: URLRequestConvertible, completion: @escaping Handler<Any> ) {
        sessionManager.request(reqestUrl).validate().responseData { [weak self](response) in
            self?.printResponse(reqestUrl: reqestUrl, responseData: response)
            switch response.result {
            case .success:
                completion(.success(response))
            case .failure(let responseError as NSError):
                let error = self?.buildError(response: response, responseError: responseError)
                completion(.failure(error!))
            }
        }//End sessionManager.request
        
    }
    
   
    
    /// Helper method to build an HTTP request.
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint object.
    ///   - params: Http request parameter as [String: Any], optional.
    /// - Returns: An Http request object of type URLRequestConvertible.
    private func buildURlRequest(endPoint: EndPointProtocol, params: Parameters?) -> URLRequestConvertible{
        let relativePath =  endPoint.url
        let url = URL(string: relativePath)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        
        var encoding: ParameterEncoding!
        
        
        
        if let headers = endPoint.headers {
            headers.keys.forEach({ (key) in
                urlRequest.setValue(headers[key]!, forHTTPHeaderField: key )
            })
            
            if let contentType = headers["Content-Type"] {
                switch contentType {
                case ContentType.json.rawValue:
                    encoding = JSONEncoding.default
                case ContentType.urlEncoded.rawValue:
                    encoding = URLEncoding.default
                default:
                    encoding = JSONEncoding.default
                }
            }else{
                encoding = JSONEncoding.default
            }
        }else if endPoint.httpMethod == .post {
            encoding = URLEncoding(destination: .httpBody)
        }
      
        if endPoint.httpMethod == .get || endPoint.httpMethod == .delete  {
            encoding = URLEncoding.default // this == URLEncoding(destination: .queryString) (not sure) from moyad
        }
        
        return try! encoding.encode(urlRequest, with: params)
    }
    
    
    /// Helper method to build an HTTP request.
    ///
    /// - Parameters:
    ///   - endPoint: Endpoint object.
    ///   - params: Http request parameter as [Any], optional.
    /// - Returns: An Http request object of type URLRequestConvertible.
    private func buildURlRequestArray(endPoint: EndPointProtocol, params: Parameters?) -> URLRequestConvertible{
        let relativePath =  endPoint.url
        let url = URL(string: relativePath)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        urlRequest.timeoutInterval = 30
        if let headers = endPoint.headers {
            headers.keys.forEach({ (key) in
                urlRequest.setValue(headers[key]!, forHTTPHeaderField: key )
            })
        }
        
        
        let encoding = ArrayEncoding()
        
        return try! encoding.encode(urlRequest, with: params)
    }
    
    func buildError(response:  DataResponse<Data>, responseError: NSError?) -> ErrorModel?{
        guard let data = response.data else {
            var networkError:String = "Unknown Error"
            let errorComponents = response.error?.localizedDescription.split(separator: ":") ?? []
            if  errorComponents.count > 1 {
                networkError = String(errorComponents[1])
            }else if errorComponents.count > 0{
                networkError = ""
            }
            return ErrorModel(message: networkError)
        }
        let decoder = JSONDecoder()
        do {
            let errorModel = try decoder.decode(ResponseModel<String>.self, from: data)
            let error = ErrorModel(message: errorModel.ErrorMessage ?? "unKnown Error")
            error.ErrorCode = String(response.response?.statusCode ?? 0)//errorModel.ErrorCode
            return error
        }catch{
            let error:ErrorModel = ErrorModel(message: error.localizedDescription)
            return error
        }
    }
    
    private func printResponse(reqestUrl: URLRequestConvertible,responseData:DataResponse<Data>)  {
        if let url = reqestUrl.urlRequest?.url {
            prettyPrintedResponse(url: url.absoluteString,
                                  statusCode: responseData.response?.statusCode ?? 0 ,
                                  method: reqestUrl.urlRequest?.httpMethod ?? "",
                                  data: responseData.data ?? Data(),
                                  name:  url.lastPathComponent)
        }
    }
    
    //MARK: - Update Token
    private func checkToken(handler: @escaping Handler<Bool>){
        if UpdateTokenModel.isTokenRequeird() && !UpdateTokenModel.isTokenValid()  {
            updateToken { result  in
                switch result {
                case .success(let model):
                    UpdateTokenModel.saveToken(token: model.token)
                    self.sessionManagerConfiguration(token: model.token ?? "")
                    print("token updated")
                    handler(.success(true))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }else {
            handler(.success(true))
        }
    }
    
    private func updateToken(handler: @escaping Handler<UpdateTokenModel>) {
        let url =   Labiba._updateTokenUrl
        let endPoint = EndPoint(url: url, httpMethod: .post)
        let params:[String:Any] = [
            "Username":Labiba.jwtAuthParamerters.username,
            "Password":Labiba.jwtAuthParamerters.password
        ]
        request(endPoint: endPoint, parameters: params) { result in
            switch  result {
            case .success(let data):
                let decoder =  JSONDecoder()
                do {
                    let model = try decoder.decode(UpdateTokenModel.self, from: data)
                    handler(.success(model))
                } catch {
                    handler(.failure(ErrorModel(message: error.localizedDescription)))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
   
}


private let arrayParametersKey = "arrayParametersKey"

/// Extenstion that allows an array be sent as a request parameters
extension Array {
    /// Convert the receiver array to a `Parameters` object.
    func asParameters() -> Parameters {
        return [arrayParametersKey: self]
    }
}


/// Convert the parameters into a json array, and it is added as the request body.
/// The array must be sent as parameters using its `asParameters` method.
 struct ArrayEncoding: ParameterEncoding {
    
    /// The options for writing the parameters as JSON data.
     let options: JSONSerialization.WritingOptions
    
    
    /// Creates a new instance of the encoding using the given options
    ///
    /// - parameter options: The options used to encode the json. Default is `[]`
    ///
    /// - returns: The new instance
     init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
     func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters,
            let array = parameters[arrayParametersKey] else {
                return urlRequest
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }
        
        return urlRequest
    }
}

class ErrorModel:Codable,Error {
    var message:String = ""//localized(forKey: .unKnownError)
    var error:String?
    var ErrorCode:String?
    init(message:String  ) {
        self.message = message
    }
    
    static func generalError()-> ErrorModel {
        ErrorModel(message: "error-msg".localForChosnLangCodeBB)
    }
   
}

class ResponseModel<T:Decodable>:Decodable {
    var success:Bool?
    var ErrorMessage:String?
    var data:T?
    var Link:String?
}
