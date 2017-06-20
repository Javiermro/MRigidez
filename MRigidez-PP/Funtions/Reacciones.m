% function [ALbar,AGbar] = Empot_perfecto(conec,qtype,barfz)
function [Elem_data] = Reacciones(Elem_data,Prob_data)

% Calcula los esfuerzos de empotramiento perfecto en coordenadas locales
global nelem nnodo ndime ndofs npoin nfixe nload

% loads = [nro  tipo  L1  L2  q1  q2  alpha]; 

for ielem=1:nelem
    AL = zeros(6,1) ;
    for iforce=1:size(Prob_data.barfz,1)
        if ielem==Prob_data.barfz(iforce,1) 
            tipo = Prob_data.qtype(Prob_data.barfz(iforce,2),2);
            if tipo == 1  % carga uniformemente distribuida
                q     = Prob_data.qtype(Prob_data.barfz(iforce,2),5)    ;
                alpha = Prob_data.qtype(Prob_data.barfz(iforce,2),7)    ;
                tita  = Prob_data.conec(ielem,7)   ;                 
                sen_a = sind(alpha-tita) ;
                cos_a = cosd(alpha-tita) ;
                L  = Prob_data.conec(ielem,6) ;
                
                N  = -cos_a*q*L/2 ;
                M  = -sen_a*q*L^2/12 ;
                Q  = -sen_a*q*L/2 ;
                AL = AL + [N Q M  N Q -M]' ;                
            elseif tipo == 2  % carga puntual en cualquier posición
                L     = Prob_data.conec(ielem,6) ;
                p     = Prob_data.qtype(Prob_data.barfz(iforce,2),5)    ;
                li    = L*Prob_data.qtype(Prob_data.barfz(iforce,2),3)  ;
                lj    = L - li ;
                alpha = Prob_data.qtype(Prob_data.barfz(iforce,2),7)    ;
                tita  = Prob_data.conec(ielem,7)   ;                 
                sen_a = sind(alpha-tita) ;
                cos_a = cosd(alpha-tita) ;
                
                Ni  = -cos_a*p*lj/L ;
                Nj  = -cos_a*p*li/L ;
                Mi  = -sen_a*p*li*(lj/L) ;
                Mj  = -sen_a*p*lj*(li/L) ;
                Qi  = -sen_a*p*((lj/L)^2)*(3-2*lj/L) ;
                Qj  = -sen_a*p*((li/L)^2)*(3-2*li/L) ;
                AL = AL + [Ni Qi Mi  Nj Qj -Mj]' ;   
                
            end
        end
    end
    Elem_data(ielem).ALbar = AL ;
    Elem_data(ielem).AGbar = Elem_data(ielem).RT'*AL ;
end


% R = [ cos_a  sen_a ; -sen_a  cos_a];

