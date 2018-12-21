[num,text,raw] = xlsread('C:\Users\tzhu02\Desktop\Blood Pressure\FebConference\SpreadSheet.xlsx', '76 With ABP data');
for i = 2:2
    if raw{i,17} == 1
        [w_m,w_T_m] = Fetch_data_from_graph(raw{i,2});   
        [w_m,w_T_m] = FillingGaps_Double_Filter(w_m',w_T_m');
        w_m = fillmissing(w_m,'spline');
    end
end
