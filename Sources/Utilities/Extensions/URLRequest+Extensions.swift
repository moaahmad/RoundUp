//
//  URLRequest+Extensions.swift
//  StarlingRoundUp
//
//  Created by Mo Ahmad on 06/09/2024.
//

import Foundation

extension URLRequest {
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}

extension URLRequest {
    public init(
        method: HTTPMethod,
        url: URL,
        bodyData: Data? = nil
    ) {
        self.init(url: url)
        httpMethod = method.rawValue
        addValue("application/json", forHTTPHeaderField: "Accept")
        addValue(APIConstants.bearerToken, forHTTPHeaderField: "Authorization")
        
        if [HTTPMethod.post, .put].contains(method) {
            httpBody = bodyData
            addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}

enum APIConstants {
    static let bearerToken = """
        Bearer eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21T0XKjMAz8lQ7PVSckxIG89e1-4D5ASHLjKdiMbdrr3Ny_n8EQSqZv2V1ptULO38KEUFwLHAyw9O4lRPSdsW8t2vcXcn3xXISxTRXtpZL2pCvQGmuoiGpo5USgFLUHxVV90ZiK5c9QXMvLUR3Ox6asnwuDcSbOjVLniUAiN9r4y3Us_rfhxfvYHks4cHuGqjwqaJVuoaHk0ZAgqSZ5R_cuNneIbqiWs4aGlYLq0JygrpGhupR8apsUCevUkdZ6JZIQtjl8JAV4qQgqmXYohYA1oT5VJ1XStEMgN8j0UXJSuM1RwWIvVy_ITw9C_BoeBMNio9FG_J7vTIg7ZgHMPoW8Cpt4B1mJEenWy71yw5_eRHnCMd6cNyGdDIxl82F4xC4Xt9ihpSUaoWcgZ6N3XR40MYvmrDa-x2icBadBj5aXADSG6Pp1D-nRLN09WsYoV5ZOUo4VzmW9REwIr5TgJK547hzwS2SVMlhMMtiKwPT4tnhmbfsJ0aMNSFPmOw2do7T95p0JcNNneGSXLu-06dZRefaOmqu8kJgh7kDYS_keAT_SKQK8uS3HjltW3XGzz3cmL6fTZ__BYhN_8NrEbEo34bEThrT29oyCxJgWHIcFDrg-k_T_T68oPSbn-dv4PbvO3bM_9IP7tHc-yhQAKHw8UgPrTH2_6XyKxyMX__4DnkGK6rIEAAA.pgjUOxHzKU9Za0YK-mbgtIgPze7VAHFZ2n4kULn430hTLCletzcIBhzH1KHvO_JxbW6bE9BcsjvItKmYS_w9fBATt2DbY9Nj1AkN00L8y4PPMvOAT8JKEUnc13bqIKs-cfpZa7a0KoblRx2dEePmWbnKjlS4AsuwRMlXVQiwSdJnh9yk97TA5nsQ8fPBKWx0QGP3nY3eqt1hXhRq3DClsVTcI2N-cOTO-EbQ9SLAllb0R65pHkJxjq73AYJJQR0sbhjW04-gg5nvzhU4L9348c4mBNpznEA7UGktoFVmrKlsYxEPqlHb2JUSmsGbjnQuB4qOGUc4EaK2IardEXdaXqXrWjfBF4Jw04QHb6uXvb0ZvFv-EggkzPjYHaw4Fk_cQzm1tLfwIGXkkec468uhuX-gxFhRqUrE4FbturERZ9IfAbBB2uVbJbnxdQ6pwvMYbz35rG5z9t-_sOy-4lL3GkM5kB7FNeKJgERqTweR9ZAo386ehbQ7rDkLRQe0v5W0ORD8qmi1BB-bY3p_AYWUYQtxZLvSqJAaJleEYFW0z5If58v9NegdgMEMbR9CRHk8_Kl5TiNIFLrVRjSoCUC3bDMpZX6T3U6Lf2ui5ktdwhl8KWzG5RVmdqyjcZkMSOv6JKXnG6_sj3EKjyrJ9ICZmYbpQ6RC8qNHPg1agFsM01A
        """
}
