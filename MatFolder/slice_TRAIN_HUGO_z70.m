
% HUGO TRAINING DATA z=70 

cd 'CST_Data\Train_HUGO_z70';

T_Matrix = xlsread('HUGO_Train_z70_v2.xlsx');
files = dir('*.txt');

for i=1:length(files)
    eval(['load ' files(i).name ' -ascii']);
end

X=T_Matrix(:,1);
Y=T_Matrix(:,2);
T=T_Matrix(:,3);
format Long

i_select = inpolygon(X,Y,Skin_Outer(:,1),Skin_Outer(:,2));
X = X(i_select);
Y = Y(i_select);
T = T(i_select);

figure(1)
scatter(X, Y, 20, T, 'filled');
colorbar
title('Temperature map after 60s [�C]')
set(gca,'clim',[37 42.5])
set(gcf,'Position',[5 550 450 500])

N = length(X); %number of points
N_p = 11; %number of segments per point
N_s = 4; %number of sensors


%%%%%%%%%

epsAir = 1;     %Air Properties
sigAir = 0; 
rhoAir = 0;

epsBlood = 69.9;     %Blood Properties
sigBlood = 1.27; 
rhoBlood = 1050;

epsCSF = 79.1;      %CSF Properties 
sigCSF = 2.17; 
rhoCSF = 1010; 

epsGreyMatter = 67.7;      %Grey Matter Properties 
sigGreyMatter = 0.62; 
rhoGreyMatter = 1050; 

epsWhiteMatter = 48.8;      %White Matter Properties 
sigWhiteMatter = 0.36; 
rhoWhiteMatter = 1040; 

epsBone = 14.2;      %Bone Properties
sigBone = 0.07; 
rhoBone = 2000; 

epsMuscle = 61.3;      %Muscle Properties 
sigMuscle = 0.73; 
rhoMuscle = 1080; 

epsFat = 5.79;     %Fat Properties
sigFat = 0.04; 
rhoFat = 900;

epsSkin = 58.8;      %Skin Properties 
sigSkin = 0.56; 
rhoSkin = 1100; 


% 4 Sensors: Coordinates Matrix
coordSensors = zeros(4,2);
coordSensors = [0 73; 0 -77; -55 0; 58 0]; 

%4 Sensors: Temperatures
tempSensors = [39.0; 38.2; 38.7; 38.0]; 
 
%Create dielectric properties matrix   
ptesDiel=zeros(N,N_s,3,N_p);

xS=coordSensors(:,1);
yS=coordSensors(:,2);

dx = zeros(N,N_s,N_p);
dy = zeros(N,N_s,N_p);

for i = 1:N
   for j = 1:N_s
    dx(i,j,:)= linspace(X(i),xS(j),N_p);
    dy(i,j,:)= linspace(Y(i),yS(j),N_p);
    
   end
end


for i=1:N
    for s=1:N_s
        for p=1:N_p

         is_in_Air = inpolygon(dx(i,s,p),dy(i,s,p),Air1(:,1),Air1(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Air2(:,1),Air2(:,2));
             if is_in_Air
                ptesDiel(i,s,1,p)=epsAir;  
                ptesDiel(i,s,2,p)=sigAir; 
                ptesDiel(i,s,3,p)=rhoAir;
                continue;
             end   
            
         is_in_Blood = inpolygon(dx(i,s,p),dy(i,s,p),Blood1(:,1),Blood1(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Blood2(:,1),Blood2(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Blood3(:,1),Blood3(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Blood4(:,1),Blood4(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Blood5(:,1),Blood5(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Blood6(:,1),Blood6(:,2)) || ... 
                       inpolygon(dx(i,s,p),dy(i,s,p),Blood7(:,1),Blood7(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Blood8(:,1),Blood8(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Blood9(:,1),Blood9(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Blood10(:,1),Blood10(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Blood11(:,1),Blood11(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Blood12(:,1),Blood12(:,2));
            if is_in_Blood
                ptesDiel(i,s,1,p)=epsBlood;  
                ptesDiel(i,s,2,p)=sigBlood; 
                ptesDiel(i,s,3,p)=rhoBlood;
                continue;
            end
            
           is_in_CSF = inpolygon(dx(i,s,p),dy(i,s,p),CSF1(:,1),CSF1(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF2(:,1),CSF2(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF3(:,1),CSF3(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF4(:,1),CSF4(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF5(:,1),CSF5(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF6(:,1),CSF6(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF7(:,1),CSF7(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF8(:,1),CSF8(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF9(:,1),CSF9(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF10(:,1),CSF10(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF11(:,1),CSF11(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF12(:,1),CSF12(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF13(:,1),CSF13(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF14(:,1),CSF14(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF15(:,1),CSF15(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF16(:,1),CSF16(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF17(:,1),CSF17(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF18(:,1),CSF18(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF19(:,1),CSF19(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF20(:,1),CSF20(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF21(:,1),CSF21(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF22(:,1),CSF22(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF23(:,1),CSF23(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF24(:,1),CSF24(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF25(:,1),CSF25(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF26(:,1),CSF26(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF27(:,1),CSF27(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF28(:,1),CSF28(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF29(:,1),CSF29(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF30(:,1),CSF30(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF31(:,1),CSF31(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF32(:,1),CSF32(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF33(:,1),CSF33(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF34(:,1),CSF34(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF35(:,1),CSF35(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF36(:,1),CSF36(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF37(:,1),CSF37(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF38(:,1),CSF38(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF39(:,1),CSF39(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF40(:,1),CSF40(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF41(:,1),CSF41(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF42(:,1),CSF42(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF43(:,1),CSF43(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF44(:,1),CSF44(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF45(:,1),CSF45(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF46(:,1),CSF46(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),CSF47(:,1),CSF47(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),CSF48(:,1),CSF48(:,2)) ;
           if is_in_CSF
                ptesDiel(i,s,1,p)=epsCSF; 
                ptesDiel(i,s,2,p)=sigCSF; 
                ptesDiel(i,s,3,p)=rhoCSF;
                continue;
           end
            
           is_in_GreyMatter = inpolygon(dx(i,s,p),dy(i,s,p),GM1(:,1),GM1(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),GM2(:,1),GM2(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),GM3(:,1),GM3(:,2));
            if is_in_GreyMatter
                ptesDiel(i,s,1,p)=epsGreyMatter; 
                ptesDiel(i,s,2,p)=sigGreyMatter; 
                ptesDiel(i,s,3,p)=rhoGreyMatter;
                continue;
            end
            
            is_in_WhiteMatter = inpolygon(dx(i,s,p),dy(i,s,p),WM1(:,1),WM1(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),WM2(:,1),WM2(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),WM3(:,1),WM3(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),WM4(:,1),WM4(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),WM5(:,1),WM5(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),WM6(:,1),WM6(:,2)) || ...
                              inpolygon(dx(i,s,p),dy(i,s,p),WM7(:,1),WM7(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),WM8(:,1),WM8(:,2)) ;
            if is_in_WhiteMatter
                ptesDiel(i,s,1,p)=epsWhiteMatter; 
                ptesDiel(i,s,2,p)=sigWhiteMatter; 
                ptesDiel(i,s,3,p)=rhoWhiteMatter;
                continue;
            end
            
            is_in_GreyMatter2 =  inpolygon(dx(i,s,p),dy(i,s,p),GM_Contour(:,1),GM_Contour(:,2));
            
            if is_in_GreyMatter2
                ptesDiel(i,s,1,p)=epsGreyMatter; 
                ptesDiel(i,s,2,p)=sigGreyMatter; 
                ptesDiel(i,s,3,p)=rhoGreyMatter;
                continue;
            end
            
            is_in_Bone = inpolygon(dx(i,s,p),dy(i,s,p),Bone_Contour(:,1),Bone_Contour(:,2));
            if is_in_Bone
                ptesDiel(i,s,1,p)=epsBone; 
                ptesDiel(i,s,2,p)=sigBone; 
                ptesDiel(i,s,3,p)=rhoBone;
                continue;
            end
            
            is_in_Muscle = inpolygon(dx(i,s,p),dy(i,s,p),Muscle1(:,1),Muscle1(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Muscle2(:,1),Muscle2(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Muscle3(:,1),Muscle3(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Muscle4(:,1),Muscle4(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Muscle5(:,1),Muscle5(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Muscle6(:,1),Muscle6(:,2)) || ... 
                       inpolygon(dx(i,s,p),dy(i,s,p),Muscle7(:,1),Muscle7(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Muscle8(:,1),Muscle8(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Muscle9(:,1),Muscle9(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Muscle10(:,1),Muscle10(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Muscle11(:,1),Muscle11(:,2)) || inpolygon(dx(i,s,p),dy(i,s,p),Muscle12(:,1),Muscle12(:,2)) || ...
                       inpolygon(dx(i,s,p),dy(i,s,p),Muscle13(:,1),Muscle13(:,2));
            if is_in_Muscle
                ptesDiel(i,s,1,p)=epsMuscle;  
                ptesDiel(i,s,2,p)=sigMuscle; 
                ptesDiel(i,s,3,p)=rhoMuscle;
                continue;
            end
            
            is_in_Fat = inpolygon(dx(i,s,p),dy(i,s,p),Fat_Contour(:,1),Fat_Contour(:,2));
            if is_in_Fat
                ptesDiel(i,s,1,p)=epsFat; 
                ptesDiel(i,s,2,p)=sigFat; 
                ptesDiel(i,s,3,p)=rhoFat;
                continue;
            end
            
             is_in_Skin = inpolygon(dx(i,s,p),dy(i,s,p),Skin_Outer(:,1),Skin_Outer(:,2));
            if is_in_Skin
                ptesDiel(i,s,1,p)=epsSkin; 
                ptesDiel(i,s,2,p)=sigSkin; 
                ptesDiel(i,s,3,p)=rhoSkin;
                continue;
            end
            
        end
    end
end

% Plots of dielectric properties

DtoPlot = permute(ptesDiel, [1, 2, 4, 3]);
DtoPlot = reshape(DtoPlot, [N*N_s*N_p, 3]);
coordToPlot = [reshape(dx,[N*N_s*N_p, 1]), reshape(dy,[N*N_s*N_p, 1])];

figure('pos',[10 500 1600 400])
subplot(1,3,1) 
scatter(coordToPlot(:,1), ...
         coordToPlot(:,2), 1,DtoPlot(:,1))
colorbar
set(gca,'clim',[5 80])
title('Epsilon/Permittivity map')

subplot(1,3,2) 
scatter(coordToPlot(:,1), ...
         coordToPlot(:,2), 1,DtoPlot(:,2))
colorbar
set(gca,'clim',[0 2.5])
title('Sigma/Conductivity map [S/m]')

subplot(1,3,3) 
scatter(coordToPlot(:,1), ...
         coordToPlot(:,2), 1,DtoPlot(:,3))
colorbar
set(gca,'clim',[900 1100])
title('Rho/Density map [kg/m3]')

ptesDiel = reshape(ptesDiel, [N*N_s, 3*N_p]);

%Calculate norm of the vectors of coordinates [Point i ; Sensor j] 

normDistance=zeros(N,N_s);
coordCart=[X(:),Y(:)]; 

for i=1:N
    for j=1:N_s
       P=coordCart(i,:)-coordSensors(j,:);
       normDistance(i,j)=norm(P);
    end
end

tempSensors=repmat(tempSensors,N,1);    
T=repelem(T,N_s);       % Shaping the data
normDistance=reshape(transpose(normDistance),[N*N_s 1]);       % Shaping the data

x_Data3 = [ptesDiel(:,:),normDistance(:,:),tempSensors(:),T(:)];  %Data Matrix: Columns = dielectric properties (epsilon, sigma, rho), distance to Sensors, temperature at Sensor, Temperature at Point P itself. 
                                                                          %             Rows = 4 rows for 1 Point P (for the 4 Sensors S1 -> S4) 

h={'eps1' 'sigma1' 'rho1' 'eps2' 'sigma2' 'rho2' 'eps3' 'sigma3' 'rho3' 'eps4' 'sigma4' 'rho4' 'eps5' 'sigma5' 'rho5' 'eps6' 'sigma6' 'rho6' 'eps7' 'sigma7' 'rho7' 'eps8' 'sigma8' 'rho8' 'eps9' 'sigma9' 'rho9' 'eps10' 'sigma10' 'rho10' 'eps11' 'sigma11' 'rho11' 'Norm S' 'Ts' 'Tp'  };
f=figure('position',[10 100 1000 650]);
t=uitable('parent',f,'data',x_Data3,'columnname',h,'columnwidth',{54},'position',[5 10 995 640]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%% Clear variables and save only useful data 


x_Data = [x_Data3];




%%%%%%%%%%%%%%%%%%%%%%%%% Save Matrices %%%%%%%%%%%%%%%%%%%% 



%%% z = 70

cd 'C:\Users\Julie\Desktop\NITE_deuxieme\NITE\Data\2019-04-24\Train_Slice3_z70';

T_Matrix_z70 = xlsread('HUGO_Train_z70_v2.xlsx');
files_z70 = dir('*.txt');

for i=1:length(files_z70)
    eval(['load ' files_z70(i).name ' -ascii']);
end

X_z70=T_Matrix_z70(:,1);
Y_z70=T_Matrix_z70(:,2);
T_z70=T_Matrix_z70(:,3);
format Long

i_select_z70 = inpolygon(X_z70,Y_z70,Skin_Outer(:,1),Skin_Outer(:,2));
X_z70 = X_z70(i_select_z70);
Y_z70 = Y_z70(i_select_z70);
T_z70 = T_z70(i_select_z70);

M_3 = [X_z70, Y_z70, T_z70]; 

M_Train = M_3;
clearvars -except x_Data M_Train 

save ('MatFolder\Training_new.mat', 'x_Data');
