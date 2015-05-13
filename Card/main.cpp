/*
Copyright (c) 2011, Gerhard H. Schalk (www.smartcard-magic.net)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/
#include <conio.h>
#include <stdio.h>
#include "pcsc.h"
#include "util.h"
#include "clessCardType.h"
#include "clientWebS.h"

int main(int argc, char* argv[])
{
	char* machinName = argv[1];
	// Get Data: CLA = 0xFF, INS = 0xCA, P1 = 0x00, P2 = 0x00, Le = 0x00
	// {CLA,INS,P1,P2}
	BYTE baCmdApduGetData[] = { 0xFF, 0xCA, 0x00, 0x00, 0x00 };

	BYTE baResponseApdu[300];
	DWORD lResponseApduLen = 0;

	BYTE atr[40];
	INT	 atrLength;
	LONG lRetValue;

	unsigned int loop;
	int option;

	system("cls");
	printf("PCSC API Example - Read Card Serial Number (UID)...\n\n");

	lRetValue = PCSC_Connect(NULL);
	PCSC_EXIT_ON_ERROR(lRetValue);
	do{
		do{
			lRetValue = PCSC_WaitForCardPresent();
		} while (lRetValue != 0);

		lRetValue = PCSC_ActivateCard();
		PCSC_EXIT_ON_ERROR(lRetValue);

		lRetValue = PCSC_GetAtrString(atr, &atrLength);
		PCSC_EXIT_ON_ERROR(lRetValue);

		// Send pseudo APDU to retrieve the card serical number (UID)
		PCSC_Exchange(baCmdApduGetData, (DWORD)sizeof(baCmdApduGetData), baResponseApdu, &lResponseApduLen);
		PCSC_EXIT_ON_ERROR(lRetValue);

		// Verify if status word SW1SW2 is equal 0x9000.
		if (baResponseApdu[lResponseApduLen - 2] == 0x90 &&
			baResponseApdu[lResponseApduLen - 1] == 0x00)
		{
			// Contactless card detected.
			// Retrieve the card serical number (UID) form the response APDU.
			printHexString("Card Serial Number (UID): 0x", baResponseApdu, lResponseApduLen - 2);


			printf("Choose option : (1) Save card ID, (2) Save lap, (3) quit");
			scanf("%d", &option);

			if (option == 1)
			{
				char* etuId;
				scanf("%s", &etuId);
				saveCardID((char*)baResponseApdu, etuId);
			}
			else if (option == 2)
			{
				saveLapDateTime((char*)baResponseApdu, machinName);
			}
		}
	} while (option != 3);



	//lRetValue = PCSC_WaitForCardRemoval();

	PCSC_Disconnect();

	printf("\n");
	getchar();
	return 0;
}
