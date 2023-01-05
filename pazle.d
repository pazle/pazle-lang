/*
	DMD64 D Compiler v2.100.0                  
	Copyright (C) 1999-2022 by The D Language Foundation, All Rights Reserved written by Walter Bright
*/


module wasp;

import std.stdio;
import std.file;
import std.array;
import std.conv;
import std.string;
import std.algorithm;

import node;
import lexer;
import shell;
import parser;
import config;

import Modules.console;

import Object.datatype;
import eval;


void tracebackConsole(Node trace){
	//writeln(trace.str);
	writeln("  File '", trace.str, "' at line ", trace.line);

	if(exists(trace.str)){
		File file = File(trace.str, "r");

		for(int i = 0; i < trace.line-1; i++)
			file.readln();

		writeln("    ", strip(file.readln));
		file.close();
	}
}


void Happened(Exception e, ERROR err) {
	string[] E = e.msg.split("||");

	if (E.length == 1)
		writeln("ERROR: ", e.msg);
	else
		writeln( E[0], ": ", E[1]);

	writeln("  File '", e.file, "' on line ", e.line);

	if (exists(e.file)){
		File file = File(e.file, "r");
		
		for(int i = 0; i < e.line-1; i++)
			file.readln();

		writeln("    ", strip(file.readln), '\n');
		file.close();
	}

	if(err.traceback.length)
		err.traceback = remove(err.traceback, err.traceback.length - 1);
		err.traceback = err.traceback.reverse;

	foreach(Node node; err.traceback)
		tracebackConsole(node);
}


void Start(string file, string code){
	ERROR errors = new ERROR();
	DataType[string] pl;

	try
		new Eval(new Parse(new Lex(code).tokens, file).ast, eval.HASHTABLE.dup, file, errors);
	catch (Exception e){
		Happened(e, errors);
	}
}


int CLI(string[] argv){
	return 1;
}


void dirOrfile(string fl){
	if (exists(fl))
		if(isDir(fl)){
			std.file.chdir(fl);
			string fl2 = "__init__.rn";

			if(exists(fl2))
				Start(fl2, readText(fl2));
			else
				writeln("rain: directory '"~fl~"' missing file '"~fl2~"'");
		} else
			Start(fl, readText(fl));
	else
		writeln("pazle: '"~ fl ~"' [Errno 2] No such file or directory");
} 


void main(string[] argv) {
	HASHTABLE = config.BUILTINS();
	IMPORTED_MODULES = config.IMPORTS(argv, eval.HASHTABLE);

	if (argv.length > 1){
		if (CLI(argv))
			dirOrfile(argv[1]);

	} else 
		shell.Shell();
}
