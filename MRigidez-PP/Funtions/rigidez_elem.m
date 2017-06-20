function [kelem] = rigidez_elem(lelem,EA,alfax,alfay,alfaz);
cosel=cosd(alfax);
cosem=cosd(alfay);
cosen=cosd(alfaz);
kelem=zeros(6,6);
kelem=[ cosel*cosel  cosel*cosem  cosel*cosen  -cosel*cosel  -cosel*cosem  -cosel*cosen ;
        cosel*cosem  cosem*cosem cosem*cosen   -cosel*cosem -cosem*cosem -cosem*cosen ;
        cosel*cosen  cosem*cosen cosen*cosen   -cosel*cosen -cosem*cosen -cosen*cosen ;
        -cosel*cosel -cosel*cosem -cosel*cosen cosel*cosel cosel*cosem cosel*cosen ;
        -cosel*cosem -cosem*cosem -cosem*cosen cosel*cosem cosem*cosem cosem*cosen;
        -cosel*cosen -cosem*cosen -cosen*cosen cosel*cosen cosem*cosen cosen*cosen;];
        

kelem=(EA/lelem)*kelem ;