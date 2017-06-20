function [kelem] = KPortico(datos) ;

E = datos(3)          ;
L = datos(6)          ;
tita = datos(7)       ;

b    = datos(4) ;
h    = datos(5) ;

A = b*h        ;
s = sind(tita) ;
c = cosd(tita) ;
I = (b*h^3)/12   ;
%     It = b^3*h^3/(3.6*(b^2+h^2)) ;

Kloc = [E*A/L   0.0         0.0       -E*A/L   0.0        0.0       ;
    0.0     12*E*I/L^3  6*E*I/L^2  0.0   -12*E*I/L^3  6*E*I/L^2 ;
    0.0     6*E*I/L^2   4*E*I/L    0.0   -6*E*I/L^2   2*E*I/L   ;
    -E*A/L  0.0         0.0        E*A/L  0.0         0.0       ;
    0.0    -12*E*I/L^3 -6*E*I/L^2  0.0    12*E*I/L^3 -6*E*I/L^2 ;
    0.0     6*E*I/L^2   2*E*I/L    0.0   -6*E*I/L^2   4*E*I/L ]  ;

Rot = [ c  s  0  0  0  0 ;
       -s  c  0  0  0  0 ;
        0  0  1  0  0  0 ;
        0  0  0  c  s  0 ;
        0  0  0 -s  c  0 ;
        0  0  0  0  0  1 ] ;

kelem = Rot'*Kloc*Rot ;

