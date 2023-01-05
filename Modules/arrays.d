module Modules.arrays;


import std.conv, std.range, std.digest, std.string;
import std.stdio, std.array, std.algorithm;

import Object.datatype, Object.boolean;
import Object.strings, Object.numbers;
import Object.lists;



class Reverse: DataType{
    override DataType __call__(DataType[] params){
        params[0].__array__.reverse;
        return new None();
    }

    override string __str__(){return "reverse (arrays method)";}
}


class Copy: DataType{
    override DataType __call__(DataType[] params){
        return new List(params[0].__array__.dup);
    }

    override string __str__(){return "copy (arrays method)";}
}


class Concate: DataType{
    override DataType __call__(DataType[] params){
    	DataType[] arr = params[0].__array__;

    	for(int i = 1; i < params.length; i++)
    		arr ~= params[i].__array__;

        return new List(arr);
    }

    override string __str__(){return "concate (arrays method)";}
}

class Fetch: DataType{
    override DataType __call__(DataType[] params){
    	DataType[] arr;
    	int min = cast(int)params[1].number2;
    	int max = cast(int)params[0].__array__.length;

    	if (params.length > 2) {
    		max = cast(int)params[2].number2;

    		if (max > params[0].__array__.length)
    			max = cast(int)params[0].__array__.length;
    	}



    	for(int i = min; i < max; i++)
    		arr ~= params[0].__array__[i];

        return new List(arr);
    }

    override string __str__(){return "fetch (arrays method)";}
}


class Get: DataType{
    override DataType __call__(DataType[] params){
    	DataType[] arr;
    	int len = cast(int)params[0].__array__.length;
    	int max = cast(int)params[1].number2;

    	if (max > len)
    		max = len;

    	for(int i = 0; i < max; i++)
    		arr ~= params[0].__array__[i];

        return new List(arr);
    }

    override string __str__(){return "get (arrays method)";}
}


class Arrays_: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "copy": new Copy(),
            "fetch": new Fetch(),
            "get": new Get(),
            "concate": new Concate(),
            "reverse": new Reverse(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "arrays (builtin module)";
    }
}




