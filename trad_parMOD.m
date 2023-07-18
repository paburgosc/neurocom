

function info_par=trad_parMOD(x,y,fc)
% AP-->y
% ML-->x

N=size(y,1);


dt=1/fc;
T=N*dt;


x=x-mean(x); y=y-mean(y);

rd=sqrt(x.^2+y.^2);

% TIME-DOMAIN DISTANCE PARAMETERS

% % Distanza Media, Mean Amplitude (MDIST) [mm] {Hufschmidt et al., 1980}
mdist=mean(rd);
mdist_ap=mean(abs(y));
mdist_ml=mean(abs(x));

% Distanza Quadratica Media, RMS (RDIST) [mm]
rdist=sqrt(mean(rd.^2));
rdist_ap=sqrt(mean(y.^2)); % mod. Laura sept. 2000
rdist_ml=sqrt(mean(x.^2));

% Escursione Totale, Sway Path (TOTEX) [mm]
totex=sum(sqrt((x(2:N)-x(1:N-1)).^2+(y(2:N)-y(1:N-1)).^2));
totex_ap=sum(abs(y(2:N)-y(1:N-1)));
totex_ml=sum(abs(x(2:N)-x(1:N-1)));

% Estensione del movimento (RANGE) [mm]
range=sqrt((max(x)-min(x))^2+(max(y)-min(y))^2);
range_ap=max(y)-min(y);
range_ml=max(x)-min(x);

% Velocita' Media (MVELO) [mm/s] {Kapteyn et al., 1983}
mvelo=totex/T;
mvelo_ap=totex_ap/T;
mvelo_ml=totex_ml/T;

% % TIME-DOMAIN AREA PARAMETERS
% 
% % Cerchio al 95% di Confidenza (AREA_CC) [mm2]
r=mdist+1.645*std(rd);
area_cc=pi*r^2;

% % Ellisse al 95% di Confidenza (AREA_CE) [mm2]
MCOV=cov([x y]);
D=sqrt((MCOV(1,1)+MCOV(2,2))^2-4*(MCOV(1,1)*MCOV(2,2)-MCOV(1,2)^2));
a=sqrt(3*(MCOV(1,1)+MCOV(2,2)+D));
b=sqrt(3*(MCOV(1,1)+MCOV(2,2)-D));
area_ce=2*pi*3*sqrt(MCOV(1,1)*MCOV(2,2)-MCOV(1,2)^2);

% TIME-DOMAIN HYBRID PARAMETERS

% Sway Area (AREA_SW) [mm2/s]
area_sw=sum(abs(x(2:N).*y(1:N-1)-x(1:N-1).*y(2:N)))/(2*T);
% 
% % Frequenza Media (MFREQ) [Hz]
% mfreq=totex/(2*pi*mdist*T);
% mfreq_ap=totex_ap/(4*sqrt(2)*mdist_ap*T);
% mfreq_ml=totex_ml/(4*sqrt(2)*mdist_ml*T);
% 
% % Dimensione Frattale (FD) [-]
% fd=log(N)/log(N*range/totex);
% 
% % Dimensione Frattale CC (fd_cc)
% fd_cc=log(N)/log(N*2*(mdist+1.645*std(rd))/totex);
% 
% % Dimensione Frattale CE (fd_ce)
% fd_ce=log(N)/log(N*sqrt(8*3*sqrt(MCOV(1,1)*MCOV(2,2)-MCOV(1,2)^2))/totex);

% FREQUENCY-DOMAIN PARAMETERS (parte aggiunta il il 19/4/1999, Laura)

% TUTTI I PARAMETRI SONO CALCOLATI CONSIDERANDIO IL SEGNALE IN [0.5,5 Hz]
% IN ACCORDO CON IL RANGE UTILIZZATO DA Prieto et al.

% Densità spettrale di Potenza (Prd)  
df=fc/N;
F=[0:df:(fc*(N-1)/N)];   	% nel caso di N=5000 e fc=100 Hz df=fc/N=0.02  
fi=0.15;							% limiti assunti da Prieto et al. (1996)
ff=7; % 13-May-02 temp modified
[val,pti]=min(abs(F-fi));
[val,ptf]=min(abs(F-ff));
Grd=(abs(fft(rd)).^2)/N;   %Densità spettrale di Pot.
Gap=(abs(fft(y)).^2)/N;
Gml=(abs(fft(x)).^2)/N;
G_rd=Grd(pti:ptf);            % così vado da fi-5 Hz
G_ap=Gap(pti:ptf);
G_ml=Gml(pti:ptf);

% Potenza (RD)
Prd=sum(G_rd);
Pap=sum(G_ap);
Pml=sum(G_ml);

% % 50% Power Frequency(f50)
% i=0;
% hp=0;
% while (hp<0.5*Prd)
%    i=i+1;
%    hp=sum(G_rd(1:i));
% end
% f50=fi+i*df;
% 
% i=0;  %Componente AP
% hp=0;
% while (hp<0.5*Pap)
%    i=i+1;
%    hp=sum(G_ap(1:i));
% end
% f50_ap=fi+i*df;
% 
% i=0;  %Componente ML
% hp=0;
% while (hp<0.5*Pml)
%    i=i+1;
%    hp=sum(G_ml(1:i));
% end
% f50_ml=fi+i*df;


% 95% Power Frequency (f95)
i=0;
hp=0;
while (hp<0.95*Prd)
   i=i+1;
   hp=sum(G_rd(1:i));
end
f95=fi+i*df;

i=0;
hp=0;
while (hp<0.95*Pap)
   i=i+1;
   hp=sum(G_ap(1:i));
end
f95_ap=fi+i*df;

i=0;
hp=0;
while (hp<0.95*Pml)
   i=i+1;
   hp=sum(G_ml(1:i));
end
f95_ml=fi+i*df;

% Frequenza Centroidale (CFREQ)
I=[1:length(G_rd)]';
m1=sum((df*I).*G_rd);
m2=sum(((df*I).^2).*G_rd);
m1ap=sum((df*I).*G_ap);
m2ap=sum(((df*I).^2).*G_ap);
m1ml=sum((df*I).*G_ml);
m2ml=sum(((df*I).^2).*G_ml);

CFREQ=(m2/Prd)^0.5 ;
CFREQ_ap=(m2ap/Pap)^0.5 ;
CFREQ_ml=(m2ml/Pml)^0.5 ;

% Dispersione in Frequenza (FREQD)
FREQD=(1-(m1^2/(Prd*m2)))^0.5;
FREQD_ap=(1-(m1ap^2/(Pap*m2ap)))^0.5;
FREQD_ml=(1-(m1ml^2/(Pml*m2ml)))^0.5;


% [k,gr,percVar]=MaxVarDir_ferrara(x,y);

info_par=[rdist; rdist_ap; rdist_ml; range; range_ap; range_ml; mvelo; mvelo_ap; mvelo_ml; f95; f95_ap; f95_ml; area_ce; area_sw; CFREQ; CFREQ_ap; CFREQ_ml; FREQD; FREQD_ap; FREQD_ml];
