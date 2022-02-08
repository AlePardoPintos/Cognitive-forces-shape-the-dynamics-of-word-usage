%% FIGURE 1

clear all

figure(1);clf
set(gcf,'color','w')
set(gcf,'position',[680 298 750 500])
bordeizq = 0.1;
ancho = .4; %*5
seph = .08; %
bordeinf = .08;
alto1 =.85;
alto =.4;
sepv =.08;
seph = 0.08;

clear handles
handles(1)=axes('position',[bordeizq bordeinf ancho alto1]);
handles(2)=axes('position',[bordeizq+ancho+seph bordeinf+alto+sepv ancho alto]);
handles(3)=axes('position',[bordeizq+ancho+seph bordeinf ancho alto]);

% PANEL A

language='en2020';
load(['./' language '/TIMELINE'])

gpalabras={ 'time' 'work' 'god'}; 

index=arrayfun(@(x) find(ismember({TIMELINE.words.word},x)),gpalabras);


h={};
set(gcf,'currentaxes',handles(2)); hold all
hasta=2000;
line([TIMELINE.desde hasta],[0 0],'color',[.5 .5 .5])
line([1750 1750], [-1.5e-4 2.5e-4],'color','k');
colores = get(gca,'colororder');
colores = [[0 0 .7]; [0  .6 .7];[.6 0 .7]];
colores  = [0 0 1; 0 0.50 1; 0 0.80 1];
colores  = [75 156 211; 15 82 186; 0 35 102]/256;
for indp=1:length(gpalabras)
    set(gcf,'currentaxes',handles(1))
    hold all
    
    years=double(TIMELINE.words(index(indp)).years);
    freqrel=TIMELINE.words(index(indp)).freqrel;
    trend=TIMELINE.words(index(indp)).trend;
    osc=TIMELINE.words(index(indp)).smoothed;%;
    total=trend+osc;    
    
    plot(years,TIMELINE.words(index(indp)).freqrel,'.','Color',colores(indp,:))    
    plot(years,trend,'linewidth',.5,'color','k');
    plot(years,total,'linewidth',.5,'color',colores(indp,:),'linewidth',1.5)
    line([1750 1750], ylim,'color','k')
    ylabel('Word frequency')
    xlabel('Year')
    xlim([TIMELINE.desde hasta])
    ylim([0 2e-3])
    indexpos=length(years)-8;
    if indp==3
        text(years(indexpos)-10,trend(indexpos)-0.0001,gpalabras{indp},...
            'horizontalalignment','right','fontsize',15)
    elseif indp==2
        text(years(indexpos)-8,trend(indexpos)+.00015,gpalabras{indp},...
            'horizontalalignment','right','fontsize',15)
    else
        text(years(indexpos)-8,trend(indexpos),gpalabras{indp},...
            'horizontalalignment','right','fontsize',15)        
    end
    
    % PANEL B
    
    set(gcf,'currentaxes',handles(2))
    hold all
    h{indp}=plot(years,osc,'linewidth',1.5,'color',colores(indp,:));
    ylabel('Oscillatory components')
    xlabel('Year')
    xlim([TIMELINE.desde hasta])
    
   drawnow
end
set(gcf,'currentaxes',handles(2))
legend([h{1:3}],gpalabras,'location','north')


% PANEL C

load('./Wavelets')

ancho=50;
step=0.25;
Scales=1:step:ancho;

bases={'en2020';'es2020';'fr2020';'al2020';'it2020'};

set(gcf,'currentaxes',handles(indp))
hold all

for len=1:length(bases)
    
    PerMax=((8*pi^2/5)^(1/2))*M(len).ScalesMax;
    Periodos=((8*pi^2/5)^(1/2))*Scales;
    [N,edges] = histcounts(PerMax,Periodos);
    edges = edges(2:end) - (edges(2)-edges(1))/2;
    scatter(edges,N,20,'filled');
    [mmax,indmax]=max(N(2:end-1));
    fprintf('%s %2.1f\n',bases{len},edges(indmax))
    box on 
    set(gca, 'YGrid', 'off', 'XGrid', 'on')
end

set(gca,'ytick',[0:2000:20000])
xlim([5.5 80])
ylim([0 9999])
xlabel('Periods (years)')
ylabel('Count')

legend({'English','Spanish','French','German','Italian'})

AxesH = axes('Parent', gcf, ...
  'Units', 'normalized', ...
  'Position', [0, 0, 1, 1], ...
  'Visible', 'off', ...
  'XLim', [0, 1], ...
  'YLim', [0, 1], ...
  'NextPlot', 'add');
letras='abc'    ;
for indp=1:length(letras)
    set(gcf,'currentaxes',handles(indp))

    if indp==1
        posx = min(xlim)+range(xlim)*(.05+.04);
        posy = max(ylim)-range(ylim)*(.05-.03);
    else
        posx = min(xlim)+range(xlim)*.02;
        posy = max(ylim)-range(ylim)*.05;
    end
    text(posx,posy,letras(indp),'fontsize',20)   
end



%% FIGURE 2 

clear all
figure(2);clf

set(gcf,'color','w')

set(gcf,'position',[30 148 800 800])

bordeizq = 0.08;
ancho1 = .27;
ancho2 = .27;
seph = .10; %
seph2 = .01; %
bordeinf = .08;
alto1 =.39;
alto2 =alto1/3;
sepv=0.1;


clear handles
handles(1)=axes('position',[bordeizq+ancho1+seph+ancho2             bordeinf+alto2+sepv ancho1 alto1]);
handles(2)=axes('position',[5             bordeinf ancho1 alto1]);

handles(3)=axes('position',[bordeizq bordeinf+5*alto2+sepv ancho2 alto2]);
handles(4)=axes('position',[bordeizq bordeinf+4*alto2+sepv ancho2 alto2]);
handles(5)=axes('position',[bordeizq bordeinf+3*alto2+sepv ancho2 alto2]);

handles(6)=axes('position',[bordeizq bordeinf+2*alto2 ancho2 alto2]);
handles(7)=axes('position',[bordeizq bordeinf+1*alto2 ancho2 alto2]);
handles(8)=axes('position',[bordeizq bordeinf+0*alto2 ancho2 alto2]);

handles(9)=axes('position',[bordeizq+ancho2+seph2 bordeinf+5*alto2+sepv ancho2 alto2]);
handles(10)=axes('position',[bordeizq+ancho2+seph2 bordeinf+4*alto2+sepv ancho2 alto2]);
handles(11)=axes('position',[bordeizq+ancho2+seph2 bordeinf+3*alto2+sepv ancho2 alto2]);

handles(12)=axes('position',[bordeizq+ancho2+seph2 bordeinf+2*alto2 ancho2 alto2]);
handles(13)=axes('position',[bordeizq+ancho2+seph2 bordeinf+1*alto2 ancho2 alto2]);
handles(14)=axes('position',[bordeizq+ancho2+seph2 bordeinf+0*alto2 ancho2 alto2]);

elegidastrend = [23 11];

elegidasosc = [13 25];

% PANEL E
language='en2020';
load(['./' language '/DataTrendFig2'])
dt=ft;
st=mean(shuffle);
load(['./' language '/DataOscFig2'])
do=ft;
so=mean(shuffle);

set(gcf,'currentaxes',handles(1))
hold all
box on
barwidth=0.7;
bar(1,mean(do),barwidth,'facecolor',[1 1 1])
plot([1 1],mean(do)+[-sem(do) sem(do)],'linewidth',3,'color',[.3 .3 .3])
bar(2,mean(dt),barwidth,'facecolor',[.7 .7 .7])
plot([2 2],mean(dt)+[-sem(dt) sem(dt)],'linewidth',3,'color',[.3 .3 .3])
bar(3,mean(so),barwidth,'facecolor',[.4 .4 .4])
plot([3 3],mean(so)+[-sem(so) sem(so)],'linewidth',3,'color',[.3 .3 .3])
set(gca,'xtick',[1 2 3],'xticklabel',{'Oscillations' 'Trends' 'Shuffle'})
ylabel('Semantic similarity')
ylim([0.07 0.25])
xlim([0.2 3.8])

[h p ci s]=ttest2(dt,do);
fprintf('h: %g\tp: %g\tc: [%g - %g]\tt-stat: %g\tdf: %g\tsd: %g\n',h,p,ci(1),ci(2),s.tstat,s.df,s.sd)
[h p ci s]=ttest2(dt,st);
fprintf('h: %g\tp: %g\tc: [%g - %g]\tt-stat: %g\tdf: %g\tsd: %g\n',h,p,ci(1),ci(2),s.tstat,s.df,s.sd)
[h p ci s]=ttest2(do,so);
fprintf('h: %g\tp: %g\tc: [%g - %g]\tt-stat: %g\tdf: %g\tsd: %g\n',h,p,ci(1),ci(2),s.tstat,s.df,s.sd)

% PANEL A Y B
load(['./' language '/clusters_trend'])
load(['./' language '/TIMELINE'])
load(['./' language '/clusters_trend_subcom'])

TREND=reshape([TIMELINE.words.trend],length(TIMELINE.words(1).years),...
    length([TIMELINE.words]))';
OSC=reshape([TIMELINE.words.smoothed],length(TIMELINE.words(1).years),...
    length([TIMELINE.words]))';



elegidas=elegidastrend;
paneles=[[6 7 8];[12  13 14]];

for indcomunidad=1:length(elegidas)

    comunidad=elegidas(indcomunidad);

    index=find(T==megustan(comunidad));
    [ParOrden,ang] = fp_nouns.calcula_parametro_orden(index,desde,hasta,OSC);
    Nyears=length(desde:hasta);    
    Nwords=length(index);        
       
    
    
    palabras=subcom{indcomunidad};
    index_subcom=find(ismember({TIMELINE.words.word},palabras));
    PAL=struct('palabra',palabras,'count',num2cell([TIMELINE.words(index_subcom).tot]));

    if indcomunidad==1
        wordcloud({PAL.palabra},[PAL.count],'position',[.45-.36 .35 .16 .1],...
            'MaxDisplayWords',CuantasCloud);                
    elseif indcomunidad==2
        wordcloud({PAL.palabra},[PAL.count],'position',[.75-.36 .38 .16 .1],...
            'MaxDisplayWords',CuantasCloud);                        
    end    
    


    %trends
    set(gcf,'currentaxes',handles(paneles(indcomunidad,1)));
    for indp=1:length(index_subcom)
        yplot=TREND(index_subcom((indp)),desde:hasta);
        yplot=yplot/max(yplot);
        plot(TIMELINE.words(1).years(desde:hasta),yplot); hold on;       % data
    end 
    box off
    set(gca,'xcolor','none')
    set(gca,'ytick',[])
    if indcomunidad==1
        ylabel('Trends')
    end
    if indcomunidad==1
        ylim([-.5 1])    
    else
        ylim([-.1 1]) 
    end
    yticks([0 1])
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    
    %oscilaciones
    ZZ=OSC(index_subcom,desde:hasta)'; 
    set(gcf,'currentaxes',handles(paneles(indcomunidad,2)));
    hold all   
    hh=line(TIMELINE.words(1).years([desde hasta]),[0 0],'color','k','linewidth',1);
    nomuestraenlegend(hh);
    for indp=1:length(index_subcom)
        plot(TIMELINE.words(1).years(desde:hasta),ZZ(:,indp)/max(abs(ZZ(:,indp)))); hold on;
    end        

    box off
    set(gca,'xcolor','none')
    ylim([-1 1])
    if indcomunidad==1
        ylabel('Oscilations')
    end    
    yticks([0])
    set(gca,'ytick',[])
    set(gca,'xtick',[])    

    
    %parámetro de orden
    set(gcf,'currentaxes',handles(paneles(indcomunidad,3)));
    plot(TIMELINE.words(1).years(desde:hasta),smooth(ParOrden,4),'k');hold on;
    plot(TIMELINE.words(1).years(desde:hasta),mean(ParOrden)*ones(1,Nyears),'--b');
    ylim([0 1])
    box off    
    xlabel('Year')
    if indcomunidad==1
        ylabel('Coherence \rho')
    else
        set(gca,'yticklabel',[])
    end
    ylim([0 1])
    yticks([0 1])
    
    linkaxes(handles(paneles(indcomunidad,:)),'x')
 
    xlim([1750 1999])    
   
    
end

% PANEL C Y D
CuantasCloud=15;

load(['./' language '/clusters_osc'])
load(['./' language '/TIMELINE'])
TREND=reshape([TIMELINE.words.trend],length(TIMELINE.words(1).years),...
    length([TIMELINE.words]))';
OSC=reshape([TIMELINE.words.smoothed],length(TIMELINE.words(1).years),...
    length([TIMELINE.words]))';

elegidas=elegidasosc;
paneles=[[3 4 5];[9 10 11]];

for indcomunidad=1:length(elegidas)

    comunidad=elegidas(indcomunidad);
  
    index=find(T==megustan(comunidad));
    [ParOrden,ang] = fp_nouns.calcula_parametro_orden(index,desde,hasta,OSC);
    Nyears=length(desde:hasta);    
    Nwords=length(index);        
    ZZ=OSC(index,desde:hasta)';    
  
    
    palabras={TIMELINE.words(index).word};
    PAL=struct('palabra',palabras,'count',num2cell([TIMELINE.words(index).tot]));    
    if indcomunidad==1
        wordcloud({PAL.palabra},[PAL.count],'position',[.47-.36 .82 .16 .1],...
            'MaxDisplayWords',CuantasCloud);                
    elseif indcomunidad==2
        wordcloud({PAL.palabra},[PAL.count],'position',[.77-.36 .82 .16 .1],...
            'MaxDisplayWords',CuantasCloud);                        
    end  
        

    %trends   
    set(gcf,'currentaxes',handles(paneles(indcomunidad,1)));
    for indp=1:length(index)
        yplot=TREND(index((indp)),desde:hasta);
        yplot=yplot/max(yplot);
        plot(TIMELINE.words(1).years(desde:hasta),yplot); hold on;
    end
    
    box off
    set(gca,'xcolor','none')
    set(gca,'ytick',[])
    if indcomunidad==1
        ylabel('Trends')
    end
    ylim([-.5 1])

    yticks([0 1])
    set(gca,'ytick',[])
    set(gca,'xtick',[])

    
    %oscilaciones
    set(gcf,'currentaxes',handles(paneles(indcomunidad,2)));
    hold all   

    for indp=1:Nwords
        plot(TIMELINE.words(1).years(desde:hasta),ZZ(:,indp)/max(abs(ZZ(:,indp)))); hold on;
    end        
    box off
    set(gca,'xcolor','none')
    ylim([-1 1])
    if indcomunidad==1
        ylabel('Oscilations')
    end
    yticks([0])
    set(gca,'ytick',[])
    set(gca,'xtick',[])

    
    %parámetro de orden
    set(gcf,'currentaxes',handles(paneles(indcomunidad,3)));
    plot(TIMELINE.words(1).years(desde:hasta),smooth(ParOrden,4),'k');hold on;

    ylim([0 1])
    box off
    xlabel('Year')
    if indcomunidad==1
        ylabel('Coherence \rho')
    else
        set(gca,'yticklabel',[])
    end
    ylim([0 1])
    yticks([0 1])

    linkaxes(handles(paneles(indcomunidad,:)),'x')
    xlim([1750 1999])
    

end

AxesH = axes('Parent', gcf, ...
  'Units', 'normalized', ...
  'Position', [0, 0, 1, 1], ...
  'Visible', 'off', ...
  'XLim', [0, 1], ...
  'YLim', [0, 1], ...
  'NextPlot', 'add');
letras='eda  c  b  d'    ;
for indp=1:12
    pos=get(handles(indp),'position');
    posx=pos(1)+.01;
    posy=pos(2)+pos(4)+.02;
    text(posx,posy,letras(indp),'fontsize',20)
end

%hago todo transparente
for indp=1:14
    set(handles(indp),'color','none')
end
%cambio el orden para que los wordclouds vayan al fondo
children=get(gcf,'children');
set(gcf,'Children', children(end:-1:1));


%% FIGURE 3
clear all

figure(3);clf

set(gcf,'color','w')

x0=30;
y0=200;
width=1200;
height=400;
set(gcf,'position',[x0,y0,width,height])

bordeizq = 0.05;
ancho1 = .3;
ancho2 = .22;
seph1 = .04*1.5;
bordeinf = .12;
alto1 =.82;
alto2 =alto1 /2;


clear handles
handles(1)=axes('position',[bordeizq                       bordeinf       ancho1 alto1]);
handles(2)=axes('position',[bordeizq+ancho1+seph1          bordeinf+alto2 ancho2 alto2]);
handles(3)=axes('position',[bordeizq+ancho1+seph1          bordeinf       ancho2 alto2]);
handles(4)=axes('position',[bordeizq+ancho1+seph1*2+ancho2 bordeinf       ancho1 alto1]);

elegidas=[6851 3422];
language='en2020';
load(['./' language '/Ajustes'])
medidas={'corrtotal';'corrosc';'disttotal';'distosc';'SumaCODT'};
load(['./' language '/TIMELINE'])

% PANEL A
set(gcf,'currentaxes',handles(1));
hold all


ylabel('\tau (years)')
xlabel('r (years^{-1})')
xx=.1:.01:2;
plot(xx,8./(27*xx),'k','linewidth',4)
xlim([.21 0.98])
ylim([0.1 11.5])
xticks([0.3:0.1:1])
posmaximos=[Todo.posmaximos];
Razon=[Todo.razon];
maximos=[Todo.maximos];

indp=5;

x=rs([posmaximos.(medidas{indp})]);
x=x+(rand(size(x))-1/2).*0.01;
y=taus([posmaximos.(medidas{indp})]);
C=[Razon.(medidas{indp})];
y=y+(rand(size(y))-1/2).*0.1;
indice=[Razon.(medidas{indp})]>0.75 & [Razon.(medidas{indp})]<1.25;
Indices=find(indice);

hold on
xx=.1:.01:2;
plot(xx,8./(27.*xx),'k','linewidth',4)

h=scatter(x(indice),y(indice),10,'k','o','filled');
h.CData = [.5 .5 .5];
colormap bone

scatter(x(elegidas(1)),y(elegidas(1)), 40,'filled', 'r')
scatter(x(elegidas(2)),y(elegidas(2)), 40,'filled', 'r')

imagedir='./imagenes/';

% [left bottom width height]
%AMORTIGUADO
axes('position',[.13 .25 .09 .19]);
I=importdata([imagedir 'Imagen1.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);

%HOPF
axes('position',[.25 .7 .09 .19]);
I=importdata([imagedir 'Imagen3.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);

%REALES
axes('position',[.028 .023 .09 .19]);
I=importdata([imagedir 'Imagen2.png']);
h=image(I.cdata);
set(gca,'xcolor','none','ycolor','none','color','none')
set(h, 'AlphaData', I.alpha);


% PANEL B Y C
pal1=Todo(elegidas(1)).indpal;
pal2=Todo(elegidas(2)).indpal;
set(gcf,'currentaxes',handles(2))
ind=pal1;
plot(TIMELINE.words(ind).years,TIMELINE.words(ind).smoothed+TIMELINE.words(ind).trend,'k')
hold on
plot(TIMELINE.words(ind).years,Todo(elegidas(1)).soluciones.SumaCODT,'r')
ylabel('Relative Frequency')
yticks([1e-6:1e-6:3e-6]);
text(1915,2e-6,TIMELINE.words(ind).word)
set(gca,'xticklabel',[])
xlim([1750 2000])
ylim([-0.1e-6 3e-6])
h=legend({'Experimental','Model'},'Position',[0.47 0.83 0.01 0.02]);
h.EdgeColor='none';
set(h,'color','none')

set(gcf,'currentaxes',handles(3))
ind=pal2;
plot(TIMELINE.words(ind).years,TIMELINE.words(ind).smoothed+TIMELINE.words(ind).trend,'k')
hold on
plot(TIMELINE.words(ind).years,Todo(elegidas(2)).soluciones.SumaCODT,'r')
xlim([1750 2000])
ylabel('Relative Frequency')
xlabel('Year')
text(1915,8e-6,TIMELINE.words(ind).word)
yticks([0 .2e-5 .6e-5 1e-5]);


% PANEL D
set(gcf,'currentaxes',handles(4));
bases={'en2020';'fr2020';'al2020';'it2020';'es2020'};
mincom=9;
colores='brypg';
for len=1:length(bases)
    language=bases{len};
   
    load(sprintf('./%s/stat_shuffle',language))
    mediashuffle=meantrue;
    
    load(sprintf('./%s/stat_true',language))
    mediasreal=meantrue;

    
    load(sprintf('./%s/stat_con_trend',language))
    D=CS{1};
    index=[D.n_palabras]>mincom;
    mediacontrend=[D(index).mean_par];
    
    load(sprintf('./%s/stat_sin_trend',language))
    C=CS{1};
    index=[C.n_palabras]>mincom;
    mediasintrend=[C(index).mean_par];


    medias=[nanmean(mediasreal) nanmean(mediashuffle) mean(mediasintrend) nanmean(mediacontrend)];
    err=[nansem(mediasreal) nansem(mediashuffle') sem(mediasintrend) nansem(mediacontrend)];
    
    errorbar((0.7+0.1*len:3.7+0.1*len),medias,err...
        ,'linestyle','none','linewidth',3,'capsize',0);hold all

end

ylim([0.19 0.45])
xpos = [1:4];
row1 = {'Exp' '   Exp' '   Sim' '  Sim'};
row2 = {'' 'Shuffled' 'no trend' ' trend'};
labelArray = [row1; row2];
tickLabels = (sprintf('%s\\newline%s\n', labelArray{:}));
set(gca,'xtick',xpos,'xticklabel',tickLabels )
set(gca, 'YGrid', 'on', 'XGrid', 'off','ytick',[0.1:0.05:0.9])
xlim([.5 4.5])
ylabel('Phase Coherence \rho')

hhh=plot([1 1 5 5],[.79 .85 .85 .79],'color',[.5 .5 .5]);
nomuestraenlegend(hhh)
xpos=[min(xlim) 2.5] ;
ypos=ylim;
x = xpos([1 2 2 1 1]);
y = ypos([1 1 2 2 1]);
p=patch(x,y,'k');
set(p,'FaceAlpha',0.1,'linestyle','none');
legend({'English','Spanish','French','German','Italian'},'Position',[0.84 0.8 0.01 0.02])

AxesH = axes('Parent', gcf, ...
  'Units', 'normalized', ...
  'Position', [0, 0, 1, 1], ...
  'Visible', 'off', ...
  'XLim', [0, 1], ...
  'YLim', [0, 1], ...
  'NextPlot', 'add');
letras='abcd'    ;
for indp=1:4
    pos=get(handles(indp),'position');
    posx=pos(1)+.01;
    posy=pos(2)+pos(4)-.04;
    text(posx,posy,letras(indp),'fontsize',20)
end



%% SUPPLEMENTARY FIGURE 1.1 Wavelet

clear all
load('./Wavelets')

ancho=50;
step=0.25;
Scales=1:step:ancho;

bases={'en2020';'es2020';'fr2020';'al2020';'it2020'};

figure(10);clf;
set(gcf,'position',[300 100 600 800])
subplot(2,1,2)
set(gca,'position',[.1 .09 .85 .41])
hold all

for len=1:length(bases)
    
    PerMax=((8*pi^2/5)^(1/2))*M(len).ScalesMax;
    Periodos=((8*pi^2/5)^(1/2))*Scales;
    [N,edges] = histcounts(PerMax,Periodos);
    edges = edges(2:end) - (edges(2)-edges(1))/2;
    plot(edges,N,'-o');
    [mmax,indmax]=max(N(2:end-1));
    fprintf('%s %2.1f\n',bases{len},edges(indmax))
    box on 
    set(gca, 'YGrid', 'off', 'XGrid', 'on')
end

set(gca,'ytick',[0:2000:20000])
xlim([5.5 80])
ylim([0 9999])
xlabel('Periods (years)')
ylabel('Count')

language='en2020';
load(['./' language '/TIMELINE'])
DataCruda=reshape([TIMELINE.words.freqrel],length(TIMELINE.words(1).years),length(TIMELINE.words))';
TREND=reshape([TIMELINE.words.trend],length(TIMELINE.words(1).years),length(TIMELINE.words))';
OscCruda=DataCruda-TREND;

ancho=50;
step=0.25;
Scales=1:step:ancho;
ScalesMax=[];

axes('position',[.68 .28 .25 .20])
set(gca,'position',[.60 .28 .33 .20])
    
load EscalogramaEjemplo

datafil=imgaussfilt(data,[6 3],'FilterSize',[21 21]);
x=TIMELINE.words(1).years;
y=Scales;
ix=find(imregionalmax(abs(datafil)));
[row,col]=ind2sub(size(datafil),ix);
imagesc(x,y,datafil);hold on
colormap('jet')
caxis(caxis/2)

index=col~=1 & col~=size(datafil,2) & row~=1 & row~=size(datafil,1);
scatter(x(col(index)),y(row(index)),10,'filled','k')
ylabel('Scale Index')
xlabel('Year')    


%% SUPPLEMENTARY FIGURE 1.2 Fourier
clear all
languages={'en2020','es2020','fr2020','al2020','it2020'};
languages_label={'English','Spanish','French','German','Italian'};

figure(10)

subplot(2,1,1);
set(gca,'position',[0.1 0.5 0.85  0.41])
hold all;


for indlang = 1:length(languages)
    language=languages{indlang};
    fprintf('Loading %s ',language)
    load(['./' language '/TIMELINE'])
    DataCruda=reshape([TIMELINE.words.freqrel],...
        length(TIMELINE.words(1).years),length(TIMELINE.words))'; 
    TREND=reshape([TIMELINE.words.trend],...
        length(TIMELINE.words(1).years),length(TIMELINE.words))'; 

    OSC=DataCruda-TREND;

    Fs=1;
    desde=1;
    hasta=270;

    C=OSC;
    rowmin= min(C,[],2);
    rowmax=max(C,[],2);

    redmat=C(:,desde:hasta);
    redmat=redmat';

    fprintf('(%d, %d)\n',size(redmat,1),size(redmat,2))
    
    filas=size(redmat,1);
    columnas=size(redmat,2);

    redmat = redmat./repmat(std(redmat),filas,1);
    
    vec = redmat(:,randperm(columnas));    

    for indvec = 1 : size(vec,2)
        hastadonde = randi(100)-1;
        vec(1:hastadonde,indvec) = nan;
    end        

    vec=vec(:);
    vec(isnan(vec))=[];

    vec = vec - mean(vec);
    L=length(vec);

    Y=fft(vec);
    P2 = abs(Y/L);
    P1 = P2(round(1:L/2+1));
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;

    curvas = P1/(f(2)-f(1));
    
    CUANTOSMOOTH=1000;    
    data_suavizado=smooth(curvas,CUANTOSMOOTH);    
    data_suavizado = lowpass(data_suavizado,10,1);

    data_suavizado=data_suavizado/sum(data_suavizado)*columnas;

    f_concatenado=f+f(2);
    dataplot = data_suavizado;        

    cuantodesplazo = 0.0025;
    plot(1./f,indlang*cuantodesplazo+dataplot,'-','displayname',languages_label{indlang});

    ylabel('FFT power [Arb. Units]')
    set(gca,'xticklabel','')
    set(gca,'yticklabel','')
    xlim([5.5 80])    
   ylim([0.009 0.033])      
    box on
    set(gca, 'YGrid', 'off', 'XGrid', 'on')
end
legend;


%% SUPPLEMENTARY FIGURE 2.1 BANDPASS 
clear all

ventanas=1:10;
language='en2020';
load(sprintf('./%s/PasabandaVent',language))

figure(4);clf;
set(gcf,'position',[300 100 900 400])
h(1) = axes('position',[.55 .12 .43 .85]);
h(2)= axes('position',[.03 .55 .15 .3]);
h(3) = axes('position',[.15 .6 .2 .2]);
h(4) = axes('position',[.25 .15 .3 .3]);
h(5) = axes('position',[.25 .55 .3 .3]);

annotation('rectangle',[0.018,0.52,0.46,0.385])

set(gcf,'currentaxes',h(1))
hold all
for ve=3
    
    ventana=ventanas(ve);
    x=(1./fcosc(1:(end-ventana))+1./fcosc((1:(end-ventana))+ventana))/2;
    hhh=plot(x,M(ve,1:end-ventana+1),'-','displayname',sprintf('%i years',ventana)); 
    scatter(x,M(ve,1:end-ventana+1),[],hhh.Color,'filled')

    xlabel('Frequency [1/years]')
    ylabel('Similarity between FastText and TimeSeries')
    box on
    set(gca,'xtick',0:5:25,'xticklabel',{'Inf' '1/5' '1/10' '1/15' '1/20' '1/25'})

end


%% SUPPLEMENTARY FIGURE 2.2 IMAGES

language='en2020';
load(sprintf('./%s/TIMELINE.mat',language))

sd = nan(100,1);
for indw=1:100
    y = TIMELINE.words(indw).freqrel-TIMELINE.words(indw).trend;
    sd(indw) = std(y);
end
[sorted,indsorted]=sort(sd);

figure(4);
cla(h(2))
cla(h(3))
cla(h(4))
cla(h(5))

set(gcf,'currentaxes',h(2))
hold all
for inds=1:5
    indw=indsorted(inds);
    x = TIMELINE.words(indw).years;
    y = TIMELINE.words(indw).freqrel-TIMELINE.words(indw).trend;
    cuantodesplazo =7e-5;
    plot(x,y+cuantodesplazo*inds,'k','linewidth',1.5)
end
xlim([min(x) max(x)])
set(gca,'xtick',[],'ytick',[])
set(gca,'xcolor','none','ycolor','none')
title('Timeseries')

set(gcf,'currentaxes',h(3))
[~,~,I]=imread('./imagenes/bandpasssymbol.png');
image(I)
colormap(1-gray)
set(gca,'xcolor','none','ycolor','none')
axis square
title('Bandpass')

set(gcf,'currentaxes',h(4))
load(sprintf('./%s/mysim',language))
imagesc(mysim(1:20,1:20))
axis square
colormap(1-bone)
set(gca,'xtick',[],'ytick',[])
title('FastText Similarity S')

set(gcf,'currentaxes',h(5))
load(sprintf('./%s/MyCorrPasabanda',language))
imagesc(mysim(1:20,1:20))
axis square
colormap(1-bone)
set(gca,'xtick',[],'ytick',[])
title('Dynamic Similarity M')

AxesH = axes('Parent', gcf, ...
  'Units', 'normalized', ...
  'Position', [0, 0, 1, 1], ...
  'Visible', 'off', ...
  'XLim', [0, 1], ...
  'YLim', [0, 1], ...
  'NextPlot', 'add');
letras='cab'    ;
xs = [.56 .03 .3];
ys = [.95 .95 .47];
for indp=1:3
    pos=get(h(indp),'position');
    posx=xs(indp);
    posy=ys(indp);
    text(posx,posy,letras(indp),'fontsize',20)
end

