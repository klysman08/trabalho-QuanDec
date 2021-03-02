# O Problema do Transporte modelo 2
#
#
#
#
#
#   Igor Freitas - 2016086240
#   Pedro Callegari Portugal - 2016092402
#   Pedro Novato Silva de Faria - 2016070042
#   Selena Souza Afgouni - 2016119378



# FABRICAS
set M;

# REGIOES
set N;

# PRODUTOS
set O;


#Multiplicador de custos logisticos para regioes @j

param multCusLog{i in M,j in N};


#mult demanda max
param multd{j in N};

# Capacidade de producao por hora do produto @k na fabrica @i
param ch{i in M, k in O};

# Disponibilidade de dias na fabrica @i no trimestre
param dd{i in M};

# Demanda minima do produto @k na região @j
param dmin{j in N, k in O};

# Demanda maxima do produto @k na região @j
param dmax{j in N, k in O};

# Preço de venda produto @k na região @j
param pr{j in N, k in O};

# Custo fixo de funcionamento de fabrica @i
param cf{i in M};

# Custo variavel de produção de produto @k na fabrica @i
param cv{i in M, k in O};

# Custo logistico de transporte de fabrica @i para região @j
param cl{i in M, j in N};

# Capacidade maxima de escoamento de fabrica @i para região @j
param ce{i in M, j in N};

# Variaveis-----------------------------------------------------------------------

#Volume escoado de fabrica *i para regiao *j
var vEsc{i in M, j in N,k in O},integer, >= 0;

#se fabrica @i é utilizada, valor binario
var vFabr{i in M}, binary;

var vreceita;
var vmarketshare;
var vcusto;
var vlucro;

# Funcao Objetivo-----------------------------------------------------------------
maximize lucro : sum{i in M,j in N,k in O}(vEsc[i,j,k] * pr[j,k] )- sum{i in M,j in N,k in O}(vEsc[i,j,k] * cl[i,j]* multCusLog[i,j]) - sum{i in M}(vFabr[i]*cf[i]) - sum{i in M,j in N,k in O}(vEsc[i,j,k] * cv[i,k]); 
#maximize marketshare: sum{i in M,j in N,k in O}vEsc[i,j,k];
#maximize receita: sum{i in M,j in N,k in O}(vEsc[i,j,k] * pr[j,k] );
#minimize custo: sum{i in M,j in N,k in O}(vEsc[i,j,k] * cl[i,j]* multCusLog[i,j]) +sum{i in M}(vFabr[i]*cf[i]) +sum{i in M,j in N,k in O}(vEsc[i,j,k] * cv[i,k]);
#Restricoes-----------------------------------------------------------------------

#res binaria
r1 {i in M}: sum {j in N, k in O} vEsc[i,j,k] <= vFabr[i]*10000000000;
#demanda minima
r2 {j in N,k in O}: sum{i in M}vEsc[i,j,k] >= dmin[j,k];
#demanda maxima
r3 {j in N,k in O}: sum{i in M}vEsc[i,j,k] <= dmax[j,k] * multd[j];
#capacidade de producao
r4 {i in M}: sum{j in N,k in O}vEsc[i,j,k]*((ch[i,k]+0.00000000000000000001)**-1)<=dd[i]*24;
#capacidade maxima de escoamento
r5 {j in N,i in M}:  sum{k in O}vEsc[i,j,k] <= ce[i,j];

r6: vreceita = sum{i in M,j in N,k in O}(vEsc[i,j,k] * pr[j,k]);
r7: vmarketshare = sum{i in M,j in N,k in O}vEsc[i,j,k];
r8: vcusto = sum{i in M,j in N,k in O}(vEsc[i,j,k] * cl[i,j]* multCusLog[i,j]) +sum{i in M}(vFabr[i]*cf[i]) +sum{i in M,j in N,k in O}(vEsc[i,j,k] * cv[i,k]);
r9: vlucro = sum{i in M,j in N,k in O}(vEsc[i,j,k] * pr[j,k] )- sum{i in M,j in N,k in O}(vEsc[i,j,k] * cl[i,j]* multCusLog[i,j]) - sum{i in M}(vFabr[i]*cf[i]) - sum{i in M,j in N,k in O}(vEsc[i,j,k] * cv[i,k]);

#option solver cplex; 

solve;

display vEsc;
display vFabr;

display lucro;



#------------------------------------------------Dados----------------------------------------------------------

data;

# Fabricas
set M :=  ARG BRA EUA MEX ITA POL IND CHI COR IDO VIE;

#REGIÕES
set N := NAM SAM CAM EUR ORM AFR OCE NAS SAS;

#PRODUUTOS 
set O := VEST CAL ACES;



# CAPACIDADE PRODUÇÃO POR HORA
param ch :
        VEST    CAL    ACES :=
    ARG 400     340    0
    BRA 630     535    0
    EUA 1000    780    1500
    MEX 580     0      0
    ITA 590     460    350
    POL 410     400    0
    IND 895     0      0
    CHI 0       850    0
    COR 0       350    290
    IDO 0       630    510
    VIE 760     0      520;
    
    
    
# DISPONIBILIDADE DE DIAS NO TRIMESTRE
param dd :=
    ARG 62
    BRA 68
    EUA 60
    MEX 66
    ITA 61
    POL 71
    IND 65
    CHI 71
    COR 62
    IDO 69
    VIE 70;
    
    
 #DEMANDA MINIMA A SER ATENDIDA
 param dmin :
        VEST    CAL     ACES :=
    NAM 660000  710000  210000
    SAM 220000  430000  60000
    CAM 70000   30000   6000
    EUR 430000  460000  105000
    ORM 135000  90000   17000
    AFR 70000   25000   8000
    OCE 65000   55000   20000
    NAS 545000  585000  120000
    SAS 215000  315000  60000;
    
    
 #MULT DEMANDA MAX
  param multd :=
    NAM 1
    SAM 1
    CAM 1
    EUR 1
    ORM 1
    AFR 1
    OCE 1
    NAS 1
    SAS 1;
    
    
 param multCusLog :
          NAM   SAM   CAM   EUR   ORM   AFR   OCE   NAS   SAS :=
    ARG   1     1     1     1      1     1     1     1     1
    BRA   1     1     1     1      1     1     1     1     1
    EUA   1     1     1     1      1     1     1     1     1 
    MEX   1     1     1     1      1     1     1     1     1
    ITA   1     1     1     1      1     1     1     1     1
    POL   1     1     1     1      1     1     1     1     1
    IND   1     1     1     1      1     1     1     1     1
    CHI   1     1     1     1      1     1     1     1     1 
    COR   1     1     1     1      1     1     1     1     1
    IDO   1     1     1     1      1     1     1     1     1
    VIE   1     1     1     1      1     1     1     1     1;
    
    
    

 #DEMANDA MAXIMA POSSIVEL
 param dmax :
        VEST    CAL    ACES :=
    NAM 924000  994000 294000
    SAM 350000  516000 70000
    CAM 84000   36000  8000
    EUR 602000  644000 147000
    ORM 162000  108000 21000
    AFR 84000   60000  10000
    OCE 78000   66000  24000
    NAS 763000  819000 180000
    SAS 301000  441000 84000; 
    
 #PREÇO POR REGIAO
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
    
    
#   CUSTO FIXO DE UTILIZACAO DA FABRICA
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
    
    
# CUSTO VARIAVEL DE PRODUCAO
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
    
    
# CUSTO LOGISTICO
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
param ce :
          NAM      SAM      CAM      EUR      ORM      AFR      OCE      NAS      SAS :=
    ARG   800000   4000000  1000000  500000   100000   300000   100000   100000   1000000 
    BRA   1500000  5000000  1000000  500000   500000   300000   100000   1000000  1000000
    EUA   5000000  3500000  2000000  1000000  100000   800000   100000   1000000  1000000
    MEX   3000000  1000000  2000000  500000   100000   500000   100000   100000   1000000
    ITA   1000000  1000000  500000   2000000  500000   500000   100000   100000   1000000
    POL   1000000  1000000  500000   2000000  100000   100000   100000   100000   1000000
    IND   500000   1000000  500000   600000   500000   1000000  1000000  1000000  3000000
    CHI   1000000  3500000  500000   1000000  100000   2000000  3000000  5000000  3000000
    COR   1000000  1000000  500000   600000   300000   2000000  1000000  2000000  3000000
    IDO   600000   2000000  500000   600000   300000   1500000  3500000  1000000  5000000
    VIE   600000   2000000  500000   600000   300000   500000   3500000  1000000  5000000;

end;