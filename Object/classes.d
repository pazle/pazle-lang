module Object.classes;

import std.stdio;
import std.conv;
import std.uni;

import node;
import eval;
import Object.datatype;
import Object.strings;
import Object.functions;


class Object_: DataType{
	string name;
	string key;
	string file;
	Node[] code;
	ERROR errors;
	Node[] inherit;
	DataType[string] heap;
	DataType[string] supers;
	DataType[string] attributes;

	this(string name, Node[] inherit, Node[] code, DataType[string] heap, DataType[] params, string[] keys, string file, ERROR errors){
		this.heap = heap;
		this.name = name;
		this.file = file;
		this.errors = errors;
		this.supers = supers;
		this.inherit = inherit;
		this.attributes = [
				"__name__": new String(name),
				"__repr__": new String(name ~ " (object)")
		];

		DataType[string] i;
		DataType obj;
		DataType obj2;

		// inherited attributes
		foreach(Node x; this.inherit){
			i = new Eval(x.params, this.heap, this.file, this.errors).hash;
			obj = i[x.str];

			i = new Eval(obj.__code__, obj.__heap__.dup, this.file, this.errors).hash;

			for(int a = 0; a < obj.__keys__.length; a++){
				key = obj.__keys__[a];
				obj2 = i[key];

				if (typeid(obj2) == typeid(Func)){
					obj2.attrs["self"] = this;
					obj2.attrs["__repr__"] = new String(obj2.attrs["__name__"].__str__ ~ " (object " ~ name ~ " method)");
				}

				if (obj2.attrs["__name__"].__str__ == "this")
					this.supers[x.str] = obj2;

				this.attributes[key] = obj2;
			}
		}

		// this class attributes
		i = new Eval(code, this.heap, this.file, this.errors).hash;

		for(int a = 0; a < keys.length; a++){
			obj = i[keys[a]];

			if (typeid(obj) == typeid(Func)){
				obj.attrs["self"] = this;
				obj.attrs["__repr__"] = new String(obj.attrs["__name__"].__str__ ~ " (object " ~ name ~ " method)");
			}

			this.attributes[keys[a]] = obj;
		}

		if ("this" in this.attributes)
			this.attributes["this"].__call__(params);
	}

	override DataType[string] __heap__(){
		return this.supers;
	}

	override string __type__(){
		return this.name;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return this.attributes["__repr__"].__str__;
	}

	override string __json__(){
		return this.attributes["__repr__"].__str__;
	}

	override bool capable(){ return true; }
}


class Class: DataType{
	string name;
	Node[] code;
	ERROR errors;
	string file;
	string[] keys;
	Node[] inherit;
	DataType[string] heap;
	DataType[string] attributes;

	this(string name, Node[] inherit, Node[] code, DataType[string] heap, string[] keys, string file, ERROR errors){
		this.name = name;
		this.code = code;
		this.keys = keys;
		this.heap = heap;
		this.file = file;
		this.errors = errors;
		this.inherit = inherit;
		this.attributes = ["__name__": new String(name)];

		DataType[string] i;
		DataType obj;

		foreach(Node x; this.inherit){
			i = new Eval(x.params, this.heap, this.file, this.errors).hash;
			obj = i[x.str];

			i = new Eval(obj.__code__, obj.__heap__.dup, this.file, this.errors).hash;

			for(int a = 0; a < obj.__keys__.length; a++)
				this.attributes[obj.__keys__[a]] = i[obj.__keys__[a]];
		}

		i = new Eval(this.code, this.heap.dup, this.file, this.errors).hash;

		for(int a = 0; a < keys.length; a++)
			this.attributes[keys[a]] = i[keys[a]];
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType[string] __heap__(){
		return this.heap;
	}

	override Node[] __code__(){
		return this.code;
	}

	override string[] __keys__(){
		return this.keys;
	}

	override string __type__(){
		return this.name;
	}

	override DataType __call__(DataType[] params){
		return new Object_(this.name, this.inherit, this.code, this.heap, params, this.keys, this.file, this.errors);
	}

	override string __str__(){
		return this.name ~ " (type)";
	}

	override string __json__(){
		return this.name ~ " (type)";
	}
}


class Obj_: DataType{
	string repr;
	DataType[string] attributes;

	this(string repr, DataType[string] atts){
		this.repr = repr;
		this.attributes = atts;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return this.repr;
	}

	override string __json__(){
		return this.repr;
	}

	override string __type__(){
		return "object";
	}

	override bool capable(){ return true; }
}
