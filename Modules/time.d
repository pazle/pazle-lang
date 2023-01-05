module Modules.time;

import std.uni;
import std.conv;
import std.stdio;
import std.string;
import std.algorithm;

import core.time;
import core.stdc.time;
import std.datetime;
import core.thread;

import Object.classes;
import Object.strings;
import Object.numbers;
import Object.boolean;
import Object.datatype;


// function adds zeros to mins, secs and hrs incase the are less than 10
string[] MHS(SysTime ct){
    string seconds = to!string(ct.second);
    string minutes = to!string(ct.minute);
    string hours = to!string(ct.hour);

    if(ct.hour < 10)
        hours = '0'~hours;

    if(ct.minute < 10)
        minutes = '0'~minutes;

    if(ct.second < 10)
        seconds = '0'~seconds;

    return [seconds, minutes, hours];
}


// Returns current date
class Now: DataType{
    override DataType __call__(DataType[] params){
        auto ct = Clock.currTime();

        string[] mhs = MHS(ct);

        string now = capitalize(to!string(ct.dayOfWeek)) ~ " " ~ to!string(ct.day) ~ " " ~ capitalize(to!string(ct.month)) ~ " " ~ mhs[2] ~ ":" ~ mhs[1] ~ ":" ~ mhs[0] ~ " " ~ to!string(ct.year);

        return new String(now);
    }

    override string __str__() { return "now (time method)"; }
}


// pause current thread fro specified time 
class Sleep: DataType{
    override DataType __call__(DataType[] params){
        Thread.getThis().sleep(dur!"msecs"(params[0].number2));
        return new Number(0);
    }

    override string __str__() { return "sleep (time method)"; }
}


// Returns Date object
class Date: DataType{
    override DataType __call__(DataType[] params){
        
        SysTime dt = Clock.currTime();

        // getting micro mill and nano seconds
        auto frac = dt.fracSecs.split();

        string[] mhs = MHS(dt);

        // format to represent the object
        string repr = capitalize(to!string(dt.dayOfWeek)) ~ " " ~ to!string(dt.day) ~ " " ~ capitalize(to!string(dt.month)) ~ " " ~ mhs[2] ~ ":" ~ mhs[1] ~ ":" ~ mhs[0] ~ " " ~ to!string(dt.year);

        return new Obj_(repr, [
                    "day": new Number(dt.day),
                    "week_day": new Number(dt.dayOfWeek),
                    "year_day": new Number(dt.dayOfYear),

                    "hour": new Number(dt.hour),
                    "minutes": new Number(dt.minute),
                    "seconds": new Number(dt.second),

                    "month": new Number(dt.month),
                    "year": new Number(dt.year),

                    "milli_seconds": new Number(frac.msecs),
                    "micro_seconds": new Number(frac.usecs),
                    "nano_seconds": new Number(frac.hnsecs),

                    "is_leap": bool_sort(dt.isLeapYear),
                ]);
    }

    override string __str__() { return "Date (time object)"; }
}


// returns timestamp since epoch
class Epoch: DataType{
    override DataType __call__(DataType[] params){
        auto st = Clock.currTime();
        string epo = to!string(st.toUnixTime()) ~ '.' ~ to!string(st.fracSecs.total!"hnsecs");

        return new Number(to!double(epo));
    }

    override string __str__() { return "epoch (time method)"; }
}


// time module object
class Time: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "now": new Now(),
            "epoch": new Epoch(),
            "sleep": new Sleep(),
            "Date": new Date(),
        ];
    }

    override DataType[string] attrs() { return this.attributes; }
    override string __str__() { return "time (builtin module)"; }
}

