module Modules.random;

import std.stdio;
import std.random;
import std.conv;
import std.algorithm;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.lists;



class Shuffle: DataType{
    override DataType __call__(DataType[] params){
        return new List(randomShuffle(params[0].__array__));
    }
    override string __str__() { return "shuffle (random method)"; }
}


class randSample: DataType{
    override DataType __call__(DataType[] params){
        DataType data = params[0];
        List samples = new List([]);

        foreach(i; randomSample(data.__array__, cast(int)params[1].number2))
            samples.__act__(i);

        return samples;
    }
    override string __str__() { return "sample (random method)"; }
}


class randInteger: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1)
            return new Number(cast(int)(uniform(params[0].number, params[1].number)));
        
        return new Number(cast(int)(uniform(0, params[0].number)));
    }

    override string __str__() { return "integer (random method)"; }
}


class randReal: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1)
            return new Number(uniform(params[0].number, params[1].number));
            
        return new Number(uniform(0, params[0].number));
    }

    override string __str__() { return "real (random method)"; }
}


class randBool: DataType{
    override DataType __call__(DataType[] params){
        if ([true, false][cast(int)(uniform(0, 2))])
            return new True();

        return new False();
    }
    override string __str__() { return "bool (random method)"; }
}


class randPick: DataType{
    override DataType __call__(DataType[] params){
        DataType data = params[0];

        if(typeid(data) == typeid(List))
            return choice(data.__array__);

        return new String(""~(data.__str__[uniform(0, data.__str__.length)]));
    }
    override string __str__() { return "pick (random method)"; }
}


class randString: DataType{
    override DataType __call__(DataType[] params){
        string str;
        string pick = "kyKSegYpwanMfLvmtNq82B6Z4AxblJDV17Woj0h3I9CQrcEPuzHGFdTOUiX5sR";

        if(params.length > 1)
            pick = params[1].__str__ ~ pick; 

        for(int i = 0; i < params[0].number2; i++)
            str ~= pick[uniform(0, pick.length)];

        return new String(str);
    }
    override string __str__() { return "string (random method)"; }
}


class randStringPool: DataType{
    override DataType __call__(DataType[] params){
        string pool = params[0].__str__;
        string str;

        ulong len = params[1].number2; 

        for(ulong i = 0; i < len; i++)
            str ~= pool[uniform(0, pool.length)];

        return new String(str);
    }
    override string __str__() { return "stringPool (random method)"; }
}


class Rand: DataType{
    override DataType __call__(DataType[] params){
        return new Number(uniform(0.0000000001, 1));
    }

    override string __str__() {
        return "random (random method)";
    }
}


class Random: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "shuffle": new Shuffle(),
            "random": new Rand(),

            "pick": new randPick(),
            "string": new randString(),
            "stringPool": new randStringPool(),
            "sample": new randSample(),
            
            "bool": new randBool(),
            "real": new randReal(),
            "integer": new randInteger(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "random (builtin module)";
    }
}

