module Device(force_request,AddressToContact,AD,irdy,trdy,rq,gnt,clk,frame,devsel,devadd,indata,nm_transaction,c_be,rd,wr,Byte_enable,number_words);
inout irdy,trdy,devsel;
input [3:0] Byte_enable;
input rd,wr;
input[3:0] number_words;
reg[3:0] n2=0;
input[3:0] nm_transaction;
input[31:0]devadd;
input [31:0] indata;
inout rq;
reg Devsel=1'bz;
assign devsel=Devsel;
reg read_slave=0;
reg[3:0] pointer=0;
reg[3:0] pointer1=0;
inout gnt;
reg Trdy=1'bz;
input clk;
reg[3:0] n=4'b0000;
inout frame;
assign trdy=Trdy;
inout [3:0] c_be;
reg [3:0]C_be=4'bzzzz;
assign c_be=C_be;
reg stop=1;
inout [31:0] AD;
input [31:0] AddressToContact;
input force_request;
reg [31:0] Data=32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
reg ok=1 ;
reg Rq=1'bz,Frame=1'bz,Irdy=1'bz;
reg x=1;
assign rq=Rq;
assign irdy=Irdy;
assign frame=Frame;
reg write_slave=0;
reg[31:0] mem[0:9];
assign AD=Data;
reg[7:0] A;

reg[7:0] B;

reg[7:0] C;

reg[7:0] D;

always@(posedge  clk)
begin
if(Frame==1&&frame===1'bx)
begin
Frame=1'bz;
Data=32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
C_be=4'bzzzz;
end
end
always@(posedge clk,negedge  clk)
begin
if(trdy===1'bx&&Devsel==1&&Trdy==1)
begin
Trdy=1'bz;
end
if(irdy===1'bx&&Irdy==1)
begin
Irdy=1'bz;
end
if(Devsel==1&&devsel===1'bx)
begin
Devsel=1'bz;
end

end
always@(posedge clk)
begin
if(AD==devadd)//slave
begin
  @(negedge clk)
Devsel=0;
Trdy=0;
write_slave=1;
read_slave=1;
end
end
always@(posedge clk)
begin
if(ok==1)
begin
Data=32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
end
end
always@(nm_transaction)
begin
n=0;
x=1;
pointer=0;

end
always@(posedge clk)
begin

if(trdy==0&&devsel==0&&Frame==0&&rq==0&&rd==0&&wr==1)
begin
stop=1;

 @(negedge clk)
 Irdy=0;

end else if(trdy==0&&devsel==0&&Frame==0&&rq==0)
begin
 @(negedge clk)
stop=1;
 Irdy=0;
end
if(Frame==1&&Irdy==0&&wr==0&&rd==1)
begin
 @(negedge clk)
 Irdy=1;
end

if(Frame==1&&Irdy==0&&rd==0&&wr==1)
begin

 Irdy=1;
end
if(gnt==1&&frame==1&&Trdy==0&&wr==0&&rd==1)
begin
@(negedge clk)
Devsel=1;
Trdy=1;
write_slave=0;
end 

end
always@(posedge clk)
begin
if(frame===1'bz&&rq==0)
begin
@(negedge clk)
Frame=1;
end
if(frame===1'bz&&rq==0&&rd==0&&wr==1)
begin
Frame=1;
end
end
always@(AddressToContact)
begin
if(rq==0&&Frame==0&&devsel==0&&AddressToContact!==32'hzzzz_zzzz&&rd==1&&wr==0)
begin
stop=0;
 @(negedge clk)
Irdy=1;
  ok=0;
  Data=AddressToContact;
end
if(rq==0&&Frame==0&&devsel==0&&AddressToContact!==32'hzzzz_zzzz&&rd==0&&wr==1)
begin
 @(negedge clk)
Irdy=1;
stop=0;
  Data=AddressToContact;
#10
 Data=32'hzzzz_zzzz;
end
end
always@(posedge clk)
begin
if(irdy==1&&Devsel==0&&gnt==1&&Trdy==0&&Irdy===1'bz&&frame==1)
begin
read_slave=0;
@(negedge clk)
Devsel=1;
Trdy=1;
end

end
always@(posedge clk)
begin
if(rq==0&&gnt==0&&frame==1&&irdy==1&&rd==1&&wr==0)
begin
   @(negedge clk)
  ok=0;
  Frame=0;
 C_be=4'b1010;
  Data=AddressToContact;
end
if(Trdy===1'bz||(Devsel==1&&Trdy==1&&rq==1&&gnt==1&&Irdy===1'bz&&Frame===1'bz&&devsel==1&&irdy==1&&trdy==1&&c_be===4'bzzzz))
begin
@(negedge clk)
begin
pointer1=0;
end
end
if(rq==0&&gnt==0&&frame==1&&irdy==1&&rd==0&&wr==1)
begin
   @(negedge clk)
  ok=0;
  Frame=0;
 C_be=4'b1111;
  Data=AddressToContact;
#10
Data=32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
end
end
always@(posedge clk)
begin
if(Frame==1&&n==nm_transaction&&wr==0&&rd==1)
begin
@(negedge clk)
 Rq=1;
 ok=1;
C_be=4'bzzzz;
pointer=0;
end 
else if(n!=nm_transaction&&wr==0&&rd==1)
begin
@(negedge clk)
Rq=force_request;
end
end
always@(posedge clk)
begin
if(Frame==1&&n==nm_transaction&&wr==1&&rd==0)
begin
Rq=1;
@(negedge clk)
 ok=1;
C_be=4'bzzzz;
end 
else if(n!=nm_transaction&&wr==1&&rd==0)
begin
@(negedge clk)
Rq=force_request;
end
end
always@(posedge clk)
begin
if(n==nm_transaction&&x==1&&rd==1&&wr==0)
begin
@(negedge clk)
Frame=1;
x=0;
pointer=0;
end else if(x==0&&rq==1)
begin
@(negedge clk)
Frame=1'bz;
end
else if(Frame==0&&irdy==0&&trdy==0&&devsel==0&&rq==0&&wr==0&&rd==1&&Irdy==0&&stop==1&&n2!=number_words)//write master
begin
 @(negedge clk)
 n2=n2+4'b0001;
 C_be=Byte_enable;
 Data=indata;
#14
Data=32'hzzzz_zzzz;
 end
end
always@(posedge clk)
begin
if(n2==number_words)
begin
n=n+1;
n2=0;
Frame=1;
end

end
always@(posedge clk)
begin
#1
 if(devsel==0&&trdy==0&&irdy==0&&c_be==4'b1111&&Trdy==0&&read_slave==1&&frame==0)//read slave 
begin
@(negedge clk)
ok=0;
Data=mem[pointer1];
pointer1=pointer1+4'b0001;
#14
Data=32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;

end

end

always@(posedge clk)
begin
if(devsel==0&&Trdy==0&&irdy==0&&AD!=devadd&&write_slave==1&&c_be!=4'b1111&&AD!==32'hzzzz_zzzz)//write slave
begin
 A=AD[7:0];
 B=AD[15:8];
C=AD[23:16];
 D=AD[31:24];
@(negedge clk)
case(c_be)
4'b0000: mem[pointer1]=AD;
4'b0001:  mem[pointer1]={8'bxxxx_xxxx,8'bxxxx_xxxx,8'bxxxx_xxxx,A};
4'b0010:  mem[pointer1]={8'bxxxx_xxxx,8'bxxxx_xxxx,B,8'bxxxx_xxxx};
4'b0011:  mem[pointer1]={8'bxxxx_xxxx,8'bxxxx_xxxx,B,A};
4'b0100:  mem[pointer1]={8'bxxxx_xxxx,C,8'bxxxx_xxxx,8'bxxxx_xxxx};
4'b0101:  mem[pointer1]={8'bxxxx_xxxx,C,8'bxxxx_xxxx,A};
4'b0110:  mem[pointer1]={8'bxxxx_xxxx,C,B,8'bxxxx_xxxx};
4'b0111:  mem[pointer1]={8'bxxxx_xxxx,C,B,A};
4'b1000:  mem[pointer1]={D,8'bxxxx_xxxx,8'bxxxx_xxxx,8'bxxxx_xxxx};
4'b1001:  mem[pointer1]={D,8'bxxxx_xxxx,8'bxxxx_xxxx,A};
4'b1010:  mem[pointer1]={D,8'bxxxx_xxxx,B,8'bxxxx_xxxx};
4'b1011:  mem[pointer1]={D,8'bxxxx_xxxx,B,A};
4'b1100:  mem[pointer1]={D,C,8'bxxxx_xxxx,8'bxxxx_xxxx};
4'b1101:  mem[pointer1]={D,C,8'bxxxx_xxxx,A};
4'b1110:  mem[pointer1]={D,C,B,8'bxxxx_xxxx};
4'b1111:  mem[pointer1]={D,C,B,A};
endcase
pointer1=pointer1+4'b0001;
end
end

always@(posedge clk)
begin
if(n==nm_transaction&&x==1&&rd==0&&wr==1)
begin
Frame=1;
x=0;
end
else if(Frame==0&&irdy==0&&trdy==0&&devsel==0&&rq==0&&AD!==AddressToContact&&rd==0&&wr==1&&AD!==32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz&&stop==1&&c_be==4'b1111&&n2!=number_words)//read master
begin
 @(negedge clk)
 n2=n2+4'b0001;
 mem[pointer]=AD;
pointer=pointer+1;
 end
 
end
endmodule
module arbitre(rq,gnt,priority0,priority1,priority2,priority3,priority4,frame,irdy,clk);
inout [4:0] gnt;
input[4:0] rq;
input[4:0]priority0,priority1,priority2,priority3,priority4;
input frame,irdy,clk;
reg [4:0] Gnt=5'bzzzzz;
reg[4:0] max=0;

assign gnt[0]=Gnt[0];
assign gnt[1]=Gnt[1];
assign gnt[2]=Gnt[2];
assign gnt[3]=Gnt[3];
assign gnt[4]=Gnt[4];
reg pass=0;
reg[4:0] nmax=5'bxxxxx;
reg [4:0]max2[4:0];
always@(posedge clk)
begin
if(rq[0]==0)
begin
if(priority0>max&&frame==1&&irdy==1)
begin
max=priority0;
nmax=5'b00000;
max2[0]=priority0;
end
end

if(rq[1]==0&&frame==1&&irdy==1)
begin
if(priority1>max)
begin
max=priority1;
nmax=5'b00001;
max2[1]=priority1;
end
end
if(rq[2]==0)
begin
if(priority2>max&&frame==1&&irdy==1)
begin
max=priority2;
nmax=5'b00010;
max2[2]=priority2;
end
end
if(rq[3]==0)
begin
if(priority3>max&&frame==1&&irdy==1)
begin
max=priority3;
nmax=5'b00011;
max2[3]=priority3;
end
end

if(rq[4]==0)
begin
if(priority4>max&&frame==1&&irdy==1)
begin
max=priority4;
nmax=5'b00100;
max2[4]=priority4;
end
end
end
always@(posedge clk)
begin
if(pass==0&&nmax!==5'bxxxxx&&frame==1&&irdy==1&&nmax!==5'bzzzzz)
@(negedge clk)
begin
Gnt[0]=1;
Gnt[1]=1;
Gnt[2]=1;
Gnt[3]=1;
Gnt[4]=1;
Gnt[nmax]=0;
pass=1;
end
end
always@(posedge clk)
begin
if(frame==0&&(gnt[0]==0||gnt[1]==0||gnt[2]==0||gnt[3]==0||gnt[4]==0))
begin
@(negedge clk)
Gnt[nmax]=1;
pass=0;
max=0;
nmax=5'bzzzzz;
end
if(rq[nmax]==1&&max2[nmax]==max)
begin
Gnt[nmax]=1;
pass=0;
max=0;
max2[nmax]=0;
nmax=5'bzzzzz;
end
end
endmodule

module pci_tb();
reg clk=0,Force_requesta,Force_requestb,Force_requestc,Force_requestd;
reg[31:0] addressToContacta,addressToContactb,addressToContactc,addressToContactd;
wire irdy,trdy,rqa,rqb,rqc,rqd,frame,devsel,force_requesta,force_requestb,force_requestc,force_requestd;
wire [3:0]c_be;
reg [3:0]Byte_enablea,Byte_enableb,Byte_enablec,Byte_enabled;
wire[31:0]AddressToContacta,AddressToContactb,AddressToContactc,AddressToContactd;
reg Irdy,Trdy,Frame,Devsel;
assign irdy=Irdy;
assign trdy=Trdy;
assign frame=Frame;
assign devsel=Devsel;
wire [4:0] gnt;
reg [4:0] rq;
  
reg[4:0] priority0,priority1,priority2,priority3;
assign force_requesta=Force_requesta;
assign force_requestb=Force_requestb;
assign force_requestc=Force_requestc;
assign force_requestd=Force_requestd;
assign AddressToContacta=addressToContacta;
assign AddressToContactb=addressToContactb;
assign AddressToContactc=addressToContactc;
assign AddressToContactd=addressToContactd;
wire[31:0] indata_a,indata_c,indata_b,indata_d,devadd_a,devadd_b,devadd_c,devadd_d;
reg [31:0] maska,maskda,maskc,maskdb,maskdc,maskb,maskd,maskdd;
assign indata_a=maska;
assign indata_b=maskb;
assign indata_c=maskc;
assign devadd_a=maskda;
assign devadd_b=maskdb;
assign devadd_c=maskdc;
assign devadd_d=maskdd;
reg[3:0] number_wordsa,number_wordsb,number_wordsc,number_wordsd;
wire[31:0] AD;
reg [31:0] ad;
assign AD=ad;
reg rdp,wrp;
reg[3:0] nm_transactiona,nm_transactionc,nm_transactionb,nm_transactiond;
reg rda,wra,rdc,wrc,rdd,wrd;
always
begin
#5
clk=!clk;
end
always@(rqa,rqb,rqc,rqd)
begin
rq[0]=rqa;
 rq[1]=rqb;
 rq[2]=rqc;
rq[3]=rqd;
end
initial
begin
number_wordsa=2;
number_wordsb=2;
number_wordsc=1;
number_wordsd=2;
maskb=1;
ad=32'hzzzz_zzzz;
Force_requesta=0;
addressToContacta=32'b1111_0100_1111_0100_1111_0100_1111_0100;
addressToContactb=32'b1111_0000_1111_0000_1111_0000_1111_0000;
maskb=32'hBBBBBBBB;

nm_transactionb=2;
 priority0=3;
priority1=2;
priority2=1;
priority3=4;
nm_transactiona=4'b0011;
nm_transactionc=4'b0010;
nm_transactiond=4'b0010;
rdc=1'b0;
wrc=1'b1;
rda=1'b1;
wra=1'b0;
rdp=1'b1;
wrp=1'b0;
rdd=0;
wrd=1;
Irdy=1'b1;
Trdy=1'b1;
Frame=1'b1;
Devsel=1'b1;
maska=32'hAAAA_AAAA;
maskc=32'hCCCC_CCCC;
maskda=32'b1111_0000_1111_0000_1111_0000_1111_0000;
maskdb=32'b1111_0100_1111_0100_1111_0100_1111_0100;
maskdc=32'b1111_0101_1111_0101_1111_0101_1111_0101;
maskdd=32'b1111_0111_1111_0111_1111_0111_1111_1111;
Force_requestb=0;
#40
Trdy=1'bz;
Frame=1'bz;
Devsel=1'bz;
Byte_enablea=4'b0000;
Byte_enableb=4'b0000;
Byte_enablec=4'b0000;
#10
Irdy=1'bz;
#10
Byte_enablea=4'b0001;
#20
Byte_enablea=4'b0010;
#50
Byte_enablea=4'b0100;
#240
Byte_enablea=4'b0000;
Force_requestd=0;
addressToContactd=32'b1111_0100_1111_0100_1111_0100_1111_0100;
#10
Force_requestc=0;
addressToContactc=32'b1111_0000_1111_0000_1111_0000_1111_0000;
#350
addressToContactc=32'b1111_0100_1111_0100_1111_0100_1111_0100;

end

Device A(force_requesta,AddressToContacta,AD,irdy,trdy,rqa,gnt[0],clk,frame,devsel,devadd_a,indata_a,nm_transactiona,c_be,rda,wra,Byte_enablea,number_wordsa);
Device B(force_requestb,AddressToContactb,AD,irdy,trdy,rqb,gnt[1],clk,frame,devsel,devadd_b,indata_b,nm_transactionb,c_be,rdp,wrp,Byte_enableb,number_wordsb);
Device C(force_requestc,AddressToContactc,AD,irdy,trdy,rqc,gnt[2],clk,frame,devsel,devadd_c,indata_c,nm_transactionc,c_be,rdc,wrc,Byte_enablec,number_wordsc);
Device D(force_requestd,AddressToContactd,AD,irdy,trdy,rqd,gnt[3],clk,frame,devsel,devadd_d,indata_d,nm_transactiond,c_be,rdd,wrd,Byte_enabled,number_wordsd);
arbitre a(rq,gnt,priority0,priority1,priority2,priority3,priority4,frame,irdy,clk); 
endmodule