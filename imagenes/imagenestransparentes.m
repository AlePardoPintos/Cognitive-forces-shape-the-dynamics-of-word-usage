figure(1);clf

imagedir='./imagenes/';
imagedir='';

x=0:100;
y=sin(x/5);
plot(x,y)

%               [left bottom width height] en fracción de la figura
axes('position',[.1 .7 .2 .2]);
I=importdata([imagedir 'Imagen1.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);


axes('position',[.6 .7 .2 .2]);
I=importdata([imagedir 'Imagen2.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);

axes('position',[.1 .1 .2 .2]);
I=importdata([imagedir 'Imagen3.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);