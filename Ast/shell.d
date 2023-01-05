module shell;


import std.uni;
import std.file;
import std.stdio;
import std.string;
import std.algorithm;

import eval;
import node;
import lexer;
import parser;

import Object.datatype;
import Object.strings;
import Object.boolean;


void Space(int x){
	for(int i = 0; i < x; i++){
		write(' ');
	}
}


int count = 1;
int spaces = 4;
string check, multi;
string code;

void sadolin(){
	version(linux){
		write("\n\x1b[32mpazle>\x1b[m ");
	} else {
		write("\npazle> ");
	}
}

string Code() {
	sadolin();
	code = chomp(readln());
	check = code.replace(" ", "").replace("\t", "");

	if (check.length) {
		if (check[check.length-1] == '{') {
			code ~= '\n';

			while (count) {
				Space(spaces);
				multi = chomp(readln());
				check = multi.replace(" ", "").replace("\t", "");

				if (check.length){
					if (check[check.length-1] == '}'){
						count -= 1;
						spaces -= 4;

					} else if (check[check.length-1] == '{'){
						count += 1;
						spaces += 4;
					}
					code ~= multi ~ '\n';
				}
			}
			count = 1;
			spaces = 4;
		}
	}
	
	return code;
}


void Shell(){
	DataType[string] pl;
	ERROR errors = new ERROR();

	while (true){
		code = Code();

		try 
			pl = new Eval(new Parse(new Lex(code).tokens, "stdin").ast, eval.HASHTABLE, "stdin", errors).hash;

		catch (Exception e) {
			writeln("Traceback [most recent cmd]");
			Node i;
			i = errors.traceback[errors.traceback.length - 1];

			writeln("   ", code);
			writeln();

			string[] E = e.msg.split("||");

			if (E.length == 1)
				writeln("ERROR: ", e.msg);
			else
				writeln("ERROR: ", E[0], ": ", E[1]);
		}
	}
}


