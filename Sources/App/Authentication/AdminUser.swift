import Foundation
import Vapor

struct AdminUser: Authenticatable {
    let user: String
}
