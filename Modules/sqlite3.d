module Modules.sqlite3;

pragma(lib, "sqlite3");


import std.stdio;
import std.conv;
import std.string;
import std.path;
import etc.c.sqlite3;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.classes;
import Object.lists;
import Object.bytes;



class sqlClose: DataType{
    sqlite3* db;

    this(sqlite3* db){
        this.db = db;
    }

    override DataType __call__(DataType[] params){
        sqlite3_close(this.db);
        return new None();
    }
    override string __str__() { return "close (database)"; }
}



extern(C) int callback(void* none, int length, char** values, char** columns){
    List row = new List([]);

    for(int i=0; i<length; i++)
        row.__act__(new String(to!string(values[i] ? values[i] : "NULL")));

    List* table = cast(List*)none;
    table.__act__(row);

    return 0;
}


extern(C) int callback2(void* none, int length, char** values, char** columns){
    List* row = cast(List*)none;

    for(int i=0; i<length; i++)
        row.__act__(new String(to!string(values[i] ? values[i] : "NULL")));

    return 0;
}



class sqlExecute: DataType{
    sqlite3* db;

    this(sqlite3* db){
        this.db = db;
    }

    override DataType __call__(DataType[] params){
        char* errorMessage;
        List rows = new List([]);

        int status_code = sqlite3_exec(this.db, toStringz(params[0].__str__), &callback, &rows, &errorMessage);

        return new Obj_("feedback", [
                            "error": new String(to!string(errorMessage)),
                            "status": new Number(status_code),
                            "fetch": rows,
                        ]);
    }
    override string __str__() { return "execute (database method)"; }
}


class sqlRun: DataType{
    sqlite3* db;

    this(sqlite3* db){
        this.db = db;
    }

    override DataType __call__(DataType[] params){
        char* errorMessage;
        List rows = new List([]);

        int status_code = sqlite3_exec(this.db, toStringz(params[0].__str__), &callback2, &rows, &errorMessage);

        return new Obj_("feedback", [
                            "error": new String(to!string(errorMessage)),
                            "status": new Number(status_code),
                            "fetch": rows,
                        ]);
    }
    override string __str__() { return "run (database method)"; }
}


class sqlChanges: DataType{
    sqlite3* db;
    
    this(sqlite3* db){ this.db = db; }

    override DataType __call__(DataType[] params){
        return new Number(sqlite3_changes(this.db));
    }
    override string __str__() { return "changes (database method)"; }
}


class sqlErrorCode: DataType{
    sqlite3* db;
    
    this(sqlite3* db){ this.db = db; }

    override DataType __call__(DataType[] params){
        return new Number(sqlite3_errcode(this.db));
    }
    override string __str__() { return "errorCode (database method)"; }
}


class sqlErrMessage: DataType{
    sqlite3* db;
    
    this(sqlite3* db){ this.db = db; }

    override DataType __call__(DataType[] params){
        return new String(to!string(sqlite3_errmsg(this.db)));
    }
    override string __str__() { return "errorMessage (database method)"; }
}


class sqlTotalChanges: DataType{
    sqlite3* db;
    
    this(sqlite3* db){ this.db = db; }

    override DataType __call__(DataType[] params){
        return new Number(sqlite3_total_changes(this.db));
    }
    override string __str__() { return "totalChanges (database method)"; }
}


class sqlInterrupt: DataType{
    sqlite3* db;
    
    this(sqlite3* db){ this.db = db; }

    override DataType __call__(DataType[] params){
        sqlite3_interrupt(this.db);
        return new None();
    }
    override string __str__() { return "interrupt (database method)"; }
}


class openDatabase: DataType{
    DataType[string] attributes;
    int status_code;
    string name;
    sqlite3* db;

    this(string name){
        this.name = name;
        this.db = db;
        this.status_code = status_code;
        this.openDb();

        this.attributes = [
            "execute": new sqlExecute(this.db),
            "run": new sqlRun(this.db),
            
            "errorMessage": new sqlErrMessage(this.db),
            "errorCode": new sqlErrorCode(this.db),

            "close": new sqlClose(this.db),
            "status": new Number(this.status_code),
            "interrupt": new sqlInterrupt(this.db),

            "changes": new sqlChanges(this.db),
            "totalChanges": new sqlTotalChanges(this.db),
        ];
    }

    void openDb(){
        this.status_code = sqlite3_open(toStringz(this.name), &this.db);
    }
    
    override DataType[string] attrs(){ return this.attributes; }

    override string __str__(){ return std.path.baseName(this.name) ~ " (sqlite3 database)";}
}


class Database: DataType{
    override DataType __call__(DataType[] params){
        return new openDatabase(params[0].__str__);
    }
    override string __str__() { return "Database (sqlite3 object)";}
}


class sqlComplete: DataType{
    override DataType __call__(DataType[] params){
        return new Number(sqlite3_complete(toStringz(params[0].__str__)));
    }
    override string __str__() { return "complete (database method)"; }
}


class sqlSleep: DataType{
    override DataType __call__(DataType[] params){
        return new Number(sqlite3_sleep(cast(int)params[0].number));
    }
    override string __str__() { return "sleep (database method)"; }
}


class sqlTempDir: DataType{
    override DataType __call__(DataType[] params){
        return new String(to!string(sqlite3_temp_directory));
    }
    override string __str__() { return "tempDir (database method)"; }
}


class Sqlite3: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "Database": new Database(),
            "sleep": new sqlSleep(),
            "tempDir": new sqlTempDir(),
            "complete": new sqlComplete(),
            "SQLITE_OK": new Number(0),
            "SQLITE_ERROR": new Number(1),
            "SQLITE_INTERNAL": new Number(2),
            "SQLITE_PERM": new Number(3),
            "SQLITE_ABORT": new Number(4),
            "SQLITE_BUSY": new Number(5),
            "SQLITE_LOCKED": new Number(6),
            "SQLITE_READONLY": new Number(8),
            "SQLITE_INTERRUPT": new Number(9),
            "SQLITE_IOERR": new Number(10),
            "SQLITE_CORRUPT": new Number(11),
            "SQLITE_NOTFOUND": new Number(12),
            "SQLITE_FULL": new Number(13),
            "SQLITE_EMPTY": new Number(16),
            "SQLITE_TOOBIG": new Number(18),
            "SQLITE_MISMATCH": new Number(20),
            "SQLITE_AUTH": new Number(23),
        ];
    }

    override DataType[string] attrs() { return this.attributes; }

    override string __type__() { return "sqlite3"; }

    override string __str__() { return "sqlite3 (built-in module)"; }
}

