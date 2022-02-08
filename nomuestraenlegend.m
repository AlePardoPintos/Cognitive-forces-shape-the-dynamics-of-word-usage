function nomuestraenlegend(h)
for i=1:length(h)
    if ishandle(h(i))
        set(get(get(h(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    end
end
