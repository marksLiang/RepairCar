//
//  CreatedbBase.swift
//  ProjectFramework
//
//  Created by 购友住朋 on 16/7/6.
//  Copyright © 2016年 HCY. All rights reserved.
//

import Foundation
import FMDB

class CreatedbBase {
    
    //SQL 代码说明
    //    #define SQLITE_OK           0   /* 成功 | Successful result */
    //    /* 错误码开始 */
    //    #define SQLITE_ERROR        1   /* SQL错误 或 丢失数据库 | SQL error or missing database */
    //    #define SQLITE_INTERNAL     2   /* SQLite 内部逻辑错误 | Internal logic error in SQLite */
    //    #define SQLITE_PERM         3   /* 拒绝访问 | Access permission denied */
    //    #define SQLITE_ABORT        4   /* 回调函数请求取消操作 | Callback routine requested an abort */
    //    #define SQLITE_BUSY         5   /* 数据库文件被锁定 | The database file is locked */
    //    #define SQLITE_LOCKED       6   /* 数据库中的一个表被锁定 | A table in the database is locked */
    //    #define SQLITE_NOMEM        7   /* 某次 malloc() 函数调用失败 | A malloc() failed */
    //    #define SQLITE_READONLY     8   /* 尝试写入一个只读数据库 | Attempt to write a readonly database */
    //    #define SQLITE_INTERRUPT    9   /* 操作被 sqlite3_interupt() 函数中断 | Operation terminated by sqlite3_interrupt() */
    //    #define SQLITE_IOERR       10   /* 发生某些磁盘 I/O 错误 | Some kind of disk I/O error occurred */
    //    #define SQLITE_CORRUPT     11   /* 数据库磁盘映像不正确 | The database disk image is malformed */
    //    #define SQLITE_NOTFOUND    12   /* sqlite3_file_control() 中出现未知操作数 | Unknown opcode in sqlite3_file_control() */
    //    #define SQLITE_FULL        13   /* 因为数据库满导致插入失败 | Insertion failed because database is full */
    //    #define SQLITE_CANTOPEN    14   /* 无法打开数据库文件 | Unable to open the database file */
    //    #define SQLITE_PROTOCOL    15   /* 数据库锁定协议错误 | Database lock protocol error */
    //    #define SQLITE_EMPTY       16   /* 数据库为空 | Database is empty */
    //    #define SQLITE_SCHEMA      17   /* 数据结构发生改变 | The database schema changed */
    //    #define SQLITE_TOOBIG      18   /* 字符串或二进制数据超过大小限制 | String or BLOB exceeds size limit */
    //    #define SQLITE_CONSTRAINT  19   /* 由于约束违例而取消 | Abort due to constraint violation */
    //    #define SQLITE_MISMATCH    20   /* 数据类型不匹配 | Data type mismatch */
    //    #define SQLITE_MISUSE      21   /* 不正确的库使用 | Library used incorrectly */
    //    #define SQLITE_NOLFS       22   /* 使用了操作系统不支持的功能 | Uses OS features not supported on host */
    //    #define SQLITE_AUTH        23   /* 授权失败 | Authorization denied */
    //    #define SQLITE_FORMAT      24   /* 附加数据库格式错误 | Auxiliary database format error */
    //    #define SQLITE_RANGE       25   /* 传递给sqlite3_bind()的第二个参数超出范围 | 2nd parameter to sqlite3_bind out of range */
    //    #define SQLITE_NOTADB      26   /* 被打开的文件不是一个数据库文件 | File opened that is not a database file */
    //    #define SQLITE_ROW         100  /* sqlite3_step() 已经产生一个行结果 | sqlite3_step() has another row ready */
    //    #define SQLITE_DONE        101  /* sqlite3_step() 完成执行操作 | sqlite3_step() has finished executing */
    
    /**
     创建DBSQL
     
     - parameter dbBase:
     */
    func CreateDB( ){
 
        var DBItem=[String]()
        //用户信息
        let createSql1:String = "CREATE TABLE IF NOT EXISTS MemberInfo (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, userid integer , PhoneNo text , RealName text ,  Sex text , HeadImgPath text , Token text  , IsLogin bit , authorizationtype integer)"
        
        DBItem.append(createSql1) // 用户信息
        
        for value in DBItem {
            CommonFunction.ExecuteUpdate(value, nil, callback: { (isOk) in
                if(isOk){
                    debugPrint("数据库创建成功！" ,value)
                }
                else{
                    debugPrint("数据库创建失败! ",value)
                }
            })
        }
        
        DefaultDBData()
    }
    
    
    func DefaultDBData(){
        
        //--------------------------------用户信息表-----------------------------------
        //先查询 用户表  表是否存在数据 如果存在 则读取放到全局函数 否则就新增一条默认值为0的数据
        CommonFunction.ExecuteQuery("select *  from MemberInfo", nil) { (Result) in
            
            if(!Result.next()){
                CommonFunction.ExecuteUpdate("insert into MemberInfo (userid,PhoneNo,RealName,Sex,HeadImgPath,Token,IsLogin ,authorizationtype) values (?,?,?,?,?,?,?,? ) ", ["0" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,"" as AnyObject,false as AnyObject,"0" as AnyObject]) { (isOk) in
                }
            }else{
                CommonFunction.ExecuteQuery("select * from MemberInfo", nil, callback: { (Result) in
                    while Result.next() {
                        print(Result.resultDictionary())
                        let userid = Result.int(forColumn: "userid") as Int32
                        let PhoneNo = Result.string(forColumn: "PhoneNo") as String
                        let RealName = Result.string(forColumn: "RealName") as String
                        let Sex = Result.string(forColumn: "Sex") as String
                        let HeadImgPath = Result.string(forColumn: "HeadImgPath") as String
                        let Token = Result.string(forColumn: "Token") as String
                        let IsLogin = Result.bool(forColumn: "IsLogin") as Bool
                        
                        let authorizationtype = Result.int(forColumn: "authorizationtype") as Int32
                         
                        Global_UserInfo.IsLogin=IsLogin
                        Global_UserInfo.userid=Int(userid)
                        Global_UserInfo.PhoneNo=PhoneNo
                        Global_UserInfo.RealName=RealName
                        Global_UserInfo.Sex=Sex
                        Global_UserInfo.HeadImgPath=HeadImgPath
                        Global_UserInfo.Token=Token
                        Global_UserInfo.authorizationtype=Int(authorizationtype)
                        
                    }
                    
                })
            }
        }
        
    }
}
