//
//  Database.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 18.11.2021.
//

import Foundation
import SQLite3

class Database {
    
    var db : OpaquePointer?
    var path : String = "Pulse_db.sqlite"
    init() {
        self.db = createDB()
        self.createTable()
    }

    func createDB() -> OpaquePointer? {
        //Creating filepath for our database
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        //Making connection to database with created database path
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        }else {
            print("Database has been created with path \(filePath.path)")
            return db
        }
    }
    
    func createTable()  {
        //Composing string for query
        let query = "CREATE TABLE IF NOT EXISTS user_data(id INTEGER PRIMARY KEY AUTOINCREMENT,user_id TEXT, login TEXT, password TEXT, token TEXT);"
        var statement : OpaquePointer? = nil
        
        //Checking if our query is ok or not
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            //Actual creation of table
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Table creation success")
            }else {
                print("Table creation fail")
            }
        } else {
            print("Preparation fail")
        }
    }
    
    func insertUserData(userId: String, login: String, password: String, token: String) {
        let insertStatementString = "INSERT INTO user_data (id, user_id, login, password, token) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        //Checking if prepared statement is ok or not
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let id: Int32 = 2
            let userId = NSString(string: userId)
            let login = NSString(string: login)
            let password = NSString(string: password)
            let token = NSString(string: token)
            // 2
            sqlite3_bind_int(insertStatement, 1, id)
            // 3
            sqlite3_bind_text(insertStatement, 2, userId.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, login.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, password.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, token.utf8String, -1, nil)
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }

    //Fetching login and password from database. Function returns or ("login", "password") or ("", "")
    func queryLoginPassword() -> (String, String) {
        let queryStatementString = "SELECT * FROM user_data;"
      var queryStatement: OpaquePointer?
      // 1
      if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
          SQLITE_OK {
        // 2
        if sqlite3_step(queryStatement) == SQLITE_ROW {
          
          guard let queryResultCol3 = sqlite3_column_text(queryStatement, 2) else {
            print("Query result is nil")
              sqlite3_finalize(queryStatement)
              return ("", "")
          }
            guard let queryResultCol4 = sqlite3_column_text(queryStatement, 3) else {
              print("Query result is nil")
                sqlite3_finalize(queryStatement)
                return    ("", "")
            }
          let login = String(cString: queryResultCol3)
          let password = String(cString: queryResultCol4)
          
            return (login, password)
      } else {
          print("\nQuery returned no results.")
          sqlite3_finalize(queryStatement)
          return ("", "")
      }
      } else {
          // 6
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("\nQuery is not prepared \(errorMessage)")
          sqlite3_finalize(queryStatement)
          return ("", "")
      }
      // 7
    }
    
//    func isUserDataMoreThanOneRow() -> Bool {
//        let queryStatementString = "SELECT * FROM user_data;"
//    }
}