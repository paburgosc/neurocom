function [o1,o2,o3] = myneurocom(dirdata2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

dirdata='C:\Users\burgosp\OneDrive - Oregon Health & Science University\Documents\MATLAB\HV008\SOT';
dirdata =dirdata2;
FILES = dir(fullfile(dirdata,'*.txt'));
% [FILES, dirdata]= uigetfiles ('.txt', ' Choose data files '); 
% FILES = sort(FILES); 



for s = 1:length(FILES)
    file2load = FILES(s).name;
    
    % convert file to UTF-8
%     if ~contains(file2load,'utf8.txt')  % check if already converted  
%         file2load = convertToUTF8(file2load);
%     end
    
    D = readInData([dirdata,'\',file2load]);
    aFILES{s}=file2load;
%     subj(s)=D.SUB_ID;
%     cond(s)=D.Cond;
%     trial(s)=D.Trial;
%     testTime(s)=D.TestTime;
    COP_x=double(D.mydata(:,19)); %% COGy in Neurocom AP in cm 
    COP_y=double(D.mydata(:,20)); %% COGx in Neurocom ML in cm   
%     COP_x=double(D.mydata(:,22).*10); %% COGy in Neurocom AP in mm 
%     COP_y=double(D.mydata(:,21).*10); %% COGx in Neurocom ML in mm
%     if isempty(COP_x)
%%% To re-do with colum 18 and 19 which is COP not filtered


%     %D=readtable(file2load)
%     D=readtable(file2load,'HeaderLines',31);
%     disp(file2load)
%     COP_x=D.FP_COGy.*10;
%     COP_y=D.FP_COGx.*10;
    
    
%     COP_R_x=D.mydata(:,16).*10;
%     COP_R_y=D.mydata(:,17).*10;
%     
%     COP_L_x=D.mydata(:,14).*10;
%     COP_L_y=D.mydata(:,15).*10;
%     
    % On PLAT DATA
    % Subsampling data
    original_samp=100; 
    new_samp=20;
    R=original_samp/new_samp;
    
    COP_x_f=decimate(COP_x,R,2,'FIR');
    COP_y_f=decimate(COP_y,R,2,'FIR');
    
%     COP_R_x_f=decimate(COP_R_x,R,2,'FIR');
%     COP_R_y_f=decimate(COP_R_y,R,2,'FIR');
%     
%     COP_L_x_f=decimate(COP_L_x,R,2,'FIR');
%     COP_L_y_f=decimate(COP_L_y,R,2,'FIR');

    [A,B]=butter(2,5./10);
    COPml=filtfilt(A,B,COP_y_f);
    COPap=filtfilt(A,B,COP_x_f);
    
%     COPml_R=filtfilt(A,B,COP_R_y_f);
%     COPap_R=filtfilt(A,B,COP_R_x_f);
%     COPml_L=filtfilt(A,B,COP_L_y_f);
%     COPap_L=filtfilt(A,B,COP_L_x_f);
%     
    
    trad_par(s,:)=trad_parMOD(COPml,COPap,20);
    label_par={'rdist'; 'rdist_ap'; 'rdist_ml'; 'range'; 'range_ap'; 'range_ml';' mvelo'; 'mvelo_ap'; 'mvelo_ml'; 'f95'; 'f95_ap'; 'f95_ml'; 'area_ce'; 'area_sw'; 'CFREQ'; 'CFREQ_ap'; 'CFREQ_ml';' FREQD'; 'FREQD_ap'; 'FREQD_ml'};
      
end
% % Write xls
% header='Neurocom';
% colnames=label_par;
% xlswrite(trad_par,header,colnames,'Neurocom_Linear.xls','Sheet1')

%%% Writing html
warning off all
par_f = cell(size(trad_par));
  %makeHtmlTable(trad_par,par_f,aFILES,label_par);
  warning off all 

o1=trad_par;
o2= label_par;
o3=FILES;
end