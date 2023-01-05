module Modules.exceptions;

import std.stdio;
import std.file;


import Object.datatype;
import Object.strings;
import Object.numbers;
import Object.boolean;
import Object.lists;


class _Exception: DataType{
	string error;
	string err;
	DataType[string] attributes;

	this(string msg, string file, ulong line, string err = "Exception"){
		this.error = msg;
		this.err = err;

		this.attributes = [
			"msg": new String(msg),
			"file": new String(file),
			"line": new Number(line),
		];
	}

	override string __type__(){
		return this.err;
	}
	
	override DataType[string] attrs() {
		return this.attributes;
	}

	override string __str__() { return this.err ~ ": " ~ this.error;}
}


class _newException: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 2)
			return new _Exception(params[0].__str__, params[1].__str__, params[2].number2, "Exception");

		return new None();
	}

	override string __type__() { return "Exception"; }
	override string __str__() {return "[Exceptions.Object: #Exception]"; }
}


class _Undef: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 2)
			return new _Exception(params[0].__str__, params[1].__str__, params[2].number2, "UndefError");

		return new None();
	}

	override string __type__() { return "UndefError"; }
	override string __str__() {return "UndefError (Exceptions method)"; }
}


class Catch: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = [
			"Exception": new _newException(),
			"UndefError": new _Undef(),
		];
	}

	override DataType[string] attrs() { return this.attributes;}
	override string __str__() { return "[Module: #Exceptions]"; }
}


