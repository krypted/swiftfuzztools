//
//  main.swift
//  Tabler
//

import Foundation
import SQLite


let banner:String = #"""
krypted.com's
,d88~~\   ,88~-_     d8        e      888       888               888~-_
8888     d888   \  _d88__     d8b     888-~88e  888      e88~~8e  888   \
`Y88b   88888    |  888      /Y88b    888  888b 888     d888  88b 888    |
 `Y88b, 88888    |  888     /  Y88b   888  8888 888     8888__888 888   /
   8888  Y888 \ /   888    /____Y88b  888  888P 888     Y888    , 888_-~
\__88P'   `88__X    "88_/ /      Y88b 888-_88"  888____  "88___/  888 ~-_
                \

                            
"""#

print(banner)
//print("Usage: \(#file) <path to SQLITE .db file> \n")
if CommandLine.argc != 2{
    print("[*] Usage: SQtabler <path to SQLITE .db file> \n")
    print("[*] Better luck next time!.")
    exit(EXIT_SUCCESS)
}

let argv = CommandLine.arguments
let fileNameOrPath = argv[1]
if fileNameOrPath == "-h" || fileNameOrPath == "-help"{
    print("     Usage: SQtabler <path to SQLITE .db file> \n")
    print("----------------                    ----------------")
    print(" .... .... .... Please Do Try Again  .... .... .... ")
    exit(EXIT_SUCCESS)
}

let resolvedFIlePath = openFile(fileNameOrPath: fileNameOrPath)

var dbCursor: Connection;
do {
    dbCursor = try Connection(resolvedFIlePath.path);
}
catch {
    print("[?] Database connection failed ... exiting ... ")
    exit(EXIT_SUCCESS);
}


let sqlite_master_Table = Table("sqlite_master");
let TableColumnCalled_name = Expression<String>("name");
let TableColumnCalled_type = Expression<String>("type");

let retrievedRows = Array(try dbCursor.prepare(sqlite_master_Table.select(TableColumnCalled_name).filter(TableColumnCalled_type == "table").order(TableColumnCalled_name.asc)))
// Seriously!!?? ... again it turns out adding ".order" to the query above already returns the result, sorted as needed
// Select name FROM sql_master WHERE type == 'table' ORDER BY name ASC

var sortedArrayOfTableNames = [String]();
var loopCounter = 1

// Nice oppurtunity to try out swift's forEach loop.
retrievedRows.forEach{
    (row) in
    do {
        let tableName = try row.get(TableColumnCalled_name)
        // This print line below shows/ is proof that the returned array is already! sorted!.
        //print(tableName)
        sortedArrayOfTableNames.append(tableName)
    }
    catch{
        print("[*] *** error retrieving table name at row=", loopCounter)
    }
    loopCounter += 1
}

// Didn't use the forEach loop anymore because i just liked the
// fact that ".enumerated" provides me with the index out of the box.
//
// Turns out i need to sort! the table names ... so the index is not
// as needed as first planned, so therefore ... its back to ForEach ... lol
/*for (index, row) in retrievedRows.enumerated(){
    do {
        let tableName = try row.get(TableColumn_name)
        print("[+] ==     ", tableName)
        sortArray.append(tableName)
    }
    catch{
        print("[*] *** error retrieving table name at Row ", index+1)
    }
}*/
print("\n[+] === ===THE \(sortedArrayOfTableNames.count) TABLES ARE: === === ")
print("[-]")
sortedArrayOfTableNames.sort()
sortedArrayOfTableNames.forEach{
    (name) in
    print("[-] -> ", name)
}
print("[-]")
print("[+] === END === === ==END==  === === END === \n\n\n")



// for table_name in table_names:
//     result = cur.execute("PRAGMA table_info('%s')" % table_name).fetchall()
//     column_names = zip(*result)[1]
//     print ("\ncolumn names for %s:" % table_name)+newline_indent+(newline_indent.join(column_names))

for tableName in sortedArrayOfTableNames{

    do{
        // ".run" prepares a single Statement object from a SQL string,
        // optionally binds values to it (using the statement’s bind
        // function),executes, and returns the statement.
        //
        // I know ... I know ... possible sql Injection below.
        // Note: only "possible" not vulnerable/exploitable because we are not
        // taking "tableName" input from user. We get it from the DB itself.
        // But wait ... what if the tableName is an SQL query designed to
        // exploit this "possible" vulnerability!?? ... relax ...
        // according to the SQL specs, it's impossible(hopefully) to create
        // Valid tableName that will still be able to exploit this inexploitable possibility ... lol
        let columnNamesOptionalArray = try dbCursor.run("PRAGMA table_info('\(tableName)')")

        print("[+] == Column Names For: ", tableName, " ")

        for (index, Optional) in columnNamesOptionalArray.enumerated(){
            if let columnName = Optional[1]{
                print("[-] [", index+1, "]: ", columnName)
            }
        }
        print("[+] ===END== ===\n\n")
    }
    catch{
        print("[*] -> **** Error fetching pragma for table:", tableName, " ... ****")
    }
}


// Custom function for resolving file paths.
 func openFile(fileNameOrPath: String) -> URL {
     
     let currentDir = FileManager.default.currentDirectoryPath
     var resolvedFilePath: URL;
     
     //print("curDir: ",currentDir + "./file.txt")
     if fileNameOrPath.starts(with: "/"){
         resolvedFilePath = URL(fileURLWithPath: fileNameOrPath)
         print("[+] Using .db file at :",resolvedFilePath.path)
         return resolvedFilePath
     }
     else if fileNameOrPath.starts(with: "./"){
         let fileName = fileNameOrPath.suffix(fileNameOrPath.count - 2)
         resolvedFilePath = URL(fileURLWithPath: String(currentDir + "/" + fileName))
         print("[+] Using .db file at :",resolvedFilePath.path)
         return resolvedFilePath
     }
     else if FileManager.default.fileExists(atPath: currentDir + fileNameOrPath){
         resolvedFilePath = URL(fileURLWithPath: currentDir + fileNameOrPath)
         print("[+] Using .db file at :",resolvedFilePath.path)
         return resolvedFilePath
     }
     else {
         print("[?] File!! not!! found!! ... exiting!!!")
        exit(EXIT_SUCCESS)
     }
     
 }
