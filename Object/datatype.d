module Object.datatype;

import std.stdio;
import std.conv;
import std.uni;


import node;
import Object.boolean;


class DataType{
	DataType[] array;
	DataType[string] attributes;
	DataType OdyObject;

	double number(){
		return 0;
	}

	long number2(){
		return 0;
	}

	long num(){
		return 0;
	}

	DataType[string] attrs(){
		return attributes;
	}

	DataType[string] __heap__(){
		return attributes;
	}

	DataType __call__(DataType[] args){
		return new None();
	}

	DataType __index__(DataType[] args){
		return new None();
	}

	DataType __length__(){
		return new None();
	}

	DataType[] __array__(){
		return [];
	}

	DataType __iter__(int index){
		return new DataType();
	}

	DataType __fetch__(){
		return new DataType();
	}

	Node[] __code__(){
		return [];
	}

	string[] __keys__(){
		return [];
	}

	string __str__(){
		return "undef";
	}

	ulong[] __listrepr__(){
		return [];
	}

	byte[] __bytes__(){
		return [];
	}

	void __act__(DataType i){
	}

	string __type__(){
		return "null";
	}

	string __json__(){
		return "\"\"";
	}

	char[] __chars__(){
		return [];
	}

	bool capable(){
		return false;
	}
}

