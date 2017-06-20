function [Elem_data] = Solicitaciones(Elem_data,despG)
% Calcula los esfuerzos de empotramiento perfecto en coordenadas locales
global nelem nnodo ndime ndofs npoin nfixe nload

for ielem=1:nelem
    npos = Elem_data(ielem).conec([1 2])-1 ;
    gl = [npos.*ndofs+1 ; npos.*ndofs+2 ; npos.*ndofs+3] ;
    D = despG([gl(:,1) ; gl(:,2)]) ;
    S = Elem_data(ielem).KGele ;
    FG = S*D + Elem_data(ielem).AGbar ;
    Elem_data(ielem).FGbar = FG ;
    Elem_data(ielem).FLbar = Elem_data(ielem).RT*FG ;
end

% 
% FG=[];
% for ielem=1:nelem
%     npos = (conec(ielem,1:1:nnodo)-1) ;
%     gl = [npos.*ndofs+1 ; npos.*ndofs+2 ; npos.*ndofs+3] ;
%     D = despG([gl(:,1) ; gl(:,2)]) ;
%     S = KGele(:,:,ielem) ;
%     FG = [FG S*D + AGbar(:,ielem)] ;
% end
% 
% FL=FG;

