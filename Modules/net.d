module Modules.net;

import std.stdio;
import std.conv;
import std.net.curl;

import Object.datatype;
import Object.strings;
import Object.boolean;
import Object.numbers;
import Object.lists;
import Object.bytes;


class Readln: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){
            List lis = new List([]);
            foreach (char[] line; byLine(params[0].__str__)){
                writeln(line);
                lis.__act__(new Chars(line));
            }
            return lis;
        }
        return new None();
    }

    override string __str__() {
        return "readln (net method)";
    }
}


class Readchunk: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1){
            List lis = new List([]);
            
            version (Windows) {
                foreach (ubyte[] line; byChunk(params[0].__str__, cast(size_t)params[1].number2))
                    lis.__act__(new Chars(cast(char[])line));
            } else {
                foreach (ubyte[] line; byChunk(params[0].__str__, params[1].number2))
                    lis.__act__(new Chars(cast(char[])line));
            }

            return lis;
        }
        return new None();
    }

    override string __str__() { return "readbin (net method)";}
}


class Download: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1){
            download(params[0].__str__, params[1].__str__);
        }
        return new None();
    }

    override string __str__() {
        return "download (net method)";
    }
}


class Upload: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1){
            upload(params[0].__str__, params[1].__str__);
        }
        return new None();
    }

    override string __str__() {
        return "upload (net method)";
    }
}


class Get: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){
            return new Chars(get(params[0].__str__));
        }
        return new None();
    }

    override string __str__() {
        return "get (net method)";
    }
}


class Put: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1){
            return new Chars(put(params[0].__str__, params[1].__str__));
        }
        return new None();
    }

    override string __str__() {
        return "put (net method)";
    }
}


class Post: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1){

            auto cnt = params[1].__heap__;
            string[string] content;

            foreach (string i; cnt.keys){
                content[i] = cnt[i].__str__;
            }

            return new Chars(post(params[0].__str__, content));
        }
        return new None();
    }

    override string __str__() {
        return "post (net method)";
    }
}


class Net: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "download": new Download(),
            "upload": new Upload(),
            "get": new Get(),
            "put": new Put(),
            "post": new Post(),
            "readln": new Readln(),
            "readbin": new Readchunk(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "net (libcurl wrapper)";
    }
}

