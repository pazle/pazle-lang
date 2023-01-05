module Object.functions;

import std.stdio;
import std.conv;
import std.uni;

import node;
import eval;
import Object.datatype;
import Object.strings;


class Func: DataType{
	string name;
	Node[] code;
	ERROR errors;
	string file;
	string[] pars;
	DataType[] defaults;
	DataType[string] heap;
	DataType[string] attributes;

	this(string name, string[] pars, DataType[] defaults, Node[] code, DataType[string] heap, string file, ERROR errors){
		this.name = name;
		this.pars = pars;
		this.code = code;
		this.heap = heap;
		this.file = file;
		this.errors = errors;
		this.defaults = defaults;

		DataType repr__;

		if (this.name != "lambda")
			repr__ =  new String(this.name ~ " (method)");
		else
			repr__ =  new String(this.name ~ "(lambda method)");

		this.attributes = [
				"self": new DataType(),
				"__name__": new String(name),
				"__repr__": repr__,
			];
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override DataType __call__(DataType[] params = []){

		int Plen = cast(int)params.length;
		int Dlen = cast(int)this.defaults.length;

		if (Plen < this.pars.length) {
			int x = Plen;
			if (x > 0){ x--; }

			while (x < Dlen) {
				params ~= this.defaults[x];
				x++;
			}

			if (params.length < this.pars.length){
				string args;

				for(uint i = cast(uint)params.length; i < this.pars.length; i++)
					args ~= this.pars[i] ~ " ";

				Err = "MethodError||method '" ~ this.name ~ "' is missing arguments [ "~ args ~"]";
				throw new Exception(Err, this.heap["FN_LOC"].__array__[0].__str__, cast(int)this.heap["FN_LOC"].__array__[1].number2);
			}
		}


		DataType[string] hash = this.heap.dup;

		for (int i = 0; i < this.pars.length; i++)
			hash[this.pars[i]] = params[i];

		hash["self"] = this.attrs["self"];
		return new Eval(this.code, hash, this.file, this.errors).info["return"];
	}

	override string __type__(){
		return "function";
	}

	override string __str__(){
		return this.attributes["__repr__"].__str__;
	}

	override string __json__(){
		return this.attributes["__repr__"].__str__;
	}
}

