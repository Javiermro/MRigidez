function [KGcon,FGcon,ifixe] = CondBorde(KGlob,FGlob,fixed)
global nelem nnodo ndime ndofs npoin nfixe nload

ifixe=zeros(ndofs*npoin,2);

for i=1:nfixe
    npos=(fixed(i,1)-1)*ndofs+1 ;
    ifixe(npos,:)=fixed(i,[2 5]) ;
    ifixe(npos+1,:)=fixed(i,[3 6]) ;
    ifixe(npos+2,:)=fixed(i,[4 7]) ;
end
nfix=find(ifixe(:,1)==0);
KGcon=KGlob(nfix,nfix);
fix=find(ifixe(:,1)==1);
for i=1:length(fix)
    j=fix(i);
    FGlob = FGlob - KGlob(:,j)*ifixe(j,2);
end
FGcon=FGlob(nfix);
   
return
