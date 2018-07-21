
function plotScatterGraphForMultipleMethods(inlierRateCellArr1, inlierRateCellArr2, method1name, method2name, methodNamesCellArr)
    
    fontSize = 50;
    lineSize = 8;
    datasetNum = numel(inlierRateCellArr1);
    figure; hold on; box on; grid on;
    set(gca,'FontSize',fontSize,'FontWeight','bold');
    hold on;
    xlabel(method1name);
    ylabel(method2name);

    xlim([0,1]);
    ylim([0,1]);
    
    % scatter plot
    colorVec = {'b','g','r','c','m','k'};
    
    for i = 1:datasetNum
        plot(inlierRateCellArr1{i},inlierRateCellArr2{i},'o','MarkerSize',lineSize,'LineWidth',3,'MarkerEdgeColor',colorVec{i});
    end
    plot(0:0.001:1,0:0.001:1,'k--');
    
    h_legend = legend(methodNamesCellArr);
    hold off;

    
end