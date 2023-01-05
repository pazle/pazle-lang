module Modules.json;

import std.stdio;
import std.conv;
import std.algorithm;

import eval;
import node;
import lexer;
import parser;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.lists;



class JSONParse: DataType{
    override DataType __call__(DataType[] params){
        string jsonz  = params[0].__str__;

        Token[] toks = new Lex(jsonz).tokens;

        while (toks.length){
            if (toks[0].type !=  "NL")
                break;

            toks = remove(toks, 0);
        }

        if (toks.length) {
            toks = [new Token("JSON#%@0011", "ID", 1, 1, 1), new Token("=", "=", 1, 1, 1)] ~ toks;
            return new Eval(new Parse(toks, "JSONObject").ast, null, "JSONObject", null).hash["JSON#%@0011"];
        }

        return new None();
    }

    override string __str__() { return "parse (JSON method)"; }
}


class JSONJsonize: DataType{
    override DataType __call__(DataType[] params){
        
        return new String(params[0].__json__);
    }

    override string __str__() { return "jsonize (JSON method)"; }
}


class JSON: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "parse": new JSONParse(),
            "jsonize": new JSONJsonize(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {
        return "JSON (builtin module)";
    }
}

