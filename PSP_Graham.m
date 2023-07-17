%  'range'; 'range_ap'; 'range_ml' 'area_sw' % GRAHAM

% get area and rms from each subject and conditions
clear all
maindir = uigetdir();  % "C:\Users\burgosp\OneDrive - Oregon Health & Science University\Documents\MATLAB\Neurocom_LOS_SOT_MCTdata"

folders = dir(maindir); % folder of participants
dirFlags = [folders.isdir];
folders =folders(dirFlags);
fo = {folders(3:end).name};

% area and rms or another variables, check the size of T

varTypes = {'string','string','string','string','double','double','double','double'};
sz = [1 length(varTypes)];
varNames = {'subject','visit','condition','trial','range', 'range_ap', 'range_ml' ,'area_sw'};
T = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

for i = 1:length(fo)
    di= [maindir,'\',fo{i},'\ClinicalModule'];
    display(fo{i});
    try
    [a1,a2,a3] = myneurocom(di);
    catch
        disp('not done')
        continue
    end

    
%     h1 = readtable([maindir,'\',fo{i},'\SOT\hunova_SOT.csv']);
    rangel=find(strcmp(a2,'range')); %'range', 'range_ap', 'range_ml' ,'area_sw'
    ranapl=find(strcmp(a2,'range_ap'));
    ranmll=find(strcmp(a2,'range_ml'));
    areal=find(strcmp(a2,'area_sw'));

    sz2= [size(a1,1),8]; % {'subject','visit','condition','trial','range', 'range_ap', 'range_ml' ,'area_sw'};
    Tnew = table('Size',sz2,'VariableTypes',varTypes,'VariableNames',varNames);

    fi={a3.name};
    subj=cell(length(fi),1);
    cond=cell(length(fi),1);
    trial=cell(length(fi),1);
    visit=cell(length(fi),1);
    for j = 1:length(fi)
        %         display(j)
        pat = "C" + digitsPattern(1) + "_T" + digitsPattern(1);
        kst = strfind(fi{j},pat);
%         if ~isempty(kst)
        pat2 = fi{j}(kst:end);
        subj{j}=fo{i};
        cond{j}=pat2(2);
        us = strfind(pat2,"_");
        trial{j}=pat2(5);
        pat3 = pat2(us(2):us(3));
        visit{j}=pat3(2:end-1);
%         else
%             subj{j}="None";
%             cond{j}="None";
%             trial{j}="None";
%             visit{j}="None";
%         end
    end

%     subj(strcmp([subj{:}],"None"))=[];
%     cond(strcmp([cond{:}],"None"))=[];
%     trial(strcmp([trial{:}],"None"))=[];
%     visit(strcmp([visit{:}],"None"))=[];




    Tnew.subject(:) = subj;
    Tnew.visit(:) = visit;
    Tnew.condition(:) = cond;
    Tnew.trial(:) = trial;
    Tnew.range(:) = a1(:,rangel); 
    Tnew.range_ap(:)  = a1(:,ranapl);
    Tnew.range_ml(:)  = a1(:,ranmll);
    Tnew.area_sw(:)  = a1(:,areal);
    display(subj{1})
%     if strcmp(subj{1}, 'HV012')
%         continue
%     end
    display(cond{1})

    T = [T ; Tnew];

%     harl=contains(h1.EVALUATOR,'AREA');
%     hrml=contains(h1.EVALUATOR,'RMS');
%     hcel=contains(h1.EVALUATOR,'CE');
%     hoel=contains(h1.EVALUATOR,'OE');
%     sz3= [2,5];
%     T2new= table('Size',sz3,'VariableTypes',varTypes,'VariableNames',varNames);
%     T2new.subject(:) = subj{1};
%     T2new.condition(:) = {'OE','CE'};
%     T2new.device(:) = 'hunova';
%     T2new.area(:) = [h1.VALUE(harl & hoel);h1.VALUE(harl & hcel)];
%     T2new.rms(:)  = [h1.VALUE(hrml & hoel);h1.VALUE(hrml & hcel)];

%     T = [T ; T2new];

disp('done')
end

T(1,:)=[];

% T2=T((contains(T.condition,'T1')| contains(T.condition,'CE')|contains(T.condition,'OE')),:);
T2=T;
T3= groupsummary(T2,["subject","visit","condition"],"mean",["range", "range_ap", "range_ml" ,"area_sw"]);



AVERAGE_RESULTS =T3(T3.condition=='1'|T3.condition=='2',:);

writetable(T,'alltrials_graham.xlsx')
writetable(T3,'allconditions_graham.xlsx')

writetable(AVERAGE_RESULTS,'conditions_1_2_graham.xlsx')

%%
% OE WITH c1
% ec with c2

% nt1= T3(T3.condition=='C1',1);
% nt2= T3(T3.condition=='OE',1);
% [ntd,ia]=setdiff(nt1,nt2);
% 
% t1=T3(T3.condition=='C1',4);
% t1.Properties.VariableNames = ["neurocom"];
% t1(ia,:) =[];
% t2=T3(T3.condition=='OE',4);
% t2.Properties.VariableNames = ["hunova"];
% area=[t1,t2];
% 
% 
% nt3= T3(T3.condition=='C1',1);
% nt4= T3(T3.condition=='OE',1);
% [ntd2,ia2]=setdiff(nt3,nt4);
% 
% t3=T3(T3.condition=='C2',4);
% t3.Properties.VariableNames = ["neurocom"];
% t3(ia2,:) =[];
% t4=T3(T3.condition=='CE',4);
% t4.Properties.VariableNames = ["hunova"];
% area2= [t3,t4];
% 
% figure()
% [R1,PValue1] = corrplot(area,'testR', 'on', 'alpha', 0.05);
% title('Area C1 & OE')
% figure()
% [R2,PValue2] = corrplot(area2,'testR', 'on', 'alpha', 0.05);
% title('Area C2 & CE')

%%
% nt1= T3(T3.condition=='C1',1);
% nt2= T3(T3.condition=='OE',1);
% [ntd,ia]=setdiff(nt1,nt2);
% 
% t1=T3(T3.condition=='C1',5);
% t1.Properties.VariableNames = ["neurocom"];
% t1(ia,:) =[];
% t2=T3(T3.condition=='OE',5);
% t2.Properties.VariableNames = ["hunova"];
% rms=[t1,t2];
% 
% 
% nt3= T3(T3.condition=='C1',1);
% nt4= T3(T3.condition=='OE',1);
% [ntd2,ia2]=setdiff(nt3,nt4);
% 
% t3=T3(T3.condition=='C2',5);
% t3.Properties.VariableNames = ["neurocom"];
% t3(ia2,:) =[];
% t4=T3(T3.condition=='CE',5);
% t4.Properties.VariableNames = ["hunova"];
% rms2= [t3,t4];
% 
% figure()
% [R1,PValue1] = corrplot(rms,'testR', 'on', 'alpha', 0.05);
% title('RMS C1 & OE')
% figure()
% [R2,PValue2] = corrplot(rms2,'testR', 'on', 'alpha', 0.05);
% title('RMS C2 & CE')

