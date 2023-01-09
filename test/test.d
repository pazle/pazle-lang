import std.stdio;


class Test {
    int x;
    string y;

    this(){
        this.x = 1;
        this.y = "str";
    }
}


void main(){
    Test x = new Test();

    int v = 0;

    while (v < 1000000){
        writeln(x.x == 1);
        v++;
    }
}

