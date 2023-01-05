module Modules.thread;

import std.stdio;
import std.file;
import core.thread;
import std.concurrency;

import Object.datatype;
import Object.strings;
import Object.boolean;
import Object.lists;



DataType[string] hash;


class Threads: DataType{
	DataType[string] hash_T;
	DataType[string] attributes;

	this(DataType[string] hash_T){
		hash = hash_T;

		this.attributes = [
			"thread": new Newthread(),
			"fibre": new Newfibre(),
		];
	}
	
	override DataType[string] attrs() { return this.attributes; }
	override string __str__() { return "Thread (thread object)";}
}



class Newthread: DataType{
	override DataType __call__(DataType[] params){
		Thread _pthread;

		if (params.length > 1){
			auto TiD = new Thread({ params[0].__call__(params[1].__array__); });
			TiD.start();
		}
		
		return new None();
	}
	override string __str__() {return "thread (Thread function)"; }
}



class Newfibre: DataType{
	override DataType __call__(DataType[] params){

		auto composed = new Fiber({
			params[0].__call__([]);
		});

		composed.call();

		return new None();
	}
	override string __str__() {return "fibre (Thread function)"; }
}

