function [Elem_data,Prob_data] = Read_data(path_file,file)
% [coord,nodfz,barfz,qtype,conec,fixed] = Read_data(problem_folder)
% Lee los datos 
global nelem nnodo ndime ndofs npoin nfixe nload

file_open = fullfile(path_file,file);
fid = fopen(file_open,'r');

%% LEE DATOS DEL PROBLEMA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seccion = f_ProxString(fid);
f_VerifNom(seccion,'PROBLEMA',...
   'Datos de geometria: No esta definido el inicio con "PROBLEMA".')
% LISTA DE DATOS DEL PROBLEMA   
% Escala_Mf   Escala_Q   Escala_N
format = ['%f %f %f %f'];
matrix = textscan(fid,format);%,nElem,'CollectOutput',1,'CommentStyle','$');
esc = [matrix{1} matrix{2} matrix{3} matrix{4}];


%% LEE DATOS DE LA GEOMETRIA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seccion = f_ProxString(fid);
f_VerifNom(seccion,'GEOMETRIA',...
   'Datos de geometria: No esta definido el inicio con "GEOMETRIA".')
seccion = f_ProxString(fid);
f_VerifNom(seccion,'BARRAS',...
   'Datos de geometria: No esta definido el inicio con "BARRAS".')
% LISTA DE CONECTIVIDADES   
% Nodo_inicial   Nodo_final   E   b   h
format = ['%f %f %f %f %f'];
matrix = textscan(fid,format);%,nElem,'CollectOutput',1,'CommentStyle','$');
conec = [matrix{1} matrix{2} matrix{3} matrix{4} matrix{5}];

seccion = f_ProxString(fid);
f_VerifNom(seccion,'COORDENADAS',...
   'Datos de geometria: No esta definido el inicio con "COORDENADAS".')
% LISTA DE COORDENADAS NODALES   
% Coordenada_x Coordenada_y
format = ['%f %f'];
matrix = textscan(fid,format);%,nElem,'CollectOutput',1,'CommentStyle','$');
coord = [matrix{1} matrix{2}];

seccion = f_ProxString(fid);
f_VerifNom(seccion,'CONDICIONES',...
   'Datos de geometria: No esta definido el inicio con "CONDICIONES".')
% LISTA DE NODOS CON RESTRICCIONES   
% Numero_Nodo  Rest_x  Rest_y  Rest_tita  Valor_Rest_x  Valor_Rest_y Valor_Rest_tita
format = ['%f %f %f %f %f %f %f'];
matrix = textscan(fid,format);%,nElem,'CollectOutput',1,'CommentStyle','$');
fixed = [matrix{1} matrix{2} matrix{3} matrix{4} matrix{5} matrix{6} matrix{7}];

%% LEE DATOS DE LAS CARGAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seccion = f_ProxString(fid);
f_VerifNom(seccion,'CARGAS',...
   'Datos de geometria: No esta definido el inicio con "CARGAS".')
seccion = f_ProxString(fid);
f_VerifNom(seccion,'TIPOS',...
   'Datos de geometria: No esta definido el inicio con "TIPOS".')
% LISTA DE TIPOS DE CARGAS
% nro_de_carga   tipo    L1    L2   q1   q2    alpha
format = ['%f %f %f %f %f %f %f'];
matrix = textscan(fid,format); 
qtype = [matrix{1} matrix{2} matrix{3} matrix{4} matrix{5} matrix{6} matrix{7}];

% CARGAS EN BARRAS
% nro_de_barra   nro_de_carga
seccion = f_ProxString(fid);
f_VerifNom(seccion,'BARRAS',...
   'Datos de geometria: No esta definido el inicio con "BARRAS".')
format = ['%u %u'];
matrix = textscan(fid,format); 
barfz = [matrix{1} matrix{2}];

% CARGAS EN NODOS
% nro_de_nodo  carga_x   carga_y   carga_m
seccion = f_ProxString(fid);
f_VerifNom(seccion,'NODOS',...
   'Datos de geometria: No esta definido el inicio con "NODOS".')
format = ['%f %f %f %f'];
matrix = textscan(fid,format); 
nodfz = [matrix{1} matrix{2} matrix{3} matrix{4}];

%%
nload = size(nodfz,1) ;
nelem = size(conec,1) ;
nnodo = 2 ;
ndime = size(coord,2) ;
ndofs = 3 ;
npoin = size(coord,1) ;
nfixe = size(fixed,1) ;


Elem_data(nelem) = struct('conec',[],'KGele',[],'RT',[],'ALbar',[],'AGbar',[],'FGbar',[],'FLbar',[]);
Prob_data = struct('conec',[],'coord',coord,'nodfz',nodfz,'barfz',barfz,'qtype',qtype,'fixed',fixed,'esc',esc);

L = [] ; 
for ielem=1:nelem
    xnodi = coord(conec(ielem,1),1) ;
    ynodi = coord(conec(ielem,1),2) ;
    xnodf = coord(conec(ielem,2),1) ;
    ynodf = coord(conec(ielem,2),2) ;
    if ((ynodf-ynodi)==0 & (xnodf-xnodi)<0)
        L = [L ;long_elem2D(xnodi,ynodi,xnodf,ynodf)  180];
    else
        L = [L ;long_elem2D(xnodi,ynodi,xnodf,ynodf)  atand((ynodf-ynodi)/(xnodf-xnodi))];
    end
end
conec = [conec L] ;
Prob_data.conec = conec ;

%% MATRIZ DE ROTACION
for ielem=1:nelem
    Elem_data(ielem).KGele = KPortico(conec(ielem,:));
    tita  = conec(ielem,7)   ;                 
    sen_t = sind(tita) ;
    cos_t = cosd(tita) ;   
        
    RT = [   cos_t  sen_t  0  0      0      0 ;
            -sen_t  cos_t  0  0      0      0 ;
             0      0      1  0      0      0 ;
             0      0      0  cos_t  sen_t  0 ;
             0      0      0 -sen_t  cos_t  0 ;
             0      0      0  0      0      1 ] ;
    Elem_data(ielem).conec = conec(ielem,:) ;
    Elem_data(ielem).RT = RT ;
end

