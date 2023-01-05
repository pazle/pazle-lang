module Modules.string;


import std.conv, std.range, std.digest, std.string;
import std.stdio, std.array, std.algorithm;

import Object.datatype, Object.boolean;
import Object.strings, Object.numbers;
import Object.lists;



class Trim: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(chomp(params[0].__str__, params[1].__str__));
    	
        return new String(chomp(params[0].__str__));
    }

    override string __str__() { return "trim (strings method)"; }
}


class Concate: DataType{
    override DataType __call__(DataType[] params){
        string gen;

        foreach(i; params)
            gen ~= i.__str__;
        
        return new String(gen);
    }

    override string __str__() { return "concate (strings method)"; }
}


class Times: DataType{
    override DataType __call__(DataType[] params){
        string gen;

        for(int i = 0; i < params[1].number2; i++)
            gen ~= params[0].__str__;
        
        return new String(gen);
    }

    override string __str__() { return "times (strings method)"; }
}


class Strip: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(strip(params[0].__str__, params[1].__str__));
    	
        return new String(strip(params[0].__str__));
    }

    override string __str__() { return "strip (strings method)"; }
}


class Lstrip: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(stripLeft(params[0].__str__, params[1].__str__));
    	
        return new String(stripLeft(params[0].__str__));
    }

    override string __str__() { return "lstrip (strings method)"; }
}


class Rstrip: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(stripRight(params[0].__str__, params[1].__str__));
    	
        return new String(stripRight(params[0].__str__));
    }

    override string __str__() { return "rstrip (strings method)"; }
}


class Wrap: DataType{
    override DataType __call__(DataType[] params){
    	if (params.length > 1)
    		return new String(wrap(params[0].__str__, params[1].number2));
    	
        return new String(wrap(params[0].__str__, 5));
    }

    override string __str__() { return "wrap (strings method)"; }
}


class IndexOf: DataType {
    override DataType __call__(DataType[] params){
        return new Number(indexOf(params[0].__str__, params[1].__str__));
    }

    override string __str__() { return "indexOf (strings method)"; }
}


DataType toStr(string i){
	return new String(strip(i));
}


class SplitLines: DataType{
    override DataType __call__(DataType[] params){
        auto arr = splitLines(params[0].__str__);
        alias linz = map!(toStr);

        return new List(linz(arr).array);
    }

    override string __str__() { return "splitLines (strings method)"; }
}


class Split: DataType{
    override DataType __call__(DataType[] params){
        alias linz = map!(toStr);

    	if (params.length > 1){
        	auto arr = split(params[0].__str__, params[1].__str__);
       		return new List(linz(arr).array);
    	
    	}

        auto arr = params[0].__str__.split;
        return new List(linz(arr).array);
    }

    override string __str__() { return "split (strings method)"; }
}


class Lower: DataType{
    override DataType __call__(DataType[] params){
        return new String(toLower(params[0].__str__));
    }

    override string __str__(){return "lower (strings method)";}
}


class Upper: DataType{
    override DataType __call__(DataType[] params){
        return new String(toUpper(params[0].__str__));
    }
    
    override string __str__(){return "upper (strings method)";}
}


class Replace: DataType{
    override DataType __call__(DataType[] params){
        return new String(params[0].__str__.replace(params[1].__str__, params[2].__str__));
    }
    override string __str__(){return "replace (strings method)";}
}


class Hex: DataType{
    override DataType __call__(DataType[] params){
        return new String(toHexString(cast(ubyte[])params[0].__str__));
    }

    override string __str__(){return "hex (strings method)";}
}


class Hex_toStr: DataType{
    override DataType __call__(DataType[] params){
        //return new String(params[0].__str__.chunks(2).map!(i => cast(char) i.to!ubyte(16)).array);
        return new String(std.range.chunks(params[0].__str__, 2).map!(i => cast(char)i.to!ubyte(16)).array);
    }

    override string __str__(){return "hexTostr (strings method)";}
}


class ToString: DataType{
    override DataType __call__(DataType[] params){
        if(params.length)
            return new String(params[0].__str__);

        return new String("");
    }

    override string __str__(){return "string (strings method)";}
}



class StringM: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "trim": new Trim(),
            "wrap": new Wrap(),
            "strip": new Strip(),
            "split": new Split(),
            "times": new Times(),
            "lstrip": new Lstrip(),
            "rstrip": new Rstrip(),
            "string": new ToString(),
            "concate": new Concate(),
            "indexOf": new IndexOf(),
            "splitLines": new SplitLines(),
            "hex": new Hex(),
            "hexTostr": new Hex_toStr(),
            "lower": new Lower(),
            "upper": new Upper(),
            "replace": new Replace(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "strings (builtin module)";
    }
}


