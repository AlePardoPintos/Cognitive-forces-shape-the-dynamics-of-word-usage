classdef Word
    properties
        word
        wordorig
        years
        samples
        tot
        freqrel
        smoothed
        trend
    end
    methods
        function obj=Word(varargin)%Word(word,wordorig,years,samples)
            obj.word=varargin{1};
            obj.wordorig=varargin{2};
            obj.years=varargin{3};
            obj.samples=varargin{4};
            
        end
        
    end
end