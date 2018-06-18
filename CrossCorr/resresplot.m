function [corrcoefo,M,LI,bounds] = resresplot(matrix,residue_to_analyze,resi,resj)
offset=0; % first residue starts from 6
if resi < resj
    i=resj;
    j=resi;
elseif (resi == resj)
    error('Both residues cant be the same.');
else
    i=resi;
    j=resj;
end

%residue_to_analyze=49;
res1=(matrix(i-offset,residue_to_analyze-offset,:));res1=res1(:);
res1=[res1;res1;res1];
res2=(matrix(j-offset,residue_to_analyze-offset,:));res2=res2(:);
res2=[res2;res2;res2];

corrcoefo=corr(res1,res2);
[XCF,lags,bounds] = crosscorr(res1,res2,3,3);
[M,I] = max(abs(XCF));
LI=lags(I);

% % Create figure
% figure1 = figure;
% axes1 = axes('Parent',figure1,...
%     'Position',[0.13 0.409632352941177 0.775 0.515367647058823]);
% hold(axes1,'on');
% plot1 = plot(1:12,[res1,res2],'Parent',axes1,'Marker','o');
% set(plot1(1),'DisplayName','236','Color',[1 0 0]);
% set(plot1(2),'DisplayName','87','Color',[0 0 1]);
% xlabel('Reaction Progression');
% ylabel('Correlation');
% xlim(axes1,[0 13]);
% box(axes1,'on');set(axes1,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12],'XTickLabel',...
%     {'Free','IGP','Both','G3P','Free','IGP','Both','G3P','Free','IGP','Both','G3P'});
% legend(axes1,'show');
% 
% % Create subplot
% subplot1 = subplot(3,1,3,'Parent',figure1);
% hold(subplot1,'on');
% stem(lags,XCF,'Parent',subplot1);
% xlabel('Lags');
% ylabel('Reaction Corr');
% xlim(subplot1,[-4 4]);
% box(subplot1,'on');
% set(subplot1,'XTick',[-3 -2 -1 0 1 2 3]);

figure('unit','pixels');
pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 600 600]);
subplot(3,1,[1 2]);
plot(1:12,res1,'DisplayName',num2str(i),'MarkerSize',30,'Marker','.','LineWidth',3,'Color','r');
hold on;
plot(1:12,res2,'DisplayName',num2str(j),'MarkerSize',30,'Marker','.','LineWidth',3,'Color','b');
hold off;
xlabel('Reaction Progression','FontWeight','bold');
ax=gca;
ax.XTick=[1:12];
ylim([0 1]);
xlim([0 13]);
ax.FontWeight='bold';
ax.LineWidth=2;
ax.XTickLabel={'Free','IGP','Both','G3P','Free','IGP','Both','G3P','Free','IGP','Both','G3P'};
ylabel(['Correlation with Residue ' num2str(residue_to_analyze)],'FontWeight','bold');
legend('show');

subplot(3,1,3);
stem(lags,XCF,'MarkerSize',30,'Marker','.','LineWidth',3,'Color','k');
xlim([-4 4]);
ylim([-1.2 1.2]);
ax=gca;
ax.FontWeight='bold';
ax.LineWidth=2;
ax.XTick=[-3:1:3];
xlabel('Lags');
ylabel('Correlation_{Reaction}');
hold on;
plot(-4:1:4,bounds(1)*ones(9),'r--');
plot(-4:1:4,bounds(2)*ones(9),'r--');
hold off;

figure;
maxlag=lags(find(abs(XCF)==max(abs(XCF))));
xt=res1(5:8);
yt=res2(5+maxlag:8+maxlag);

fitvars = polyfit(xt, yt, 1);
yfit = polyval(fitvars,xt);
R=corrcoef(xt,yt);

hold on;
plot(xt,yfit,'-','LineWidth',5,'Color',[.8 .8 .8]);
plot(xt,yt,'k.','MarkerSize',70);
hold off;
xlim([0 1]);
ylim([0 1]);
xlabel(['Res ' num2str(i-offset) ' - Res ' num2str(residue_to_analyze)],'FontWeight','bold');
ylabel(['Res ' num2str(j-offset) ' - Res ' num2str(residue_to_analyze)],'FontWeight','bold');
ax=gca;
ax.FontWeight='bold';
ax.FontSize = 20;
ax.LineWidth = 5;
ax.XTick = [0:0.1:1];
ax.YTick = [0:0.1:1];
ax.TickLength = [0.02 0.035];
ax.XTickLabelRotation = 45;
title(['R = ' num2str(R(2)) ' Max Lag: ' num2str(maxlag)]);