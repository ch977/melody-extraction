function [contmat,contSet2]=melodyselection(contSet,pitchstd,contms,contTs,vibrato,nFrame)
%select melody

%contSet=contourSet;
%stage 1: voicing detection
%determining when the melody is present and when it is not
avercontms=mean(contms);
stdcontms=std(contms);
nu=0.2;     %this value changed  over different collections
voiThre = avercontms-stdcontms*nu;
voicecontId1=find(contms>voiThre);
voicecontId2=find(vibrato>0);          % vibrato means melody
voicecontId3=find(pitchstd>4);          %pitch deviation is above 40 cents
voicecontId=unique([voicecontId1; voicecontId2; voicecontId3]);
contSet=contSet(voicecontId) ;
contTs=contTs(voicecontId);
%stage 2:octave errors and pitch outliers
%maybe we need plotting some curves
 pchmean=meanPitch(contSet,contTs,nFrame);
 [contSet1,contTs1]=detOcta(contSet,contTs,pchmean);
 pchmean1=meanPitch(contSet1,contTs1,nFrame);
 [contSet2,contTs2]=remoutlier(contSet1,contTs1,pchmean1);
% pchmean2=meanPitch(contSet2,contTs2,nFrame);
% [contSet1,contTs1]=detOcta(contSet,contTs,pchmean2);
% pchmean3=meanPitch(contSet1,contTs1,nFrame);
% [contSet2,contTs2]=remoutlier(contSet1,contTs1,pchmean3);
% pchmean4=meanPitch(contSet2,contTs2,nFrame);
% [contSet1,contTs1]=detOcta(contSet,contTs,pchmean4);
% pchmean5=meanPitch(contSet1,contTs1,nFrame);
% [contSet2,contTs2]=remoutlier(contSet1,contTs1,pchmean5);
% pchmean6=meanPitch(contSet2,contTs2,nFrame);

% use for loop to do things above
% detOcta takes much time,and it delete littele contours ,so I decide to do
% it only one time,so i don't need for loop below
% pchmean=cell(7,1);
% pchmean{1}=meanPitch(contSet,contTs,nFrame);
% for ind=1:3
%     [contSet1,contTs1]=detOcta(contSet,contTs,pchmean{2*ind-1});
%     pchmean{2*ind}=meanPitch(contSet1,contTs1,nFrame);
%     [contSet2,contTs2]=remoutlier(contSet1,contTs1,pchmean{2*ind});
%     pchmean{2*ind+1}=meanPitch(contSet2,contTs2,nFrame);
% end
%contSet2,contTs2 are the output
%P(t):weighted mean of pitch of all contours present in the frame
    function pchMfilt=meanPitch(contSet,contTs,nFrame)
        
        ncont=length(contSet);
        sumcont=zeros(nFrame,2);
        sumcont(:,1)=1:nFrame;
        fracontnum=zeros(nFrame,1);         %contour nums of every frame
        sumsal=zeros(nFrame,1);
        for k=1:ncont
            
            fraID=contSet{k}(:,1);
            tem=zeros(nFrame,1);
            tem(fraID)=1;
            fracontnum=fracontnum+tem;
            
            tempcont=zeros(nFrame,2);
            tempcont(fraID,2)=contSet{k}(:,2)*contTs(k);  %pitch*contourSalience
            sumcont=sumcont+tempcont;
            
            tpsa=zeros(nFrame,1);
            tpsa(fraID)=contTs(k);
            sumsal=sumsal+tpsa;
            
        end
        pitchM=sumcont(:,2)./sumsal;   %P(t)
        pitchM(fracontnum==0)=0;
        %mean filter
        %h=fspecial('average',[1,1000]);%2.9 second sliding mean filter
        %pchMfilt=filter(h,1,pitchM);
        pchMfilt=pitchM;
    end
%save all results in meanPitch

%detect pairs of octave duplicates and remove the wrong one
    function [contSet,contTs]=detOcta(contSet,contTs,pchMfilt)
        
        len1=length(contSet);
        dupset=zeros(len1,4);
        t=1;
        for i=1:len1-1
            for j=i+1:len1
                if contSet{i}(1,1)<contSet{j}(1,1)&&contSet{i}(end,1)>contSet{j}(end,1)  %j belong to i
                    len_j=size(contSet{j},1);
                    m1=0;dist=0;
                    a_min=100000;a_max=1;
                    for k=1:len_j
                        a=find((contSet{i}(:,1)==contSet{j}(k,1)));
                        if a~=0
                            a=a(1);
                            if a<a_min
                                a_min=a;
                            end
                            if a>a_max
                                a_max=a;
                            end
                            dist=dist+abs(contSet{i}(a,2)-contSet{j}(k,2));
                            m1=m1+1;
                        end
                    end
                    mdist=dist/m1;
                    
                    
                    if mdist<125&&mdist>115         %mean distance within 1200+-50cents
                        dupset(t,:)=[j,i,a_min,a_max];    %first one is short
                        t=t+1;
                    end
                    
                elseif contSet{j}(1,1)<contSet{i}(1,1)&&contSet{j}(end,1)>contSet{i}(end,1)  %j belong to i
                    len_i=size(contSet{i},1);
                    m1=0;dist=0;
                    a_min=100000;a_max=1;
                    for k=1:len_i
                        a=find(contSet{j}(:,1)==contSet{i}(k,1));
                        
                        if numel(a)~=0
                            a=a(1);
                            if a<a_min
                                a_min=a;
                            end
                            if  a>a_max
                                a_max=a;
                            end
                            dist=dist+abs(contSet{j}(a,2)-contSet{i}(k,2));
                            m1=m1+1;
                        end
                    end
                    
                    mdist=dist/m1;
                    if mdist<125&&mdist>115         %mean distance within 1200+-50cents
                        dupset(t,:)=[i,j,a_min,a_max];    %first one is short
                        t=t+1;
                    end
                end
            end
        end
        
        dupset1=dupset(dupset(:,1)~=0,:);
        octaveErr=zeros(size(dupset1,1),1);
        octi=1;
        for i=1:size(dupset1,1)
            c1=dupset(i,1);
            c2=dupset(i,2);
            s2=dupset(i,3);
            e2=dupset(i,4);
            dupcont=contSet{c2}(s2:e2,:);
            s=contSet{c1}(1,1);
            e=contSet{c1}(end,1);
            %pm=pchMfilt(s2:e2,:);
            dist1=0;dist2=0;
            if (e-s+1)~=size(contSet{c1},1)
                for k=1:size(contSet{c1},1)
                    dist1=dist1+abs(pchMfilt(contSet{c1}(k,1))-contSet{c1}(k,2));
                end
            else
                dist1=sum(abs(contSet{c1}(:,2)-pchMfilt(s:e)));
            end
            
            if (e-s+1)~=size(dupcont,1)
                for k=1:size(dupcont,1)
                    dist2=dist2+abs(pchMfilt(dupcont(k,1))-dupcont(k,2));
                end
            else
                dist2=sum(abs(dupcont(:,2)-pchMfilt(s:e)));
            end
            
            if dist1<dist2
                octaveErr(octi)=c2;
            else
                octaveErr(octi)=c1;
            end
            octi=octi+1;
        end
        
        
        contSet(octaveErr)=[];  %remove the contour furthest from mean P(t)
        contTs(octaveErr)=[];
        %save results in detocta.mat  ,contSet:1515
    end

%remove outliers
    function [contSet,contTs]=remoutlier(contSet,contTs,pchmean)
        
        ncont=length(contSet);
        t=1;
        outlier=zeros(ncont,1);
        dist=0;
        for i=1:ncont
            s=contSet{i}(1,1);
            e=contSet{i}(end,1);
            
            
            if (s-e+1)==size(contSet{i},1)
                dist=sum(abs(contSet{i}(:,2)-pchmean(s:e)));
            else
                for k=1:size(contSet{i},1)
                    dist=dist+abs(pchmean(contSet{i}(k,1))-contSet{i}(k,2));
                end
            end
            dist=dist/size(contSet{i},1);
            
            if dist>115   %outliers:more than one octave from mean p
                outlier(t)=i;
                t=t+1;
            end
        end
        
        id=find(outlier==0);
        outlier(id:end)=[];
        contSet(outlier)=[];
        contTs(outlier)=[];
    end

%save in remoutlier.mat

%stage3:final melody selection
contSet3=cell(size(contSet2));
for i1=1:length(contSet2)
    contSet3{i1}=[contSet2{i1} i1*ones(size(contSet2{i1},1),1) contTs2(i1)*ones(size(contSet2{i1},1),1)];%add two 
    %columns responding to cont number and contTs
end
mat3=cell2mat(contSet3);
[v1,pos1]=sort(mat3(:,5));  %sort with contTs
sortmat=mat3(pos1,:);  
[v2,pos2]=sort(sortmat(:,1));  %sort with frame num
sortmat1=sortmat(pos2,:);  
[v3,I]=unique(sortmat1(:,1),'rows');
contmat=sortmat1(I,:);  
contmat(:,4:5)=[];

end