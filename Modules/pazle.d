module Modules.pazle;

import std.stdio;
import std.file;
import core.stdc.stdlib: exit;

import Modules.files: Reuseopenfile;

import Object.datatype;
import Object.strings;
import Object.boolean;
import Object.lists;


class Pazle: DataType{
	string[] argv;
	DataType[string] attributes;

	this(string[] argv){
		DataType[] argc;

		version(Windows){
			for(uint i = 1; i < argv.length; i++)
				argc ~= new String(argv[i]);
			
		} else {
			for(ulong i = 1; i < argv.length; i++)
				argc ~= new String(argv[i]);
			
		}

		this.attributes = [
							"kill": new Kill(),						
							"argv": new List(argc),
							"bin": new String(thisExePath),

							"stdin": new Reuseopenfile(stdin, "stdout", "w+"),
							"stdout": new Reuseopenfile(stdout, "stdout", "w+"),
							"stderr": new Reuseopenfile(stderr, "stdorr", "w+"),

							"path": new List([new String(""), new String(getcwd())]),

							"version": new String("0.0.1 [Sept 18 2022] - [DMD64 2.100.0]"),
							"platform": new _Platform(),
							"architecture": new _Arch(),
							"win32": new _Win32(),
						];
	}
	
	override DataType[string] attrs() {
		return this.attributes;
	}

	override string __str__() { return "pazle (builtin module)";}
}


class Kill: DataType{
	override DataType __call__(DataType[] params){
		exit(0);

		return new None();
	}
	override string __str__() {return "kill (pazle method)"; }
}


class Stdin: DataType{
	override DataType __call__(DataType[] params){
		return new None();
	}
	override string __str__() {return "stdin (pazle method)"; }
}


class Stderr: DataType{
	override DataType __call__(DataType[] params){
		return new None();
	}
	override string __str__() {return "stderr (pazle method)"; }
}


class _Win32: DataType{
	override DataType __call__(DataType[] params){
		string plat = "not windows OS";

		version (Win32){
			plat = "win32";

		} version (Win64){
			plat = "win64";

		}

		return new String(plat);
	}
	override string __str__() {return "win32 (pazle method)"; }
}


class _Arch: DataType{
	override DataType __call__(DataType[] params){
		string plat = "not_found";

		version (X86){
			plat = "x86";

		} version (x86_64){
			plat = "x86_64";

		} version (ARM){
			plat = "arm";

		}

		return new String(plat);
	}
	override string __str__() {return "architecture (pazle method)"; }
}


class _Platform: DataType{
	override DataType __call__(DataType[] params){
		string plat = "not_found";

		version (Windows){
			plat = "windows";

		} version (linux){
			plat = "linux";

		} version (FreeBSD){
			plat = "freeBSD";

		} version (OpenBSD){
			plat = "openBSD";

		} version (NetBSD){
			plat = "netBSD";

		} version (DragonFlyBSD){
			plat = "dragonFlyBSD";

		} version (FreeBSD){
			plat = "freeBSD";

		} version (BSD){
			plat = "BSD";

		} version (OSX){
			plat = "OSX";

		} version (IOS){
			plat = "iOS";

		} version (Android){
			plat = "android";

		} version (Solaris){
			plat = "solaris";

		}

		return new String(plat);
	}
	override string __str__() {return "platform (pazle method)"; }
}

