function corda=actual_coord2D(coord,npoin,despl,ndime,ndofs)

corda=zeros(npoin,ndime);
k=0;
for i=1:npoin
  x1(i)=coord(i,1) ;
  y1(i)=coord(i,2) ;
  x2(i)=x1(i) + despl(k+1);
  y2(i)=y1(i) + despl(k+2);
  k=k+ndofs;
end
[corda]=[x2' y2' ];


