#TRABALHO PRATICO
#QUANDECEPD065 
#Modelagem de Sistemas de Produ��o

#03/03/2021


# INTEGRANTES

#Klysman Rezende Alves Vieira
#Gustavo Sena Piconi 
#Daniel de Carvalho Souza
#Vitor Domingues Penaforte Parreiras


#PROBLEMA DA MODELAGEM

#     Uma empresa multinacional � produtora de diversos artigos esportivos, que s�o classificados em tr�s categorias: vestu�rio, cal�ados e acess�rias. A empresa possui unidadesem diversos pa�ses, e atende a demanda em praticamente todas as regi�es globais.A cada trimestre, ela refaz o seu plano de produ��o, podendo manter algumas unidades fechadas de acordo com o contexto atual de demandas, pre�os e custos, visando sempre maximizar o lucro da empresa como um todo.Cada unidade possui suas peculiaridades, como a capacidade de produzir determinado tipo deproduto, a produtividade, a disponibilidade e seus custos. Os dados dispon�veis para o pr�ximo trimestre seguem a seguir

###############################################################
###############################################################

# FABRICAS
set M;
# REGIOES
set N;
# PRODUTOS
set O;

###############################################################
###############################################################

# PARAMETROS

# Capacidade de producao por hora do produto
param ch{i in M, k in O};

# Disponibilidade de dias na fabrica
param dd{i in M};

# Demanda minima do produto 
param dmin{j in N, k in O};

# Demanda maxima do produto 
param dmax{j in N, k in O};

# Preco de venda produto 
param pr{j in N, k in O};

# Custo fixo de funcionamento de fabrica 
param cf{i in M};

# Custo variavel de producaoo de produto 
param cv{i in M, k in O};

# Custo logistico de transporte da fabrica 
param cl{i in M, j in N};

# Capacidade maxima de escoamento de fabrica 
param ce{i in M, j in N};

###############################################################
###############################################################

# VARIAVEIS

#Volume escoado de fabrica i para regiao *j
var vEsc{i in M, j in N,k in O},integer, >= 0;

#se fabrica i nao utilizada, valor binario
var vFabr{i in M}, binary;

var vreceita;
var vcusto;
var vlucro;

###############################################################
###############################################################

# FUNCAO OBJETIVO

maximize lucro : sum{i in M,j in N,k in O}(vEsc[i,j,k] * pr[j,k] )- sum{i in M,j in N,k in O}(vEsc[i,j,k] * cl[i,j]) - sum{i in M}(vFabr[i]*cf[i]) - sum{i in M,j in N,k in O}(vEsc[i,j,k] * cv[i,k]); 

###############################################################
###############################################################

#RESTRICOES

#binaria
r1 {i in M}: sum {j in N, k in O} vEsc[i,j,k] <= vFabr[i]*10000000000;
#demanda minima
r2 {j in N,k in O}: sum{i in M}vEsc[i,j,k] >= dmin[j,k];
#demanda maxima
r3 {j in N,k in O}: sum{i in M}vEsc[i,j,k] <= dmax[j,k] ;
#capacidade maxima de escoamento
r4 {j in N,i in M}:  sum{k in O}vEsc[i,j,k] <= ce[i,j];
r5: vreceita = sum{i in M,j in N,k in O}(vEsc[i,j,k] * pr[j,k]);
r6: vcusto = sum{i in M,j in N,k in O}(vEsc[i,j,k] * cl[i,j]) +sum{i in M}(vFabr[i]*cf[i]) +sum{i in M,j in N,k in O}(vEsc[i,j,k] * cv[i,k]);
r7: vlucro = sum{i in M,j in N,k in O}(vEsc[i,j,k] * pr[j,k] )- sum{i in M,j in N,k in O}(vEsc[i,j,k] * cl[i,j]) - sum{i in M}(vFabr[i]*cf[i]) - sum{i in M,j in N,k in O}(vEsc[i,j,k] * cv[i,k]); 

###############################################################
###############################################################


solve;


display lucro;


###############################################################
###############################################################
#DADOS DO PROBLEMA

data;

# FABRICAS
set M :=  ARG BRA EUA MEX ITA POL IND CHI COR IDO VIE;

#REGIOES
set N := NAM SAM CAM EUR ORM AFR OCE NAS SAS;

#PRODUUTOS 
set O := VEST CAL ACES;


# PRODUTIVIDADE E DISPONIBILIDADE
# Em  fun��o  do  n�vel  tecnol�gico  e  da  capacidade  da  m�o  de  obra,  cada  f�brica  possui produtividades  diferentes  (pe�as/hora).  Al�m  disso,  em  fun��o  de  leis trabalhistas,  cada f�brica possui uma disponibilidade (dias).

param ch :
        VEST    CAL    ACES :=
    ARG 0       340    250
    BRA 630     535    0
    EUA 1000    780    1500
    MEX 0       415    0
    ITA 590     460    0
    POL 410     400    200
    IND 0       600    700
    CHI 1320    850    0
    COR 100     0     290
    IDO 0       630    510
    VIE 760     680    520;

param dd :=
    ARG	62
    BRA	68
    EUA	66
    MEX	66
    ITA	61
    POL	71
    IND	61
    CHI	71
    COR	62
    IDO	69
    VIE	70;
    
# DEMANDAS MINIMAS E MAXIMAS POR REGIAO
#As diferentes regi�es possuem demandas m�nimas que a empresa deve atender, em fun��o de contratos j� estabelecidos. Al�m disso, cada regi�o determina qual o m�ximo de demanda poderia  ser  estabelecida,  caso  haja disponibilidade  e  seja  lucrativo  para  a  empresa.  A demanda � definida em milhares de pe�as (kpe�as).

param dmin :
        VEST    CAL     ACES :=
    NAM 693000  781000  252000
    SAM 231000  473000  72000
    CAM 73000   33000   7000
    EUR 451000  506000  126000
    ORM 141000  99000   20000
    AFR 73000   27000   9000
    OCE 68000   60000   24000
    NAS 572000  643000  144000
    SAS 225000  346000  72000;
    
 param dmax :
        VEST    CAL     ACES :=
    NAM 970000  1073000 323000
    SAM 367000  557000  77000
    CAM 88000   38000   8000
    EUR 632000  695000  161000
    ORM 170000  116000  23000
    AFR 88000   64000   11000
    OCE 81000   71000   26000
    NAS 801000  884000  198000
    SAS 316000  476000  92000; 
    


# PRE�O POR REGIAO
#Respeitando as diferen�as econ�micas de cada regi�o, as equipes de pricingda empresa j� determinaram os pre�os de cada produto em cada regi�o ($/pe�a).
 param pr : 
        VEST    CAL     ACES :=
    NAM 21      72.2    88.5
    SAM 15      64.6    70.8
    CAM 18      36      67.85
    EUR 15      72.2    88.5
    ORM 22      57      61.95
    AFR 14.7    40      40
    OCE 21      72.2    76.7
    NAS 15.4    45.6    44.25
    SAS 14      34      67;
    

# CUSTOS FIXOS E VARIAVEIS
#A utiliza��o ou n�o de uma f�brica no trimestre acarreta custos fixos, expressos em milh�es de d�lares (M$). Al�m disso, a produ��o de uma pe�a de cada produto possui um custo vari�vel diferente em cada f�brica, expresso em d�lares por pe�a ($/pe�a).

param cf :=
    ARG 7500000
    BRA 6500000
    EUA 7000000
    MEX 7000000
    ITA 10000000
    POL 5000000
    IND 4000000
    CHI 6000000
    COR 12000000
    IDO 2500000
    VIE 2550000;
    
param cv :
        VEST    CAL     ACES :=
    ARG 9.1     29.25   53.6
    BRA 10.4    32.5    55.25
    EUA 16.9    50.4    40
    MEX 10.4    34.1    56.9
    ITA 14.3    36.4    60.1
    POL 13.65   33      53.5
    IND 5.2     19.5    30.9
    CHI 6.5     22.1    45.8
    COR 130     37.7    56.9
    IDO 2.6     15      26
    VIE 2.6     11.4    26;
    
    
# CUSTOS LOGISTICOS
#O custo de transporte de uma pe�a entre uma f�brica e uma determinada regi�o � expresso em d�lares por pe�a ($/pe�a).
param cl :
          NAM   SAM   CAM   EUR   ORM   AFR   OCE   NAS   SAS :=
    ARG   8     3     2     8     12    11    14    14    15
    BRA   7     2     2     7     11    10    13    13    14
    EUA   1     5     3     6     10    10    15    9     11
    MEX   3     4     3     7.8   11    12    13    11    12
    ITA   9     6     8     1.7   4     7     11    8     9
    POL   9     7     9     3.2   4     8     9     8     8
    IND   13    11    9     7     3     6     6     5     5
    CHI   12    15    14    9     5     5     5     1     3
    COR   13    15    14    9     6     6     6     2     4
    IDO   14    16    16.5  11.5  9     8     3     4     2
    VIE   15    16.5  16.5  12    10    9     4     4     2;
    

# CAPACIDADE MAXIMA DE ESCOAMENTO
# Por quest�es pol�ticas e limita��es log�sticas, existe um limite m�ximo de escoamento em cada rota, expresso em milhares de pe�as (kpe�as)
param ce :
          NAM      SAM      CAM      EUR      ORM      AFR      OCE      NAS      SAS :=
    ARG	800000	4000000	1000000	500000	100000	300000	100000	100000	1000000
    BRA	1500000	5000000	1000000	500000	500000	300000	100000	1000000	1000000
    EUA	5000000	3500000	2000000	1000000	100000	800000	100000	1000000	1000000
    MEX	3000000	1000000	2000000	500000	100000	500000	100000	100000	1000000
    ITA	1000000	1000000	500000	2000000	500000	500000	100000	100000	1000000
    POL	1000000	1000000	500000	2000000	100000	100000	100000	100000	1000000
    IND	500000	1000000	500000	600000	500000	1000000	1000000	1000000	3000000
    CHI	1000000	3500000	500000	1000000	100000	2000000	3000000	5000000	3000000
    COR	1000000	1000000	500000	600000	300000	2000000	1000000	2000000	3000000
    IDO	600000	2000000	500000	600000	300000	1500000	3500000	1000000	5000000
    VIE	600000	2000000	500000	600000	300000	500000	3500000	1000000	5000000;

end;