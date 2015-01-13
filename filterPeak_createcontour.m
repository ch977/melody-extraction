function contourSet=filterPeak_createcontour(S)
%   filter out non-salience
%   output:
%   contour:contourSet
num_F=size(S,1);
tau1=0.9;
tau2=0.9;
%find peaks at each frame
peakS=cell(num_F,1);
for i=1:num_F
    [peak,loc]=findpeaks(S(i,:));
    peakS{i}=[loc' peak'];
end
%first:per frame basis
%peaks below a threshold factor tau1*max are filtered out
set1c=cell(num_F,1);
set2c=cell(num_F,1);
for i=1:num_F
    SP=peakS{i};
    pM=max(SP(:,2));
    idx=find(SP(:,2)>=tau1*pM);
    n1=length(idx);
    set1c{i}= [i*ones(n1,1) SP(idx,:)];
    
    np=size(SP,1);
    id_2=[1:np];
    id_2(idx)=[];
    set2c{i}=[i*ones(np-n1,1) SP(id_2,:)];
end
%cell2mat
set1=cell2mat(set1c);
set2=cell2mat(set2c);
%second :filter according characteristics of all frames
m_p=mean(set1(:,3));
s_p=std(set1(:,3));
Th_all=m_p-s_p*tau2;

set2= [set2;set1(set1(:,3)<=Th_all,:)];
set1=set1((set1(:,3)>Th_all),:);
%  save output in peak40.mat

contour=cell(1000,1);         %contour set
ci=1;       %contour id
while(~isempty(set1))
    t1=1;
    t2=1;
    delID1=zeros(200,1);
    delID2=zeros(200,1);
    [value,idx]=max(set1(:,3));      %find highest peak
    p1=set1(idx,:);
    contour{ci}=p1;     % add it to contour
    delID1(1)=idx;              %  id that needs to delete
    idfra=p1(1);         %frame number
    id_end=find(set1(:,1)==idfra+35,1);   %following 100ms frames
    
    for i=idx+1:id_end           % add peaks from set1 or set2
        Inset1=0;       %
        Inset2=0;
        seq=find(set1(:,1)==set1(i,1));   %
        for j=seq(1):seq(end)
            if abs(set1(j,2)-p1(2))<12      %within 80 cents (pitch continuity cue )
                contour{ci}=[contour{ci}; set1(j,:)];   %add it to contour
                t1=t1+1;
                delID1(t1)=j;
                % delID1=[delID1;j];
                idx=j;
                id_end=find(set1(:,1)==set1(j,1)+35,1);
                p1=set1(j,:);       %update p1
                Inset1=1;
                break
            end
        end
       if Inset1==1
           continue
       end
            
        if Inset1==0&&sum(set2(:,1)==set1(i,1))      %search it in set2
            seq=find(set2(:,1)==set1(i,1));
            for j=seq(1):seq(end)
                if abs(set2(j,2)-p1(2))<12 %  if there is peak in set2 within 80 cents
                    
                    contour{ci}=[contour{ci}; set2(j,:)];
                    delID2(t2)=j;
                    t2=t2+1;
                    %delID2=[delID2;j];
                    Inset2=1;
                    break
                end
            end
        end
        if Inset1==0&&Inset2==0  %not found in both sets
            break
        end
    end
    set1(delID1(delID1>0),:)=[];          %delete grouped peaks , update set1
    set2(delID2(delID2>0),:)=[];
    ci=ci+1;
end

contourSet=cell(length(contour),1);
for i=1:length(contour)
    contourSet{i}=unique(contour{i},'rows');
end

n_z=sum(cellfun('isempty',contourSet));
if n_z>0        %cont number little than 1000
    contourSet(1000-n_z+1:1000)=[];
end

%plot scatter
% pkn=cellfun('size',contour,1);
% contour_1=contour(pkn~=1);
% contour_1=cell2mat(contour_1);
% hh=contour(pkn==1);
% hh=cell2mat(hh);
% tt=hh(hh(:,3)>17,:);
% contour_2=[contour_1 ;tt];
% contour_=cell2mat(contour);
% ground=importdata('example1REF.txt');
% subplot(221);
% scatter(ground(:,1),ground(:,2),'.','r')
% subplot(222);
% scatter(contour_1(:,1),contour_1(:,2),'.','g');  %no single point
% subplot(223);
% scatter(contour_2(:,1),contour_2(:,2),'.');  %have some single point contour
% subplot(224);
% scatter(contour_(:,1),contour_(:,2),'.','b');  %have all single point contour
end








