function [w_m,w_t_m] = Fetch_data_from_graph(baby_date)
try
open(strcat('C:\Users\tzhu02\Desktop\Blood Pressure\FilteredGraphs\Baby', num2str(baby_date),'.fig'));
h = findobj(gca,'type','line');
x = get(h,'Xdata');
y = get(h,'Ydata');

w_t_m = cell2mat(x(4,1));
w_m = cell2mat(y(4,1));
catch
end
end
