module config;


import std.stdio;
import std.file;
import std.path;
import std.array;
import std.algorithm;

import eval;
import lexer;
import parser;

import Object.datatype;
import Object.strings;
import Object.boolean;
import Object.lists;
import Object.numbers;



// CHECKS FOR MODULE EXISTANCE
string check(DataType path, string flname, DataType[string] importedModules){
	if (exists(flname))
		return flname;

	else if (flname in importedModules)
		return flname;

	string full = flname ~ ".pz";
	string fl;

	if (!exists(full)) {
		foreach(DataType i; path.__array__){
			fl = i.__str__ ~ '/' ~ full;

			if (exists(fl))
				return fl;

			fl = i.__str__ ~ '/' ~ flname;

			if (exists(fl))
				return fl;
		}
		return "";
	}
	return full;
}


class Module: DataType{
	string name;

	this(DataType[string] attributes, string name){
		this.name = name;
	}

	override string __type__(){ return this.name; }

	override string __str__(){ return this.name~" (module)"; }
}


DataType act(Eval Translator, string flname, string name, DataType[string] IMPORTED_MODULES){
	DataType[string] hash = eval.HASHTABLE.dup;
	string splat;

	if (flname in IMPORTED_MODULES)
		return IMPORTED_MODULES[flname];

	else if (isDir(flname)){
		foreach(string i; dirEntries(flname, SpanMode.shallow)){
			if (endsWith(i, ".pz")) {
				splat = baseName(stripExtension(i));

				if (i != Translator.file)
					hash[splat] = act(Translator, i, splat, IMPORTED_MODULES);

			} else if (isDir(i)) {
				splat = baseName(stripExtension(i));
				hash[splat] = act(Translator, i, splat, IMPORTED_MODULES);
			}
		}

		return new Module(hash, name);
	}

	string code;
	File script = File(flname, "pz");

	while (!script.eof()){ code ~= script.readln(); }
	script.close();

	DataType[string] LIB = new Eval(new Parse(new Lex(code).tokens, flname).ast, hash, flname, Translator.errors).hash;

	DataType lib = new Module(LIB, name);
	IMPORTED_MODULES[flname] = lib;

	return lib;
}


void Include(string filename, Eval Translator){
	string code;
	File script = File(filename, "pz");

	while (!script.eof()){ code ~= script.readln(); }
	script.close();


	new Eval(new Parse(new Lex(code).tokens, filename).ast, Translator.hash, filename, Translator.errors);
}


import Modules.pazle, Modules.math, Modules.base64;
import Modules.time, Modules.files, Modules.random, Modules.socket;

import Modules.net, Modules.process, Modules.path, Modules.thread;
import Modules.console, Modules.json, Modules.string, Modules.exceptions;

import Modules.parallel, Modules.locals, Modules.arrays, Modules.dicts;


DataType[string] IMPORTS(string[] argv, DataType[string] hashref) {
	return [
		"math": new Math(),
		"file": new Files(),
		"path": new Paths(),
		"JSON": new JSON(),
		"console": new Console(),
		"random": new Random(),
		"strings": new StringM(),
		"socket": new Sockets(),
		"pazle": new Pazle(argv),
		"net": new Net(),
		"threads": new Threads(hashref),
		"process": new Process(),
		"exceptions": new Modules.exceptions.Catch(),

		"parallelism": new Parallel(),

		"time": new Time(),
		"dicts": new Dicts_(),
		
		"locals": new Locals(),
		"base64": new Base64_(),
		"arrays": new Arrays_(),
	];
}



DataType[string] BUILTINS(){
	return [
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

		"delattr": new DelAttr(),
		"getattr": new GetAttr(),
		"setattr": new SetAttr(),

		"string": new Stringed(),
		"number": new Numbered(),
		"array": new Arrayed(),
		"bytes": new Byted(),

		"FN_LOC": new List([new String(""), new Number(1)]),
	];
}

