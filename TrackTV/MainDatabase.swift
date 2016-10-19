import Foundation
import SQLite

class MainDatabase {
    public let db: Connection?
    // 初始化连接到数据库文件，不存在则会自动新建
    public init(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/mainDatabase.sqlite3")
            print("⭐️⭐️⭐️⭐️⭐️数据库路径\(path)")
        } catch {
            db = nil
            print ("Unable to open database")
        }

        createTable()
    }
    // 子类来实现
    func createTable() {

    }

}
