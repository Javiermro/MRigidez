function PlotEstructura(Elem_data,Prob_data)
global nelem nnodo ndime ndofs npoin nfixe nload

conec = Prob_data.conec ;
coord = Prob_data.coord ;
fixed = Prob_data.fixed ;
escq  = Prob_data.esc(4) ;

hold on
k=1;
if ndime==3
%     for ielem=1:nelem
%       for inod=1:nnodo 
%         xini(ielem)=coord(conec(ielem,k),1);
%         yini(ielem)=coord(conec(ielem,k),2) ; 
%         zini(ielem)=coord(conec(ielem,k),3);
%         k=k+1; 
%         if k>nnodo
%           k=1;
%         end
%         xfin(ielem)=coord(conec(ielem,k),1);
%         yfin(ielem)=coord(conec(ielem,k),2);
%         zfin (ielem)=coord(conec(ielem,k),3);
%         plot3([xini;xfin],[yini;yfin],[zini;zfin],'-k','LineWidth',2)        
%       end
%     end
else
    for ielem=1:nelem
        for inod=1:nnodo 
            xini=coord(conec(ielem,k),1);
            yini=coord(conec(ielem,k),2) ; 
            k=k+1; 
            if k>nnodo ; k=1 ; end
            xfin=coord(conec(ielem,k),1);
            yfin=coord(conec(ielem,k),2);
            plot([xini;xfin],[yini;yfin],'-k','LineWidth',2)
        end
                
        for ibfor=1:size(Prob_data.barfz,1)
            if ielem==Prob_data.barfz(ibfor,1) 
                tipo = Prob_data.qtype(Prob_data.barfz(ibfor,2),2);
                if tipo == 1  % carga uniformemente distribuida
                    q     = escq*Prob_data.qtype(Prob_data.barfz(ibfor,2),5)    ;
                    tita  = Prob_data.conec(ielem,7)   ;  

                    qxi = xini - q*(cosd(tita+90)) ;
                    qyi = yini - q*(sind(tita+90)) ;
                    qxf = xfin - q*(cosd(tita+90)) ;
                    qyf = yfin - q*(sind(tita+90)) ;
                    xm  = (qxi + qxf)/2 ; 
                    ym  = (qyi + qyf)/2/2 ; 

                    plot([xini;qxi;qxf;xfin],[yini;qyi;qyf;yfin],'-b','LineWidth',1) 
                    t=text(xm,ym,['q=' num2str(q/escq)]) ;  
                    t.Color = 'blue' ;
                elseif tipo == 2  % carga puntual en cualquier posición
                    
                end
            end
        end
        
    end
end


for infor=1:size(Prob_data.nodfz,1)
    inod = Prob_data.nodfz(infor,1) ;
    esc = 0.1*max(conec(:,6));
    x0 = coord(inod,1) ; y0 = coord(inod,2) ;
    
    if (Prob_data.nodfz(infor,2)~=0 || Prob_data.nodfz(infor,3)~=0) % Fuerza
        Px = esc*Prob_data.nodfz(infor,2) ;
        Py = esc*Prob_data.nodfz(infor,3) ;
        quiver(x0+Px,y0-Py,Px,Py,'-r')
        t=text(x0+Px,y0-Py,['P =' num2str(sqrt((Px/esc)^2+(Py/esc)^2))]) ; 
        t.Color = 'red' ;
    end
        
    if Prob_data.nodfz(infor,4)<0
        R = 1*esc; tita = (-0.1667*pi:0.01:1.1667*pi); 
        x = x0+R*cos(tita); y = y0+R*sin(tita); plot(x,y,'-g'); axis equal
        % Momento -
        plot(x0+[R*cosd(30) R*cosd(30)],y0+[0 -R*sind(30)],'g')
        plot(x0+[(R*cosd(30)+R*sind(30)*tand(30)) R*cosd(30)],...
            y0+[-0.1*R -R*sind(30)],'g')
        t=text(x0-R,y0,['M =' num2str(Prob_data.nodfz(infor,4))]) ;
        t.Color = 'green' ;
    elseif Prob_data.nodfz(infor,4)>0
        R = 1*esc; tita = (-0.1667*pi:0.01:1.1667*pi); 
        x = x0+R*cos(tita); y = y0+R*sin(tita); plot(x,y,'-g'); axis equal
        % Momento +
        plot(x0+[-R*cosd(30) -R*cosd(30)],y0+[0 -R*sind(30)],'g')
        plot(x0+[-(R*cosd(30)+R*sind(30)*tand(30)) -R*cosd(30)],...
            y0+[-0.1*R -R*sind(30)],'g')  
        t=text(x0+R,y0,['M =' num2str(Prob_data.nodfz(infor,4))]) ;
        t.Color = 'green' ;
    end    
end

%% grafica los vinculos externos
for ifix=1:nfixe
    inod= fixed(ifix,1) ;
    fix = fixed(ifix,[2 3 4 ]) ;
    esc = 0.1*max(conec(:,6));
    [elem,c] = find(inod==Prob_data.conec(:,[1 2])) ;
    ang = conec(elem,7) ;
    if find(fix==1)==1 % Apoyo simple en direccion x-x         
        PlotApoyos(coord(inod,1),coord(inod,2),esc,'ASxx',0)
    elseif find(fix==1)==2 % Apoyo simple en direccion y-y    
        PlotApoyos(coord(inod,1),coord(inod,2),esc,'ASyy',0)
    elseif find(fix==1)==3 % Apoyo simple en direccion z-z
        error('No existe vinculo que solo limite la rotacion')
    elseif size(find(fix==1),2)==2 % Apoyo doble    
        PlotApoyos(coord(inod,1),coord(inod,2),esc,'AD',0)
    elseif size(find(fix==1),2)==3 % Empotramiento  
        if c==1
            PlotApoyos(coord(inod,1),coord(inod,2),esc,'E',ang+90)
        elseif c==2
            PlotApoyos(coord(inod,1),coord(inod,2),esc,'E',ang-90)
        end        
    end
        
    
end


%% Imprime la numeración de los nodos
for ipoin=1:npoin 
    t=text(coord(ipoin,1),coord(ipoin,2),num2str(ipoin) );
    t.Color = 'red' ;
end
axis equal
title('Estructura indeformada')
grid
hold off
