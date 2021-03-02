# O Problema do Transporte 


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
    ARG	0	340	250
    BRA	630	535	0
    EUA	1000	780	1500
    MEX	0	415	0
    ITA	590	460	0
    POL	410	400	200
    IND	0	600	700
    CHI	1320	850	0
    COR	100	0	290
    IDO	0	630	510
    VIE	760	680	520;



    
    
    
# DISPONIBILIDADE DE DIAS 
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
    
    
    
 #DEMANDA MINIMA A SER ATENDIDA
 param dmin :
        VEST    CAL     ACES :=
    NAM 	693	781	252
    SAM	231	473	72
    CAM	73	33	7
    EUR	451	506	126
    ORM	141	99	20
    AFR	73	27	9
    OCE	68	60	24
    NAS	572	643	144
    SAS	225	346	72;
    

 #DEMANDA MAXIMA POSSIVEL
 param dmax :
        VEST    CAL    ACES :=
    NAM	970	1073	323
    SAM	367	557	77
    CAM	88	38	8
    EUR	632	695	161
    ORM	170	116	23
    AFR	88	64	11
    OCE	81	71	26
    NAS	801	884	198
    SAS	316	476	92; 
    
    
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
    
    
 #PREÇO POR REGIAO
 param pr : 
        VEST    CAL     ACES :=
    NAM	21	72	89
    SAM	15	65	71
    CAM	18	36	68
    EUR	15	72	89
    ORM	22	57	62
    AFR	15	40	40
    OCE	21	72	77
    NAS	15	46	44
    SAS	14	34	67;
    
    
#   CUSTO FIXO DE UTILIZACAO DA FABRICA
param cf :=
    ARG	7500000
    BRA	6500000
    EUA	7000000
    MEX	7000000
    ITA	10000000
    POL	5000000
    IND	4000000
    CHI	6000000
    COR	12000000
    IDO	2500000
    VIE	2550000;
    
    
# CUSTO VARIAVEL DE PRODUCAO
param cv :
        VEST    CAL     ACES :=
    ARG	9.1	29.25	53.6
    BRA	10.4	32.5	55.25
    EUA	16.9	50.4	40
    MEX	10.4	34.1	56.9
    ITA	14.3	36.4	60.1
    POL	7	33	53.5
    IND	5.2	19.5	30.9
    CHI	6.5	22.1	45.8
    COR	13	37.7	56.9
    IDO	2.6	15	26
    VIE	2.6	11.4	26;
    
    
# CUSTO LOGISTICO
param cl :
          NAM   SAM   CAM   EUR   ORM   AFR   OCE   NAS   SAS :=
    ARG	62	3	2	8	12	11	14	14	15
    BRA	68	2	2	7	11	10	13	13	14
    EUA	66	5	3	6	10	10	15	9	11
    MEX	66	4	3	8	11	12	13	11	12
    ITA	61	6	8	2	4	7	11	8	9
    POL	71	7	9	3	4	8	9	8	8
    IND	61	11	9	7	3	6	6	5	5
    CHI	71	15	14	9	5	5	5	1	3
    COR	62	15	14	9	6	6	6	2	4
    IDO	69	16	17	12	9	8	3	4	2
    VIE	70	17	17	12	10	9	4	4	2;
    

    
# CAPACIDADE MAXIMA DE ESCOAMENTO
param ce :
          NAM      SAM      CAM      EUR      ORM      AFR      OCE      NAS      SAS :=
    ARG	800	4000	1000	500	100	300	100	100	1000
    BRA	1500	5000	1000	500	500	300	100	1000	1000
    EUA	5000	3500	2000	1000	100	800	100	1000	1000
    MEX	3000	1000	2000	500	100	500	100	100	1000
    ITA	1000	1000	500	2000	500	500	100	100	1000
    POL	1000	1000	500	2000	100	100	100	100	1000
    IND	500	1000	500	600	500	1000	1000	1000	3000
    CHI	1000	3500	500	1000	100	2000	3000	5000	3000
    COR	1000	1000	500	600	300	2000	1000	2000	3000
    IDO	600	2000	500	600	300	1500	3500	1000	5000
    VIE	600	2000	500	600	300	500	3500	1000	5000;

end;