function PlotSolicitaciones(Prob_data,Elem_data)
global nelem nnodo ndime ndofs npoin nfixe nload

escMf = Prob_data.esc(1) ; escQ = Prob_data.esc(2) ; escN = Prob_data.esc(3) ;

figure(2) ;hold on
for ielem=1:nelem
    k=1;
    xini = 0.0; yini = 0.0 ; xfin = 0.0 ; yfin = 0.0;
    xini = Prob_data.coord(Elem_data(ielem).conec(k),1);
    yini = Prob_data.coord(Elem_data(ielem).conec(k),2) ; 
    
    k=k+1; 
    xfin = Prob_data.coord(Elem_data(ielem).conec(k),1);
    yfin = Prob_data.coord(Elem_data(ielem).conec(k),2);

    plot([xini;xfin],[yini;yfin],'-k','LineWidth',2)
    Mi = escMf*Elem_data(ielem).FLbar(3) ;
    Mf = escMf*Elem_data(ielem).FLbar(6) ;
    tita = Elem_data(ielem).conec(7) ;
    
    Mxi = xini + (Mi)*(cosd(tita+90)) ;
    Myi = yini + (Mi)*(sind(tita+90)) ;
    Mxf = xfin - (Mf)*(cosd(tita+90)) ;
    Myf = yfin - (Mf)*(sind(tita+90)) ;
    
    qtype = Prob_data.qtype(Prob_data.barfz((Prob_data.barfz(:,1)==ielem),2),2) ;
    if find(qtype==1) ~= 0 % carga distribuida
        Qi = escMf*Elem_data(ielem).FLbar(2) ;
        L  = Elem_data(ielem).conec(6) ;
        Mm = Mi - Qi*L/2 ;
        Mxm = (xini+xfin)/2 + (Mm)*(cosd(tita+90)) ;
        Mym = (yini+yfin)/2 + (Mm)*(sind(tita+90)) ;
        if cosd(tita)==0  % barras verticales
            A = [Myi^2  Myi  1 ;
                 Mym^2  Mym  1 ;
                 Myf^2  Myf  1 ] ;
            b = [Mxi Mxm Mxf ] ;
            ti = inv(A)*b' ;
            if Myf<Myi
                yL = Myi:-10:Myf ;
            else
                yL = Myi: 10:Myf ;
            end
            Mfy = [yL'.^2  yL' ones(size(yL,2),1)]*ti ;             
            xL = Mfy'; Mfx = yL' ;
        else
            A = [Mxi^2  Mxi  1 ;
                 Mxm^2  Mxm  1 ;
                 Mxf^2  Mxf  1 ] ;
            b = [Myi Mym Myf ] ;
            ti = inv(A)*b' ;
            if Mxf<Mxi
                xL = Mxi:-10:Mxf ;
            else
                xL = Mxi: 10:Mxf ;
            end
            Mfx = [xL'.^2  xL' ones(size(xL,2),1)]*ti ;    
        end
        text(Mxm,Mym,num2str(round(Mm/escMf,2))) ;
    else
        xL=[]; Mfx=[];
    end
    
    plot([xini;Mxi;xL';Mxf;xfin],[yini;Myi;Mfx;Myf;yfin],'-b') 
    text(Mxi,Myi,num2str(round(Mi/escMf,2))) ;
    text(Mxf,Myf,num2str(round(Mf/escMf,2))) ;
end
axis equal
title('Momento Flector')
grid
hold off


figure(3) ;hold on
for ielem=1:nelem
    k=1;
    xini = 0.0; yini = 0.0 ; xfin = 0.0 ; yfin = 0.0;
    xini = Prob_data.coord(Elem_data(ielem).conec(k),1);
    yini = Prob_data.coord(Elem_data(ielem).conec(k),2) ; 
    
    k=k+1; 
    xfin = Prob_data.coord(Elem_data(ielem).conec(k),1);
    yfin = Prob_data.coord(Elem_data(ielem).conec(k),2);

    plot([xini;xfin],[yini;yfin],'-k','LineWidth',2)
    Qi = escQ*Elem_data(ielem).FLbar(2) ;
    Qf = escQ*Elem_data(ielem).FLbar(5) ;
    tita = Elem_data(ielem).conec(7) ;
    
    Qxi = xini + (Qi)*(cosd(tita+90)) ;
    Qyi = yini + (Qi)*(sind(tita+90)) ;
    Qxf = xfin - (Qf)*(cosd(tita+90)) ;
    Qyf = yfin - (Qf)*(sind(tita+90)) ;
    
    plot([xini;Qxi;Qxf;xfin],[yini;Qyi;Qyf;yfin],'-b')        
    
    text(Qxi,Qyi,num2str(round(Qi/escQ,2))) ;
    text(Qxf,Qyf,num2str(round(Qf/escQ,2))) ;
end
axis equal
title('Corte')
grid
hold off



figure(4) ;hold on
for ielem=1:nelem
    k=1;
    xini = 0.0; yini = 0.0 ; xfin = 0.0 ; yfin = 0.0;
    xini = Prob_data.coord(Elem_data(ielem).conec(k),1);
    yini = Prob_data.coord(Elem_data(ielem).conec(k),2) ; 
    
    k=k+1; 
    xfin = Prob_data.coord(Elem_data(ielem).conec(k),1);
    yfin = Prob_data.coord(Elem_data(ielem).conec(k),2);

    plot([xini;xfin],[yini;yfin],'-k','LineWidth',2)
    Ni = escN*Elem_data(ielem).FLbar(1) ;
    Nf = escN*Elem_data(ielem).FLbar(1) ;
    tita = Elem_data(ielem).conec(7) ;
    
    Nxi = xini - (Ni)*(cosd(tita+90)) ;
    Nyi = yini - (Ni)*(sind(tita+90)) ;
    Nxf = xfin - (Nf)*(cosd(tita+90)) ;
    Nyf = yfin - (Nf)*(sind(tita+90)) ;
    
    plot([xini;Nxi;Nxf;xfin],[yini;Nyi;Nyf;yfin],'-b')        
    
    text(Nxi,Nyi,num2str(round(Ni/escN,2))) ;
    text(Nxf,Nyf,num2str(round(Nf/escN,2))) ;
end
axis equal
title('Normal')
grid
hold off


