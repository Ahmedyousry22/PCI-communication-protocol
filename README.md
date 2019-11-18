# PCI-communication-protocol
This is modeling of the whole PCI communication protocol in verilog consisting of two main modules : 
1- Device
2- Arbiter

There are multiple instances of Device communicating with only one Arbiter.

The Arbiter operates in Priority mode.

For every Device, there is a special input called “force_request” for testing purposes. In the real world, every device will request the bus based on its type and what it needs from the bus. However, in the simulation,this input works as a trigger for the req output signal.  This way, we can trigger any request from any device as we want. If the “force_req” signal is asserted for one cycle, then the device will want the bus for one transaction. If it was asserted for two cycles, the device will want the bus for two different transactions and act accourdingly, and so on.
There is another signal for testing purposes too called “AddressToContact”. Whenever we assert the ”force_request” signal, we should also set the address of the target we want to communicate with using this signal. Each device has a unique address and  knows about its own address.



Every device have an internal memory of 10 rows. For simplicity, assume that when some device tries to write data into another target, it always starts putting data from the very top of this memory element. If the initiator device wants to have multiple data words per transaction, then the data it sends will be stored sequentially in the memory of the target device.
[First word in place 0 , second word in place 1, and so on]


The following scenario is modeled:

1- Device A requests the bus in order to communicate with device B and send 3 data words in the transaction. Assume that Device A always sends the word “AAAAAAAA”. So after this, we should have 3 rows of device B having the values “AAAAAAAA”.

2- Device B requests the bus in order to communicate with device A and send two data words.  Assume that device B always sends the word “BBBBBBBB”

3- Device C requests the bus for two transactions, and at the same time device A requests the bus again to communicate with Device C. What should happen here is as follows : 
The arbiter will grant device A since it has a higher priority, then device A will send two data words to device C.
The arbiter must then grant the bus to device C, C now wants to send data to device A, send one word.
Device C still wants the bus to communicate with device B, and send another data word to B. So it will have the bus for a second transaction since both A & B don’t request the bus any more.
