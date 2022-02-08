classdef Corpus
    properties
        name
        desde
        hasta
        words
    end

    
    methods
        function obj=Corpus(name)
            obj.name=name;
            datadir=GetDataDir;
            
            % language='en';datadir='E:\DIEGO_COMPARTIDO\_LABO_DATOS\ngrams\english 2020\storage.googleapis.com\books\ngrams\books\20200217\eng\out\';
            % language='es';datadir='E:\DIEGO_COMPARTIDO\_LABO_DATOS\ngrams\spanish 2020\';
            datadir=strcat(datadir,obj.name,'/');
            language=obj.name;
            obj=Corpus.GetDesdeHasta(language,obj);

            obj.words=[];
            tic
            tstart=tic;
            slCharacterEncoding('UTF-8');   %lee los acentos
            d=dir([datadir '/' language '/lista_NOUN_*.txt']);
            cota=1E6;
            obj=Corpus.CargoListas(cota,obj,datadir);
            slCharacterEncoding('windows-1252')%vuelvo a la normalidad
            disp('listo')
            fprintf('Me quedan %d palabras despu�s de cargar todo\n',length(obj.words))
            toc
            obj=Corpus.SacoChirimbolos(language,obj);
            
            obj=Corpus.ColapsoMinusculas(obj);% colapso man y MAN y Man
            assignin('base','timeline',obj)

            % ESPA�OL: 10518 palabras
            % Ingles: 23524 palabras
            
            [obj,COL]=Corpus.ColapsoPlurales(obj,language);
            
            % ESPA�OL: 8064 palabras
            % Ingles: 18322 palabras
            outfilename=['../Data/' language '/plurales colapsados.xlsx'];
%             delete(outfilename)
            writetable(struct2table(COL),outfilename)

            TOT=Corpus.CargoTotales(obj);
            index=[TOT.year]>=obj.desde & [TOT.year]<=obj.hasta;
            TOT=TOT(index);
            
            for indp=1:length(obj.words)
                obj.words(indp).freqrel=double(obj.words(indp).samples) ./ [TOT.words]';
                obj.words(indp).tot=sum(obj.words(indp).samples);
            end
            [~,indsorted]=sort([obj.words.tot],'descend');
            obj.words=obj.words(indsorted);
            
        end
 
    end
    
    
    methods (Static)
        function TOT = CargoTotales(obj)
%             disp('sacado de http://stanford.edu/~risi/tutorials/absolute_ngram_counts.html')
            %bajado de http://storage.googleapis.com/books/ngrams/books/googlebooks-spa-all-totalcounts-20120701.txt
            fname=['../Data/Totales/Totales_' obj.name '.txt'];
            C=importdata(fname);C=C{1};%leo el archivo de totales
            temp=sscanf(C,'%f,%f,%f,%f');%lo parseo como numeros
            temp=reshape(temp,4,length(temp)/4)';%era una lista larga, la convierto en 4 columnas
            titulos={'year' 'words' 'pages' 'books'};
            TOT=cell2struct(num2cell(temp)',titulos');%la convierto en un array de estructura
%             index=[TOT.year]>=obj.desde & [TOT.year]<=obj.hasta;
%             TOT=TOT(index);
            
        end
        
        %sacada de Ngrams.m sin modificar
        function [obj, AS]=ColapsoPlurales(obj,language)
            
            [~,indsorted]=sort({obj.words.word});
            obj.words=obj.words(indsorted);
            
            AS=struct([]);
            tic
            
            switch language
                case {'es2020','es2012'}
                    terminacionplural='ces';
                    terminacionsingular='z';
                    A=Corpus.findpatternsingularplural(obj.words,terminacionplural,terminacionsingular);
                    obj.words = Corpus.colapsar(obj.words,A);
                    toc
                    AS=[AS A];
                    
                case {'en2012','en2020','ae2020','be2020','fe2020'}
                    %properties -> property
                    terminacionplural='ies';
                    terminacionsingular='y';
                    A=Corpus.findpatternsingularplural(obj.words,terminacionplural,terminacionsingular);
                    obj.words = Corpus.colapsar(obj.words,A);
                    AS=[AS A];
                    
                    %lista de plurales irregulares en ingles
                    %men->man
                    A=struct([]);
                    SS=table2struct(readtable('../Data/EN_PluralesIrregulares.xlsx'));
                    for indm=1:length(SS)
                        indexs=find(strcmp(SS(indm).singular,{obj.words.word}));
                        indexp=find(strcmp(SS(indm).plural,{obj.words.word}));
                        if ~isempty(indexs) & ~isempty(indexp)
                            A(end+1).indsingular=indexs;
                            A(end).indplural=indexp;
                            A(end).singular=obj.words(indexs).word;
                            A(end).plural=obj.words(indexp).word;
                            A(end).TotSing=sum(obj.words(indexs).samples);
                            A(end).TotPlu=sum(obj.words(indexp).samples);
                        end
                    end
                    obj.words = Corpus.colapsar(obj.words,A);
                    AS=[AS A];
            end
            
            
            switch language
                case {'es2020','es2012','en2012','en2020','ae2020','be2020','fe2020'}
                    %cats -> cat   casas->casa
                    terminacionplural='s';
                    terminacionsingular='';
                    SS=table2struct(readtable('../Data/EN_PluralesMalColapsados.xlsx'));
                    A=Corpus.findpatternsingularplural(obj.words,terminacionplural,terminacionsingular);
                    SacoA=[];
                    for indm=1:length(SS)
                        indicemal=find(ismember({A.singular},SS(indm).singular));
                        if ~isempty(indicemal) && strcmp(A(indicemal).singular,SS(indm).singular) &&...
                                strcmp(A(indicemal).plural,SS(indm).plural)
                            SacoA(end+1)=indicemal;
                        end
                    end
                    if ~isempty(SacoA)
                        A(SacoA)=[];
                    end
                    
                    obj.words = Corpus.colapsar(obj.words,A);
                    AS=[AS A];
                    
                    %taxes -> tax    virtuded ->virtud
                    terminacionplural='es';%ojo con and y andes
                    terminacionsingular='';
                    A=Corpus.findpatternsingularplural(obj.words,terminacionplural,terminacionsingular);
                    SacoA=[];
                    for indm=1:length(SS)
                        indicemal=find(ismember({A.singular},SS(indm).singular));
                        if ~isempty(indicemal) && strcmp(A(indicemal).singular,SS(indm).singular) &&...
                                strcmp(A(indicemal).plural,SS(indm).plural)
                            SacoA(end+1)=indicemal;
                        end
                    end
                    if ~isempty(SacoA)
                        A(SacoA)=[];
                    end
                                        
                    obj.words = Corpus.colapsar(obj.words,A);
                    toc
                    AS=[AS A];
            end
            
            %veces -> vez

            fprintf('Me quedan %d palabras despues de colapsar plurales\n',length(obj.words))
        end
        
        %sacada de Ngrams.m. modificada
        function TIMELINE = colapsar(TIMELINE,A)
            % Colapso el singular y el plural de los nouns que me interesan.
            %pero tengo todavía que eliminar del timeline los plurales 
            for i=1:length(A)
                    indsing=A(i).indsingular;
                    indplu=A(i).indplural;
                    TIMELINE(indsing).samples=TIMELINE(indsing).samples+TIMELINE(indplu).samples  ;
%                     TIMELINE(indsing).books= TIMELINE(indsing).books+TIMELINE(indplu).books;
                    TIMELINE(indsing).wordorig=[TIMELINE(indsing).wordorig TIMELINE(indplu).wordorig];
            end   
            % Elimino los plurales del timeline
            if ~isempty(A)
                TIMELINE([A.indplural])=[];                        
            end
        end
        
        %sacada de Ngrams.m sin modificar
        function A=findpatternsingularplural(TIMELINE,finishplural,finishsingular)
            % ('ies','y')
            % ('es','')
            % ('s','')
            ncharsremoveplural=length(finishplural);
            A=struct([]);
            indies=find(endsWith({TIMELINE.word},finishplural));
            for indtl=1:length(indies)
                indexp=indies(indtl);
                w1=TIMELINE(indexp).word;
                % w2 son las palabras posteriores
                w2s={TIMELINE.word};
                indexs=strcmp(w2s,[w1(1:end-ncharsremoveplural) finishsingular]);
                indexs=find(indexs);
                for i=1:length(indexs) %aca tengo que recorrer las que empiezan con word y terminan  con s o es.
                    %                     fprintf('%s\t%s\n',w1,w2{index(i)});
                    A(end+1).indsingular=indexs(i);
                    A(end).indplural=indexp;
                    A(end).singular=w2s{indexs(i)};
                    A(end).plural=w1;
                    A(end).TotSing=sum(TIMELINE(indexs(i)).samples);
                    A(end).TotPlu=sum(TIMELINE(indexp).samples);
                end
            end
        end 
        
        function obj=ColapsoMinusculas(obj)
            [listaverbos,ia,ic]=unique({obj.words.word});
            indicesacumulados=accumarray(ic,1:length(ic),[],@(x) {sort(x)});
            indicescolapsar= find(arrayfun(@(x) length(x{1}),indicesacumulados)>1);
            indiceseliminar=[];
            for ind=1:length(indicescolapsar)
                index =    indicesacumulados{indicescolapsar(ind)};
                %     for i=1:length(index)
                %         fprintf('%s ',M(index(i)).wordorig)
                %     end
                %     fprintf('\n')
                
                %acumulo en el primer indice
                for i=2:length(index)
                    obj.words(index(1)).samples=obj.words(index(1)).samples+obj.words(index(i)).samples;
%                     obj.words(index(1)).books=obj.words(index(1)).books+obj.words(index(i)).books;
                    obj.words(index(1)).wordorig=[obj.words(index(1)).wordorig obj.words(index(i)).wordorig];
                end
                indiceseliminar = [indiceseliminar;  index(2:end)];
            end
            obj.words(indiceseliminar)=[];
            fprintf('Me quedan %d palabras despues de colapsar minusculas\n',length(obj.words))
            
        end
        
        function obj=SacoChirimbolos(language,obj)
            switch language
                case {'en2020','ae2020','be2020','en2012','ae2012','be2012','fe2020'}
                    out=regexp({obj.words.word},['[0-9.' char(39)  char(230) char(233) ']']);
                case {'es2020','es2012'}
                    out=regexp({obj.words.word},'[.]');
                case {'al2020'}
                    out=regexp({obj.words.word},'[.]');
                case {'it2020'}
                    out=regexp({obj.words.word},'[''.]');
                case {'fr2020'}
                    out=regexp({obj.words.word},['[''.' char(339) ']']);
            end
            index=arrayfun(@(x) length(x{1})>0,out);
            obj.words(index)=[];
            fprintf('Me quedan %d palabras despues de sacar chirimbolos\n',length(obj.words))
        end

        function obj=CargoListas(cota,obj,datadir)
            d=dir([datadir 'lista_NOUN_*.txt']);
            for indfile=1:length(d)
                filename=d(indfile).name;%sprintf('lista_NOUN_%02d.txt',indfile);
                fprintf('Open file %s\n',filename)
                fid=fopen([datadir filename]);
                while ~feof(fid)
                    tline = fgetl(fid);
                    indfirstspace=find(isspace(tline),1,'first');
                    scannedData = textscan(tline(indfirstspace+1:end), '%d,%d,%d') ;
                    wordorig=tline(1:indfirstspace-1);
                    word=lower(strrep(wordorig,'_NOUN',''));
                    years = scannedData{1};
                    samples = scannedData{2};
                    books = scannedData{3};
                    index=years>=obj.desde & years<=obj.hasta;
                    total=sum(samples(index));%solo sumo los a�os en el intervalo
                    if total>=cota && ... %pido que haya al menos 1e6 palabras
                            sum(ismember(obj.desde:obj.hasta,years))==length(obj.desde:obj.hasta) && ... %que haya datos en todos los a�os del rango
                            ismember(word(1),['abcdefghijklmn' char(241) 'opqrstuvwxyz']) && ... % que el primer caracter sea una letra
                            length(word)>2 %que tenga al menos 3 letras
                        %                         M(end+1).word=word;
                        %                         M(end).wordorig=string(wordorig);
                        %                         M(end).year=year(index);
                        %                         M(end).samples=samples(index);
                        %                         M(end).books=books(index);
                        w=Word(word,string(wordorig),years(index),samples(index));
                        obj.words=[obj.words w];
                        fprintf('f%02d %05d %20s:\t%d\n',indfile, length(obj.words), word, total)
                    end
                end
            end
        end        
        function obj=GetDesdeHasta(language,obj)
            switch language
                case {'en2020','es2020','be2020','al2020','fr2020','it2020'}
                    obj.desde=1750;
                    obj.hasta=2019;
                case {'en2012','es2012','be2012'}
                    obj.desde=1750;
                    obj.hasta=2008;
                case {'ae2020','fe2020'}
                    obj.desde=1800;
                    obj.hasta=2019;
                case {'ae2012'}
                    obj.desde=1800;
                    obj.hasta=2008;                    
            end
        end      
    end
end


%cambiar los datadir donde esta el raw data
function datadir=GetDataDir()
[idum,hostname]= system('hostname');%LEO EL NOMBRE DE LA COMPU
switch strtrim(hostname)
    case {'diego-desktop' 'diego-pc' 'Desktop-Win10' 'primita'}
        datadir='E:\DIEGO_COMPARTIDO\_LABO_DATOS\ngrams\';
    case {'PC-Marcos' 'DESKTOP-PCFHUNF'}% poner aca el nombre de la compu
        datadir='C:\Users\Marcos\Dropbox\Lavoro\evolucion del lenguaje';
    case {'alejandro'}
        datadir='/home/alejandro/Lenguaje/';
        cd('/home/alejandro/Dropbox/Sustantivos/Code')
    otherwise
        fprintf('El nombre de la cumpu actual es: %s\n',strtrim(hostname))
        disp('No s? en qu? computadora estoy, no s? a qu? directorio ir.')
        datadir='./';
end
end



    
    