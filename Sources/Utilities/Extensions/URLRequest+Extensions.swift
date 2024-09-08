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
        Bearer eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21Ty5KjMAz8lSnOo6kAjklym9v-wH6AkOXENWBTtsns1Nb--5oYQkjlRnfr0bLE38KEUJwKHAwo7t1HiOg7Y88t2q8Pcn3xXoSxTRFtI7ittQCt8QCC6AAt1wRSUruTShwajSmY_wzFqWyq_aEWTXl8LwzGTDTiUE8EErnRxl-uU-x_GzXXrtqqhJ1q9yDKSkIrdQtHqo7lkRhJHlPt6L7Y5gwuZYO62YMWUoKod5yCZQkHao9VpaUoVZMy0lifRBzC2kdVJAEbQSB4mqFkAqUJdS1qWdI0QyA38PQo2SlcblbBYs8nz6jenoT4MzwJRrGNRhv2W74zIW6YGSjlk8kTKxPvICsxIl16vkeu-NubyG84xovzJqSVgbHKXI0ascvBLXZoabZG6BWQs9G7LjeamFlzVhvfYzTOgtOgR6tmAzSG6PplDu7RzNk9WoWRT4o7Tj4WeAvrOWJCeKIEJ3HBt8wBf5gXKYO5SAZrEJgez3PNrK2fED3agDR5vtPQOUrTr7UzAW56hmd2zvJOm25plXtvqFuUZ2IzxA0IWynvI-A1rSLA2a0-Ntw86oa71Xlk8nA6PfuLEqv4otYq5qJ0YTV2rCCNvZ5R4BjTgOMwwwGXM0n_f7qidEzOq4f2W3bpu2Vf5IP7tnc-8mQAKFyfqUHpTD3u9LaK5yUX__4DNuY1SbIEAAA.Y2-xNWQQd0BcxyxagZSYFAarB7EdDRLgSMvB4L8l5-WdCt8l9Ckeshl5cM2tejIZk_IQ71HY_UqmJ8vdsCHZ2tjMIajlHX02NUI-kLFhn0Plq5hOyUQZdHvuq_0ibz0dUXhtpEBJ84BWxuoaNt21rIyzdNLwHLv1WxDFMzhabXRRTmSSaz51lmwTw28gxdVj6ELBofKQ_ix3N1mJCnPQ6RXlPl4QIV0DDiETj3KYkOS065Fx1P7j4BYMMGGvFNrmRFy0435_1ixRMtDVO9YgE14BAikRx-Z02wzIEIM3Gk7MZWwwPdovdozkBBuWw2I-r8TJq1mOM3ZdViSlOX4rbMrfkxh8rTykcjEZ_rob7p8R7EGepwYAfmjHpqLNM25TTzzObPHEKGCLN7Vqp8_itGg2nuqNo0J6DCw9gpz2d86XcwWIVRGTNkikEvYcTu5alsOgUgR7b_Q7D9ilO7pyjInFchv1nllMfWg8rydAyFV9ArBhHuD-FsncGZDIigt99WPi-D9AcUROTc_l6hlJdRgHefyxatQVVcdR0Z7Xzwir1zPxXi9j2ck9tQ2az9_nja9P1VCQp5r_MNuqBBpzn6xx2Hr53PZhxV8wyuH6gq3b0SLgrpXYtT-bCnAH3N4BqQL8ziqb0Bar57hBTuJ49LXlqCVvh7vspBr6EIGXBuc
        """
}
