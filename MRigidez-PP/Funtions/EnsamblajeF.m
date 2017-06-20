function FGlob = EnsamblajeF(loads)
global nelem nnodo ndime ndofs npoin nfixe nload

FGlob = zeros(npoin*ndofs,1) ;
% for ielem=1:nelem
%     for igl=1:nnodo*ndofs
%         FGlob(igl,1) = FGlob(igl,1) + FGbar(igl,ielem) ;
%     end
% end

npos = 0 ;
for ifix=1:nload
for inodo=1:npoin
  npos=(inodo-1)*ndofs+1;
  if inodo==loads(ifix,1)    
    FGlob(npos,1)=loads(ifix,2) ;
    npos=npos+1;
    FGlob(npos,1)=loads(ifix,3) ;
    npos=npos+1;
    FGlob(npos,1)=loads(ifix,4) ;
  else
%     FGlob(npos)=0.0
%     npos=npos+1;
%     FGlob(npos)=0.0
%     npos=npos+1;
%     FGlob(npos)=0.0
  end     
end
end


