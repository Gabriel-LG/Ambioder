#include <stdio.h>

const char* header = 
"## SCL Builder Setup File: Do not edit!!\n"
"\n"
"## VERSION: X.BETA.RC6\n"
"## FORMAT:  v2.00.01\n"
"## DEVICE:  PIC16F684\n"
"\n"
"## PINREGACTIONS\n"
"cyc\n"
"No Repeat\n"
"RA3\n"
;

const char* footer = 
"--\n"
"&\n"
"## ADVPINREGACTIONS\n"
"--\n"
"&\n"
"--\n"
"COND1\n"
"Any\n"
"\n"
"\n"
"\n"
"0\n"
"cyc\n"
"\n"
"--\n"
"&\n"
"## CLOCK\n"
"&\n"
"## STIMULUSFILE\n"
"&\n"
"## RESPONSEFILE\n"
"&\n"
"## ASYNCH\n"
"&\n"
"## ADVANCEDSCL\n"
"\n"
"0\n"
"&\n"
;

int tick = 0;
int clock = 0;

void printBit(int bit)
{
  printf("--\n");
  printf("%d\n", clock);
  printf("%d\n", bit);
  clock += tick;
}
void printByte(int byte)
{
  printBit(0);

  int i;
  for(i=0; i<8; i++)
  {
    printBit( (byte & 0x01)?1:0 );
    byte >>= 1;
  }
  printBit(1);
}

int usage()
{
  fprintf(stderr, "\n");
  fprintf(stderr, "Generate a MPLAB X stimulus file, simulating bytes transmitted over ttl-uart (8n1)\n");
  fprintf(stderr, "Usage: rs232gen <bittime> <byte> [byte, byte, ...]\n");
  fprintf(stderr, "       bittime: the bittime in intruction cycles (decimal)\n");
  fprintf(stderr, "       byte   : a byte to transmit (hex)\n");
  return -1;
}


int main(int argc, const char** argv)
{
  int i;
  //check arguments
  if(argc < 3) return usage();
  if(sscanf(argv[1], "%d%c", &tick, &tick)!= 1) return usage();
  for(i=2; i< argc; i++)
  {
    int c = -1;
    if(sscanf(argv[i], "%02x%c", &c, &c)!= 1) return usage();
  }

  //generate header
  printf(header);

  //generate signals
  for(i=2; i< argc; i++)
  {
    int c = -1;
    sscanf(argv[i], "%02x%c", &c);
    printByte(c);
  }
  printBit(1);

  //generate footer
  printf(footer);

  return 0;

  //int c = getchar();
  //while(c != EOF)
  //{
  //  printByte(c);
  //  c = getchar();
  //}
}