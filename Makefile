SYSTEM     = x86_sles10_4.1
LIBFORMAT  = static_pic

#------------------------------------------------------------
#
# When you adapt this makefile to compile your CPLEX programs
# please copy this makefile and set CPLEXDIR and CONCERTDIR to
# the directories where CPLEX and CONCERT are installed.
#
#------------------------------------------------------------

CPLEXDIR      = /ncsu/ilog/cplex
CONCERTDIR    = /ncsu/ilog/concert
# ---------------------------------------------------------------------
# Compiler selection 
# ---------------------------------------------------------------------

CCC = g++
CC  = gcc
JAVAC = javac 

# ---------------------------------------------------------------------
# Compiler options 
# ---------------------------------------------------------------------

CCOPT = -m32 -O -fPIC -fexceptions -DNDEBUG -DIL_STD
COPT  = -m32 -fPIC 
JOPT  = -classpath $(CPLEXDIR)/lib/cplex.jar -O

# ---------------------------------------------------------------------
# Link options and libraries
# ---------------------------------------------------------------------

CPLEXBINDIR   = $(CPLEXDIR)/bin/$(BINDIST)
CPLEXJARDIR   = $(CPLEXDIR)/lib/cplex.jar
CPLEXLIBDIR   = $(CPLEXDIR)/lib/$(SYSTEM)/$(LIBFORMAT)
CONCERTLIBDIR = $(CONCERTDIR)/lib/$(SYSTEM)/$(LIBFORMAT)

CCLNFLAGS = -L$(CPLEXLIBDIR) -lilocplex -lcplex -L$(CONCERTLIBDIR) -lconcert -m32 -lm -pthread
CLNFLAGS  = -L$(CPLEXLIBDIR) -lcplex -m32 -lm -pthread
JAVA      = java  -Djava.library.path=$(CPLEXDIR)/bin/x86_sles10_4.1 -classpath $(CPLEXJARDIR):


all:
	make all_c
	make all_cpp
	make all_java

execute: all
	make execute_c
	make execute_cpp
	make execute_java
CONCERTINCDIR = $(CONCERTDIR)/include
CPLEXINCDIR   = $(CPLEXDIR)/include

EXDIR         = $(CPLEXDIR)/examples
EXINC         = $(EXDIR)/include
EXDATA        = $(EXDIR)/data
EXSRCC        = $(EXDIR)/src/c
EXSRCCPP      = $(EXDIR)/src/cpp
EXSRCJAVA     = $(EXDIR)/src/java

CFLAGS  = $(COPT)  -I$(CPLEXINCDIR)
CCFLAGS = $(CCOPT) -I$(CPLEXINCDIR) -I$(CONCERTINCDIR) 
JCFLAGS = $(JOPT)


#------------------------------------------------------------
#  make all      : to compile the examples. 
#  make execute  : to compile and execute the examples.
#------------------------------------------------------------


C_EX = lpex1 lpex2 lpex3 lpex4 lpex5 lpex6 lpex7 lpex8 \
       mipex1 mipex2 mipex3 mipex4 miqpex1 netex1 netex2 \
       qcpex1 qpex1 qpex2 \
       steel diet fixnet foodmanu adpreex1 \
       admipex1 admipex2 admipex3 admipex4 admipex5 admipex6 admipex7 \
       populate tuneset

CPP_EX = blend cutstock etsp facility fixcost1 foodmanufact \
         iloadmipex1 iloadmipex2 iloadmipex3 iloadmipex4 \
         iloadmipex5 iloadmipex6 ilodiet \
         ilolpex1 ilolpex2 ilolpex3 ilolpex4 ilolpex6 ilolpex7 \
         ilomipex1 ilomipex2 ilomipex3 ilomipex4 ilomiqpex1 \
         ilogoalex1 ilogoalex2 ilogoalex3 iloqcpex1 iloqpex1 iloqpex2 \
         inout1 inout3 mixblend rates transport ilosteel \
         warehouse ilopopulate ilotuneset

JAVA_EX = Blend.class MixBlend.class CutStock.class Diet.class \
          Etsp.class Facility.class FixCost1.class \
          FoodManufact.class InOut1.class InOut3.class \
          Rates.class Steel.class Transport.class \
          LPex1.class LPex2.class LPex3.class LPex4.class \
          LPex6.class LPex7.class \
          MIPex1.class MIPex2.class MIPex3.class MIPex4.class MIQPex1.class \
          AdMIPex1.class AdMIPex2.class AdMIPex3.class \
          AdMIPex4.class AdMIPex5.class AdMIPex6.class QCPex1.class \
          QPex1.class QPex2.class Goalex1.class Goalex2.class \
          TuneSet.class \
          Goalex3.class Populate.class Warehouse.class CplexServer.class

all_c: $(C_EX)

all_cpp: $(CPP_EX)

all_java: $(JAVA_EX)

execute_c: $(C_EX)
	 ./lpex1 -r
	 ./lpex2 $(EXDATA)/example.mps p
	 ./lpex3
	 ./lpex4
	 ./lpex5
	 ./lpex6
	 ./lpex7 $(EXDATA)/afiro.mps p
	 ./lpex8
	 ./mipex1
	 ./mipex2 $(EXDATA)/mexample.mps
	 ./mipex3
	 ./mipex4 $(EXDATA)/p0033.mps l
	 ./miqpex1
	 ./netex1
	 ./netex2 $(EXDATA)/infnet.net
	 ./qcpex1
	 ./qpex1
	 ./qpex2 $(EXDATA)/qpex.lp o
	 ./steel -r
	 ./steel -c
	 ./diet -r $(EXDATA)/diet.dat
	 ./fixnet
	 ./foodmanu
	 ./populate $(EXDATA)/location.lp
	 ./tuneset $(EXDATA)/p0033.mps
	 ./adpreex1
	 ./admipex1 $(EXDATA)/mexample.mps
	 ./admipex2 $(EXDATA)/p0033.mps
	 ./admipex3 $(EXDATA)/sosex3.lp
	 ./admipex4
	 ./admipex5
	 ./admipex6 $(EXDATA)/mexample.mps
	 ./admipex7 $(EXDATA)/mexample.mps

execute_cpp: $(CPP_EX)
	 ./blend
	 ./cutstock
	 ./etsp
	 ./facility
	 ./fixcost1
	 ./foodmanufact
	 ./iloadmipex1 $(EXDATA)/mexample.mps
	 ./iloadmipex2 $(EXDATA)/p0033.mps
	 ./iloadmipex3 $(EXDATA)/sosex3.lp
	 ./iloadmipex4
	 ./iloadmipex5
	 ./iloadmipex6 $(EXDATA)/mexample.mps
	 ./ilodiet
	 ./ilogoalex1 $(EXDATA)/mexample.mps
	 ./ilogoalex2
	 ./ilogoalex3 $(EXDATA)/mexample.mps
	 ./ilolpex1 -r
	 ./ilolpex2 $(EXDATA)/example.mps p
	 ./ilolpex3
	 ./ilolpex4
	 ./ilolpex6
	 ./ilolpex7 $(EXDATA)/afiro.mps p
	 ./ilomipex1
	 ./ilomipex2 $(EXDATA)/mexample.mps
	 ./ilomipex3
	 ./ilomipex4 $(EXDATA)/p0033.mps l
	 ./ilomiqpex1
	 ./ilopopulate $(EXDATA)/location.lp
	 ./iloqcpex1
	 ./iloqpex1
	 ./iloqpex2 $(EXDATA)/qpex.lp o
	 ./ilotuneset $(EXDATA)/p0033.mps
	 ./inout1
	 ./inout3
	 ./mixblend
	 ./rates
	 ./ilosteel
	 ./transport 1
	 ./warehouse

execute_java: $(JAVA_EX)
	 $(JAVA) Goalex1 $(EXDATA)/mexample.mps
	 $(JAVA) Goalex2
	 $(JAVA) Goalex3 $(EXDATA)/mexample.mps
	 $(JAVA) LPex1 -r
	 $(JAVA) LPex2 $(EXDATA)/example.mps p
	 $(JAVA) LPex3
	 $(JAVA) LPex4
	 $(JAVA) LPex6
	 $(JAVA) LPex7 $(EXDATA)/afiro.mps p
	 $(JAVA) MIPex1
	 $(JAVA) MIPex2 $(EXDATA)/mexample.mps
	 $(JAVA) MIPex3
	 $(JAVA) MIPex4 $(EXDATA)/p0033.mps l
	 $(JAVA) MIQPex1
	 $(JAVA) QCPex1
	 $(JAVA) QPex1
	 $(JAVA) QPex2 $(EXDATA)/qpex.lp o
	 $(JAVA) Blend
	 $(JAVA) CplexServer
	 $(JAVA) CutStock
	 $(JAVA) Diet
	 $(JAVA) Etsp
	 $(JAVA) Facility
	 $(JAVA) FixCost1
	 $(JAVA) FoodManufact
	 $(JAVA) InOut1
	 $(JAVA) InOut3
	 $(JAVA) MixBlend
	 $(JAVA) Populate $(EXDATA)/location.lp
	 $(JAVA) Rates
	 $(JAVA) Steel
	 $(JAVA) Transport 1
	 $(JAVA) TuneSet $(EXDATA)/p0033.mps
	 $(JAVA) Warehouse
	 $(JAVA) AdMIPex1 $(EXDATA)/mexample.mps
	 $(JAVA) AdMIPex2 $(EXDATA)/p0033.mps
	 $(JAVA) AdMIPex3 $(EXDATA)/sosex3.lp
	 $(JAVA) AdMIPex4
	 $(JAVA) AdMIPex5
	 $(JAVA) AdMIPex6 $(EXDATA)/mexample.mps

# ------------------------------------------------------------

clean :
	/bin/rm -rf *.o *~ *.class
	/bin/rm -rf $(C_EX) $(CPP_EX)
	/bin/rm -rf *.mps *.ord *.sos *.lp *.sav *.net *.msg *.log *.clp

# ------------------------------------------------------------
#
# The examples
#
eexample: example.o
	$(CCC) $(CCFLAGS) example.o -o example $(CCLNFLAGS)

example.o: example.cpp
	$(CCC) -c $(CCFLAGS) example.cpp -o example.o

linkfirst_1: linkfirst_1.o
	$(CCC) $(CCFLAGS) linkfirst_1.o -o linkfirst_1 $(CCLNFLAGS)

linkfirst_1.o: linkfirst_1.cpp
	$(CCC) -c $(CCFLAGS) linkfirst_1.cpp -o linkfirst_1.o



lpex1: lpex1.o
	$(CC) $(CFLAGS) lpex1.o -o lpex1 $(CLNFLAGS)
lpex1.o: $(EXSRCC)/lpex1.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/lpex1.c -o lpex1.o

lpex2: lpex2.o
	$(CC) $(CFLAGS) lpex2.o -o lpex2 $(CLNFLAGS)
lpex2.o: $(EXSRCC)/lpex2.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/lpex2.c -o lpex2.o

lpex3: lpex3.o
	$(CC) $(CFLAGS) lpex3.o -o lpex3 $(CLNFLAGS)
lpex3.o: $(EXSRCC)/lpex3.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/lpex3.c -o lpex3.o

lpex4: lpex4.o
	$(CC) $(CFLAGS) lpex4.o -o lpex4 $(CLNFLAGS)
lpex4.o: $(EXSRCC)/lpex4.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/lpex4.c -o lpex4.o

lpex5: lpex5.o
	$(CC) $(CFLAGS) lpex5.o -o lpex5 $(CLNFLAGS)
lpex5.o: $(EXSRCC)/lpex5.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/lpex5.c -o lpex5.o

lpex6: lpex6.o
	$(CC) $(CFLAGS) lpex6.o -o lpex6 $(CLNFLAGS)
lpex6.o: $(EXSRCC)/lpex6.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/lpex6.c -o lpex6.o

lpex7: lpex7.o
	$(CC) $(CFLAGS) lpex7.o -o lpex7 $(CLNFLAGS)
lpex7.o: $(EXSRCC)/lpex7.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/lpex7.c -o lpex7.o

lpex8: lpex8.o
	$(CC) $(CFLAGS) lpex8.o -o lpex8 $(CLNFLAGS)
lpex8.o: $(EXSRCC)/lpex8.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/lpex8.c -o lpex8.o

mipex1: mipex1.o
	$(CC) $(CFLAGS) mipex1.o -o mipex1 $(CLNFLAGS)
mipex1.o: $(EXSRCC)/mipex1.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/mipex1.c -o mipex1.o

mipex2: mipex2.o
	$(CC) $(CFLAGS) mipex2.o -o mipex2 $(CLNFLAGS)
mipex2.o: $(EXSRCC)/mipex2.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/mipex2.c -o mipex2.o

mipex3: mipex3.o
	$(CC) $(CFLAGS) mipex3.o -o mipex3 $(CLNFLAGS)
mipex3.o: $(EXSRCC)/mipex3.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/mipex3.c -o mipex3.o

mipex4: mipex4.o
	$(CC) $(CFLAGS) mipex4.o -o mipex4 $(CLNFLAGS)
mipex4.o: $(EXSRCC)/mipex4.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/mipex4.c -o mipex4.o

miqpex1: miqpex1.o
	$(CC) $(CFLAGS) miqpex1.o -o miqpex1 $(CLNFLAGS)
miqpex1.o: $(EXSRCC)/miqpex1.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/miqpex1.c -o miqpex1.o

netex1: netex1.o
	$(CC) $(CFLAGS) netex1.o -o netex1 $(CLNFLAGS)
netex1.o: $(EXSRCC)/netex1.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/netex1.c -o netex1.o

netex2: netex2.o
	$(CC) $(CFLAGS) netex2.o -o netex2 $(CLNFLAGS)
netex2.o: $(EXSRCC)/netex2.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/netex2.c -o netex2.o

qcpex1: qcpex1.o
	$(CC) $(CFLAGS) qcpex1.o -o qcpex1 $(CLNFLAGS)
qcpex1.o: $(EXSRCC)/qcpex1.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/qcpex1.c -o qcpex1.o

qpex1: qpex1.o
	$(CC) $(CFLAGS) qpex1.o -o qpex1 $(CLNFLAGS)
qpex1.o: $(EXSRCC)/qpex1.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/qpex1.c -o qpex1.o

qpex2: qpex2.o
	$(CC) $(CFLAGS) qpex2.o -o qpex2 $(CLNFLAGS)
qpex2.o: $(EXSRCC)/qpex2.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/qpex2.c -o qpex2.o

steel: steel.o
	$(CC) $(CFLAGS) steel.o -o steel $(CLNFLAGS)
steel.o: $(EXSRCC)/steel.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/steel.c -o steel.o

diet: diet.o
	$(CC) $(CFLAGS) diet.o -o diet $(CLNFLAGS)
diet.o: $(EXSRCC)/diet.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/diet.c -o diet.o

fixnet: fixnet.o
	$(CC) $(CFLAGS) fixnet.o -o fixnet $(CLNFLAGS)
fixnet.o: $(EXSRCC)/fixnet.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/fixnet.c -o fixnet.o

foodmanu: foodmanu.o
	$(CC) $(CFLAGS) foodmanu.o -o foodmanu $(CLNFLAGS)
foodmanu.o: $(EXSRCC)/foodmanu.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/foodmanu.c -o foodmanu.o

adpreex1: adpreex1.o
	$(CC) $(CFLAGS) adpreex1.o -o adpreex1 $(CLNFLAGS)
adpreex1.o: $(EXSRCC)/adpreex1.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/adpreex1.c -o adpreex1.o

admipex1: admipex1.o
	$(CC) $(CFLAGS) admipex1.o -o admipex1 $(CLNFLAGS)
admipex1.o: $(EXSRCC)/admipex1.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/admipex1.c -o admipex1.o

admipex2: admipex2.o
	$(CC) $(CFLAGS) admipex2.o -o admipex2 $(CLNFLAGS)
admipex2.o: $(EXSRCC)/admipex2.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/admipex2.c -o admipex2.o

admipex3: admipex3.o
	$(CC) $(CFLAGS) admipex3.o -o admipex3 $(CLNFLAGS)
admipex3.o: $(EXSRCC)/admipex3.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/admipex3.c -o admipex3.o

admipex4: admipex4.o
	$(CC) $(CFLAGS) admipex4.o -o admipex4 $(CLNFLAGS)
admipex4.o: $(EXSRCC)/admipex4.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/admipex4.c -o admipex4.o

admipex5: admipex5.o
	$(CC) $(CFLAGS) admipex5.o -o admipex5 $(CLNFLAGS)
admipex5.o: $(EXSRCC)/admipex5.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/admipex5.c -o admipex5.o

admipex6: admipex6.o
	$(CC) $(CFLAGS) admipex6.o -o admipex6 $(CLNFLAGS)
admipex6.o: $(EXSRCC)/admipex6.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/admipex6.c -o admipex6.o

admipex7: admipex7.o
	$(CC) $(CFLAGS) admipex7.o -o admipex7 $(CLNFLAGS)
admipex7.o: $(EXSRCC)/admipex7.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/admipex7.c -o admipex7.o

populate: populate.o
	$(CC) $(CFLAGS) populate.o -o populate $(CLNFLAGS)
populate.o: $(EXSRCC)/populate.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/populate.c -o populate.o

tuneset: tuneset.o
	$(CC) $(CFLAGS) tuneset.o -o tuneset $(CLNFLAGS)
tuneset.o: $(EXSRCC)/tuneset.c
	$(CC) -c $(CFLAGS) $(EXSRCC)/tuneset.c -o tuneset.o

blend: blend.o
	$(CCC) $(CCFLAGS) blend.o -o blend $(CCLNFLAGS)
blend.o: $(EXSRCCPP)/blend.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/blend.cpp -o blend.o

cutstock: cutstock.o
	$(CCC) $(CCFLAGS) cutstock.o -o cutstock $(CCLNFLAGS)
cutstock.o: $(EXSRCCPP)/cutstock.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/cutstock.cpp -o cutstock.o

etsp: etsp.o
	$(CCC) $(CCFLAGS) etsp.o -o etsp $(CCLNFLAGS)
etsp.o: $(EXSRCCPP)/etsp.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/etsp.cpp -o etsp.o

facility: facility.o
	$(CCC) $(CCFLAGS) facility.o -o facility $(CCLNFLAGS)
facility.o: $(EXSRCCPP)/facility.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/facility.cpp -o facility.o

fixcost1: fixcost1.o
	$(CCC) $(CCFLAGS) fixcost1.o -o fixcost1 $(CCLNFLAGS)
fixcost1.o: $(EXSRCCPP)/fixcost1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/fixcost1.cpp -o fixcost1.o

foodmanufact: foodmanufact.o
	$(CCC) $(CCFLAGS) foodmanufact.o -o foodmanufact $(CCLNFLAGS)
foodmanufact.o: $(EXSRCCPP)/foodmanufact.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/foodmanufact.cpp -o foodmanufact.o

iloadmipex1: iloadmipex1.o
	$(CCC) $(CCFLAGS) iloadmipex1.o -o iloadmipex1 $(CCLNFLAGS)
iloadmipex1.o: $(EXSRCCPP)/iloadmipex1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloadmipex1.cpp -o iloadmipex1.o

iloadmipex2: iloadmipex2.o
	$(CCC) $(CCFLAGS) iloadmipex2.o -o iloadmipex2 $(CCLNFLAGS)
iloadmipex2.o: $(EXSRCCPP)/iloadmipex2.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloadmipex2.cpp -o iloadmipex2.o

iloadmipex3: iloadmipex3.o
	$(CCC) $(CCFLAGS) iloadmipex3.o -o iloadmipex3 $(CCLNFLAGS)
iloadmipex3.o: $(EXSRCCPP)/iloadmipex3.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloadmipex3.cpp -o iloadmipex3.o

iloadmipex4: iloadmipex4.o
	$(CCC) $(CCFLAGS) iloadmipex4.o -o iloadmipex4 $(CCLNFLAGS)
iloadmipex4.o: $(EXSRCCPP)/iloadmipex4.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloadmipex4.cpp -o iloadmipex4.o

iloadmipex5: iloadmipex5.o
	$(CCC) $(CCFLAGS) iloadmipex5.o -o iloadmipex5 $(CCLNFLAGS)
iloadmipex5.o: $(EXSRCCPP)/iloadmipex5.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloadmipex5.cpp -o iloadmipex5.o

iloadmipex6: iloadmipex6.o
	$(CCC) $(CCFLAGS) iloadmipex6.o -o iloadmipex6 $(CCLNFLAGS)
iloadmipex6.o: $(EXSRCCPP)/iloadmipex6.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloadmipex6.cpp -o iloadmipex6.o

ilodiet: ilodiet.o
	$(CCC) $(CCFLAGS) ilodiet.o -o ilodiet $(CCLNFLAGS)
ilodiet.o: $(EXSRCCPP)/ilodiet.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilodiet.cpp -o ilodiet.o

ilolpex1: ilolpex1.o
	$(CCC) $(CCFLAGS) ilolpex1.o -o ilolpex1 $(CCLNFLAGS)
ilolpex1.o: $(EXSRCCPP)/ilolpex1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilolpex1.cpp -o ilolpex1.o

ilolpex2: ilolpex2.o
	$(CCC) $(CCFLAGS) ilolpex2.o -o ilolpex2 $(CCLNFLAGS)
ilolpex2.o: $(EXSRCCPP)/ilolpex2.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilolpex2.cpp -o ilolpex2.o

ilolpex3: ilolpex3.o
	$(CCC) $(CCFLAGS) ilolpex3.o -o ilolpex3 $(CCLNFLAGS)
ilolpex3.o: $(EXSRCCPP)/ilolpex3.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilolpex3.cpp -o ilolpex3.o

ilolpex4: ilolpex4.o
	$(CCC) $(CCFLAGS) ilolpex4.o -o ilolpex4 $(CCLNFLAGS)
ilolpex4.o: $(EXSRCCPP)/ilolpex4.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilolpex4.cpp -o ilolpex4.o

ilolpex6: ilolpex6.o
	$(CCC) $(CCFLAGS) ilolpex6.o -o ilolpex6 $(CCLNFLAGS)
ilolpex6.o: $(EXSRCCPP)/ilolpex6.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilolpex6.cpp -o ilolpex6.o

ilolpex7: ilolpex7.o
	$(CCC) $(CCFLAGS) ilolpex7.o -o ilolpex7 $(CCLNFLAGS)
ilolpex7.o: $(EXSRCCPP)/ilolpex7.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilolpex7.cpp -o ilolpex7.o

ilomipex1: ilomipex1.o
	$(CCC) $(CCFLAGS) ilomipex1.o -o ilomipex1 $(CCLNFLAGS)
ilomipex1.o: $(EXSRCCPP)/ilomipex1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilomipex1.cpp -o ilomipex1.o

ilomipex2: ilomipex2.o
	$(CCC) $(CCFLAGS) ilomipex2.o -o ilomipex2 $(CCLNFLAGS)
ilomipex2.o: $(EXSRCCPP)/ilomipex2.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilomipex2.cpp -o ilomipex2.o

ilomipex3: ilomipex3.o
	$(CCC) $(CCFLAGS) ilomipex3.o -o ilomipex3 $(CCLNFLAGS)
ilomipex3.o: $(EXSRCCPP)/ilomipex3.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilomipex3.cpp -o ilomipex3.o

ilomipex4: ilomipex4.o
	$(CCC) $(CCFLAGS) ilomipex4.o -o ilomipex4 $(CCLNFLAGS)
ilomipex4.o: $(EXSRCCPP)/ilomipex4.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilomipex4.cpp -o ilomipex4.o

inout1: inout1.o
	$(CCC) $(CCFLAGS) inout1.o -o inout1 $(CCLNFLAGS)
inout1.o: $(EXSRCCPP)/inout1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/inout1.cpp -o inout1.o

inout3: inout3.o
	$(CCC) $(CCFLAGS) inout3.o -o inout3 $(CCLNFLAGS)
inout3.o: $(EXSRCCPP)/inout3.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/inout3.cpp -o inout3.o

ilomiqpex1: ilomiqpex1.o
	$(CCC) $(CCFLAGS) ilomiqpex1.o -o ilomiqpex1 $(CCLNFLAGS)
ilomiqpex1.o: $(EXSRCCPP)/ilomiqpex1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilomiqpex1.cpp -o ilomiqpex1.o

ilogoalex1: ilogoalex1.o
	$(CCC) $(CCFLAGS) ilogoalex1.o -o ilogoalex1 $(CCLNFLAGS)
ilogoalex1.o: $(EXSRCCPP)/ilogoalex1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilogoalex1.cpp -o ilogoalex1.o

ilogoalex2: ilogoalex2.o
	$(CCC) $(CCFLAGS) ilogoalex2.o -o ilogoalex2 $(CCLNFLAGS)
ilogoalex2.o: $(EXSRCCPP)/ilogoalex2.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilogoalex2.cpp -o ilogoalex2.o

ilogoalex3: ilogoalex3.o
	$(CCC) $(CCFLAGS) ilogoalex3.o -o ilogoalex3 $(CCLNFLAGS)
ilogoalex3.o: $(EXSRCCPP)/ilogoalex3.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilogoalex3.cpp -o ilogoalex3.o

iloqcpex1: iloqcpex1.o
	$(CCC) $(CCFLAGS) iloqcpex1.o -o iloqcpex1 $(CCLNFLAGS)
iloqcpex1.o: $(EXSRCCPP)/iloqcpex1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloqcpex1.cpp -o iloqcpex1.o

iloqpex1: iloqpex1.o
	$(CCC) $(CCFLAGS) iloqpex1.o -o iloqpex1 $(CCLNFLAGS)
iloqpex1.o: $(EXSRCCPP)/iloqpex1.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloqpex1.cpp -o iloqpex1.o

iloqpex2: iloqpex2.o
	$(CCC) $(CCFLAGS) iloqpex2.o -o iloqpex2 $(CCLNFLAGS)
iloqpex2.o: $(EXSRCCPP)/iloqpex2.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/iloqpex2.cpp -o iloqpex2.o

mixblend: mixblend.o
	$(CCC) $(CCFLAGS) mixblend.o -o mixblend $(CCLNFLAGS)
mixblend.o: $(EXSRCCPP)/mixblend.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/mixblend.cpp -o mixblend.o

rates: rates.o
	$(CCC) $(CCFLAGS) rates.o -o rates $(CCLNFLAGS)
rates.o: $(EXSRCCPP)/rates.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/rates.cpp -o rates.o

transport: transport.o
	$(CCC) $(CCFLAGS) transport.o -o transport $(CCLNFLAGS)
transport.o: $(EXSRCCPP)/transport.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/transport.cpp -o transport.o

warehouse: warehouse.o
	$(CCC) $(CCFLAGS) warehouse.o -o warehouse $(CCLNFLAGS)
warehouse.o: $(EXSRCCPP)/warehouse.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/warehouse.cpp -o warehouse.o

ilopopulate: ilopopulate.o
	$(CCC) $(CCFLAGS) ilopopulate.o -o ilopopulate $(CCLNFLAGS)
ilopopulate.o: $(EXSRCCPP)/ilopopulate.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilopopulate.cpp -o ilopopulate.o

ilotuneset: ilotuneset.o
	$(CCC) $(CCFLAGS) ilotuneset.o -o ilotuneset $(CCLNFLAGS)
ilotuneset.o: $(EXSRCCPP)/ilotuneset.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilotuneset.cpp -o ilotuneset.o

ilosteel: ilosteel.o
	$(CCC) $(CCFLAGS) ilosteel.o -o ilosteel $(CCLNFLAGS)
ilosteel.o: $(EXSRCCPP)/ilosteel.cpp
	$(CCC) -c $(CCFLAGS) $(EXSRCCPP)/ilosteel.cpp -o ilosteel.o

LPex1.class: $(EXSRCJAVA)/LPex1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/LPex1.java 

LPex2.class: $(EXSRCJAVA)/LPex2.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/LPex2.java 

LPex3.class: $(EXSRCJAVA)/LPex3.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/LPex3.java 

LPex4.class: $(EXSRCJAVA)/LPex4.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/LPex4.java 

LPex6.class: $(EXSRCJAVA)/LPex6.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/LPex6.java 

LPex7.class: $(EXSRCJAVA)/LPex7.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/LPex7.java 

MIPex1.class: $(EXSRCJAVA)/MIPex1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/MIPex1.java 

MIPex2.class: $(EXSRCJAVA)/MIPex2.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/MIPex2.java 

MIPex3.class: $(EXSRCJAVA)/MIPex3.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/MIPex3.java 

MIPex4.class: $(EXSRCJAVA)/MIPex4.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/MIPex4.java 

MIQPex1.class: $(EXSRCJAVA)/MIQPex1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/MIQPex1.java 

Goalex1.class: $(EXSRCJAVA)/Goalex1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Goalex1.java 

Goalex2.class: $(EXSRCJAVA)/Goalex2.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Goalex2.java 

Goalex3.class: $(EXSRCJAVA)/Goalex3.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Goalex3.java 

AdMIPex1.class: $(EXSRCJAVA)/AdMIPex1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/AdMIPex1.java

AdMIPex2.class: $(EXSRCJAVA)/AdMIPex2.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/AdMIPex2.java

AdMIPex3.class: $(EXSRCJAVA)/AdMIPex3.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/AdMIPex3.java

AdMIPex4.class: $(EXSRCJAVA)/AdMIPex4.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/AdMIPex4.java

AdMIPex5.class: $(EXSRCJAVA)/AdMIPex5.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/AdMIPex5.java

AdMIPex6.class: $(EXSRCJAVA)/AdMIPex6.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/AdMIPex6.java

QCPex1.class: $(EXSRCJAVA)/QCPex1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/QCPex1.java 

QPex1.class: $(EXSRCJAVA)/QPex1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/QPex1.java 

QPex2.class: $(EXSRCJAVA)/QPex2.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/QPex2.java 

Diet.class: $(EXSRCJAVA)/Diet.java $(EXSRCJAVA)/InputDataReader.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Diet.java \
	                         $(EXSRCJAVA)/InputDataReader.java 

Etsp.class: $(EXSRCJAVA)/Etsp.java $(EXSRCJAVA)/InputDataReader.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Etsp.java \
	                         $(EXSRCJAVA)/InputDataReader.java 

Blend.class: $(EXSRCJAVA)/Blend.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Blend.java

MixBlend.class: $(EXSRCJAVA)/MixBlend.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/MixBlend.java

CplexServer.class: $(EXSRCJAVA)/CplexServer.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/CplexServer.java

CutStock.class: $(EXSRCJAVA)/CutStock.java $(EXSRCJAVA)/InputDataReader.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/InputDataReader.java \
                                 $(EXSRCJAVA)/CutStock.java

Facility.class: $(EXSRCJAVA)/Facility.java $(EXSRCJAVA)/InputDataReader.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/InputDataReader.java \
                                 $(EXSRCJAVA)/Facility.java

FixCost1.class: $(EXSRCJAVA)/FixCost1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/FixCost1.java

FoodManufact.class: $(EXSRCJAVA)/FoodManufact.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/FoodManufact.java

InOut1.class: $(EXSRCJAVA)/InOut1.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/InOut1.java

InOut3.class: $(EXSRCJAVA)/InOut3.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/InOut3.java

Populate.class: $(EXSRCJAVA)/Populate.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Populate.java

TuneSet.class: $(EXSRCJAVA)/TuneSet.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/TuneSet.java

Rates.class: $(EXSRCJAVA)/Rates.java $(EXSRCJAVA)/InputDataReader.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/InputDataReader.java \
                                 $(EXSRCJAVA)/Rates.java

Steel.class: $(EXSRCJAVA)/Steel.java $(EXSRCJAVA)/InputDataReader.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/InputDataReader.java \
                                 $(EXSRCJAVA)/Steel.java

Transport.class: $(EXSRCJAVA)/Transport.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Transport.java

Warehouse.class: $(EXSRCJAVA)/Warehouse.java
	$(JAVAC) $(JCFLAGS) -d . $(EXSRCJAVA)/Warehouse.java

# Local Variables:
# mode: makefile
# End:
