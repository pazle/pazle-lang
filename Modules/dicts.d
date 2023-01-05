module Modules.dicts;


import std.conv, std.range;
import std.stdio, std.array, std.algorithm;

import Object.datatype, Object.dictionary;
import Object.strings, Object.numbers;
import Object.lists, Object.boolean;




class Copy: DataType{
    override DataType __call__(DataType[] params){
        return new Dict(params[0].__heap__.dup);
    }

    override string __str__(){return "copy (dicts method)";}
}


class Has: DataType{
    override DataType __call__(DataType[] params){
        if (params[0].__str__ in params[0].__heap__)
            return new True();

        return new False();
    }

    override string __str__(){return "has (dicts method)";}
}



DataType toStr(string i){
    return new String(i);
}

class Keys: DataType{
    override DataType __call__(DataType[] params){
    	alias key = map!(toStr);
        return new List(key(params[0].__heap__.keys()).array);
    }

    override string __str__(){return "keys (dicts method)";}
}


class Values: DataType {
    override DataType __call__(DataType[] params){
        return new List(params[0].__heap__.values());
    }

    override string __str__(){return "value (dicts method)";}
}


class Set: DataType{
    override DataType __call__(DataType[] params){
        params[0].__heap__[params[1].__str__] = params[2];
        return new None();
    }

    override string __str__(){return "set (dicts method)";}
}


class Get: DataType{
    override DataType __call__(DataType[] params){
        return params[0].__heap__[params[1].__str__];
    }

    override string __str__(){return "get (dicts method)";}
}


class Pop: DataType{
    override DataType __call__(DataType[] params){
        DataType x = params[0].__heap__[params[1].__str__];
        params[0].__heap__.remove(params[1].__str__);
        return x;
    }

    override string __str__(){return "pop (dicts method)";}
}





class Dicts_: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "has": new Has(),
            "pop": new Pop(),
            "set": new Set(),
            "get": new Get(),
            "copy": new Copy(),
            "keys": new Keys(),
            "values": new Values(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "dicts (builtin module)";
    }
}




