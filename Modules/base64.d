module Modules.base64;

import std.stdio;
import std.conv;
import std.base64;

import Object.datatype;
import Object.strings;
import Object.bytes;



class Encode64: DataType{
    override DataType __call__(DataType[] params){
        return new String(Base64.encode(cast(ubyte[])params[0].__chars__));
    }

    override string __str__() { return "encode (base64 method)"; }
}


class Decode64: DataType{
    override DataType __call__(DataType[] params){
        ubyte[] b64 = Base64.decode(params[0].__str__);
        return new Chars(cast(char[])b64);
    }

    override string __str__() { return "decode (base64 method)"; }
}


class Encode64URL: DataType{
    override DataType __call__(DataType[] params){
        return new String(Base64URL.encode(cast(ubyte[])params[0].__chars__));
    }

    override string __str__() { return "encode_url (base64 method)"; }
}


class Decode64URL: DataType{
    override DataType __call__(DataType[] params){
        ubyte[] b64 = Base64URL.decode(params[0].__str__);
        return new Chars(cast(char[])b64);
    }

    override string __str__() { return "decode_url (base64 method)"; }
}


class Base64_: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "encode": new Encode64(),
            "decode": new Decode64(),
            "encode_url": new Encode64URL(),
            "decode_url": new Decode64URL(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "base64 (builtin module)";
    }
}

