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
        url: URL
    ) {
        self.init(url: url)
        httpMethod = method.rawValue
        addValue("application/json", forHTTPHeaderField: "Accept")
        addValue(APIConstants.bearerToken, forHTTPHeaderField: "Authorization")
    }
}

enum APIConstants {
    static let bearerToken = """
        Bearer eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21T23KjMAz9lQ7PVacQAkne-rY_sB8gS3LiKdiMbdLt7Oy_r4khhEzfOOfocmSJv4UJoTgVOBhg6d1biOg7Y88K7ecbub54LcKoUoRqa1E7XYPWeICa6ABKdgRNQ-q94frQakzB8mcoTmVb7dv6UNbVa2EwZqJpynYikMiNNv5yHYv_bXiuXamqhHdWe6jLqgHVaAVHqo7lkQSpOaba0X2KzRmsaL8TjcCKj1C_VxoOClsoG6nbw77dq2OTMtJYH0QSwtqHK2oA25qglmmGUghYE-pdvWtKmmYI5AaZHiU7hcvNKljs5eQF-eVJiN_Dk2BYbDTaiN_ynQlxw8yA2SeTJ2ET7yArMSJderlHrvjLmygvOMaL8yaklYGxbK6GR-xysMIOLc3WCD0DORu963KjiZk1Z7XxPUbjLDgNerQ8G6AxRNcvc0iPZs7u0TJGObF0knws8BbWS8SE8EQJTuKCb5kDfossUgZzkQzWIDA9nueaWVs_IXq0AWnyfKehc5SmX2tnAtz0DM_snOWdNt3SKvfeULcoLyRmiBsQtlLeR8BrWkWAs1t9bLh51A13q_PI5OF0evYfSqziD7VWMReli_DYCUMaez2jIDGmAcdhhgMuZ5L-_3RF6Zic54f2W3bpu2V_yAf3Ze98lMkAULg-UwPrTD3u9LaK5yUX__4D5D9kmLIEAAA.LIKxodIu65AvIAO5DRrxEhPFTzMZgrsqM12jlM-n3CMWZuvI4lN2XXi0KQhO3mBIGqhhU9A2e_TtPXq3XoY9FDzlnypCb_s5Ir800JgNFUHBWZa4Evi8vCEghGWbZnTVyTbCxCOgTQ3NJFeDJEsssymRSBSS9MMq90VBpJ8tFTOMymBaJvpcoGSHaLBSsmb4tS39g4n8ktuAwYEc2U4kSmfz8U2aWF3_m3U9ECGwLghsZFOb51hUTfhCqOYk_i2hKSZdp4DgKyQebZ_OAilTZ0pvGnNSX9GeO8NGwgxPgk8qfVj9VvxhVc0AknTj75ydqseJTZ_1LQhmUhtAbvkP2OrTn1E5AbMZtEhfB7wlHAMJOqgdBzo13AvAA90tdW-h_wDqnizNoxqq5POl3Q6DWmLWJptPtEPTZeGgG0dfMbTN3RjTq5lmJI11oHYzRbLjG7J3BHVLdHpLKD_dMnghuJTOFXGpDiglKmJvYUTq3F3FwkbL6ixAJZrIWFxMTY9TOD1aFtbbuHcl7T17-pDxG8oloJHdQmmz3uU9vnzGw82NHFUEdxaZ51AtUjPqQtD9Egn0Xjr7Y_Pl5TU_ijtelaIhKundAypNTNNYIVhnXwNWdqUVT4VDEDFGRN5nhDteEklCfULUMqxisl71o50rRHsV40nFWFq1OcD2La2qRuI
        """
}
