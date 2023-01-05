module Modules.locals;


import Object.datatype, Object.strings, Object.boolean, Object.lists;


class Locals: DataType {
	DataType[string] attributes;

	this(){
		this.attributes = [
			"call": new lCall(),
			"fn_call": new lCall_fn(),
		];
	}
	
	override DataType[string] attrs() { return this.attributes; }

	override string __str__() { return "locals (builtin module)";}
}


class lCall_fn: DataType{
	override DataType __call__(DataType[] params) {
		DataType[] ret_values;

		foreach(i; params[0].__array__){
			ret_values ~= i.attrs[params[1].__str__].__call__(params[2].__array__);
		}

		return new List(ret_values);
	}

	override string __str__() { return "fn_call (locals method)";}
}


class lCall: DataType{
	override DataType __call__(DataType[] params) {
		DataType[] ret_values;

		foreach(i; params[0].__array__){
			ret_values ~= i.__call__(params[1].__array__);
		}

		return new List(ret_values);
	}

	override string __str__() { return "call (locals method)";}
}
