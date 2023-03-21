import Foundation

struct ApiResponce: Codable {

  var code            : Int
  var status          : String
  var data            : Data

  enum CodingKeys: String, CodingKey {

    case code            = "code"
    case status          = "status"
    case data            = "data"
  }

}

struct Data: Codable {

  var offset  : Int
  var limit   : Int
  var total   : Int
  var count   : Int
  var results : [Results]

  enum CodingKeys: String, CodingKey {

    case offset  = "offset"
    case limit   = "limit"
    case total   = "total"
    case count   = "count"
    case results = "results"
  
  }
}

struct Results: Codable {

  var id          : Int
  var name        : String
  var description : String
  var thumbnail   : Thumbnail

  enum CodingKeys: String, CodingKey {

    case id          = "id"
    case name        = "name"
    case description = "description"
    case thumbnail   = "thumbnail"
  
  }
}

struct Thumbnail: Codable {

  var path: String
  var ext: String

  enum CodingKeys: String, CodingKey {
    case path      = "path"
    case ext = "extension"
  }
}
