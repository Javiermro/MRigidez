% Programa para el calculo de solidos 2D con elementos de barra lineales
% con grados de liberad de desplazamiento y rotacion
% Autor: Dr. Ing. Javier L. Mroginski
% Version: 2.0 (2017)
clc;
clear;
close all;

display('------------------------ MRigid --------------------------------------') 
display(' Programa para el calculo de porticos planos empleando el Met. Rigidez')
display(' Autor: Dr. Ing. Javier L. Mroginski')
display(' Version: 2.0 (2017)')
display('----------------------------------------------------------------------') 

global nelem nnodo ndime ndofs npoin nfixe nload

file = '2017_Cross.dat'; %'2017_PP.dat'; 

addpath([pwd '/Funtions']);
path_file = [pwd '/Problem/'];  %file = 'RVE_Inclu01.mfl';

% [coord,nodfz,barfz,qtype,conec,fixed] = Read_data(problem_folder) ;
[Elem_data,Prob_data] = Read_data(path_file,file) ;
PlotEstructura(Elem_data,Prob_data) %grafica la malla indeformada con azul

% xlabel ('Coordenada X [m]')
% ylabel ('Coordenada Y [m]')


% [ALbar,AGbar] = Empot_perfecto(conec,qtype,barfz) ;
[Elem_data] = Reacciones(Elem_data,Prob_data) ;

despG = zeros(ndofs*npoin,1) ;
FGlob = EnsamblajeF(Prob_data.nodfz) ;
[KGlob,FGlob] = EnsamblajeK(Prob_data.conec,Elem_data,FGlob) ;
% [KGlob,KGele,FGlob] = EnsamblajeK(coord,conec,AGbar,FGlob) 
[KGcon,FGcon,ifixe] = CondBorde(KGlob,FGlob,Prob_data.fixed) ;

despl=KGcon\FGcon ;
despG(find(ifixe(:,1)==1))=ifixe(find(ifixe(:,1)==1),2) ;
despG(find(ifixe(:,1)==0))=despl ;

[Elem_data] = Solicitaciones(Elem_data,despG) ;

fprintf('\n---Desplazamientos nodales---\n') 
fprintf('   Nodo   X   Y   phi \n') 
for ipoin=1:npoin
  pos = (ipoin-1)*ndofs+1 ;
  fprintf ('nodo: %3i \t %12.5e \t %12.5e \t %12.5e \t \n', ipoin, despG(pos:1:pos+ndofs-1)')
%    fprintf (' Nodo: %3i \t Desplazamiento en X = %12.5e \t Desplazamiento en Y = %12.5e \n',ipoin, despG(pos),despG(pos+1)) 
end

PlotSolicitaciones(Prob_data,Elem_data) 
fprintf('\n---Solicitaciones---\n') 
fprintf('      Barra Nodo_i Nodo_j  |  Ni Qi Mi  |  Nj Qj Mj \n') 
for ielem=1:nelem
  pos = (ipoin-1)*ndofs+1 ;
  fprintf ('Barra: %3i %3i %3i \t %12.5e \t %12.5e \t %12.5e \t %12.5e \t %12.5e \t %12.5e \t \n', ...
  ielem, Elem_data(ielem).conec([1 2]), Elem_data(ielem).FLbar)
%    fprintf (' Nodo: %3i \t Desplazamiento en X = %12.5e \t Desplazamiento en Y = %12.5e \n',ipoin, despG(pos),despG(pos+1)) 
end



% 
% fprintf('\n---Reacciones exteriores--- \n\n') 
% reac=KGlob*despG;
% for ipoin=1:npoin
%   pos = (ipoin-1)*ndime+1
%   fprintf (' Nodo: %3i \t Desplazamiento en X = %7.3f \t Desplazamiento en Y = %7.3f \n',ipoin, reac(pos),reac(pos+1)); 
% end


%display('Deformaci�n de cada elemento') 
%defor= Deformacion(nelem,despG,conec,coord)
%grafico(coord,nnodo,despl)

% corda=actual_coord2D(Prob_data.coord,npoin,despG,ndime,ndofs);
% corda=corda*10;
% plotter3D(corda,Prob_data.conec,nelem,nnodo,'r-') %grafica la malla indeformada con azul
%graphic(nelem,nnodo,coord,corda,conec)
%plotter(corda,conec,nelem,nnodo,'ro-')  %grafica la malla deformada con rojo
% hold off
