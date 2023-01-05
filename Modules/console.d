module Modules.console;

import std.stdio;
import std.conv;
import std.string;
import core.stdc.stdlib;


import Object.datatype;
import Object.dictionary;
import Object.strings;
import Object.numbers;
import Object.boolean;
import Object.lists;
import Object.bytes;


class Console: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = [
					"print": new Print(),
					"readline": new Readline(),

					"iter": new Iter(),
					"next": new Next(),
					"attrs": new Attrs(),
					"super": new Super(),
					"length": new Length(),
					"range": new Range(),
					"type": new Type(),
					"exit": new Exit(),

					"delAttr": new DelAttr(),
					"getAttr": new GetAttr(),
					"setAttr": new SetAttr(),

					"string": new Stringed(),
					"number": new Numbered(),
					"bytes": new Byted(),
					"array": new Arrayed(),
				];
	}
	
	override DataType[string] attrs() { return this.attributes; }
	override string __str__() { return "console (builtin module)";}
}


class Stringed: DataType{
	override DataType __call__(DataType[] params){
		if(params.length)
			return new String(params[0].__str__);

		return new String("");
	}

	override string __str__() { return "string (object)"; }
	override string __type__(){ return "string"; }
}


class Numbered: DataType{
	override DataType __call__(DataType[] params){
		if(params.length)
			return new Number(cast(double)params[0].number2);

		return new Number(0);
	}

	override string __str__() { return "number (object)"; }
	override string __type__(){ return "number"; }
}


class Arrayed: DataType{
	override DataType __call__(DataType[] params){
		List list = new List([]);

		if(params.length) {

			if(typeid(params[0]) == typeid(String)){
				foreach(char i; params[0].__str__)
					list.__act__(new String(i~""));
				return list;

			} else if(typeid(params[0]) == typeid(List))
					return params[0];

			else if(typeid(params[0]) == typeid(Dict))
					return params[0].attrs()["keys"].__call__(params);

			list.__act__(params[0]);
		}

		return list;
	}

	override string __str__() { return "array (object)"; }
	override string __type__(){ return "array"; }
}


class Byted: DataType{
	override DataType __call__(DataType[] params){
		if(params.length) {
			if(typeid(params[0]) == typeid(String))
				return new Chars(cast(char[])params[0].__str__);

			else if(typeid(params[0]) == typeid(Number))
				return new Bytes(cast(byte[])params[0].__str__);

			else if(typeid(params[0]) == typeid(List))
				return new Chars(cast(char[])params[0].__array__);
		}

		char[] bit; 
		return new Chars(bit);
	}

	override string __str__() { return "bytes (object)"; }
	override string __type__(){ return "bytes"; }
}


class Print: DataType{
	override DataType __call__(DataType[] params){
		foreach(DataType i; params)
			writef("%s ", i.__str__);

		writeln();
		return this;
	}
	override string __str__(){ return "print (console method)"; }
}


class Attrs: DataType{
	override DataType __call__(DataType[] params){
		DataType[] dir;

		foreach(string i; params[0].attrs.keys)
			dir ~= new String(i);

		return new List(dir);
	}
	override string __str__(){ return "attrs (console method)"; }
}


class Readline: DataType{	
	override DataType __call__(DataType[] params){
		foreach(DataType i; params)
			writef("%s", i.__str__);

		return new String(chomp(readln()));
	}
	override string __str__(){ return "readline (console method)"; }
}


class iterObject: DataType{
	int len;
	string repr;
	DataType data;
	DataType[string] attributes;

	this(DataType data){
		this.data = data;
		this.len = -1;
		this.attributes = ["__iter__": this.data];

		if (typeid(data) == typeid(Newrange))
			this.repr = data.__str__;
		else
			this.repr = "iter (object " ~ this.data.__type__ ~")";
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __fetch__(){
		this.len += 1;
		return this.data.__iter__(this.len);
	}

	override string __str__(){
		return this.repr;
	}

	override DataType __length__(){
		return this.data.__length__;
	}
}

class Newrange: DataType{
	long start, end;
	string repr;

	this(long start, long end){
		this.start = start-1;
		this.end = end-1;
		this.repr = "range ("~to!string(start)~", "~to!string(end)~")";
	}

	override DataType __iter__(int index){
		if (this.start < this.end){
			this.start += 1;
			return new Number(this.start);
		}

		return new EOI();
	}

	override DataType __call__(DataType[] params){ return new iterObject(this);}
	override string __str__(){ return this.repr; }
}


class Range: DataType {
	override DataType __call__(DataType[] params){
		if (params.length) {
			if (params.length > 1)
				return new Newrange(params[0].number2, params[1].number2).__call__([]);
			else 
				return new Newrange(0, params[0].number2).__call__([]);
		}
		return new Newrange(0, 0);
	}
}


class Iter: DataType{
	override DataType __call__(DataType[] params){
		if ("__iter__" in params[0].attrs)
			return params[0];
		else
			return new iterObject(params[0]);
	}

	override string __str__(){ return "iter (console method)"; }
}


class Next: DataType{
	override DataType __call__(DataType[] params){ return params[0].__fetch__; }
	override string __str__(){ return "next (console function)"; }
}


// super
class _super: DataType{
	DataType obj;
	DataType inst;
	DataType[string] attributes;

	this(DataType obj, DataType inst){
		this.obj = obj;
		this.inst = inst;
		this.attributes = attributes;
	}

	override DataType __call__(DataType[] params){
		this.obj.__heap__[this.inst.attrs["__name__"].__str__].__call__(params);
		return new DataType();
	}
}


class Super: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params){
		return new _super(params[0], params[1]);
		return this;
	}

	override string __str__(){
		return "super (console method)";
	}
}


class Length: DataType{
	override DataType __call__(DataType[] params){ return params[0].__length__;}

	override string __str__(){ return "length (console method)";}
}


class GetAttr: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 1){
			string att = params[1].__str__;

			if (att in params[0].attrs)
				return params[0].attrs[att];
			else
				throw new Exception("Attribute '"~att~"' not found.");
		}

		return new None();
	}

	override string __str__(){ return "getattr (console method)";}
}


class SetAttr: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 2){
			string att = params[1].__str__;
			
			params[0].attrs[att] = params[2];
			return new True();
		}

		return new None();
	}

	override string __str__(){
		return "setattr (console method)";
	}
}


class DelAttr: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 1){
			string att = params[1].__str__;

			if (att in params[0].attrs) {
				params[0].attrs.remove(att);
				return new True();
			}
		}

		return new None();
	}

	override string __str__(){
		return "delattr (console method)";
	}
}


class Type: DataType{
	override DataType __call__(DataType[] params){
		return new String(params[0].__type__);
	}

	override string __str__(){ return "type (console method)"; }
}


class Exit: DataType{
	override DataType __call__(DataType[] params){
		exit(0);
		return new None();
	}

	override string __str__(){ return "exit (console method)"; }
}
