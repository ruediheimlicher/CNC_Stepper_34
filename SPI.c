#define TIMEOUTRELOAD 150

unsigned char receive_counter;
unsigned char receive_permission;    // We do not want to receive data while we did not send our answer
                           // So the master will get a timeout and knows we are busy
unsigned char receive_length;      // the expected receive length
unsigned char receive _command;      // the received command (not the handled)
unsigned char receive_data[20];      // the received databytes in a buffer
unsigned char RUN_command;         // 

         
ISR(SPI_STC_vect) { // The interrupt service routine for spi data transfer complete
   unsigned char spi_data = 0, i;
   unsigned char wfn = 0; // wait for next 1=true 0=false                 
   spi_data = SPDR;   // read the transfer byte        
   if (!receive_permission) { // last command done?
      switch (receive_counter) { // whitch byte do we receive
         case 0: // A new byte is received
            if (spi_data == 0x92) { // in ths case 0xFF 0x42 was the start frame
               receive_csum = 0; // chacksum will be calculated at the end of the interrupt service
               wfn = 1; // Frame was correct, so we wait for the next byte
            } else wfn = 0; // if the frame was not correct we start here again next round
            break;
         case 1: // Next byte must be 0x00
            if (spi_data == 0) wfn = 1; // To be true 0xFF 0x42 0x00 was the frame ;)
            else wfn = 0; // If the byte wasn't 0x00 the frame is damaged and so we wait for a new frame
            break;
         case 2: // next byte is the length info in this case must be between 1 and 10
            if (4 < spi_data && spi_data <= 10) {
               receive_length = spi_data ; // we save the expected length in a global var
               receive_length--; // we allready received one byte after the frame: the length
               wfn = 1; // wfn should be clear from now on-
               } else wfn = 0;
            break;
         case 3: // the next byte should be the command (start 0x01=blinking, 0x03= update display, 0x66=selfdestruct ;)
            receive_command = uart_data; //We save the command for command handling in a global
            wfn = 1;
            break;
      }
      if (3 < receive_counter) { // ok every next byte comes in the data buffer
         if (receive_counter != receive_length) { // as long as new bytes are awaited
            receive_data [receive_counter-4] = uart_data; // receive counter is 4 when it first comes here bit buffer no should be 0
            wfn = 1;
         }
         else { // esle the received byte must be the last and therefore the checksum
            if (receive_csum == uart_data) { // Is the checksum correct?
                  RUN_command = receive_command;   // yes then give received command to command handling
                  receive_permission = 1; // do not receive till the command is execuded
            } else wfn = 0; // if checksum is incorrect, the received bytes were damaged
         }
      }
      switch (wfn) { // Wait for the next protocol byte?
         case 0: // no await the first again
            receive_toutcount    = 0; // timeout counter is dont care now
            receive_counter    = 0; // next byte awaited is 0
            break;
         case 1: // Everything ok,
            receive_toutcount    = TIMEOUTRELOAD ; // reload the timeout counter
            receive_counter++; // next byte awaited
            receive_csum ^=uart_data; // add this byte to the checksum
            break;
      }
   }
}

ISR(TIMER0_COMP_vect) {
   if (receive_counter =! 0) {
      if (!receive_toutcount--) { //If a timeout occours receive_toutcount == 0
         receive_counter    = 0; // reset receive counter
      }
      

int main() {
//
while(1) {
   if (RUN_command != 0x00) { //If a command to handle is received
      switch (RUN_command) {
         case 0x01: // Start blinking
            // Start blinking here
            break;
         case 0x03: // update display
            // update display here
            break;
         case 0x66: // Self destruct
            InitiateSelfDestruct();
            break;
         default:
            // No command handling for this command
      }
   receive_permission = 0: // We can allow new received commands and data
       RUN_command = 0x00 // Very important!!!
  }
   // as long as no command is recived the Contoller can work on his other dutys!
}
